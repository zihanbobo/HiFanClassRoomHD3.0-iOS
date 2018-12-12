//
//  HF_LoginView.h
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HF_LoginView : UIView
//手机输入框提示Lable
@property (nonatomic, strong) UILabel *phoneTitle;
//手机输入框
@property (nonatomic, strong) UITextField *phoneAccountField;
//手机分割线
@property (nonatomic, strong) UIView *phoneLine;

//密码输入框提示Label
@property (nonatomic, strong) UILabel *passwordTitle;
//密码输入框
@property (nonatomic, strong) UITextField *passwordField;
//密码分割线
@property (nonatomic, strong) UIView *passwordLine;
//密码显示状态
@property (nonatomic, strong) UIButton *showPasswordStatusBtn;


//忘记密码
@property (nonatomic, strong) UIButton *forgotPasswordButton;
//登录
@property (nonatomic, strong) UIButton *loginButton;
//注册
@property (nonatomic, strong) UIButton *registerButton;
@end

NS_ASSUME_NONNULL_END
