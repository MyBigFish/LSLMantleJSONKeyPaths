//
//  FileProvider.m
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "FileProvider.h"
#import "XCodePrivate.h"
#import "BaseFileModel.h"
#import "DocumentNavigator.h"

@interface FileProvider ()

@property (nonatomic, copy) NSArray *fileReferences;

@end

@implementation FileProvider

- (NSArray *)fileReferences {
    
    NSArray *projectFiles = [self flattenedProjectContents];
    
    NSMutableArray *references = [NSMutableArray array];
    
    for (PBXReference *pbxReference in projectFiles) {
        
        BaseFileModel *file = [[BaseFileModel alloc] initWithPBXReference:pbxReference];
        if (references) {
            [references addObject:file];
        }
        
    }
    
    return [references copy];
}



- (NSArray *)flattenedProjectContents {
    NSArray *workspaceReferencedContainers = [[[DocumentNavigator currentWorkspace] referencedContainers] allObjects];
    NSArray *contents = [NSArray array];
    
    for (IDEContainer *container in workspaceReferencedContainers) {
        if ([container isKindOfClass:NSClassFromString(@"Xcode3Project")]) {
            Xcode3Project *project = (Xcode3Project *)container;
            Xcode3Group *rootGroup = [project rootGroup];
            PBXGroup *pbxGroup = [rootGroup group];
            
            NSMutableArray *groupContents = [NSMutableArray array];
            [pbxGroup flattenItemsIntoArray:groupContents];
            contents = [contents arrayByAddingObjectsFromArray:groupContents];
        }
    }
    
    return contents;

}

- (instancetype)initWithFileReferences:(NSArray *)fileReferences {
    if (self = [super init]) {
        _fileReferences = fileReferences;
    }
    return self;
}

- (FileCollection *)referenceCollectionForSourceCodeDocument:(IDESourceCodeDocument *)sourceCodeDocument {
    if (sourceCodeDocument) {
        DVTFilePath *filePath = sourceCodeDocument.filePath;
        NSString *fileName = filePath.fileURL.lastPathComponent;
        fileName = [self fileNameByStrippingExtensionAndLastOccuranceOfTest:fileName];
        
        FileModel *headerRef = nil;
        FileModel *sourceRef = nil;
        FileModel *testRef = nil;
        
        NSArray *fileReferences = [self fileReferences];
        for (FileModel *reference in fileReferences) {
            if ([reference.name rangeOfString:fileName].location != NSNotFound) {
                if ([reference.name.pathExtension isEqualToString:@"m"]) {
                    sourceRef = reference;
                } else if ([reference.name.pathExtension isEqualToString:@"h"]) {
                    headerRef = reference;
                }
            }
        }
        
        return [[FileCollection alloc] initWithHeaderFileReference:headerRef sourceFileReference:sourceRef testFileReference:testRef];
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
