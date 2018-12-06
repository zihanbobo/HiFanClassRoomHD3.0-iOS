//
//  HF_FindMoreHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_FindMoreHomeViewController.h"
#import "HF_FindMoreHomeCycleCell.h"
#import "HF_FindMoreHomeContentCell.h"
#import "HF_FindMoreMoviePlayViewController.h"


@interface HF_FindMoreHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HF_FindMoreHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBigLabel.text = @"Find More";
    self.titleLabel.text = @"发现";
    [self.rightButton setTitle:@"我喜欢的" forState:(UIControlStateNormal)];
    [self.rightButton setImage:UIIMAGE_FROM_NAME(@"爱心") forState:(UIControlStateNormal)];
    
    
    @weakify(self);
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"发现");
     }];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor yellowColor];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return LineH(285);
    }else{
        return LineH(309);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        static NSString *cellID = @"HF_FindMoreHomeCycleCell";
        HF_FindMoreHomeCycleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_FindMoreHomeCycleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UICOLOR_RANDOM_COLOR();
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *cellID = @"HF_FindMoreHomeContentCell";
        HF_FindMoreHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_FindMoreHomeContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

//        cell.backgroundColor = UICOLOR_RANDOM_COLOR();

        return cell;
    } else {
        return nil;
    }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    HF_FindMoreHomeContentCell *cell = [self.tableView cellForRowAtIndexPath:index];
    cell.selectedBlock = ^(NSInteger index) {
        NSLog(@"点击的是 %ld 个",(long)index);
        
        HF_FindMoreMoviePlayViewController *vc = [[HF_FindMoreMoviePlayViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
}



//MARK:滑动动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y-90)/100.0f;
    
    
    if (offset_Y >0 && offset_Y <=64) {
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(126)-offset_Y);
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
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
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navBigLabel.hidden = YES;
        self.navBigLabel.alpha = 0;
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(20)];
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(32), LineW(100), LineH(20));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(36), LineW(100), LineH(16));
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
        
    } else if (offset_Y <0){
        
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(126));
        self.tableView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
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
