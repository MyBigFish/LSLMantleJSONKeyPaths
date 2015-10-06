//
//  FileCollection.h
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@interface FileCollection : NSObject

- (instancetype)initWithHeaderFileReference:(FileModel *)headerFile
                        sourceFileReference:(FileModel *)sourceFile
                          testFileReference:(FileModel *)testFile;

@property (nonatomic, readonly) FileModel *headerFile;
@property (nonatomic, readonly) FileModel *sourceFile;
@property (nonatomic, readonly) FileModel *testFile;


@end
