//
//  HF_HomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_HomeViewController.h"
#import "HF_HomeLeftView.h"
#import "HF_FindMoreHomeViewController.h"      //发现
#import "HF_MyScheduleHomeViewController.h"   //课表
#import "HF_OrderCourseHomeViewController.h"   //约课



#import "GGT_ScheduleViewController.h"
#import "GGT_MineSplitViewController.h"
#import "GGT_OrderCourseViewController.h"
#import "BaseNavigationController.h"
//检查设备
#import "GGT_CheckDevicePopViewController.h"
#import "GGT_PopAlertView.h"
// 测试拓课
#import "TKEduClassRoom.h"
#import "TKMacro.h"
#import "TKUtil.h"

#import "HF_UpdateModel.h"
#import "GGT_UnitBookListHeaderModel.h"
#import "GGT_GradingAlertVC.h"
#import "GGT_ExperienceUserOrderCourseVC.h"


@interface HF_HomeViewController () <UIPopoverPresentationControllerDelegate, TKEduRoomDelegate>
@property (nonatomic, strong) HF_HomeLeftView *homeLeftView;
@property (nonatomic, strong) HF_FindMoreHomeViewController *findMoreHomeVC;
@property (nonatomic, strong) BaseNavigationController *findMoreHomeNav;

@property (nonatomic, strong) HF_MyScheduleHomeViewController *courseTableHomeVc;
@property (nonatomic, strong) BaseNavigationController *courseTableHomeNav;

@property (nonatomic, strong) HF_OrderCourseHomeViewController *orderCourseHomeVc;
@property (nonatomic, strong) BaseNavigationController *orderCourseHomeNav;

@property (nonatomic, strong) GGT_ExperienceUserOrderCourseVC *xc_experienceVC;
@property (nonatomic, strong) BaseNavigationController *xc_experienceNav;
@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation HF_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self setUpNewController];

    HF_Singleton *sin = [HF_Singleton sharedSingleton];
    if (sin.isShowVersionUpdateAlert == YES) {
        [self updateNewVersion];
    }
    [self judgeStudentLevel];
    
    [self getCacheSize];
}


