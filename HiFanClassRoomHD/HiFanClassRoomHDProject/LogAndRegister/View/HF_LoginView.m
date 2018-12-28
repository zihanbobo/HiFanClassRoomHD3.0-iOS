//
//  HF_LoginView.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_LoginView.h"

@implementation HF_LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UICOLOR_FROM_HEX(0xF0F7FD);
        [self setUpLoginView];
    }
    return self;
}

- (void)setUpLoginView {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group"]];
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    UILabel *welcomeLabel = [UILabel new];
    welcomeLabel.font = Font(100);
    welcomeLabel.text = @"Welcome";
    welcomeLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 10);
    [welcomeLabel sizeToFit];
    [self addSubview:welcomeLabel];
    [welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(25);
        make.left.equalTo(self.mas_left).offset(35);
        make.width.mas_equalTo(439);
        make.height.mas_equalTo(100);
    }];
    UILabel *loginLabel = [UILabel new];
    loginLabel.font = Font(38);
    loginLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    loginLabel.text = @"登录";
    [loginLabel sizeToFit];
    [self addSubview:loginLabel];
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(welcomeLabel.mas_left).offset(0);
        make.bottom.equalTo(welcomeLabel.mas_bottom).offset(-7);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(50);
    }];
    //手机号码
    self.phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(LineX(467), LineY(312), LineW(97), LineH(16))];
    self.phoneTitle.font = Font(16);
    self.phoneTitle.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 40);
    self.phoneTitle.text = @"手机号码";
    [self addSubview:self.phoneTitle];
    self.phoneAccountField = [[UITextField alloc] initWithFrame:CGRectMake(LineX(467), LineY(312), LineW(540), LineH(33))];
    self.phoneAccountField.tag = 1;
    
    [self addSubview:self.phoneAccountField];
    self.phoneLine = [[UIView alloc] initWithFrame:CGRectMake(LineX(467), LineY(345), LineW(540), 1)];
    self.phoneLine.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0xEAEFF3, 100);
    [self addSubview:self.phoneLine];
    
    //密码
    self.passwordTitle = [[UILabel alloc] initWithFrame:CGRectMake(LineX(467), LineY(382), LineW(97), LineH(16))];
    self.passwordTitle.font = Font(16);
    self.passwordTitle.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 40);
    self.passwordTitle.text = @"登录密码";
    
    [self addSubview:self.passwordTitle];
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(LineX(467), LineY(382), LineW(540), LineH(33))];
    self.passwordField.tag = 2;
    self.passwordField.secureTextEntry = YES;
    [self addSubview:self.passwordField];
    
    self.passwordLine = [[UIView alloc] initWithFrame:CGRectMake(LineX(467), LineY(415), LineW(540), 1)];
    self.passwordLine.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0xEAEFF3, 100);
    [self addSubview:self.passwordLine];
    //密码显示状态
    self.showPasswordStatusBtn = [UIButton new];
    [self.showPasswordStatusBtn setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    [self addSubview:self.showPasswordStatusBtn];
    [self.showPasswordStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LineW(28));
        make.height.mas_equalTo(LineH(16));
        make.centerY.equalTo(self.passwordField.mas_centerY);
        make.right.equalTo(self.passwordField.mas_right).offset(-20);
    }];
    
    
    
    
    //登录按钮
    self.loginButton = [UIButton new];
    [self.loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateNormal];
    self.loginButton.titleEdgeInsets = UIEdgeInsetsMake(-7, 0, 0, 0);
    [self addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.passwordLine.mas_bottom).offset(50);
        make.width.mas_equalTo(153);
        make.height.mas_equalTo(80);
    }];
}

@end
