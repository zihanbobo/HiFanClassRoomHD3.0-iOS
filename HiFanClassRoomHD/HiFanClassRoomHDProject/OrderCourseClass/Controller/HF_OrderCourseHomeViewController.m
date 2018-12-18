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
    

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, home_right_width, SCREEN_HEIGHT()) style:UITableViewStylePlain];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
