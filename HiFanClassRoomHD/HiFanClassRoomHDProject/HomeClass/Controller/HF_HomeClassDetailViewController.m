//
//  HF_HomeClassDetailViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/19.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeClassDetailViewController.h"

@interface HF_HomeClassDetailViewController ()
//关闭
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation HF_HomeClassDetailViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 600;
        tempSize.height = SCREEN_HEIGHT()-145;
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //检测设备
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(20)];
    titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    titleLabel.text = @"课程详情";
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.top.equalTo(self.view.mas_top).offset(26);
        make.height.mas_offset(20);
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.top.equalTo(self.view.mas_top).offset(63);
        make.height.mas_offset(1);
    }];
    
    
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:UIIMAGE_FROM_NAME(@"close") forState:(UIControlStateNormal)];
    [self.view addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    
    @weakify(self);
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
