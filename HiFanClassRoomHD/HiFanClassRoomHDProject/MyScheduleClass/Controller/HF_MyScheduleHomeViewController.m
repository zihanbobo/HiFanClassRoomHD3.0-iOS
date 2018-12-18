//
//  HF_MyScheduleHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_MyScheduleHomeViewController.h"
#import "HF_MyScheduleHomeHeaderCell.h"
#import "HF_MyScheduleHomeUnFinishedCell.h"
#import "HF_MyScheduleHomeFinishedCell.h"


#import "HF_MyScheduleHomeUnfishedListViewController.h"
#import "HF_MyScheduleHomeFishedListViewController.h"

static BOOL isFirst;
@interface HF_MyScheduleHomeViewController ()
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *unFinishedDataArray;
@property (nonatomic, strong) NSMutableArray *finishedDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HF_MyScheduleHomeHeaderCell *headerView;


@property (nonatomic, strong) HF_MyScheduleHomeUnfishedListViewController *unFinishedListVC;
@property (nonatomic, strong) HF_MyScheduleHomeFishedListViewController *finishedListVC;
@end

@implementation HF_MyScheduleHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.unFinishedDataArray = [NSMutableArray array];
    self.finishedDataArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    isFirst = NO;
    self.unFinishedDataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11", nil];
    self.dataArray = self.unFinishedDataArray;
    self.finishedDataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
}


-(void)initUI {

    //    self.bigScrollView = [[UIScrollView alloc] init];
    //    self.bigScrollView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
    //    [self.view addSubview:self.bigScrollView];
    
    __weak HF_MyScheduleHomeViewController *weakSelf  = self;
    self.headerView = [[HF_MyScheduleHomeHeaderCell alloc] init];
    self.headerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.headerView.frame = CGRectMake(0, 0, home_right_width, LineH(85));
    self.headerView.unFinishedBlock = ^{
        NSLog(@"未完成");
        //        if (self.contentScrollView.contentOffset.x == 0) {
        //            return;
        //        }
        //        self.contentScrollView.contentOffset = CGPointMake(0, 0);
    };
    
    
    self.headerView.finishedBlock = ^{
        NSLog(@"已完成");
        //        if (self.contentScrollView.contentOffset.x == home_right_width) {
        //            return;
        //        }
        //        self.contentScrollView.contentOffset = CGPointMake(home_right_width, 0);
    };
    [self.view addSubview:self.headerView];
    
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.frame = CGRectMake(0, 0, home_right_width, SCREEN_HEIGHT());
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(home_right_width*2, self.contentScrollView.height);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
//    self.contentScrollView.backgroundColor = UICOLOR_FROM_HEX(Color000000);
    self.contentScrollView.backgroundColor = UICOLOR_RANDOM_COLOR();

    [self.view addSubview:self.contentScrollView];
    
    self.unFinishedListVC = [[HF_MyScheduleHomeUnfishedListViewController alloc] init];
    self.unFinishedListVC.view.frame = CGRectMake(0, 0, home_right_width, self.contentScrollView.height);
    self.unFinishedListVC.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.unFinishedListVC.scrollHeightBlock = ^(CGFloat height) {

    };
    [self.contentScrollView addSubview:self.unFinishedListVC.view];
    
    
    self.finishedListVC = [[HF_MyScheduleHomeFishedListViewController alloc] init];
    self.finishedListVC.view.frame = CGRectMake(home_right_width, 0, home_right_width, self.contentScrollView.height);
    self.finishedListVC.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.finishedListVC.scrollHeightBlock = ^(CGFloat height) {

    };
    [self.contentScrollView addSubview:self.finishedListVC.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
