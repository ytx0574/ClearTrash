//
//  CommandTools.m
//  jt
//
//  Created by Johnson on 2017/5/16.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "CommandTools.h"

@implementation CommandTools


+ (BOOL)excuteCommandLine:(NSString *)commandPath arguments:(NSArray *)arguments;
{
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    //执行系统命令
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = commandPath;
    task.arguments = arguments;
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    //执行成功 停止执行后面
    if (task.terminationStatus == 0) {
        return YES;
    }else {
        
        NSString *outputString;
        NSString *errorString;
        BOOL flag =[self runProcessAsAdministrator:commandPath withArguments:arguments output:&outputString errorDescription:&errorString];
        if (errorString || outputString) {
            NSLog(@"command perform error:%@ output:%@", errorString, outputString);
        }
        return flag;
    }
    
}


//https://stackoverflow.com/questions/6841937/authorizationexecutewithprivileges-is-deprecated
+ (BOOL)runProcessAsAdministrator:(NSString*)scriptPath
                    withArguments:(NSArray *)arguments
                           output:(NSString **)output
                 errorDescription:(NSString **)errorDescription
{
    
    NSString * allArgs = [arguments componentsJoinedByString:@" "];
    NSString * fullScript = [NSString stringWithFormat:@"'%@' %@", scriptPath, allArgs];
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult) {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber]) {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (*errorDescription == nil) {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    } else {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
    }
}



/**
 
 //最原始的一段授权代码
 
 
 //    NSDictionary *error = [NSDictionary new];
 //    NSString *script = [commandPath stringByAppendingFormat:@" %@", [arguments componentsJoinedByString:@" "]];
 //    script = @"sudo -s";
 //    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
 //    NSAppleEventDescriptor *des = [appleScript executeAndReturnError:&error];
 //    if (error) {
 //        NSLog(@"apple script excute error %@", error);
 //    }
 
 
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
 
 const char *tool = [commandPath UTF8String];
 
 char *arg = [[arguments componentsJoinedByString:@" "] UTF8String];
 
 char *args[] = {arg, NULL};
 
 FILE *communicationsPipe = NULL;
 
 status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &communicationsPipe);
 
 if (status != errAuthorizationSuccess)
 {
 
 NSLog(@"Authorization Execute Error: %d", status);
 
 }
 
 
 // The only way to guarantee that a credential acquired when you
 
 // request a right is not shared with other authorization instances is
 
 // to destroy the credential. To do so, call the AuthorizationFree
 
 // function with the flag kAuthorizationFlagDestroyRights.
 
 //  CodeGo.net
 
 status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
 */

@end
