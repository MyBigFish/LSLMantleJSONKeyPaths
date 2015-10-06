//
//  LSLMantleJSONKeyPaths.h
//  LSLMantleJSONKeyPaths
//
//  Created by LiuShulong on 10/6/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import <AppKit/AppKit.h>

@class LSLMantleJSONKeyPaths;

static LSLMantleJSONKeyPaths *sharedPlugin;

@interface LSLMantleJSONKeyPaths : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end