//
//  main.m
//  ClearTrash
//
//  Created by Johnson on 8/16/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ServiceManagement/ServiceManagement.h>
#import <CoreFoundation/CoreFoundation.h>


void delFile(NSString *folderPath, NSString *fileFullName) {
    
    //把 空格 ( ) 都添加 '\'
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileFullName];
    
    filePath = [filePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
    filePath = [filePath stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
    
    NSString *string = [NSString stringWithFormat:@"rm -rf %@", filePath];
    int status = system([string UTF8String]);
    printf("status %d \n", status);
    
}

//Mac系统弹框输入管理员密码清理
void removeFileWithElevatedPrivilegesFromVolumes(NSArray *volumesTrashes)

{
    
    // Create authorization reference
    
    OSStatus status;
    
    AuthorizationRef authorizationRef;
    
    // AuthorizationCreate and pass NULL as the initial
    
    // AuthorizationRights set so that the AuthorizationRef gets created
    
    // successfully, and then later call AuthorizationCopyRights to
    
    // determine or extend the allowable rights.
    
    //  CodeGo.net
    
    status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
    
    if (status != errAuthorizationSuccess)
    {
        
        NSLog(@"Error Creating Initial Authorization: %d", status);
        
        return;
        
    }
    
    // kAuthorizationRightExecute == "system.privilege.admin"
    
    AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
    
    AuthorizationRights rights = {1, &right};
    
    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed |
    
    kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
    
    // Call AuthorizationCopyRights to determine or extend the allowable rights.
    
    status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
    
    if (status != errAuthorizationSuccess)
    {
        
        NSLog(@"Copy Rights Unsuccessful: %d", status);
        
        return;
        
    }
    
    // use rm tool with -rf
    
    char *tool = "/bin/rm";
    
    
    for (NSString *path in volumesTrashes)
    {
        
        char *args[] = {"-rf", (char *)[path UTF8String], NULL};
        
        FILE *pipe = NULL;
        
        status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &pipe);
        
        if (status != errAuthorizationSuccess)
        {
            
            NSLog(@"Error: %d", status);
            
            return;
            
        }
        
    }
    
    // The only way to guarantee that a credential acquired when you
    
    // request a right is not shared with other authorization instances is
    
    // to destroy the credential. To do so, call the AuthorizationFree
    
    // function with the flag kAuthorizationFlagDestroyRights.
    
    //  CodeGo.net
    
    status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);

}


NSFileManager * fileManager()
{
    return [NSFileManager defaultManager];
}

BOOL isSystemDisk(NSString *volumesPath)
{
    NSDictionary *attributes = [[fileManager() enumeratorAtPath:volumesPath] directoryAttributes];
    return [attributes[NSFileOwnerAccountName] isEqualToString:@"root"]
    &&
    [attributes[NSFileOwnerAccountID] integerValue] == 0
    &&
    [attributes[NSFileGroupOwnerAccountName] isEqualToString:@"wheel"]
    &&
    [attributes[NSFileGroupOwnerAccountID] integerValue] == 0;
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        
        //clear user trash
        NSString *userTrashPath = [NSHomeDirectory() stringByAppendingString:@"/.Trash/"];
        NSError *error;
        NSArray *arrayUserTrashFilesPath = [fileManager() contentsOfDirectoryAtPath:userTrashPath error:&error];
        
        [arrayUserTrashFilesPath enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            delFile(userTrashPath, obj);
            
        }];
        
        
        
        //clear volumes trash
        NSString *rootVolumes = @"/Volumes";
        NSMutableArray *arraysVolumesPath = [[fileManager() contentsOfDirectoryAtPath:rootVolumes error:NULL] mutableCopy];
        
        
        [arraysVolumesPath enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *volumesPath = [rootVolumes stringByAppendingPathComponent:obj];
            if (isSystemDisk(volumesPath)) {
                return ;
            }
        
            NSString *folderPath = [volumesPath stringByAppendingString:@"/.Trashes"];
            if ([fileManager() fileExistsAtPath:folderPath]) {
                //添加可读权限
                system([[NSString stringWithFormat:@"chmod +r %@", folderPath] UTF8String]);
                
                NSError *err;
                NSArray *arrayFilesPath = [fileManager() contentsOfDirectoryAtPath:folderPath error:&err];
                if (err) {
                    NSLog(@"Error: %@, Path: %@", err, folderPath);
                }
                
                [arrayFilesPath enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    delFile(folderPath, obj);
                }];
            }
            
        }];
    
        
//        //clear volumes trash with admin user password
//        [arraysVolumesPath enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            NSString *folderPath = [[rootVolumes stringByAppendingPathComponent:obj] stringByAppendingString:@"/.Trashes"];
//            [arraysVolumesPath replaceObjectAtIndex:idx withObject:folderPath];
//            
//        }];
//        
//        removeFileWithElevatedPrivilegesFromVolumes(arraysVolumesPath);

    
    }
    return 0;
}




