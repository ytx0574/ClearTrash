//
//  CommandFile.m
//  jt
//
//  Created by Johnson on 2017/5/25.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "CommandFile.h"


@implementation CommandFile

+ (void)excuteWithOption:(NSString *)option content:(NSString *)content;
{
    if ([option isEqualToString:@"-file-clear"] || [option isEqualToString:@"-f-c"]) {
        
        [self clearSystemTrash];
    }

}


+ (void)clearSystemTrash
{
    //clear user trash
    NSString *userTrashPath = [NSHomeDirectory() stringByAppendingString:@"/.Trash/"];
    NSError *error;
    NSArray *arrayUserTrashFilesPath = [JTFileManager contentsOfDirectoryAtPath:userTrashPath error:&error];
    
    [arrayUserTrashFilesPath enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [self delFileWihtFolder:userTrashPath fileFullName:obj];
        
    }];
    
    
    //clear volumes trash
    NSString *rootVolumes = @"/Volumes";
    NSMutableArray *arraysVolumesPath = [[JTFileManager contentsOfDirectoryAtPath:rootVolumes error:NULL] mutableCopy];
    
    
    [arraysVolumesPath enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *volumesPath = [rootVolumes stringByAppendingPathComponent:obj];
        if ([self isSystemDisk:volumesPath]) {
            return ;
        }
        
        NSString *folderPath = [volumesPath stringByAppendingString:@"/.Trashes"];
        if ([JTFileManager fileExistsAtPath:folderPath]) {
            //添加可读权限
            system([[NSString stringWithFormat:@"chmod +r %@", folderPath] UTF8String]);
            
            NSError *err;
            NSArray *arrayFilesPath = [JTFileManager contentsOfDirectoryAtPath:folderPath error:&err];
            if (err) {
                NSLog(@"Error: %@, Path: %@", err, folderPath);
            }
            
            [arrayFilesPath enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self delFileWihtFolder:folderPath fileFullName:obj];
            }];
        }
        
    }];
    
}



+ (BOOL)isSystemDisk:(NSString *)volumesPath
{
    NSDictionary *attributes = [[JTFileManager enumeratorAtPath:volumesPath] directoryAttributes];
    return [attributes[NSFileOwnerAccountName] isEqualToString:@"root"]
    &&
    [attributes[NSFileOwnerAccountID] integerValue] == 0
    &&
    [attributes[NSFileGroupOwnerAccountName] isEqualToString:@"wheel"]
    &&
    [attributes[NSFileGroupOwnerAccountID] integerValue] == 0;
}


+ (void)delFileWihtFolder:(NSString *)folderPath fileFullName:(NSString *)fileFullName;
{
        //把 空格 ( ) ' 都添加 '\'
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileFullName];
        
        filePath = [filePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        filePath = [filePath stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
        filePath = [filePath stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
        filePath = [filePath stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
        
        NSString *string = [NSString stringWithFormat:@"rm -rf %@", filePath];
        int status = system([string UTF8String]);
        printf("excutable status %d \n", status);
}

@end
