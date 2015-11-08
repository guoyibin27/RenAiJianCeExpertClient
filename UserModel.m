//
//  UserModel.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(instancetype)parse:(NSDictionary *)json
{
    self.userId = [json objectForKey:@"Id"];
    self.email = [json objectForKey:@"EMail"];
    self.username = [json objectForKey:@"Username"];
    self.name = [json objectForKey:@"Name"];
    self.userType = [json objectForKey:@"Type"];
    self.status = [json objectForKey:@"Status"];
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId    forKey:@"userId"];
    [aCoder encodeObject:self.username forKey:@"userName"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.userType forKey:@"type"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.userId = [aDecoder decodeObjectForKey:@"userId"];
    self.username = [aDecoder decodeObjectForKey:@"userName"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.status = [aDecoder decodeObjectForKey:@"status"];
    self.userType = [aDecoder decodeObjectForKey:@"type"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    return self;
}

@end
