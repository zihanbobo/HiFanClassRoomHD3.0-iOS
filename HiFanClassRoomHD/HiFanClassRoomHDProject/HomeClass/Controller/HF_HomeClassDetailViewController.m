//
//  HF_HomeClassDetailViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/19.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeClassDetailViewController.h"
#import "HF_ClassDetailsTopView.h"
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
    HF_ClassDetailsTopView *topView = [HF_ClassDetailsTopView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.height.mas_equalTo(LineH(245));
    }];
    
    @weakify(self);
    [[topView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
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
