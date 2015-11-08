//
//  HttpClient.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface HttpClient : AFHTTPRequestOperationManager

+ (HttpClient *) sharedClient;

@end
