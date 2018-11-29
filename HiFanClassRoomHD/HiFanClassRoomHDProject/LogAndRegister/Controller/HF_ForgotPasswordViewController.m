//
//  HF_ForgotPasswordViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "HF_ForgotPasswordViewController.h"
#import "HF_ForgotPasswordView.h"
#import "UIButton+timer.h"

@interface HF_ForgotPasswordViewController ()

@property (nonatomic, strong) HF_ForgotPasswordView *forgotPasswordView;
@end

@implementation HF_ForgotPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackButton];
    
    self.navigationItem.title = @"忘记密码";
    
    
    self.forgotPasswordView = [[HF_ForgotPasswordView alloc]init];
    self.forgotPasswordView.backgroundColor = [UIColor whiteColor];
    self.view = self.forgotPasswordView;
    
    
    //获取验证码
    @weakify(self);
    [[self.forgotPasswordView.getCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self getCodeLoadData];
     }];
    
    //确认按钮
    [[self.forgotPasswordView.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self confirmLoadData];
     }];
    
}

#pragma mark 确认
- (void)confirmLoadData {
    //需要先对文本放弃第一响应者
    [self.forgotPasswordView.phoneAccountField resignFirstResponder];
    [self.forgotPasswordView.verificationCodeField resignFirstResponder];
    [self.forgotPasswordView.passwordField resignFirstResponder];
    
    if(IsStrEmpty(self.forgotPasswordView.phoneAccountField.text)) {
        [MBProgressHUD showMessage:@"请输入手机号码" toView:self.view];
        return;
    }
    
    
    //判断第一位是否是1开头
    NSString *firstStr = [self.forgotPasswordView.phoneAccountField.text substringToIndex:1];
    if (![firstStr isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    
    //验证码
    if (IsStrEmpty(self.forgotPasswordView.verificationCodeField.text)) {
        [MBProgressHUD showMessage:@"验证码不能为空" toView:self.view];
        return;
    }
    
    //密码验证
    if(IsStrEmpty(self.forgotPasswordView.passwordField.text) || self.forgotPasswordView.passwordField.text.length <6 || self.forgotPasswordView.passwordField.text.length >12) {
        [MBProgressHUD showMessage:@"请设置6-12位的登录密码" toView:self.view];
        return;
    }
    
    
    
    NSDictionary *postDic = @{@"cell":self.forgotPasswordView.phoneAccountField.text,@"code":self.forgotPasswordView.verificationCodeField.text,@"newPsw":self.forgotPasswordView.passwordField.text};
    
    
    [[BaseService share] sendPostRequestWithPath:URL_ChangePwdByCode parameters:postDic token:NO viewController:self success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        
        [self performSelector:@selector(turnToHomeClick) withObject:nil afterDelay:0.0f];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
}

-(void)turnToHomeClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 获取验证码
- (void)getCodeLoadData {
    if(IsStrEmpty(self.forgotPasswordView.phoneAccountField.text)) {
        [MBProgressHUD showMessage:@"请输入手机号码" toView:self.view];
        return;
    }
    
    
    //判断第一位是否是1开头
    NSString *firstStr = [self.forgotPasswordView.phoneAccountField.text substringToIndex:1];
    if (![firstStr isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    
    //拼接地址,使用？拼接
    NSString *cellStr = [NSString stringWithFormat:@"cell=%@",self.forgotPasswordView.phoneAccountField.text];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",URL_GetChangePasswordSMS,cellStr];
    
    [[BaseService share] sendGetRequestWithPath:urlStr token:NO viewController:self success:^(id responseObject) {
        
        [self.forgotPasswordView.getCodeButton addTimer];
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
    
}


@end
