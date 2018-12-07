//
//  HF_MyScheduleHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_MyScheduleHomeViewController.h"
#import "HF_MyScheduleHomeHeaderCell.h"
#import "HF_MyScheduleHomeUnFinishedView.h"
#import "HF_MyScheduleHomeFinishedView.h"





#import "HF_MyScheduleHomeUnFinishedCell.h"
#import "HF_MyScheduleHomeFinishedCell.h"


#import "HF_MyScheduleHomeUnfishedListViewController.h"
#import "HF_MyScheduleHomeFishedListViewController.h"

@interface HF_MyScheduleHomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *unFinishedDataArray;
@property (nonatomic, strong) NSMutableArray *finishedDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HF_MyScheduleHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.unFinishedDataArray = [NSMutableArray array];
    self.finishedDataArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];

    self.unFinishedDataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11", nil];
    self.dataArray = self.unFinishedDataArray;
    self.finishedDataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];

}


-(void)initUI {
    self.navBigLabel.text = @"My Schedule";
    self.titleLabel.text = @"课表";
    [self.rightButton setTitle:@"学习攻略" forState:(UIControlStateNormal)];
    [self.rightButton setImage:UIIMAGE_FROM_NAME(@"攻略") forState:(UIControlStateNormal)];
    
    
    @weakify(self);
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"学习攻略");
     }];
    
    
    
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
    [self.view addSubview:self.bigScrollView];
    
    
    HF_MyScheduleHomeHeaderCell *header = [[HF_MyScheduleHomeHeaderCell alloc] init];
    header.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    header.frame = CGRectMake(0, 0, home_right_width, LineH(85));
    header.unFinishedBlock = ^{
        NSLog(@"未完成");
        if (self.contentScrollView.contentOffset.x == 0) {
            return;
        }
        self.contentScrollView.contentOffset = CGPointMake(0, 0);
    };
    
    
    header.finishedBlock = ^{
        NSLog(@"已完成");
        if (self.contentScrollView.contentOffset.x == home_right_width) {
            return;
        }
        self.contentScrollView.contentOffset = CGPointMake(home_right_width, 0);
    };
    [self.bigScrollView addSubview:header];
    

    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.frame = CGRectMake(0, header.y+header.height, home_right_width, self.bigScrollView.height - LineH(85));
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(home_right_width*2, self.contentScrollView.height);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.bigScrollView addSubview:self.contentScrollView];
    
    
    
    HF_MyScheduleHomeUnFinishedView *unFinishedView = [[HF_MyScheduleHomeUnFinishedView alloc] init];
    unFinishedView.frame = CGRectMake(0, 0, home_right_width, self.contentScrollView.height);
    unFinishedView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.contentScrollView addSubview:unFinishedView];
    
    
    HF_MyScheduleHomeFinishedView *finishedView = [[HF_MyScheduleHomeFinishedView alloc] init];
    finishedView.frame = CGRectMake(home_right_width, 0, home_right_width, self.contentScrollView.height);
    finishedView.backgroundColor = UICOLOR_RANDOM_COLOR();
    [self.contentScrollView addSubview:finishedView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

//MARK:滑动动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y-90)/100.0f;
    
    NSLog(@"%f",offset_Y);

    
    if (offset_Y >0 && offset_Y <=64) {
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(126)-offset_Y);
        self.collectionView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        CGFloat fontSize =  (90-offset_Y)/90 * 38;
        int a = floor(fontSize); //floor 向下取整
        a = (a>20 ? a : 20);  //三目运算符
        self.navBigLabel.hidden = NO;
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(a)];
        self.titleLabel.frame = CGRectMake(LineX(17), self.navView.height-LineH(a)-LineH(12), LineW(100), LineH(a));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), self.navView.height-LineH(16)-LineH(12), LineW(100), LineH(16));
        
        
        self.navBigLabel.frame = CGRectMake(LineX(14), self.navView.height-LineH(91), home_right_width-LineW(28), LineH(90));
        self.navBigLabel.alpha = -alpha;
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
        
        
    } else if (offset_Y >0 && offset_Y >64){
        
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(64));
        self.collectionView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navBigLabel.hidden = YES;
        self.navBigLabel.alpha = 0;
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(20)];
       
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(32), LineW(100), LineH(20));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(36), LineW(100), LineH(16));
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
        
    } else if (offset_Y <0){
        
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(126));
        self.collectionView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        self.navBigLabel.hidden = NO;
        self.navBigLabel.alpha = 1;
        self.navBigLabel.frame = CGRectMake(LineX(14), LineY(35), home_right_width-LineW(28), LineH(90));
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(72), LineW(100), LineH(38));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(93), LineW(100), LineH(16));
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
