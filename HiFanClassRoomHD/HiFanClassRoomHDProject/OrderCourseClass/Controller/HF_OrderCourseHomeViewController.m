//
//  HF_OrderCourseHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_OrderCourseHomeViewController.h"

@interface HF_OrderCourseHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView; //tableView
@end

@implementation HF_OrderCourseHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navImgView.image = UIIMAGE_FROM_NAME(@"Reservations");
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
    [self.view addSubview:self.tableView];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y-75)/100.0f;

    if (offset_Y >0 && offset_Y <=69) {
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132)-offset_Y);
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        CGFloat fontSize =  (100-offset_Y)/100 * 38;
        int a = floor(fontSize); //floor 向下取整
        if (a <=20) {
            a = 20;
        } else {
            a = a;
        }
        self.navImgView.hidden = NO;
        
        self.titleLabel.font = Font(a);
        self.titleLabel.frame = CGRectMake(LineX(17), self.navView.height-LineH(a)-LineH(12), LineW(100), LineH(a));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), self.navView.height-LineH(16)-LineH(12), LineW(100), LineH(16));
    

        self.navImgView.frame = CGRectMake(LineX(14), self.navView.height-LineY(25)-LineH(75), LineW(618), LineH(75));
        self.navImgView.alpha = -alpha;

        
    } else if (offset_Y >0 && offset_Y >69){

        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(64));
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navImgView.hidden = YES;
        self.navImgView.alpha = 0;

        self.titleLabel.font = Font(20);
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(32), LineW(100), LineH(20));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(36), LineW(100), LineH(16));

    } else if (offset_Y <0){

        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(132));
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        self.navImgView.hidden = NO;
        self.navImgView.alpha = 1;
        self.navImgView.frame = CGRectMake(LineX(14), LineY(32), LineW(618), LineH(75));
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(78), LineW(100), LineH(38));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(99), LineW(100), LineH(16));
        self.titleLabel.font = Font(38);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
