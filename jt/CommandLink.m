//
//  CommandLink.m
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "CommandLink.h"

@implementation CommandLink

+ (void)excuteWithOption:(NSString *)option content:(NSString *)content;
{
    if ([option isEqualToString:@"-link-e"] || [option isEqualToString:@"-l-e"]) {
        
        [[self class] encodeWhthLink:content];
    }
    
    else if ([option isEqualToString:@"-link-d"] || [option isEqualToString:@"-l-d"]) {
        
        [[self class] dencodeWhthLink:content];
    }

    else {
        [[self class] dencodeWhthLink:content];
    }
    
}

+ (void)encodeWhthLink:(NSString *)link
{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    NSMutableArray *ay = [NSMutableArray array];
    
    
    for(NSUInteger i = 0; i < [link length];i++)
    {
        NSString *character = [link substringWithRange:NSMakeRange(i, 1)];
        
        int a = [link characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            
            character = [character stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        }
        [ay addObject:character];
        
    }
    
    [CommandManager log:[NSString stringWithFormat:@"---仅encode汉字---\n%@", [ay componentsJoinedByString:@""]]];
}

+ (void)dencodeWhthLink:(NSString *)link
{
    //    NSString *s = [link stringByReplacingPercentEscapesUsingEncoding:4];
    [CommandManager log:link.stringByRemovingPercentEncoding];
}

@end
