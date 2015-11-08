//
//  LoginViewController.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>

@property (retain, nonatomic) UIImageView *logo;
@property (retain, nonatomic) UITextField *usernameFeild;
@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) UIButton *loginButton;

-(void)login;
@end
