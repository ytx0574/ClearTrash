//
//  Command.h
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandManager.h"
#import "Header.h"

@interface Command : NSObject

+ (void)excuteWithOption:(NSString *)option content:(NSString *)content;

@end
