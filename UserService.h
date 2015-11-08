//
//  UserService.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "BaseService.h"

@class UserModel;
@interface UserService : BaseService

+(void)userLogin:(NSString *)username atPassword:(NSString *)password callback:(UserResultBlock)callback;

+(void)userLogout:(BooleanResultBlock)callback;

+(void)fetchReservationAgenda:(NSNumber *)userId startPoint:(NSString *)start endPoint:(NSString *)end callback:(FetchReservationsBlock)callback;
@end
