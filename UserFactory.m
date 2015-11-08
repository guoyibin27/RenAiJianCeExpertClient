//
//  UserFactory.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "UserFactory.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "ChatUserModel.h"

@implementation UserFactory

// cache users that will be use in getUserById
- (void)cacheUserByIds:(NSSet *)userIds block:(AVBooleanResultBlock)block {
    block(YES, nil); // don't forget it
}

- (id <CDUserModel> )getUserById:(NSString *)userId {
    NSString *username = [AppDelegate getCacheChattingUser:userId];
    ChatUserModel *model = [[ChatUserModel alloc] init];
    if(username == nil || username.length == 0){
        UserModel *usermodel = [AppDelegate getCurrentLogonUser];
        if([userId isEqualToString:[NSString stringWithFormat:@"servicer_%@",usermodel.userId]]){
            model.userId = [NSString stringWithFormat:@"servicer_%@",usermodel.userId];
            model.username = usermodel.name;
            model.avatarUrl = nil;
        }
        return model;
    }else{
        model.userId = userId;
        model.username = username;
        model.avatarUrl = nil;
        return model;
    }
}

@end
