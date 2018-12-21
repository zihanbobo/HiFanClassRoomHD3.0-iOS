//
//  HF_BaseTabbarViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_BaseTabbarViewController.h"
#import "HF_BaseTabbarLeftView.h"
#import "HF_HomeViewController.h"              //首页
#import "HF_FindMoreHomeViewController.h"      //发现
#import "HF_MyScheduleHomeViewController.h"    //课程
#import "HF_ServiceHomeViewController.h"       //服务
#import "HF_MineHomeViewController.h"          //我的



#import "HF_OrderCourseHomeViewController.h"   //约课
#import "GGT_ScheduleViewController.h"
#import "GGT_MineSplitViewController.h"
#import "GGT_OrderCourseViewController.h"
#import "BaseNavigationController.h"

#import "GGT_PopAlertView.h"

#import "HF_UpdateModel.h"
#import "GGT_UnitBookListHeaderModel.h"
#import "GGT_GradingAlertVC.h"
#import "GGT_ExperienceUserOrderCourseVC.h"

@interface HF_BaseTabbarViewController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) HF_BaseTabbarLeftView *homeLeftView;
//首页
@property (nonatomic, strong) HF_HomeViewController *homeVc;
@property (nonatomic, strong) BaseNavigationController *homeNav;
//发现
@property (nonatomic, strong) HF_FindMoreHomeViewController *findMoreHomeVC;
@property (nonatomic, strong) BaseNavigationController *findMoreHomeNav;
//课程
@property (nonatomic, strong) HF_MyScheduleHomeViewController *courseTableHomeVc;
@property (nonatomic, strong) BaseNavigationController *courseTableHomeNav;
//服务
@property (nonatomic, strong) HF_ServiceHomeViewController *serviceHomeVc;
@property (nonatomic, strong) BaseNavigationController *serviceHomeNav;

@property (nonatomic, strong) HF_OrderCourseHomeViewController *orderCourseHomeVc;
@property (nonatomic, strong) BaseNavigationController *orderCourseHomeNav;

@property (nonatomic, strong) GGT_ExperienceUserOrderCourseVC *xc_experienceVC;
@property (nonatomic, strong) BaseNavigationController *xc_experienceNav;
@property (nonatomic, strong) UIViewController *currentVC;


//我的
@property (nonatomic, strong) HF_MineHomeViewController *mineMenuVC;
@property (nonatomic, strong) BaseNavigationController *mineMenuNav;
@property (nonatomic, getter=isSelectedMineVc) BOOL selectedMineVc;
@property (nonatomic, strong) UIView *blackBgView;
@property (nonatomic, strong) UIVisualEffectView *blackBgViewEffe; //定义毛玻璃
@property (nonatomic, strong) UIButton *hiddenBlackBgViewBtn;
@property (nonatomic, strong) HF_Singleton *sin;
@end

@implementation HF_BaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    [self initView];
    [self setUpNewController];

    self.selectedMineVc = NO;
    self.sin = [HF_Singleton sharedSingleton];
    self.sin.isShowMineView = NO;

    if (self.sin.isShowVersionUpdateAlert == YES) {
        [self updateNewVersion];
    }
    [self judgeStudentLevel];
    
    [self getCacheSize];
}


