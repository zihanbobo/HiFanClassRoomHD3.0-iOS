//
//  GGT_LoginViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_LoginViewController.h"
#import "GGT_ForgotPasswordViewController.h"
#import "GGT_RegisterViewController.h"
#import "GGT_LoginView.h"
#import "HF_HomeViewController.h"
#import "JPUSHService.h"


@interface GGT_LoginViewController ()

@property (nonatomic, strong) GGT_LoginView *loginView;

@end

@implementation GGT_LoginViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//设置状态条为黑色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginView = [[GGT_LoginView alloc]init];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.view = self.loginView;
    
    
    //对手机号进行存储
    if (!IsStrEmpty([UserDefaults() objectForKey:@"phoneNumber"])) {
        self.loginView.phoneAccountField.text = [UserDefaults() objectForKey:@"phoneNumber"];
    }
    
    
    //忘记密码
    @weakify(self);
    [[self.loginView.forgotPasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         GGT_ForgotPasswordViewController *vc = [[GGT_ForgotPasswordViewController alloc]init];
         [self.navigationController pushViewController:vc animated:YES];
     }];
    
    
    //注册
    [[self.loginView.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         GGT_RegisterViewController *vc = [[GGT_RegisterViewController alloc]init];
         [self.navigationController pushViewController:vc animated:YES];
     }];
    
    //登录
    [[self.loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         
         [self loginLoadData];
         
         //非接口登录----测试用
         //         [self turnToHomeClick];
     }];
    
}


#pragma mark 登录按钮处理
- (void)loginLoadData {
    //需要先对文本放弃第一响应者
    [self.loginView.phoneAccountField resignFirstResponder];
    [self.loginView.passwordField resignFirstResponder];
    
    
    if(IsStrEmpty(self.loginView.phoneAccountField.text)) {
        [MBProgressHUD showMessage:@"请输入手机号码" toView:self.view];
        return;
    }
    
    
    //判断第一位是否是1开头
    NSString *firstStr = [self.loginView.phoneAccountField.text substringToIndex:1];
    if (![firstStr isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    
    //密码验证
    if(IsStrEmpty(self.loginView.passwordField.text) || self.loginView.passwordField.text.length <6 || self.loginView.passwordField.text.length >18) {
        [MBProgressHUD showMessage:@"请输入正确的登录密码（6-18位）" toView:self.view];
        return;
    }
    
    
    NSDictionary *postDic = @{@"UserName":self.loginView.phoneAccountField.text,@"Password":self.loginView.passwordField.text};

    [[BaseService share] sendPostRequestWithPath:URL_Login parameters:postDic token:NO viewController:self success:^(id responseObject) {

        [UserDefaults() setObject:responseObject[@"data"][@"userToken"] forKey:K_userToken];
        [UserDefaults() setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"accountID"]] forKey:K_AccountID];
        [UserDefaults() setObject:self.loginView.phoneAccountField.text forKey:@"phoneNumber"];
        [UserDefaults() setObject:self.loginView.passwordField.text forKey:K_password];
        [UserDefaults() synchronize];
        
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        
        [self performSelector:@selector(turnToHomeClick) withObject:nil afterDelay:0.0f];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
    
}

- (void)turnToHomeClick {
    [UserDefaults() setObject:@"yes" forKey:@"login"];
    [UserDefaults() synchronize];
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    sin.isShowVersionUpdateAlert = YES;
    HF_HomeViewController *homeVc = [[HF_HomeViewController alloc]init];
    [self.navigationController pushViewController:homeVc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
