//
//  FileCollection.m
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "FileCollection.h"

@implementation FileCollection

- (instancetype)initWithHeaderFileReference:(FileModel *)headerFile
                        sourceFileReference:(FileModel *)sourceFile
                          testFileReference:(FileModel *)testFile;
{
    if (self = [super init]) {
        _headerFile = headerFile;
        _sourceFile = sourceFile;
        _testFile = testFile;
    }
    return self;
}

@end