- (void)setUpNewController {
    //首页
    self.homeVc = [[HF_HomeViewController alloc] init];
    self.homeNav = [[BaseNavigationController alloc] initWithRootViewController:self.homeVc];
    [self.homeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];
    [self addChildViewController:self.homeNav];
    
    //发现
    self.findMoreHomeVC = [[HF_FindMoreHomeViewController alloc] init];
    self.findMoreHomeNav = [[BaseNavigationController alloc] initWithRootViewController:self.findMoreHomeVC];
    [self.findMoreHomeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];
    [self addChildViewController:self.findMoreHomeNav];
    
    //课表
    self.courseTableHomeVc = [[HF_MyScheduleHomeViewController alloc] init];
    self.courseTableHomeNav = [[BaseNavigationController alloc] initWithRootViewController:self.courseTableHomeVc];
    [self.courseTableHomeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];

    //服务
        self.serviceHomeVc = [[HF_ServiceHomeViewController alloc] init];
        self.serviceHomeNav = [[BaseNavigationController alloc] initWithRootViewController:self.serviceHomeVc];
        [self.serviceHomeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];
    
    
    //约课
//    self.orderCourseHomeVc = [[HF_OrderCourseHomeViewController alloc] init];
//    self.orderCourseHomeNav = [[BaseNavigationController alloc] initWithRootViewController:self.orderCourseHomeVc];
//    [self.orderCourseHomeNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];

    //体验课
//    self.xc_experienceVC = [[GGT_ExperienceUserOrderCourseVC alloc] init];
//    self.xc_experienceNav = [[BaseNavigationController alloc] initWithRootViewController:self.xc_experienceVC];
//    [self.xc_experienceNav.view setFrame:CGRectMake(self.homeLeftView.width, 0, SCREEN_WIDTH()-self.homeLeftView.width, SCREEN_HEIGHT())];
    
    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.homeNav.view];
    self.currentVC = self.homeNav;
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
    self.homeLeftView = [[HF_BaseTabbarLeftView alloc]init];
    self.homeLeftView = [[HF_BaseTabbarLeftView alloc]initWithFrame:CGRectMake(0, 0, home_left_width, SCREEN_HEIGHT())];
    [self.view addSubview:self.homeLeftView];
    
    self.homeLeftView.buttonClickBlock = ^(UIButton *button) {
        @strongify(self);
        switch (button.tag) {
            case 99:
                { //我的
                    
                    if (self.sin.isShowMineView == NO) { //保证每次只加载一次
                        self.sin.isShowMineView = YES;
                        [self.blackBgView addSubview:self.blackBgViewEffe];
                        [self.blackBgView addSubview:self.hiddenBlackBgViewBtn];
                        [self.view.superview addSubview:self.blackBgView];
                        [self.view.superview addSubview:self.mineMenuNav.view];
                    }

                    if (self.selectedMineVc == NO) {
                        [UIView animateWithDuration:0.3f animations:^{
                            self.blackBgView.hidden = NO;
                            self.homeLeftView.sanjiaoImgView.hidden = NO;
                            self.mineMenuNav.view.frame = CGRectMake(home_left_width, 0, LineW(360), LineH(768));
                            self.selectedMineVc = YES;
                        }];
                    } else {
                        [UIView animateWithDuration:0.3f animations:^{
                            self.blackBgView.hidden = YES;
                            self.homeLeftView.sanjiaoImgView.hidden = YES;
                            self.mineMenuNav.view.frame = CGRectMake(home_left_width, 0,0, LineH(768));
                            self.selectedMineVc = NO;
                        }];
                    }
                }
                break;
            case 100:
            {  //首页
                
                [self closeMineMenu];
                
                //点击处于当前页面的按钮,直接跳出
                if (self.currentVC == self.homeNav) {
                    return;
                } else {
                    [self replaceController:self.currentVC newController:self.homeNav];
                }
            }
                break;
            case 101:
            { //发现
//                [self switchViewController];
                [self closeMineMenu];
                
                if (self.currentVC == self.findMoreHomeNav) {
                    return;
                } else {
                    [self replaceController:self.currentVC newController:self.findMoreHomeNav];
                }
                
            }
                break;
            case 102:
            { //课程
                [self closeMineMenu];

                
                if (self.currentVC == self.courseTableHomeNav) {
                    return;
                } else {
                    [self replaceController:self.currentVC newController:self.courseTableHomeNav];
                }
            }
                break;
            case 103:
            { //服务
                [self closeMineMenu];
                
                if (self.currentVC == self.serviceHomeNav) {
                    return;
                } else {
                    [self replaceController:self.currentVC newController:self.serviceHomeNav];
                }
            }
                break;
            default:
                break;
        }
    };
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




//MARK:懒加载
-(BaseNavigationController *)mineMenuNav {
    if (!_mineMenuNav) {
        self.mineMenuVC = [[HF_MineHomeViewController alloc] init];
        self.mineMenuNav = [[BaseNavigationController alloc] initWithRootViewController:self.mineMenuVC];
        self.mineMenuNav.view.frame = CGRectMake(home_left_width, 0, 0, LineH(768));
        self.mineMenuNav.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        __weak HF_BaseTabbarViewController *weakSelf  = self;
        self.mineMenuVC.hiddenBlock = ^{
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.blackBgView.hidden = YES;
                weakSelf.homeLeftView.sanjiaoImgView.hidden = YES;
                weakSelf.mineMenuNav.view.frame = CGRectMake(home_left_width, 0,0, LineH(768));
                weakSelf.selectedMineVc = NO;
            }];
        };
        
    }
    return _mineMenuNav;
}

-(UIView *)blackBgView {
    if (!_blackBgView) {
        self.blackBgView = [[UIView alloc] init];
        self.blackBgView.frame = CGRectMake(home_left_width, 0, home_right_width, LineH(768));
        self.blackBgView.backgroundColor = [UICOLOR_FROM_HEX(Color000000) colorWithAlphaComponent:0.2];
    }
    return _blackBgView;
}


-(UIVisualEffectView *)blackBgViewEffe {
    if (!_blackBgViewEffe) {
        //UIBlurEffectStyleExtraLight      UIBlurEffectStyleLight      UIBlurEffectStyleDark
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.blackBgViewEffe = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.blackBgViewEffe.frame = CGRectMake(home_left_width, 0, home_right_width, LineH(768));
    }
    return _blackBgViewEffe;
}


-(UIButton *)hiddenBlackBgViewBtn {
    if (!_hiddenBlackBgViewBtn) {
        self.hiddenBlackBgViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.hiddenBlackBgViewBtn addTarget:self action:@selector(closeMineMenu) forControlEvents:(UIControlEventTouchUpInside)];
        self.hiddenBlackBgViewBtn.frame = CGRectMake(home_left_width, 0, home_right_width, LineH(768));
    }
    return _hiddenBlackBgViewBtn;
}

-(void)closeMineMenu {
    if (self.selectedMineVc == YES) {
        [UIView animateWithDuration:0.3f animations:^{
            self.blackBgView.hidden = YES;
            self.homeLeftView.sanjiaoImgView.hidden = YES;
            self.mineMenuNav.view.frame = CGRectMake(home_left_width, 0,0, LineH(768));
            self.selectedMineVc = NO;
        }];
    }
}

@end
