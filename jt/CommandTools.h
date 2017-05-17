//
//  CommandTools.h
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandTools : NSObject
+ (void)excuteCommandLine:(NSString *)commandPath arguments:(NSArray *)arguments;
@end
