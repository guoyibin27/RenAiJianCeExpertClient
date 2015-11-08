//
//  AppDelegate.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/4/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"
#import "Constants.h"
#import "LeanChatLib.h"
#import "UserFactory.h"
#import "LZPushManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self netWorkStatusListening];
    NSLog(@"didFinishLaunchingWithOptions - %@",launchOptions);
    
//    [AVPush setProductionMode:NO];
    [AVOSCloud setApplicationId:LEANCLOUD_APP_ID clientKey:LEANCLOUD_KEY];
    [CDChatManager manager].userDelegate = [[UserFactory alloc] init];
    [AVOSCloud setLastModifyEnabled:YES];
#ifdef DEBUG
    [AVOSCloud setAllLogsEnabled:YES];
#endif
    [[LZPushManager manager] registerForRemoteNotification];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[LZPushManager manager] syncBadge];
    [[LZPushManager manager] cleanBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[LZPushManager manager] syncBadge];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[LZPushManager manager] saveInstallationWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive) {
        // 应用在前台时收到推送，只能来自于普通的推送，而非离线消息推送
    }
    else {
        [[CDChatManager manager] didReceiveRemoteNotification:userInfo];
    }
}


-(void)netWorkStatusListening
{
    NSURL *baseUrl = [NSURL URLWithString:SERVER_HOST];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                [operationQueue setSuspended:YES];
                [ProgressHUD showError:@"无网络可用"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                [operationQueue setSuspended:NO];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                [operationQueue setSuspended:NO];
            }
                break;
            default:
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}

+ (UserModel *) getCurrentLogonUser{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:CURRENT_USER];
    UserModel *currentUser = nil;
    if(data){
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return currentUser;
}

+(void)removeUserFromNSUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:CURRENT_USER];
    [userDefaults synchronize];
}

+ (void) setCurrentLogonUser:(UserModel *) logonUser{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:logonUser];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:CURRENT_USER];
    [userDefaults synchronize];
}

+ (void) cacheChattingUser:(NSString *)userId username:(NSString *) username
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:userId];
    [userDefaults synchronize];
}

+ (NSString *) getCacheChattingUser:(NSString *)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:userId];
    return username;
}
@end
