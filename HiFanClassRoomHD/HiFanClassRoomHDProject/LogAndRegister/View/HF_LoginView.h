//
//  HF_LoginView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HF_LoginView : UIView <UITextFieldDelegate>
//手机输入框
@property (nonatomic, strong) UITextField *phoneAccountField;
//密码输入框
@property (nonatomic, strong) UITextField *passwordField;


//忘记密码
@property (nonatomic, strong) UIButton *forgotPasswordButton;
//登录
@property (nonatomic, strong) UIButton *loginButton;
//注册
@property (nonatomic, strong) UIButton *registerButton;
@end

