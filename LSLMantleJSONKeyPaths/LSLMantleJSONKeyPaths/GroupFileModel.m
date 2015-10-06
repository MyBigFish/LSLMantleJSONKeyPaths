//
//  GroupFileModel.m
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "GroupFileModel.h"
#import "XCodePrivate.h"

@interface GroupFileModel ()

@property (nonatomic, readonly) PBXGroup *pbxGroup;

@end

@implementation GroupFileModel

- (instancetype)initWithPBXReference:(PBXGroup *)pbxReference {
    if (self = [super init]) {
        _pbxGroup = pbxReference;
    }
    return self;
}

- (NSString *)name {
    return self.pbxGroup.name;
}

- (NSString *)absolutePath {
    return self.pbxGroup.absolutePath;
}

- (PBXContainer *)container {
    return self.pbxGroup.container;
}


@end
