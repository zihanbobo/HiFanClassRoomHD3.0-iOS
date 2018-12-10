//
//  HF_OrderCourseHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_OrderCourseHomeViewController.h"
#import "HF_OrderCourseListViewController.h"
@interface HF_OrderCourseHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property(nonatomic, strong) UIButton *appointmentCourseButton;  //预约课程按钮
@end

@implementation HF_OrderCourseHomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    
    self.navBigLabel.text = @"Class Booking";
    self.titleLabel.text = @"约课";
    [self.rightButton setTitle:@"学习攻略" forState:(UIControlStateNormal)];
    [self.rightButton setImage:UIIMAGE_FROM_NAME(@"攻略") forState:(UIControlStateNormal)];
    
    
    @weakify(self);
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"学习攻略");
     }];
    

    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor yellowColor];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //创建约课按钮
    [self initAppointmentCourseButton];

    
    
}


#pragma mark -- 创建预约课程按钮
- (void)initAppointmentCourseButton {
    @weakify(self);
    self.appointmentCourseButton = [UIButton new];
    [self.appointmentCourseButton setTitle:@"约 课" forState:UIControlStateNormal];
    self.appointmentCourseButton.titleLabel.font = Font(18);
    [self.appointmentCourseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.appointmentCourseButton.layer.masksToBounds = YES;
    self.appointmentCourseButton.layer.cornerRadius = 60 / 2;
    [self.appointmentCourseButton setBackgroundColor:UICOLOR_FROM_HEX(0x02B6E3)];
    //[self.appointmentCourseButton addTarget:self action:@selector(orderCourseList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.appointmentCourseButton];
    [self.appointmentCourseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).offset(-15);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(60);
    }];
    
    [[self.appointmentCourseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        HF_OrderCourseListViewController *orList = [HF_OrderCourseListViewController new];
        NSLog(@"%@",self.navigationController);
        NSLog(@"约课按钮被点击");
        [self.navigationController pushViewController:orList animated:YES];
    }];
}

- (void)orderCourseList {
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 768;
    }else{
        return 20;
    }
}

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


//MARK:滑动动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y-75)/100.0f;
    
    if (offset_Y >0 && offset_Y <=69) {
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132)-offset_Y);
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        CGFloat fontSize =  (100-offset_Y)/100 * 38;
        int a = floor(fontSize); //floor 向下取整
        a = (a>20 ? a : 20);  //三目运算符
        self.navBigLabel.hidden = NO;

        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(a)];
        self.titleLabel.frame = CGRectMake(LineX(17), self.navView.height-LineH(a)-LineH(12), LineW(100), LineH(a));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), self.navView.height-LineH(16)-LineH(12), LineW(100), LineH(16));
        
        
        self.navBigLabel.frame = CGRectMake(LineX(14), self.navView.height-LineY(25)-LineH(75), home_right_width-LineW(28), LineH(75));
        self.navBigLabel.alpha = -alpha;
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
        
        
    } else if (offset_Y >0 && offset_Y >69){
        
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(64));
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navBigLabel.hidden = YES;
        self.navBigLabel.alpha = 0;
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(20)];
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(32), LineW(100), LineH(20));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(36), LineW(100), LineH(16));
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
        
    } else if (offset_Y <0){
        
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132));
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        self.navBigLabel.hidden = NO;
        self.navBigLabel.alpha = 1;
        self.navBigLabel.frame = CGRectMake(LineX(14), LineY(32), home_right_width-LineW(28), LineH(75));
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(78), LineW(100), LineH(38));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(99), LineW(100), LineH(16));
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
