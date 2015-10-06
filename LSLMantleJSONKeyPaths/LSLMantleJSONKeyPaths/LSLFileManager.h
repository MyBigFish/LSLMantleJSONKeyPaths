//
//  LSLFileManager.h
//  LSLMantleJSONKeyPaths
//
//  Created by LiuShulong on 10/6/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCodePrivate.h"

@interface LSLFileManager : NSObject

@property (nonatomic,copy) NSString *currentImplementText;

- (NSString *)generatorJSONKeyPathsByPropertyKeyString;

@end
