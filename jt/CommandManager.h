//
//  CommandManager.h
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandManager : NSObject

+ (void)excuteWithArguments:(NSArray *)arguments;
+ (void)log:(NSString *)log;

@end
