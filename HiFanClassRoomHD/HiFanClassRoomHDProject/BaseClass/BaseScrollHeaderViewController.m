//
//  BaseScrollHeaderViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/30.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseScrollHeaderViewController.h"

@interface BaseScrollHeaderViewController ()
@end

@implementation BaseScrollHeaderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    //MARK:导航View
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, home_right_width, LineH(126))];
    self.navView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.view addSubview:self.navView];
    
    //MARK:导航背景大字体 126-90-1 = 35
    self.navBigLabel = [[UILabel alloc] initWithFrame:CGRectMake(LineX(14), LineY(35), home_right_width-LineW(28), LineH(90))];
    self.navBigLabel.alpha = 1;
    self.navBigLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:LineH(86)];
    self.navBigLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 5);
    [self.navView addSubview:self.navBigLabel];
    
    //MARK:导航文字 126-38-16 = 72
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LineX(17), LineY(72), LineW(100), LineH(38))];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
    self.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [self.navView addSubview:self.titleLabel];
    
    //MARK:导航按钮 126-16-17 = 93
    self.rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(93), LineW(100), LineH(16));
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = Font(16);
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(2.5), 0, 0);
    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(2.5));
    [self.navView addSubview:self.rightButton];
    
    //MARK:导航分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(LineX(17), LineY(125), home_right_width-LineW(34), LineH(1));
    self.lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self.view addSubview:self.lineView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
