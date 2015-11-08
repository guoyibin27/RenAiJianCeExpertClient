//
//  BaseViewController.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "BaseViewController.h"
#import "ProgressHUD.h"
#import "Constants.h"

@implementation BaseViewController

- (void) showMessage:(NSString *) message {
    if(self.view.window){
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
    }
}

- (void) showProgress:(NSString *) message{
    [ProgressHUD show:message Interaction:NO];
}

- (void) dismissProgress{
    [ProgressHUD dismiss];
}

- (void) viewDidDisappear:(BOOL)animated{
    if(self.view.window){
        [ProgressHUD dismiss];
    }
}

- (void) dismissKeyboard:(UIView *) view{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [view addGestureRecognizer:tapGestureRecognizer];
}

- (void) keyboardHide:(id)sender{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
    [recognizer.view endEditing:YES];
}

@end
