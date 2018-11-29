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
//    self.navigationController.navigationBar.alpha = 1;
    
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, home_right_width, LineH(132))];
    self.navView.backgroundColor = [UIColor redColor];
//    self.navView.alpha = 1;
    [self.view addSubview:self.navView];
    
    
    self.navImgView = [[UIImageView alloc] initWithFrame:CGRectMake(LineX(14), LineY(32), LineW(618), LineH(75))];
    self.navImgView.image = UIIMAGE_FROM_NAME(@"Reservations");
    [self.navView addSubview:self.navImgView];
    
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LineX(17), LineY(72), LineW(100), LineH(38))];
    self.titleLabel.text = @"约课";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = Font(38);
    [self.navView addSubview:self.titleLabel];

    
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button.frame = CGRectMake(LineX(843), LineY(93), LineW(100), LineH(16));
    [self.button setTitle:@"学习攻略" forState:(UIControlStateNormal)];
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
    CGFloat alpha = (offset_Y - 64)/100.0f;

    
    
    NSLog(@"%f",offset_Y);
    
    
    if (offset_Y >0 && offset_Y <=69) {
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132)-offset_Y);
        self.homeTableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        self.navImgView.hidden = NO;
        self.navImgView.frame = CGRectMake(LineX(14), LineY(32)-offset_Y, LineW(618), LineH(75)-offset_Y);
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(72)-offset_Y, LineW(100), LineH(38));
        self.button.frame = CGRectMake(LineX(843), LineY(93)-offset_Y, LineW(100), LineH(16));
        self.titleLabel.font = Font(offset_Y/18);

        
    } else if (offset_Y >0 && offset_Y >69){
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(64));
        self.homeTableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navImgView.hidden = YES;
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(32), LineW(100), LineH(38));
        self.button.frame = CGRectMake(LineX(843), LineY(36), LineW(100), LineH(16));
        self.titleLabel.font = Font(20);

        
    } else if (offset_Y <0){
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132));
        self.homeTableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navImgView.hidden = NO;

        self.navImgView.frame = CGRectMake(LineX(14), LineY(32), LineW(618), LineH(75));
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(72), LineW(100), LineH(38));
        self.button.frame = CGRectMake(LineX(843), LineY(93), LineW(100), LineH(16));
        self.titleLabel.font = Font(38);
    }

    
    
 

    
//    if (alpha <= 0) {
//        self.navView.alpha = 0;
//    }else {
//        self.navView.alpha = alpha;
//    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
