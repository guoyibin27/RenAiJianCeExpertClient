//
//  ChatUserModel.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeanChatLib.h"

@interface ChatUserModel : NSObject<CDUserModel>

@property (retain, nonatomic) NSString *userId;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *avatarUrl;

@end
