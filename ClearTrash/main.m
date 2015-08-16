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
        NSString *trashPath = @"/Users/johnson/.Trash/";
        NSError *error;
        NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:trashPath error:&error];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *string = [NSString stringWithFormat:@"rm -rf %@%@", trashPath, obj];
            system([string UTF8String]);
        }];
        
        
    }
    return 0;
}
