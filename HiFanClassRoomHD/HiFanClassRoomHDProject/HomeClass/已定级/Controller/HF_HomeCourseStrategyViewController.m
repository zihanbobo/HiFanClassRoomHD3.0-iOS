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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
