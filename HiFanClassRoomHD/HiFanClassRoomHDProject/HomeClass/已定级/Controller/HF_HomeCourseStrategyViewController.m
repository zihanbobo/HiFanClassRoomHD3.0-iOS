//
//  HF_HomeCourseStrategyViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeCourseStrategyViewController.h"

@interface HF_HomeCourseStrategyViewController ()

@end

@implementation HF_HomeCourseStrategyViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftItem:@"箭头"];
    self.navigationItem.title = @"课程攻略";
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = UIIMAGE_FROM_NAME(@"课程攻略背景图片");
    [self.view addSubview:imgView];

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
