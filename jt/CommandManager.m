//
//  CommandManager.m
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "CommandManager.h"
#import "Command.h"

const NSString *kUsege =
@"Usage: jt [options] content \n"
"\n"
"  where options are:\n"
"        -help    help                   使用说明\n"
"        -l       -link                  把链接进行解码, 变成原有的字符串\n"
"        -l-e     -link-e                把链接进行编码, 变成浏览器可用\n"
"        -l-d     -link-d                把链接进行解码, 变成原有的字符串\n"
"        -f-c     -file-clear            清空Mac废纸篓\n"
"";



@implementation CommandManager

+ (void)excuteWithArguments:(NSArray *)arguments;
{
    if (arguments.count < 2) {
        [Command excuteWithOption:@"help" content:nil];
    }else {
        //jt link ddd
        
        NSString *option = arguments[1];
        
        NSMutableArray *ay = [arguments mutableCopy];
        [ay removeObject:option];
        [ay removeObject:ay.firstObject];
        
        NSString *content = [ay componentsJoinedByString:@" "];
        
        [Command excuteWithOption:option content:content];
    }
    
}

+ (void)log:(NSString *)log
{
    fprintf(stderr, "%s\n", [log UTF8String]);
}

@end
