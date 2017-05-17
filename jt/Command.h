//
//  Command.h
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandManager.h"

@interface Command : NSObject

+ (Class)commandClassFromOption:(NSString *)option;

+ (void)excuteWithOption:(NSString *)option content:(NSString *)content;

@end
