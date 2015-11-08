//
//  BaseViewController.h
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void) showProgress:(NSString *) message;

- (void) dismissProgress;

- (void) showMessage:(NSString *) message;

//隐藏输入键盘
- (void) dismissKeyboard:(UIView *) view;
@end
