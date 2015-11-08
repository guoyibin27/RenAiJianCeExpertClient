//
//  UserModel.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (retain, nonatomic) NSNumber *userId;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *userType;
@property (retain, nonatomic) NSString *status;
@property (retain, nonatomic) NSString *email;

-(instancetype)parse:(NSDictionary *)json;


@end
