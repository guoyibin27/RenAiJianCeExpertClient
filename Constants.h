//
//  Constants.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#ifndef RenAiJianCeExpertClient_Constants_h
#define RenAiJianCeExpertClient_Constants_h

#define LEANCLOUD_APP_ID @"inji87dzdnwf2op2136765atp3wnmmquxzhkxz8138sacpye"
#define LEANCLOUD_KEY @"vuf2a48luq7acrrgda40nho4fapzsfr1y3dc4se2ihwmrcmq"


#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)

#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define Hex2UIColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DEFAULT_FONT_SIZE_LARGE 16
#define DEFAULT_FONT_SIZE_MIDDLE 14
#define DEFAULT_FONT_SIZE_SMALL 12

typedef enum{
    ReservationTypeNone,
    ReservationTypeApp,
    ReservationTypePhone
}REVSATION_TYPE;

#define CURRENT_USER @"CurrentUser"

//#define SERVER_HOST @"http://192.168.31.154:9000/api/"
//#define SERVER_HOST @"http://192.168.1.148:9000/api/"
#define SERVER_HOST @"http://www.renaijianyan.com:9095/api"
//#define SERVER_HOST @"http://192.168.1.104:9000/api/"
//#define IMAGE_SERVER_HOST @"http://192.168.1.104:9001/cui/pages/showimage.aspx?filename="
//#define IMAGE_SERVER_HOST @"http://192.168.1.148:9001/cui/pages/showimage.aspx?filename="
#define IMAGE_SERVER_HOST @"http://www.renaijianyan.com:9091/cui/pages/showimage.aspx?filename="

//USER CONTROLLER
#define LOGIN_URL @"user/userLogon"
#define RESET_PASSWORD_URL @"user/resetPassword"
#define FETCH_RESERVATION_AGENDA @"reservation/servicerAgenda"

//block
@class UserModel;
typedef void (^BooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^UserResultBlock)(UserModel *user, NSError *error);
typedef void (^FetchReservationsBlock)(NSMutableArray *reservations,NSError *error);

#endif
