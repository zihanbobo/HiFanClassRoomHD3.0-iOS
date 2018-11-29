//
//  GGT_ViewControllerTest.m
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/7/21.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "HF_LaunchViewController.h"

@interface HF_LaunchViewController ()
@property (nonatomic, strong) UIImageView *xc_imgView;
@end

@implementation HF_LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.xc_imgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = [UIImage xc_getLaunchImage];
        imgView;
    });
    [self.view addSubview:self.xc_imgView];
    
    [self.xc_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

@end
