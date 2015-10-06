//
//  FileModel.h
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCodePrivate.h"

@interface BaseFileModel : NSObject

- (instancetype)initWithPBXReference:(PBXReference *)pbxReference;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *absolutePath;
@property (nonatomic, readonly) PBXContainer *container;

@property (nonatomic, readonly) BOOL isTestFile;
@property (nonatomic, readonly) BOOL isSourceFile;
@property (nonatomic, readonly) BOOL isHeaderFile;


@end
