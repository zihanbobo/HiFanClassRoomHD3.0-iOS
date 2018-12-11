//
//  HF_MineViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MineHomeViewController.h"
#import "HF_MineHomeHeaderCell.h"
#import "HF_MineHomeTableViewCell.h"
#import "HF_MineClassCountViewController.h"

@interface HF_MineHomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *loginOutButton;

@end

@implementation HF_MineHomeViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);

    [self initUI];
 
}

-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
    }
    return _tableView;
}


-(UIButton *)loginOutButton {
    if (!_loginOutButton) {
        self.loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginOutButton setTitleColor:UICOLOR_FROM_HEX(0xFB9901) forState:UIControlStateNormal];
        [self.loginOutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
        self.loginOutButton.titleLabel.font = Font(18);
        self.loginOutButton.layer.masksToBounds = YES;
        self.loginOutButton.layer.cornerRadius = LineH(25);
        self.loginOutButton.layer.borderColor = UICOLOR_FROM_HEX(0xFB9901).CGColor;
        self.loginOutButton.layer.borderWidth = LineW(1);
    }
    return _loginOutButton;
}



- (void)initUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
    }];
    
    
    [self.view addSubview:self.loginOutButton];
    [self.loginOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.mas_equalTo(50);
    }];
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellStr = @"HF_MineHomeHeaderCell";
        HF_MineHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HF_MineHomeHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        static NSString *cellStr = @"HF_MineHomeTableViewCell";
        HF_MineHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HF_MineHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HF_MineClassCountViewController *vc = [[HF_MineClassCountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return LineH(190);
    }
    return LineH(50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
