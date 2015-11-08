//
//  UserService.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "UserService.h"
#import "UserModel.h"
#import "HttpClient.h"
#import "Constants.h"
#import "LeanChatLib.h"
#import "ReservationModel.h"

@implementation UserService

+(void)userLogin:(NSString *)username atPassword:(NSString *)password callback:(UserResultBlock)callback
{
    NSDictionary *param = @{@"username":username,@"password":password};
    [[HttpClient sharedClient] GET:LOGIN_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL _success = [[responseObject objectForKey:@"Success"] boolValue];
        if(_success){
            UserModel *usermodel = [[[UserModel alloc] init] parse:[responseObject objectForKey:@"Data"]];
            callback(usermodel,nil);
        }else{
            callback(nil,[self errorWithText:@"用户名或者密码错误"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil,[self errorWithText:@"登录失败，请稍后重试"]);
    }];
}

+(void)userLogout:(BooleanResultBlock)callback
{
    [[CDChatManager manager] closeWithCallback:callback];
}

+(void)fetchReservationAgenda:(NSNumber *)userId startPoint:(NSString *)start endPoint:(NSString *)end callback:(FetchReservationsBlock)callback
{
    NSDictionary *params = @{@"servicerId":userId,@"start":start,@"end":end};
    [[HttpClient sharedClient] GET:FETCH_RESERVATION_AGENDA parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL _success = [[responseObject objectForKey:@"Success"] boolValue];
        if(_success){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *data = [responseObject objectForKey:@"Data"];
            for(int i=0;i< data.count ;i++){
                [array addObject:[[[ReservationModel alloc] init] parse:[data objectAtIndex:i]]];
            }
            callback(array,nil);
        }else{
            callback(nil,[self errorWithText:@"无数据"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil,[self errorWithText:@"获取数据失败，请稍后重试"]);
    }];
}
@end
