//
//  VariantGroupFileModel.m
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "VariantGroupFileModel.h"

@interface VariantGroupFileModel ()

@property (nonatomic, readonly) PBXVariantGroup *pbxVariantGroup;

@end

@implementation VariantGroupFileModel

- (instancetype)initWithPBXReference:(PBXVariantGroup *)pbxReference {
    if (self = [super init]) {
        _pbxVariantGroup = pbxReference;
    }
    return self;
}

- (NSString *)name {
    return self.pbxVariantGroup.name;
}

- (NSString *)absolutePath {
    return self.pbxVariantGroup.absolutePath;
}

- (PBXContainer *)container {
    return self.pbxVariantGroup.container;
}


@end
