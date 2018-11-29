//
//  GGT_ScheduleViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/18.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleViewController.h"
#import "GGT_ScheduleUnFinishedViewController.h"
#import "GGT_ScheduleFinishedViewController.h"
//#import "GGT_ApplyClassViewController.h"

@interface GGT_ScheduleViewController ()
@property (nonatomic, strong) GGT_ScheduleUnFinishedViewController  *unFinishedVc;
@property (nonatomic, strong) GGT_ScheduleFinishedViewController  *finishedVc;
//@property (nonatomic, strong) GGT_ApplyClassViewController  *applyClassVc;

@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation GGT_ScheduleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航上的2个切换按钮
    [self initSegmentedControl];
    
    //添加2个子视图
    [self setUpNewController];
}

- (void)setUpNewController {
    
//    self.applyClassVc = [[GGT_ApplyClassViewController alloc] init];
//    [self.applyClassVc.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
//    [self addChildViewController:self.applyClassVc];
    
    self.unFinishedVc = [[GGT_ScheduleUnFinishedViewController alloc] init];
    [self.unFinishedVc.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
    [self addChildViewController:self.unFinishedVc];
    
    self.finishedVc = [[GGT_ScheduleFinishedViewController alloc] init];
    [self.finishedVc.view setFrame:CGRectMake(0, 0, home_right_width, SCREEN_HEIGHT()-64)];

    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.unFinishedVc.view];
    self.currentVC = self.unFinishedVc;
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.3f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        } else {
            self.currentVC = oldController;
        }
    }];
}


- (void)initSegmentedControl {
    //添加到视图
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake((home_right_width-LineW(184))/2, LineY(4), LineW(184), LineH(36));
    self.navigationItem.titleView = titleView;
    
    
    //先生成存放标题的数据
//    NSArray *array = [NSArray arrayWithObjects:@"申请中",@"未完成",@"已结束", nil];

    NSArray *array = [NSArray arrayWithObjects:@"未完成",@"已结束", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake(0, 0, titleView.width, titleView.height);
    //根据内容定分段宽度
    segment.apportionsSegmentWidthsByContent = YES;
    //开始时默认选中下标(第一个下标默认是0)
    segment.selectedSegmentIndex = 0;
    //控件渲染色(也就是外观字体颜色)
    segment.tintColor = [UIColor whiteColor];
    //添加事件
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    //添加到视图
    [titleView addSubview:segment];
}

//点击不同分段就会有不同的事件进行相应
-(void)change:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
//        case 0:
//            //  点击处于当前页面的按钮,直接跳出
//            if (self.currentVC == self.applyClassVc) {
//                return;
//            } else {
//
//                [self replaceController:self.currentVC newController:self.applyClassVc];
//            }
//            break;
        case 0:
            //  点击处于当前页面的按钮,直接跳出
            if (self.currentVC == self.unFinishedVc) {
                return;
            } else {
                
                [self replaceController:self.currentVC newController:self.unFinishedVc];
            }
            break;
        case 1:
            if (self.currentVC == self.finishedVc) {
                return;
            } else {
                [self replaceController:self.currentVC newController:self.finishedVc];
            }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


