//
//  ReservationModel.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReservationModel : NSObject

@property (retain, nonatomic) NSNumber *reservationId;
@property (retain, nonatomic) NSString *reservationDesc;
@property (retain, nonatomic) NSString *reservationInfo;
@property (retain, nonatomic) NSString *reservationMethod;
@property (retain, nonatomic) NSString *reserveBy;
@property (retain, nonatomic) NSNumber *serviceId;
@property (retain, nonatomic) NSNumber *serviceExpertId;
@property (retain, nonatomic) NSString *start;
@property (retain, nonatomic) NSString *end;
@property (retain, nonatomic) NSString *startLabel;
@property (retain, nonatomic) NSString *endLabel;
@property (retain, nonatomic) NSString *status;
@property (retain, nonatomic) NSNumber *amount;
@property (nonatomic) BOOL isShowBadge;

-(instancetype)parse:(NSDictionary *)dict;
@end
