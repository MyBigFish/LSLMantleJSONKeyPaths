//
//  FileProvider.h
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCollection.h"

@interface FileProvider : NSObject

- (NSArray *)fileReferences;

- (instancetype)initWithFileReferences:(NSArray *)fileReferences;
- (FileCollection *)referenceCollectionForSourceCodeDocument:(IDESourceCodeDocument *)sourceCodeDocument;


@end
