//
//  GGT_ScheduleUnFinishedDetailViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleUnFinishedDetailViewController.h"
#import "GGT_ScheduleUnFisishedHeaderInfoCell.h"
#import "GGT_ScheuleUnFinishedIconCell.h"
#import "GGT_ScheduleDetailModel.h"
#import "GGT_PracticeViewController.h"

#import "GGT_ApplyViewController.h"
#import "GGT_ApplySucceedViewController.h"

@interface GGT_ScheduleUnFinishedDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
//右边请求的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

//导航右侧文字
//@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation GGT_ScheduleUnFinishedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    [self setNav];
    
    [self initTableView];
    
    // 启动倒计时管理
    [kCountDownManager start];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getLoadData];
    }];
    

    //NotificationViewController中的通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshScheduleList" object:nil] subscribeNext:^(NSNotification * _Nullable x) {// x 是通知对象
        NSLog(@"上课时间到，刷新课表详情页数据");
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
    }];
    
}

#pragma mark 导航设置
- (void)setNav{
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self setLeftItem:@"fanhui_white" title:@"课表"];
    self.navigationItem.title = @"课程详情";
    
//    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.rightBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
//    self.rightBtn.frame = CGRectMake(0, 0, LineW(70), LineH(44));
//    self.rightBtn.titleLabel.font = Font(16);
//    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
//    [self.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)rightAction:(UIButton *)button {
    if (!IsStrEmpty(button.titleLabel.text)) {
        GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定取消本次课程" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //首先获取这个月取消了几次课程了
            [self CancelLessonCountData:model.DetailRecordID];
        }];
        
        alert.titleColor = UICOLOR_FROM_HEX(0x000000);
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)getLoadData {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?lessonId=%ld",URL_GetLessonDeatil,(long)self.lessonId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *dic in dataArray) {
                    GGT_ScheduleDetailModel *model = [GGT_ScheduleDetailModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            
//            GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
//            //0 是未开始  1 上课中 3 即将开始 2 已结束 ----上课时间10分钟之内不可以取消课程
//            if (model.StatusName == 0) {
//                [self.rightBtn setTitle:@"取消课程" forState:UIControlStateNormal];
//            } else {
//                [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
//            }
            
        }
        
        // 刷新
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self reloadData];
        
    } failure:^(NSError *error) {
    }];
}

- (void)reloadData {
    // 网络加载数据
    [kCountDownManager reload];
    // 刷新
    [self.tableView reloadData];
}


- (void)initTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];
}


#pragma mark - Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *idStr = @"GGT_ScheduleUnFisishedHeaderInfoCell";
        GGT_ScheduleUnFisishedHeaderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!cell) {
            cell = [[GGT_ScheduleUnFisishedHeaderInfoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
        [cell getCellModel:model];
        
        
        //邀请好友
//        cell.yaoqingButton.tag = 100 + indexPath.row;
//        [cell.yaoqingButton addTarget:self action:@selector(yaoqingButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //课前预习
        cell.classBeforeButton.tag = 200 + indexPath.row;
        [cell.classBeforeButton addTarget:self action:@selector(courseExercisesButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //进入教室
        cell.classEnterButton.tag = 300 + indexPath.row;
        [cell.classEnterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        return cell;
    } else if (indexPath.row == 1){
        static NSString *idStr = @"GGT_ScheuleUnFinishedIconCell";
        GGT_ScheuleUnFinishedIconCell *cell1 = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!cell1) {
            cell1 = [[GGT_ScheuleUnFinishedIconCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idStr];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
        [cell1 getCellModel:model];
        
        return cell1;
    } else {
        NSLog(@"Some exception message for unexpected tableView");
        abort();  //__attribute__((noreturn)) 静态内存泄漏解决办法
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return LineH(198);
    } else {
        return LineH(188);
    }
}


//首先获取这个月取消了课程的次数
- (void)CancelLessonCountData : (NSInteger )DetailRecordID {
    
    [[BaseService share] sendGetRequestWithPath:URL_CancelLessonCount token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //取消约课
            [self CancelLessonData:DetailRecordID];
        }];
        
        alert.titleColor = UICOLOR_FROM_HEX(0x000000);
        cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
        doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
        
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
}

//取消约课
- (void)CancelLessonData : (NSInteger )DetailRecordID {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&DemandId=%ld",URL_CancelLesson,(long)DetailRecordID];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        
        //刷新
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
        
        if (self.refreshLoadData) {
            self.refreshLoadData(YES);
        }
        
        //取消课程之后返回，并刷新数据
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
}




#pragma mark 课前预习
- (void)courseExercisesButtonClick:(UIButton *)button {
    GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&LessonID=%ld",URL_AddBeforeLog,(long)model.DetailRecordID];
    [[BaseService share] sendAFGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:xc_returnCode] integerValue] > 0) {
            GGT_PracticeViewController *vc = [[GGT_PracticeViewController alloc]init];
            vc.titleStr = model.FileTittle;
            vc.webUrl = model.BeforeFilePath;
            vc.lessonid = [NSString stringWithFormat:@"%ld",(long)model.DetailRecordID];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
    
    
}

#pragma mark 进入教室
- (void)enterButtonClick:(UIButton *)button {
    GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
    
    //0 是未开始  1 上课中 3 即将开始 2 已结束 ----上课时间10分钟之内不可以取消课程
    if (model.StatusName == 0) {
        
//        LOSAlertPRO(@"请在开课前10分钟内进入教室", @"知道了");
        
    } else if (model.StatusName == 1 || model.StatusName == 3) {
        HF_ClassRoomModel *tkModel = [[HF_ClassRoomModel alloc] init];
        tkModel.serial = model.serial;
        tkModel.host = model.host;
        tkModel.port = model.port;
        tkModel.nickname = model.nickname;
        tkModel.userrole = model.userrole;
        tkModel.LessonId = model.LessonId;
        
        
        [HF_ClassRoomManager tk_enterClassroomWithViewController:self courseModel:tkModel leftRoomBlock:^{
            
        }];
    }
}

-(void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark 邀请好友
- (void)yaoqingButtonClick:(UIButton *)button {
    GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
    
    GGT_ApplySucceedViewController *vc = [GGT_ApplySucceedViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    vc.preferredContentSize = CGSizeMake(460, 296);
    vc.classTypeName = @"邀请好友";
    
    //文字赋值
    vc.jiaocaiStr = [NSString stringWithFormat:@"已加入 %@ 的课程",model.StartTimePad];
    vc.chengbanStr = [NSString stringWithFormat:@"剩余%ld个席位",(long)model.ResidueNum];
    if ([model.shareUrl isKindOfClass:[NSString class]] && model.shareUrl.length >0) {
        vc.codeStr = model.shareUrl;
    }
    [self presentViewController:nav animated:YES completion:nil];
}
 */
@end
