//
//  Command.m
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "Command.h"
#import "CommandLink.h"
#import "CommandFile.h"

extern NSString *kUsege;

@implementation Command

+ (void)excuteWithOption:(NSString *)option content:(NSString *)content;

{
    if ([option hasPrefix:@"-help"] || [option isEqualToString:@"help"]) {
        [CommandManager log:[NSString stringWithFormat:@"%@", kUsege]];
    }
    
    else if ([option hasPrefix:@"-link"] || [option hasPrefix:@"-l"]) {
        
        [[CommandLink class]  excuteWithOption:option content:content];
    }
    
    else if ([option isEqualToString:@"-file"] || [option hasPrefix:@"-f"]) {
        
        [[CommandFile class]  excuteWithOption:option content:content];
    }
    
    else {
        [CommandManager log:[NSString stringWithFormat:@"option 传入错误 \n%@", kUsege]];
    }
}

@end
