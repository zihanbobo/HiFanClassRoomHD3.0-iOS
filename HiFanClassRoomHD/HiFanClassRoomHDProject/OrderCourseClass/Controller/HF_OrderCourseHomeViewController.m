//
//  HF_OrderCourseHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_OrderCourseHomeViewController.h"

@interface HF_OrderCourseHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *navImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;


@end

@implementation HF_OrderCourseHomeViewController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.alpha = 1;
    
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, home_right_width, LineH(132))];
    self.navView.backgroundColor = [UIColor greenColor];
//    self.navView.alpha = 1;
    [self.view addSubview:self.navView];
    
    
    self.navImgView = [[UIImageView alloc] initWithFrame:CGRectMake(LineX(14), LineY(32), LineW(618), LineH(75))];
    self.navImgView.image = UIIMAGE_FROM_NAME(@"Reservations");
    self.navImgView.alpha = 1;
    [self.navView addSubview:self.navImgView];
    
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LineX(17), LineY(78), LineW(100), LineH(38))];
    self.titleLabel.text = @"约课";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = Font(38);
    [self.navView addSubview:self.titleLabel];

    
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button.frame = CGRectMake(home_right_width-LineW(120), LineY(99), LineW(100), LineH(16));
    [self.button setTitle:@"学习攻略" forState:(UIControlStateNormal)];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.titleLabel.font = Font(16);
    [self.navView addSubview:self.button];
    
    @weakify(self);
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"学习攻略");
     }];
    


    
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height) style:UITableViewStylePlain];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.tableFooterView = [[UIView alloc] init];
    self.homeTableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.homeTableView];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 132; //20 12 100
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 100)];
//    mainView.backgroundColor = [UIColor grayColor];
//
//
//    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 200)];
//    self.headImage.image = [UIImage imageNamed:@"Reservations"];
//    [mainView addSubview:self.headImage];
//
//
//    return mainView;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"111");
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y-75)/100.0f;

    
    
    NSLog(@"%f     %f",offset_Y,alpha);
    
    
    if (offset_Y >0 && offset_Y <=69) {
        NSLog(@"1--------------------1");
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132)-offset_Y);
        self.homeTableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
    
        
        CGFloat fontSize =  (100-offset_Y)/100 * 38;
        int a = floor(fontSize); //floor 向下取整
        if (a <=20) {
            a = 20;
        } else {
            a = a;
        }
        self.navImgView.hidden = NO;
//        CGFloat h = LineH(75)-offset_Y;
//        self.navImgView.frame = CGRectMake(LineX(14), self.navView.height-LineH(25)-h, LineW(618), h);
        
        
        self.titleLabel.font = Font(a);
        self.titleLabel.frame = CGRectMake(LineX(17), self.navView.height-LineH(a)-LineH(12), LineW(100), LineH(a));
        self.button.frame = CGRectMake(home_right_width-LineW(120), self.navView.height-LineH(16)-LineH(12), LineW(100), LineH(16));
    

        self.navImgView.frame = CGRectMake(LineX(14), self.navView.height-LineY(25)-LineH(75), LineW(618), LineH(75));
        self.navImgView.alpha = -alpha;

        
    } else if (offset_Y >0 && offset_Y >69){
        NSLog(@"2--------------------2");

        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(64));
        self.homeTableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navImgView.hidden = YES;
        self.navImgView.alpha = 0;

        self.titleLabel.font = Font(20);
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(32), LineW(100), LineH(20));
        self.button.frame = CGRectMake(home_right_width-LineW(120), LineY(36), LineW(100), LineH(16));

    } else if (offset_Y <0){
        NSLog(@"3--------------------3");

        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132));
        self.homeTableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        self.navImgView.hidden = NO;
        self.navImgView.alpha = 1;
        self.navImgView.frame = CGRectMake(LineX(14), LineY(32), LineW(618), LineH(75));
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(78), LineW(100), LineH(38));
        self.button.frame = CGRectMake(home_right_width-LineW(120), LineY(99), LineW(100), LineH(16));
        self.titleLabel.font = Font(38);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
