//
//  NSObject_Extension.m
//  LSLMantleJSONKeyPaths
//
//  Created by LiuShulong on 10/6/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//


#import "NSObject_Extension.h"
#import "LSLMantleJSONKeyPaths.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[LSLMantleJSONKeyPaths alloc] initWithBundle:plugin];
        });
    }
}
@end
