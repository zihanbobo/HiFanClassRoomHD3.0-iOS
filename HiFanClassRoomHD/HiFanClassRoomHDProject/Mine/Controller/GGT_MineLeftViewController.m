//
//  GGT_MineLeftViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/12.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_MineLeftViewController.h"
#import "GGT_SelfInfoViewController.h"
#import "GGT_MineClassViewController.h"
#import "GGT_SettingViewController.h"
#import "GGT_MineHeaderView.h"
#import "GGT_MineLeftTableViewCell.h"
#import "GGT_MineLeftModel.h"
#import "GGT_CoursePhraseModel.h" //常用语模型，可共用


static BOOL isShowClassVc;   //是否显示我的课时cell

@interface GGT_MineLeftViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GGT_MineHeaderView *headerView;
@property (nonatomic, strong) GGT_MineLeftModel *model;
@end

@implementation GGT_MineLeftViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChangeNameWithNotification:) name:@"reFreshClassTotalCount" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reFreshClassTotalCount" object:nil];

}


//课时发生改变的时候，修改课时数
- (void)pushChangeNameWithNotification:(NSNotification *)noti {
    HF_Singleton *sin = [HF_Singleton sharedSingleton];
    
    if (isShowClassVc == YES) {
        GGT_MineLeftTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.leftSubTitleLabel.text = [NSString stringWithFormat:@"剩余%@课时",sin.leftTotalCount];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义宽度，设置为350
    self.splitViewController.maximumPrimaryColumnWidth = LineW(350); //可以修改屏幕的宽度
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.48;
    

    //创建tableview
    [self initTableView];
    //获取网络数据
    [self getLoadData];
}

#pragma mark 没网络，重新数据请求
- (void)refreshHeaderLodaData {
    //刷新数据
    HF_Singleton *sin = [HF_Singleton sharedSingleton];
    sin.isRefreshSelfInfoData = nil;

    //获取网络数据
    [self getLoadData];
}


-(void)refreshLodaData {
    //获取网络数据
    [self getLoadData];
}


#pragma mark 获取网络请求，添加到view上
- (void)getLoadData {
    self.dataArray = [NSMutableArray array];

    HF_Singleton *sin = [HF_Singleton sharedSingleton];
    NSString *flag;
    if (sin.isAuditStatus == YES) {
        flag = @"0";
    } else {
        flag = @"1";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&Flag=%@",URL_GetLessonStatistics,flag];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:NO success:^(id responseObject) {

        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            //头部的数据
            self.model = [GGT_MineLeftModel yy_modelWithDictionary:responseObject[@"data"]];
            [self.headerView getResultModel:self.model];
            
            //cell的数据
            NSArray *picArr = responseObject[@"data"][@"dicList"];
            if ([picArr isKindOfClass:[NSArray class]] && picArr.count >0) {
                if (picArr.count == 2) {
                    isShowClassVc = NO;
                } else if (picArr.count == 3) {
                    isShowClassVc = YES;
                }
                
                for (NSDictionary *dic in picArr) {
                    GGT_CoursePhraseModel *model = [GGT_CoursePhraseModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            [self.tableView reloadData];

            HF_Singleton *sin = [HF_Singleton sharedSingleton];
            //获取课时数
            sin.leftTotalCount = [NSString stringWithFormat:@"%ld",(long)_model.totalCount];
            
            //每次请求数据后，都默认选中第一行
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
            
            
            if (self.refreshLoadData) {
                self.refreshLoadData(NO);
            }

        }
    } failure:^(NSError *error) {
//        HF_Singleton *sin = [HF_Singleton sharedSingleton];
//        if (sin.netStatus == NO) {
//            if (self.refreshLoadData) {
//                self.refreshLoadData(YES);
//            }
//        } else {
//            if (self.refreshLoadData) {
//                self.refreshLoadData(YES);
//            }
//
//            [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
//        }
        
        
        //防止失败后，没有列表，无法退出登录
//        NSArray *dicListArray = @[@{@"name":@"个人信息",@"pic":@"Personal_information"},@{@"name":@"我的课时",@"pic":@"class"},@{@"name":@"设置",@"pic":@"Set_up_the"}];
//        //cell的数据
//        isShowClassVc = YES;
//        for (NSDictionary *dic in dicListArray) {
//            GGT_CoursePhraseModel *model = [GGT_CoursePhraseModel yy_modelWithDictionary:dic];
//            [self.dataArray addObject:model];
//        }
//        [self.tableView reloadData];
//        //每次请求数据后，都默认选中第一行
//        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
//
//
//        [MBProgressHUD showMessage:@"登录过期，请重新登录" toView:self.view];
        
        
   
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


- (void)initTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,LineW(351),SCREEN_HEIGHT()) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.view addSubview:self.tableView];
    
    
    _headerView = [[GGT_MineHeaderView alloc]init];
    _headerView.frame = CGRectMake(0, 0, LineW(350), LineH(275));
    _tableView.tableHeaderView = _headerView;
    
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"Cell";
    GGT_MineLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[GGT_MineLeftTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellStr];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        cell.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    }
    
    
    GGT_CoursePhraseModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.leftTitleLabel.text = model.name;
    cell.iconName =  model.pic;
    
    
    if (isShowClassVc == YES) {
        if (indexPath.row == 0) {
            GGT_SelfInfoViewController *vc = [[GGT_SelfInfoViewController alloc]init];
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
            [self.splitViewController showDetailViewController:nav sender:self];
        }
        
        if (indexPath.row == 1) {
            cell.leftSubTitleLabel.text = [NSString stringWithFormat:@"剩余%ld课时",(long)_model.totalCount];
        }
    } else {
        if (indexPath.row == 0) {
            GGT_SelfInfoViewController *vc = [[GGT_SelfInfoViewController alloc]init];
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
            [self.splitViewController showDetailViewController:nav sender:self];
        }
    }

    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    
    if (isShowClassVc == NO) {
        switch (indexPath.row) {
            case 0:
                //个人信息
                vc = [[GGT_SelfInfoViewController alloc]init];
                
                break;
            case 1:
                //设置
                vc = [[GGT_SettingViewController alloc]init];
                break;
            default:
                vc = [[UIViewController alloc]init];
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                //个人信息
                vc = [[GGT_SelfInfoViewController alloc]init];
                
                break;
            case 1:
                //我的课时
                vc = [[GGT_MineClassViewController alloc]init];
                
                break;
            case 2:
                //设置
                vc = [[GGT_SettingViewController alloc]init];
                
                break;
                
            default:
                vc = [[UIViewController alloc]init];
                break;
        }
    }
    
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self.splitViewController showDetailViewController:nav sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
