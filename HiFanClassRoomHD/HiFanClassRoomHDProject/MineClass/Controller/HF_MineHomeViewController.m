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
#import "HF_MineHomeFooterView.h"

@interface HF_MineHomeViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *loginOutButton;
@property (nonatomic, strong) HF_Singleton *sin;
@property (nonatomic, strong) HF_MineHomeInfoModel *model;
@property (nonatomic, strong) UIImageView *QRCodeImageView;
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
        self.dataArray = [NSMutableArray arrayWithObjects:@"",@"清除缓存",@"设备检测",@"在线技术支持",@"当前版本",@"", nil];
    } else {
        self.dataArray = [NSMutableArray arrayWithObjects:@"",@"我的课时",@"清除缓存",@"设备检测",@"在线技术支持",@"当前版本",@"", nil];
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
        
        //返回，关闭界面
        cell.backBlock = ^{
            if (self.hiddenBlock) {
                self.hiddenBlock();
            }
        };
        
        cell.cellModel = self.model;
        
        return cell;
    } else if (indexPath.row == self.dataArray.count -1) {
        static NSString *cellStr = @"HF_MineHomeFooterView";
        HF_MineHomeFooterView *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HF_MineHomeFooterView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //退出登录
        @weakify(self);
        cell.loginOutButtonBlock = ^{
            @strongify(self);
            [self logOutButtonClick];
        };
        
        return cell;
    } else {
        static NSString *cellStr = @"HF_MineHomeTableViewCell";
        HF_MineHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HF_MineHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.leftLabelString = [self.dataArray safe_objectAtIndex:indexPath.row];
        
        if (self.dataArray.count == 6) {
            if (indexPath.row == 1) {
                cell.rightLabel.text = self.sin.cacheSize;
            } else if(indexPath.row == 5) { //当前版本
                cell.enterImgView.hidden = YES;
                
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                // app版本
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                cell.rightLabel.text = [NSString stringWithFormat:@"V%@",app_Version];
                [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-20);
                }];
            }
        } else if (self.dataArray.count == 7) {
            if (indexPath.row == 1) {
                cell.rightLabel.text = [NSString stringWithFormat:@"剩余%ld课时",(long)self.model.totalCount];
            } else if (indexPath.row == 2) {
                cell.rightLabel.text = self.sin.cacheSize;
            } else if(indexPath.row == 5) { //当前版本
                cell.enterImgView.hidden = YES;
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                // app版本
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                cell.rightLabel.text = [NSString stringWithFormat:@"V%@",app_Version];
                [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-20);
                }];
            }
        }

        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 6) {
        if (indexPath.row == 1) { //清除缓存
            [self clearCache];
        } else if (indexPath.row == 2){ //设备检测
            [self checkDeviceClick];
        } else if (indexPath.row == 3){ //在线技术支持
            [self technicalDebugClick];
        }
    } else if (self.dataArray.count == 7) {
        if (indexPath.row == 1) {
            HF_MineClassCountViewController *vc = [[HF_MineClassCountViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2){ //清除缓存
            [self clearCache];
        } else if (indexPath.row == 3){ //设备检测
            [self checkDeviceClick];
        } else if (indexPath.row == 4){ //在线技术支持
            [self technicalDebugClick];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return LineH(195);
    } else if(indexPath.row == self.dataArray.count -1) {
       return self.tableView.height - LineH(195)-(LineH(50)*(self.dataArray.count-2));
    } else {
        return LineH(50);
    }
}

//MARK:清除缓存
-(void)clearCache {
    NSString *messageStr = [NSString stringWithFormat:@"当前应用缓存%@，清除减少占用空间，保留提高加载速度",self.sin.cacheSize];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    alert.titleColor = UICOLOR_FROM_HEX(0x000000);
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"保留" style:UIAlertActionStyleCancel handler:nil];
    cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
    
    UIAlertAction *clernAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeCache];
    }];
    clernAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
    
    [alert addAction:cancelAction];
    [alert addAction:clernAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)removeCache{
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //返回路径中的文件数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    //    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError *error;
        
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                if (self.dataArray.count == 6) {
                    HF_MineHomeTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    cell.rightLabel.text = [NSString stringWithFormat:@"0.00M"];
                } else if (self.dataArray.count == 7) {
                    HF_MineHomeTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    cell.rightLabel.text = [NSString stringWithFormat:@"0.00M"];
                }
                self.sin.cacheSize = @"0.00M";
                
            } else {
                //                [MBProgressHUD showMessage:@"清除失败" toView:self.view];
            }
        }
    }
}


//MARK:退出登录
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
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
