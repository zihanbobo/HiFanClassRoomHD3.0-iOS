//
//  GGT_SettingViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_SettingViewController.h"
//可以和个人信息共用一个
#import "GGT_SelfInfoTableViewCell.h"
#import "HF_LoginViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h" //JPUSHRegisterDelegate


@interface GGT_SettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

//退出登录按钮
@property (nonatomic, strong) UIButton *logOutButton;
@end

@implementation GGT_SettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.navigationItem.title = @"设置";
    
    [self initContentView];
    
}

- (void)initContentView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(LineX(20), LineY(20), marginMineRight-LineW(40), LineH(144)) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = LineW(6);
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    

    _dataArray = @[@"推送消息",@"清除缓存",@"当前版本"];
    [_tableView reloadData];
    
    
    
    self.logOutButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.logOutButton.frame = CGRectMake((marginMineRight-LineW(324))/2, _tableView.y+_tableView.height+LineY(40), LineW(324), LineH(44));
    [self.logOutButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [self.logOutButton setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:(UIControlStateNormal)];
    self.logOutButton.titleLabel.font = Font(18);
    self.logOutButton.layer.masksToBounds = YES;
    self.logOutButton.layer.cornerRadius = LineH(22);
    self.logOutButton.layer.borderColor = UICOLOR_FROM_HEX(ColorFF6600).CGColor;
    self.logOutButton.layer.borderWidth = LineW(1);
    [self.logOutButton addTarget:self action:@selector(logOutButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.logOutButton];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_SelfInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[GGT_SelfInfoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    cell.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    cell.leftTitleLabel.text = _dataArray[indexPath.row];
    

    
    if (indexPath.row == 0) {
        cell.rightImgView.hidden = YES;
        
        UISwitch *swicthView = [[UISwitch alloc] initWithFrame:CGRectMake(_tableView.width-LineW(72), LineY(8.5), LineW(51), LineH(31))];
        if ([GGT_SettingViewController checkingPushAuthority] == YES) {
            if ([GGT_SettingViewController isPush] == YES) {
                swicthView.on = YES;
            } else {
                swicthView.on = NO;
            }
        } else {
            swicthView.on = NO;
        }
        
        //设置开关开启状态时的颜色
        swicthView.onTintColor = UICOLOR_FROM_HEX(0x4CD964);
        [swicthView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:swicthView];
        
        
    } else if (indexPath.row == 1) {
        //计算缓存大小
        HF_Singleton *sin = [HF_Singleton sharedSingleton];
        cell.contentLabel.text = sin.cacheSize;


    } else if (indexPath.row == 2) {
        //更新坐标
        cell.rightImgView.hidden = YES;
        [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.leftTitleLabel.mas_right).with.offset(LineX(15));
            make.right.equalTo(cell.rightImgView.mas_left).with.offset(-LineX(20));
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.height.mas_offset(LineH(22));
        }];
        
        
        [cell.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).with.offset(-LineX(0));
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.size.mas_offset(CGSizeMake(LineW(0), LineH(0)));
        }];
        
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        cell.contentLabel.text = [NSString stringWithFormat:@"v%@",app_Version];
    }

    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LineH(48);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
    
        //刷新cell数据，保持两个数量相等
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        
        //清除缓存
        HF_Singleton *sin = [HF_Singleton sharedSingleton];
        NSString *messageStr = [NSString stringWithFormat:@"当前应用缓存%@，清除减少占用空间，保留提高加载速度",sin.cacheSize];
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
 
}


#pragma mark 通知开关---以及判断
-(void)switchAction:(UISwitch *)sender {
    
    if (sender.isOn) {
        // 打开推送
        [self openPushWithSwitch:sender];
    }else {
        //关闭通知
        [self closePushSwitch:sender];
        
    }
}
//不做任何处理，消除警告---极光的代理
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//
//}
//
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//
//}