- (void)setUpNewController {
    //发现
    self.findMoreHomeVC = [[HF_FindMoreHomeViewController alloc] init];
    self.findMoreHomeNav = [[BaseNavigationController alloc] initWithRootViewController:self.findMoreHomeVC];
    [self.findMoreHomeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];
    [self addChildViewController:self.findMoreHomeNav];
    
    //课表
    self.courseTableHomeVc = [[HF_MyScheduleHomeViewController alloc] init];
    self.courseTableHomeNav = [[BaseNavigationController alloc] initWithRootViewController:self.courseTableHomeVc];
    [self.courseTableHomeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];

    //约课
    self.orderCourseHomeVc = [[HF_OrderCourseHomeViewController alloc] init];
    self.orderCourseHomeNav = [[BaseNavigationController alloc] initWithRootViewController:self.orderCourseHomeVc];
    [self.orderCourseHomeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];

    //体验课
//    self.xc_experienceVC = [[GGT_ExperienceUserOrderCourseVC alloc] init];
//    self.xc_experienceNav = [[BaseNavigationController alloc] initWithRootViewController:self.xc_experienceVC];
//    [self.xc_experienceNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];
    
    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.findMoreHomeNav.view];
    self.currentVC = self.findMoreHomeNav;
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {
    /*
     transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.3f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        
    }];
}


- (void)initView {
    @weakify(self);
    self.homeLeftView = [[HF_HomeLeftView alloc]init];
    self.homeLeftView = [[HF_HomeLeftView alloc]initWithFrame:CGRectMake(0, 0, home_left_width, SCREEN_HEIGHT())];
    [self.view addSubview:self.homeLeftView];
    
    self.homeLeftView.buttonClickBlock = ^(UIButton *button) {
        @strongify(self);
        switch (button.tag) {
            case 99:
                NSLog(@"头像");
                
                break;
            case 100:
            {
                NSLog(@"发现0");
                //点击处于当前页面的按钮,直接跳出
                if (self.currentVC == self.findMoreHomeNav) {
                    NSLog(@"发现1");

                    return;
                } else {
                    NSLog(@"发现2");
                    [self replaceController:self.currentVC newController:self.findMoreHomeNav];
                }
            }
                break;
            case 101:
            {
//                [self switchViewController];
                
                NSLog(@"课表0");

                if (self.currentVC == self.courseTableHomeNav) {
                    NSLog(@"课表1");

                    return;
                } else {
                    NSLog(@"课表2");

                    [self replaceController:self.currentVC newController:self.courseTableHomeNav];
                }
                
            }
                break;
            case 102:
            {
                NSLog(@"约课0");

                if (self.currentVC == self.orderCourseHomeNav) {
                    NSLog(@"约课1");
                    return;
                } else {
                    NSLog(@"约课2");

                    [self replaceController:self.currentVC newController:self.orderCourseHomeNav];
                }
            }
                break;
            case 103:
            {
                
                GGT_CheckDevicePopViewController *vc = [GGT_CheckDevicePopViewController new];
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
                
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.popoverPresentationController.delegate = self;
                //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                // 修改弹出视图的size 在控制器内部修改更好
                //    vc.preferredContentSize = CGSizeMake(100, 100);
                [self presentViewController:nav animated:YES completion:nil];
                
                
            }
                break;
            case 104:
            {
                //#warning 自测直播教室使用，用完之后注释
                //                HF_ClassRoomModel *tkModel = [[HF_ClassRoomModel alloc] init];
                //                tkModel.serial = @"1782752406";
                //                tkModel.host = @"global.talk-cloud.net";
                //                tkModel.port = @"80";
                //                tkModel.nickname = @"小ipad";
                //                tkModel.userrole = @"2";
                //
                //                [HF_ClassRoomManager tk_enterClassroomWithViewController:self courseModel:tkModel leftRoomBlock:^{
                //
                //                }];
                //                return;
                
                
                @weakify(self);
                [GGT_PopAlertView viewWithTitle:xc_servicePhoneNum message:xc_serviceTime bottomButtonTitle:xc_humanCheckTitle bgImg:@"rengongzaixianzhichi_background" type:XCPopTypeHumanService cancleBlock:^{
                    //                    @strongify(self);
                    NSLog(@"---点的是叉号---%@", self);
                } enterBlock:^{
                    @strongify(self);
                    NSLog(@"---点按钮---%@", self);
                    [self getHumanCheckClassroomInfo];
                }];
                
            }
                break;
                
            default:
                break;
        }
    };
}

// 获取人工检测设备房间的信息
- (void)getHumanCheckClassroomInfo
{
    [[BaseService share] sendGetRequestWithPath:URL_GetOnlineInfns token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        // 进入教室
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            HF_ClassRoomModel *model = [HF_ClassRoomModel yy_modelWithDictionary:responseObject[@"data"]];
            if (![model.nickname isKindOfClass:[NSString class]] || model.nickname.length == 0) {
                model.nickname = @"Student";
            }
            
            [HF_ClassRoomManager tk_enterClassroomWithViewController:self courseModel:model leftRoomBlock:^{
                
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)updateNewVersion {
    
    // 版本号
    NSString *version = [APP_VERSION() stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?Version=%@", URL_VersionUpdateNew,version];
    
    [[BaseService share] sendGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            HF_UpdateModel *model = [HF_UpdateModel yy_modelWithDictionary:responseObject[@"data"]];
            [self popAlertVCWithModel:model];
        } else {
            // 更新接口失败 也要进行定级判断
            //            [self judgeStudentLevel];
        }
        
    } failure:^(NSError *error) {
        
        // 更新接口失败 也要进行定级判断
        //        [self judgeStudentLevel];
    }];
}

- (void)popAlertVCWithModel:(HF_UpdateModel *)model
{
    //Type类型：0 非强制性更新  1 强制性更新  2 已是最新版本，不用更新
    if ([model.Title isKindOfClass:[NSString class]] && [model.Contents isKindOfClass:[NSString class]]) {
        
        UIAlertController *alterC = [UIAlertController alertControllerWithTitle:model.Title message:model.Contents preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = nil;
        UIAlertAction *secondAction = nil;
        
        if ([model.FirstButton isKindOfClass:[NSString class]]) {
            firstAction = [UIAlertAction actionWithTitle:model.FirstButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 不弹更新窗口 进行定级判断
                //                [self judgeStudentLevel];
            }];
        }
        
        if ([model.LastButton isKindOfClass:[NSString class]]) {
            secondAction = [UIAlertAction actionWithTitle:model.LastButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([model.Url isKindOfClass:[NSString class]]) {
                    //对中文地址进行编码处理，否则会跳转失败
                    NSString *urlStr = [model.Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    // 不弹更新窗口 谈定级窗口
                    //                    [self judgeStudentLevel];
                }
                
                if ([model.Type isKindOfClass:[NSString class]] && [model.Type isEqualToString:@"1"]) {
                    [self updateNewVersion];
                }
                
            }];
        }
        
        firstAction.textColor = UICOLOR_FROM_HEX(Color777777);
        secondAction.textColor = UICOLOR_FROM_HEX(kThemeColor);
        
        if ([model.Type isEqualToString:@"0"]) {
            [alterC addAction:firstAction];
        }
        
        [alterC addAction:secondAction];
        
        
        
        if (![model.Type isEqualToString:@"2"]) {
            [self presentViewController:alterC animated:YES completion:nil];
        } else {
            // 不弹更新窗口 谈定级窗口
            //            [self judgeStudentLevel];
        }
        
    }
    
}


// 切换正式学员和体验课学员
- (void)switchViewController {
    if (self.currentVC == self.courseTableHomeVc || self.currentVC == self.xc_experienceNav) {
        return;
    } else {
        
        // 网络请求 判断是否是体验课学员
        [[BaseService share] sendGetRequestWithPath:URL_IsOfficial token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
            
            // result=1 正式学员
            [self replaceController:self.currentVC newController:self.courseTableHomeVc];
        } failure:^(NSError *error) {
            
            // result=0 体验课学员
            [self replaceController:self.currentVC newController:self.xc_experienceNav];
            
        }];
    }
}

//推荐接口。获取定级用，以前后台给错了接口
- (void)judgeStudentLevel {
    // 1：定级    -2：未定级或抛错
    [[BaseService share] sendGetRequestWithPath:URL_GetRecommendedCourses token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        //        data =     {
        //            BdId = 4546;
        //            BookingId = 160;
        //            Describe = "to practice speaking using different nouns and verbs, and review the whole unit";
        //            FilePath = "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson1-3.png";
        //            ImageId = "";
        //            Level = 1;
        //            LevelName = A1;
        //            UnitName = "Unit1_Food Lesson1-3";
        //        };
        
        
        //        {
        //            data = "";
        //            msg = "已定级";
        //            result = 1;
        //        }
        
        
        //如果有推荐就直接展示，没推荐，就请求别的接口获取，因为以前的后台给错了。cao
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]] && [responseObject[@"data"] count] >0) {
            [UserDefaults() setObject:responseObject[@"data"][@"BookingId"] forKey:K_BookingId];
            [UserDefaults() setObject:responseObject[@"data"][@"LevelName"] forKey:K_LevelName];
            [UserDefaults() synchronize];
        } else {
            [[BaseService share] sendGetRequestWithPath:URL_GetBookList token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
                    
                    [UserDefaults() setObject:[responseObject[@"data"] safe_objectAtIndex:0][@"BookingId"] forKey:K_BookingId];
                    [UserDefaults() setObject:[responseObject[@"data"] safe_objectAtIndex:0][@"BookingTitle"] forKey:K_LevelName];
                    [UserDefaults() synchronize];
                    
                }
                
            } failure:^(NSError *error) {
            }];
            
        }
        
        
    } failure:^(NSError *error) {
        
        //只有等于 -2 才会弹窗
        NSDictionary *dic = error.userInfo;
        if ([dic[xc_returnCode] integerValue] ==  -2) {
            GGT_GradingAlertVC *vc = [GGT_GradingAlertVC new];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
            vc.popoverPresentationController.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
}

#pragma mark - UIPopoverPresentationControllerDelegate
////默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
//- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
//    return UIModalPresentationNone;
//}
//
////点击蒙版是否消失，默认为yes；
//-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
//    return NO;
//}
//
////弹框消失时调用的方法
//-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
//    NSLog(@"弹框已经消失");
//}


#pragma mark 计算缓存大小
-(void)getCacheSize {
    // 执⾏耗时的异步操作...
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求数据
        NSString *folderSize = [NSString stringWithFormat:@"%.2fM",[self folderSize]];
        // 回到主线程,执⾏UI刷新操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //对图片或别的操作进行赋值等，回到主线程
            HF_Singleton *sin = [HF_Singleton sharedSingleton];
            sin.cacheSize = folderSize;
        });
    });
}

// 缓存大小
- (CGFloat)folderSize{
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSLog(@"文件地址：%@---%@",cachePath,[self class]);
    
    for(NSString *path in files) {
        
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0 /1024.0;
    
    return sizeM;
}


@end
