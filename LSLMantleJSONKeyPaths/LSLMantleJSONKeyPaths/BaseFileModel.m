//
//  FileModel.m
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "BaseFileModel.h"
#import "FileModel.h"
#import "GroupFileModel.h"
#import "VariantGroupFileModel.h"

@implementation BaseFileModel

- (instancetype)initWithPBXReference:(PBXReference *)pbxReference {
    if ([pbxReference isKindOfClass:NSClassFromString(@"PBXGroup")]) {
        return [[GroupFileModel alloc] initWithPBXReference:pbxReference];
    } else if ([pbxReference isKindOfClass:NSClassFromString(@"PBXFileReference")]) {
        return [[FileModel alloc] initWithPBXReference:pbxReference];
    } else if ([pbxReference isKindOfClass:NSClassFromString(@"PBXVariantGroup")]) {
        return [[VariantGroupFileModel alloc] initWithPBXReference:pbxReference];
    }
    return nil;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
         @"name"        : @"name",
         @"absolutePath": @"absolutePath",
         @"container"   : @"container",
         @"isTestFile"  : @"isTestFile",
         @"isSourceFile": @"isSourceFile",
         @"isHeaderFile": @"isHeaderFile"

    };
}

@end