- (void)openPushWithSwitch:(UISwitch *)sender {
    
    if ([GGT_SettingViewController checkingPushAuthority] == YES) {
        [sender setOn:YES];
        
        
        
        [MBProgressHUD showMessage:@"已打开消息推送" toView:self.view];
        [UserDefaults() setObject:@"YES" forKey:@"isPush" ];
        
        
        //方法更新了，seq（请求时传入的序列号，会在回调时原样返回）是随便设置的，待测试
        [JPUSHService setAlias:[UserDefaults() objectForKey:K_registerID] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"注册---rescode: %ld, \n iAlias: %@, \n alias: %ld\n", (long)iResCode, iAlias , (long)seq);
        } seq:0];
        
        //        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        //        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        //        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        //突然想到还有一种方法，就是直接添加删除alias
    }else {
        
        [sender setOn:NO animated:NO];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"推送消息未打开" message:@"请为hi翻外教课堂开放消息推送权限：设置->通知->hi翻外教课堂（允许通知）" preferredStyle:UIAlertControllerStyleAlert];
        alert.titleColor = UICOLOR_FROM_HEX(0x111111);
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        
        UIAlertAction *clernAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        clernAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:clernAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)closePushSwitch:(UISwitch *)sender {
    if ([GGT_SettingViewController checkingPushAuthority] == NO) {
        [sender setOn:NO animated:NO];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"推送消息未打开" message:@"请为hi翻外教课堂开放消息推送权限：设置->通知->hi翻外教课堂（允许通知）" preferredStyle:UIAlertControllerStyleAlert];
        alert.titleColor = UICOLOR_FROM_HEX(0x111111);
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        
        UIAlertAction *clernAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        clernAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:clernAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    //关闭推送
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"关闭推送通知，您将不再收到上课提醒等通知，是否确认关闭" preferredStyle:UIAlertControllerStyleAlert];
    alert.titleColor = UICOLOR_FROM_HEX(0x111111);
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [sender setOn:YES animated:NO];
        [UserDefaults() setObject:@"YES" forKey:@"isPush" ];
        
        
    }];
    cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
    
    UIAlertAction *clernAction = [UIAlertAction actionWithTitle:@"确认关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UserDefaults() setObject:@"NO" forKey:@"isPush" ];
        [MBProgressHUD showMessage:@"已关闭消息推送" toView:self.view];
        //注销通知
        //        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"注销---rescode: %ld, \n iAlias: %@, \n alias: %ld\n", (long)iResCode, iAlias , (long)seq);
        } seq:0];
    }];
    clernAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
    
    [alert addAction:cancelAction];
    [alert addAction:clernAction];
    [self presentViewController:alert animated:YES completion:nil];
}

+ (BOOL)checkingPushAuthority{
    
    if (SYSTEM_VERSION_GETATER_THAN_OR_EQUAL_TO(8)) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (UIUserNotificationTypeNone != setting.types) {
            NSLog(@"推送打开 8.0，还需要判断在打开状态下，来回切换的状态");
            
            
            return YES;
        }
    }
    return NO;
    
}

+ (BOOL)isPush {
    if (IsStrEmpty([UserDefaults() objectForKey:@"isPush"])) {
        [UserDefaults() setObject:@"YES" forKey:@"isPush" ];
        return YES;
    } else if ([[UserDefaults() objectForKey:@"isPush"] isEqualToString:@"YES"]) {
        return YES;
    } else if ([[UserDefaults() objectForKey:@"isPush"] isEqualToString:@"NO"]) {
        return NO;
    }
    return NO;
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


#pragma mark 清除缓存
- (void)removeCache{
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //返回路径中的文件数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    //    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError *error;
        
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                
                GGT_SelfInfoTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                cell.contentLabel.text = [NSString stringWithFormat:@"0.00M"];
                
            } else {
                //                [MBProgressHUD showMessage:@"清除失败" toView:self.view];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
