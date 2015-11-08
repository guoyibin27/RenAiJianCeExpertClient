//
//  ChattingRoomViewController.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "ChattingRoomViewController.h"
#import "ReservationModel.h"
#import "Constants.h"
#import "LeanChatLib.h"

@implementation ChattingRoomViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"咨询室"];
    [self setBackgroundColor:Hex2UIColor(0xf5f5f5)];
    self.view.backgroundColor = Hex2UIColor(0xe6e6e6);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"结束咨询" style:UIBarButtonItemStylePlain target:self action:@selector(finishReservation)];
    [self navigationItem].rightBarButtonItem = rightButton;
}


-(void)finishReservation{
    [[CDChatManager manager] removeMembersWithClientIds:self.conv.members conversation:self.conv block:^(BOOL succeeded, NSError *error) {
        if(error){
            [self alert:@"结束咨询请求发送失败，请重试!"];
        }else{
            [[CDChatManager manager] deleteConversation:self.conv];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)alert:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil message:msg delegate:nil
                              cancelButtonTitle   :@"确定" otherButtonTitles:nil];
    [alertView show];
}
@end
