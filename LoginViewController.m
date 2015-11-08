//
//  LoginViewController.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "Constants.h"
#import "UserService.h"

@implementation LoginViewController
@synthesize usernameFeild,passwordField,loginButton,logo;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登陆";
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    logo = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 180) / 2, 104, 180, 100)];
    logo.image = [UIImage imageNamed:@"AppLogo"];
//    logo.contentMode = UIViewContentModeScaleAspectFit;
    
    usernameFeild = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logo.frame) + 40, CGRectGetWidth(self.view.frame) - 20, 44)];
    [usernameFeild setPlaceholder:@"用户名"];
    usernameFeild.borderStyle = UITextBorderStyleRoundedRect;
    usernameFeild.delegate = self;
    usernameFeild.text = @"lesly";
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(usernameFeild.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 44)];
    passwordField.placeholder = @"密码";
    passwordField.secureTextEntry = YES;
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.delegate = self;
    passwordField.text = @"8forxiao";
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(passwordField.frame) + 20, CGRectGetWidth(self.view.frame) - 20, 44)];
    loginButton.backgroundColor = Hex2UIColor(0x2987EA);
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [self dismissKeyboard:self.view];
    [self.view addSubview:logo];
    [self.view addSubview:usernameFeild];
    [self.view addSubview:passwordField];
    [self.view addSubview:loginButton];
}

-(void)login
{
    if([self validateInputValue]){
        [self showProgress:nil];
        [UserService userLogin:usernameFeild.text atPassword:passwordField.text callback:^(UserModel *user, NSError *error) {
            [self dismissProgress];
            if(error){
                [self showMessage:[error localizedDescription]];
            }else{
                [AppDelegate setCurrentLogonUser:user];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

-(BOOL)validateInputValue
{
    if(usernameFeild.text == nil || usernameFeild.text.length == 0){
        [self showMessage:@"请输入用户名"];
        return NO;
    }
    
    if(passwordField.text == nil || passwordField.text.length == 0){
        [self showMessage:@"请输入密码"];
        return NO;
    }
    return  YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 45 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
