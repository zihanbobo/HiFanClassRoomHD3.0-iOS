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
#import "HF_MineHomeInfoModel.h"
#import "HF_CheckDeviceViewController.h"
#import "HF_TechnicalDebugViewController.h"

@interface HF_MineHomeViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *loginOutButton;
@property (nonatomic, strong) HF_Singleton *sin;
@property (nonatomic, strong) HF_MineHomeInfoModel *model;
@end

@implementation HF_MineHomeViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.sin = [HF_Singleton sharedSingleton];
    self.dataArray = [NSMutableArray array];

    if (self.sin.isAuditStatus == YES) {
        self.dataArray = [NSMutableArray arrayWithObjects:@"",@"清除缓存",@"设备检测",@"在线技术支持", nil];
    } else {
        self.dataArray = [NSMutableArray arrayWithObjects:@"",@"我的课时",@"清除缓存",@"设备检测",@"在线技术支持", nil];
    }
    
    
    [self initUI];
    [self loadData];
}


-(void)loadData {
    NSString *flag;
    if (self.sin.isAuditStatus == YES) { //无用了
        flag = @"0";
    } else {
        flag = @"1";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&Flag=%@",URL_GetLessonStatistics,flag];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
        self.model = [HF_MineHomeInfoModel yy_modelWithDictionary:responseObject[@"data"]];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        // 清空密码
        [UserDefaults() setObject:@"" forKey:K_password];
        [MBProgressHUD showMessage:@"登录过期，请重新登录" toView:[UIApplication sharedApplication].keyWindow];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HF_LoginViewController *loginVc = [[HF_LoginViewController alloc]init];
            [UserDefaults() setObject:@"no" forKey:@"login"];
            [UserDefaults() setObject:@"" forKey:K_userToken];
            [UserDefaults() synchronize];
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVc];
            self.view.window.rootViewController = nav;
        });
    }];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellStr = @"HF_MineHomeHeaderCell";
        HF_MineHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HF_MineHomeHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backBlock = ^{
            if (self.hiddenBlock) {
                self.hiddenBlock();
            }
        };
        
        cell.cellModel = self.model;
        
        return cell;
    } else {
        static NSString *cellStr = @"HF_MineHomeTableViewCell";
        HF_MineHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HF_MineHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.leftLabelString = [self.dataArray safe_objectAtIndex:indexPath.row];
        
        if (self.dataArray.count == 4) {
            if (indexPath.row == 1) {
                cell.rightLabel.text = self.sin.cacheSize;
            }
        } else if (self.dataArray.count == 5) {
            if (indexPath.row == 1) {
                cell.rightLabel.text = [NSString stringWithFormat:@"剩余%ld课时",(long)self.model.totalCount];
            } else if (indexPath.row == 2) {
                cell.rightLabel.text = self.sin.cacheSize;
            }
        }
        
        
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 4) {
        if (indexPath.row == 1) { //清除缓存
            
            
        } else if (indexPath.row == 2){ //设备检测
            [self checkDeviceClick];
        } else if (indexPath.row == 3){ //在线技术支持
            [self technicalDebugClick];
        }
    } else if (self.dataArray.count == 5) {
        if (indexPath.row == 1) {
            HF_MineClassCountViewController *vc = [[HF_MineClassCountViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2){ //清除缓存
            
        } else if (indexPath.row == 3){ //设备检测
            [self checkDeviceClick];
        } else if (indexPath.row == 4){ //在线技术支持
            [self technicalDebugClick];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return LineH(190);
    } else {
        return LineH(50);
    }
}


//MARK:设备检测
-(void)checkDeviceClick {
    HF_CheckDeviceViewController *vc = [HF_CheckDeviceViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}


//MARK:在线技术支持
-(void)technicalDebugClick {
    HF_TechnicalDebugViewController *vc = [HF_TechnicalDebugViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}




//MARK:UI
-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


-(UIButton *)loginOutButton {
    if (!_loginOutButton) {
        self.loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginOutButton setTitleColor:UICOLOR_FROM_HEX(0xFB9901) forState:UIControlStateNormal];
        [self.loginOutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
        [self.loginOutButton addTarget:self action:@selector(logOutButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        self.loginOutButton.titleLabel.font = Font(18);
        self.loginOutButton.layer.masksToBounds = YES;
        self.loginOutButton.layer.cornerRadius = LineH(25);
        self.loginOutButton.layer.borderColor = UICOLOR_FROM_HEX(0xFB9901).CGColor;
        self.loginOutButton.layer.borderWidth = LineW(1);
    }
    return _loginOutButton;
}

#pragma mark 退出登录
- (void)logOutButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.titleColor = UICOLOR_FROM_HEX(0x000000);
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
    
    UIAlertAction *clernAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HF_LoginViewController *loginVc = [[HF_LoginViewController alloc]init];
        [UserDefaults() setObject:@"no" forKey:@"login"];
        [UserDefaults() setObject:@"" forKey:K_userToken];
        [UserDefaults() synchronize];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVc];
        self.view.window.rootViewController = nav;
    }];
    clernAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
    
    [alert addAction:cancelAction];
    [alert addAction:clernAction];
    [self presentViewController:alert animated:YES completion:nil];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
