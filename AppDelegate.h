//
//  AppDelegate.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/4/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(UserModel *) getCurrentLogonUser;

+ (void) setCurrentLogonUser:(UserModel *) logonUser;

+ (void)removeUserFromNSUserDefaults;

+ (void) cacheChattingUser:(NSString *)userId username:(NSString *) username;
+ (NSString *) getCacheChattingUser:(NSString *)userId;

@end

