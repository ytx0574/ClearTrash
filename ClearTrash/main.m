//
//  main.m
//  ClearTrash
//
//  Created by Johnson on 8/16/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        NSString *trashPath = [NSHomeDirectory() stringByAppendingString:@"/.Trash/"];
        NSError *error;
        NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:trashPath error:&error];
        
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            //把 空格 ( ) 都添加 '\'
            obj = [obj stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
            obj = [obj stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
            obj = [obj stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
            
            NSString *string = [NSString stringWithFormat:@"rm -rf %@%@", trashPath, obj];
            int status = system([string UTF8String]);
            printf("status %d \n", status);
        }];
        
        
    }
    return 0;
}
