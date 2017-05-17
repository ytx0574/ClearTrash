//
//  Command.m
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "Command.h"
#import "CommandLink.h"

extern NSString *kUsege;

@implementation Command

+ (void)excuteWithOption:(NSString *)option content:(NSString *)content;

{
    if ([option hasPrefix:@"-help"] || [option isEqualToString:@"help"]) {
        [CommandManager log:[NSString stringWithFormat:@"指令错误: %@", kUsege]];
    }
    
    if ([option hasPrefix:@"-link"] || [option hasPrefix:@"-l"]) {
        
        [[CommandLink class]  excuteWithOption:option content:content];
    }
    
    else if ([option isEqualToString:@"-link-d"] || [option isEqualToString:@"-l-d"]) {
        
        [[CommandLink class]  excuteWithOption:option content:content];
    }
    
    else {
        [CommandManager log:@"option 传入错误, 请看说明"];
    }
}

@end
