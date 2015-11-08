//
//  HttpClient.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "AFNetworking/AFHTTPSessionManager.h"
#import "HttpClient.h"
#import "Constants.h"

@implementation HttpClient


+ (HttpClient *) sharedClient{
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:SERVER_HOST]];
        _sharedClient.requestSerializer.timeoutInterval = 8;
    });
    
    return _sharedClient;
}
@end
