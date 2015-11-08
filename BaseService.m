//
//  BaseService.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService

+(NSError *)errorWithText:(NSString *)text
{
    return [NSError errorWithDomain:@"RenAiJianCeClient" code:0 userInfo:@{NSLocalizedDescriptionKey:text}];
}
@end
