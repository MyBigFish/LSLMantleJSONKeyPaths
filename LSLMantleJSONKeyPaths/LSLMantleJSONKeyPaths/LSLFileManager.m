//
//  LSLFileManager.m
//  LSLMantleJSONKeyPaths
//
//  Created by LiuShulong on 10/6/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "LSLFileManager.h"
#import "DocumentNavigator.h"
#import "FileModel.h"
#import "FileProvider.h"
#import <Cocoa/Cocoa.h>

@implementation LSLFileManager


NSString *getIntefaceNameByContent(NSString *content) {
    
    NSString *regex = @"(@implementation\\s*\\S*)";
    
    NSError *error=nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
    
    NSArray *res = [pattern matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    for (NSTextCheckingResult *result in res) {
        NSString *test = [content substringWithRange:result.range];
        
        test = [[test componentsSeparatedByString:@" "] lastObject];
        
        return test;
    }
    
    return nil;
}


NSArray *getRegexResult(NSString *regex,NSString *content) {
    
    NSError *error = nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
    NSArray *res = [pattern matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    return res;
}

NSArray *getPropertiesByInterfaceName(NSString *interfaceName,NSString *content) {
    
    
    NSString *regex = [NSString stringWithFormat:@"@interface\\s+%@(?s)(.*)@end",interfaceName];
    
    NSError *error = nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
    NSArray *res = [pattern matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    for (NSTextCheckingResult *result in res) {
        NSString *test = [content substringWithRange:result.range];
        
        //匹配property
        NSArray *properties = getRegexResult(@"@property.*?;", test);
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSTextCheckingResult *subResult in properties) {
            
            NSString *subString = [test substringWithRange:subResult.range];
            
            NSRange lastStarRange = [subString rangeOfString:@"*" options:NSBackwardsSearch];
            NSRange lastSpaceRange = [subString rangeOfString:@" " options:NSBackwardsSearch];
            
            NSString *str;
            if (lastSpaceRange.location > lastStarRange.location || lastStarRange.length == 0) {
                str = [subString substringWithRange:NSMakeRange(lastSpaceRange.location, subString.length - lastSpaceRange.location)];
            } else {
                str = [subString substringWithRange:NSMakeRange(lastStarRange.location, subString.length - lastStarRange.location)];
            }
            NSMutableCharacterSet *set = [[NSMutableCharacterSet alloc] init];
            [set addCharactersInString:@" *;"];
            //去掉空格和逗号
            NSMutableArray *strArr = [[str componentsSeparatedByCharactersInSet:set] mutableCopy];
            [strArr removeObject:@" "];
            str = [strArr componentsJoinedByString:@""];
            
            [array addObject:str];
        }
        return array;
    }
    
    
    return nil;
}


- (NSString *)generatorJSONKeyPathsByPropertyKeyString {
        
    NSMutableString *str = [@"+ (NSDictionary *)JSONKeyPathsByPropertyKey {\n    return @{\n" mutableCopy];
    
    NSArray *array = [self allProperties];
    
    //计算长度
    NSUInteger maxLen = 0;
    
    for (NSString *propername in array) {
        if (propername.length > maxLen) {
            maxLen = propername.length;
        }
    }
    
    for (int i = 0;i < array.count; i++) {
        
        NSString *propertyName = [array objectAtIndex:i];
        
        //计算空格个数
        NSInteger count = maxLen - propertyName.length;
        NSMutableString *firstPropertyName = [NSMutableString stringWithFormat:@"@\"%@\"",propertyName];
        if (count > 0) {
            
            for (int j = 0; j < count; j++) {
                [firstPropertyName appendString:@" "];
            }
            
        }
        
        [firstPropertyName appendString:@": "];
        
        NSString *comma = i == (array.count - 1) ? @"\n" : @",\n";
        NSString *value = [NSString stringWithFormat:@"         %@@\"%@\"%@",firstPropertyName,propertyName,comma];
        [str appendString:value];
    }
    
    [str appendString:[NSString stringWithFormat:@"\n    };\n}"]];
    
    return str;
    
}

- (NSArray *)allProperties {
    
    //获得当前文件头文件的content
    NSString *content = [self getFileContent];
    //包含光标的头文件名称
    NSString *interface = getIntefaceNameByContent(self.currentImplementText);
    
    //获得所有propertes
    NSArray *properties = getPropertiesByInterfaceName(interface, content);
    
    return properties;
    
}

//获取文件内容
- (NSString *)getFileContent {
    
    IDESourceCodeDocument *doc = [DocumentNavigator currentSourceCodeDocument];
    if (doc) {
        DVTFilePath *filePath = doc.filePath;
        NSString *fileName = filePath.fileURL.lastPathComponent;
        fileName = [self fileNameByStrippingExtensionAndLastOccuranceOfTest:fileName];
        
        FileModel *headerRef = nil;
        FileModel *sourceRef = nil;
        NSArray *fileReferences = [[[FileProvider alloc] init] fileReferences];
        for (FileModel *reference in fileReferences) {
            if ([reference.name rangeOfString:fileName].location != NSNotFound) {
                if ([reference.name.pathExtension isEqualToString:@"m"]) {
                    sourceRef = reference;
                } else if ([reference.name.pathExtension isEqualToString:@"h"]) {
                    headerRef = reference;
                    
                    NSString *path = reference.absolutePath;
                    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                    return string;
                }
            }
        }
    }
    
    return nil;
    
}

- (NSString *)fileNameByStrippingExtensionAndLastOccuranceOfTest:(NSString *)fileName {
    NSString *file = [fileName stringByDeletingPathExtension];
    NSString *strippedFileName = nil;
    
    if (file.length >= 5) {
        NSRange rangeOfOccurrenceOfTest = [file rangeOfString:@"Test" options:NSCaseInsensitiveSearch range:NSMakeRange(file.length - 5, 5)];
        NSRange rangeOfOccurrenceOfSpec = [file rangeOfString:@"Spec" options:NSCaseInsensitiveSearch range:NSMakeRange(file.length - 5, 5)];
        if (rangeOfOccurrenceOfTest.location != NSNotFound) {
            strippedFileName = [file substringToIndex:rangeOfOccurrenceOfTest.location];
        } else if (rangeOfOccurrenceOfSpec.location != NSNotFound) {
            strippedFileName = [file substringToIndex:rangeOfOccurrenceOfSpec.location];
        } else {
            strippedFileName = file;
        }
    }
    return strippedFileName;
}


@end
