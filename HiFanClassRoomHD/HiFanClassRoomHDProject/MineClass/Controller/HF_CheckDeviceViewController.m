//
//  HF_CheckDeviceViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/13.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_CheckDeviceViewController.h"
#import "HF_CheckDeviceView.h"

@interface HF_CheckDeviceViewController ()
@property (nonatomic, strong) HF_CheckDeviceView *checkDeviceView;
@end

@implementation HF_CheckDeviceViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 462;
        tempSize.height = 323;//368 切图是368，减去45的导航高度
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
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];

    self.checkDeviceView = [[HF_CheckDeviceView alloc]init];
    [self.view addSubview:self.checkDeviceView];

    [self.checkDeviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    @weakify(self);
    [[self.checkDeviceView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    [[self.checkDeviceView.cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    
    [[self.checkDeviceView.setButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
     }];
    
}

@end
