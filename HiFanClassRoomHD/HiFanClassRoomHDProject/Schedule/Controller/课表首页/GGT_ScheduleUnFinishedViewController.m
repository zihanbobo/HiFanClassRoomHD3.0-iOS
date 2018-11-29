//
//  GGT_ScheduleUnFinishedViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ScheduleUnFinishedViewController.h"
#import "GGT_ScheduleUnFinishedCell.h"
#import "GGT_ScheduleUnFinishedDetailViewController.h"
#import "GGT_PlaceHolderView.h"
#import "GGT_ScheduleUnFinishedHomeModel.h"
#import "GGT_PracticeViewController.h"
#import "NSTimer+BlockSupport.h"


static BOOL isFirstEnterVc = YES;
@interface GGT_ScheduleUnFinishedViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
//右边请求的数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GGT_PlaceHolderView *xc_placeHolderView;
@property (nonatomic, strong) NSTimer *countDowntimer;    // 用于每隔2分钟发送一次网络请求 刷新数据
@end

@implementation GGT_ScheduleUnFinishedViewController


//自动刷新数据
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFirstEnterVc == YES) {
        isFirstEnterVc = NO;
    } else {
        [self initData];
    }
}

//MARK:测试课件快捷方法
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    GGT_PracticeViewController *vc = [[GGT_PracticeViewController alloc]init];
//    vc.titleStr = @"测试";
//    vc.webUrl = @"http://192.168.191.1:8020/H5A0-U1-L1/index.html?__hbt=1539919121954";
//    //    vc.lessonid = [NSString stringWithFormat:@"%ld",(long)model.DetailRecordID];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];

    // 启动倒计时管理
    [kCountDownManager start];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self initData];
    }];
    
    
    [self sendNetEvery2Min];

}


//MARK:未开始上课的时候，2分钟刷新一次数据
- (void)sendNetEvery2Min {
    @weakify(self);
    self.countDowntimer = [NSTimer xc_scheduledTimerWithTimeInterval:60*2 block:^{
        @strongify(self);
        
        //0 是未开始  1 上课中 3 即将开始 2 已结束 ----上课时间10分钟之内不可以取消课程
        GGT_ScheduleUnFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:0];
        if (model.StatusName != 0  ) return ;            //不是未开始状态就不执行

        if (model.StartTime.length == 16) {
            model.StartTime = [NSString stringWithFormat:@"%@:00",model.StartTime];
        }
        
        //如果是未开始状态，就进行时间判断。
        HF_Singleton *sin = [HF_Singleton sharedSingleton];
        //获取时间差
        NSTimeInterval timeCount = [sin pleaseInsertStarTime:sin.nowDateString andInsertEndTime:model.StartTime class:@"GGT_ScheduleUnFinishedVCofsendNet"];
        
        //如果是时间小于0或者时间大于13分钟，不执行，否则隔2分钟刷新数据，发送通知。
        if (timeCount > 60*13  || timeCount<=0) return;  //即将上课前3分钟进行刷新数据。
        
        NSLog(@"每隔1分钟刷新一次数据,刷新课表未完成数据--%@", [self class]);
        //发送通知,刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshScheduleList" object:nil];
        [self initData];
        
        
    } repeats:YES];
    [self.countDowntimer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.countDowntimer forMode:NSRunLoopCommonModes];
}



//MARK:数据初始化
-(void)initData {
    [self.dataArray removeAllObjects];
    self.dataArray = [NSMutableArray array];
    [self getLoadData];
}


#pragma mark 数据请求
- (void)getLoadData {
    [[BaseService share] sendGetRequestWithPath:URL_GetNotMyLess token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *dic in dataArray) {
                    GGT_ScheduleUnFinishedHomeModel *model = [GGT_ScheduleUnFinishedHomeModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                
                self.xc_placeHolderView.hidden = YES;
                
            } else {
                GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:responseObject];
                self.xc_placeHolderView.xc_model = model;
                self.xc_placeHolderView.hidden = NO;
            }
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self reloadData];

    } failure:^(NSError *error) {
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:error.userInfo];
        self.xc_placeHolderView.xc_model = model;
        self.xc_placeHolderView.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        [self reloadData];
    }];
    
}

- (void)reloadData {
    // 网络加载数据
    [kCountDownManager reload];
    // 刷新
    [self.tableView reloadData];
}

- (void)initTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, LineX(18), 0, LineW(18)));
    }];
    
    
    // GGT_PlaceHolderView
    self.xc_placeHolderView = [[GGT_PlaceHolderView alloc] initWithFrame:CGRectZero withImgYHeight:LineY(120)];
    self.xc_placeHolderView.frame = CGRectMake(0, 0, home_right_width, SCREEN_HEIGHT());
    [self.tableView addSubview:self.xc_placeHolderView];
    self.xc_placeHolderView.hidden = YES;
}


#pragma mark - Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_ScheduleUnFinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGT_ScheduleUnFinishedCell"];
    if (!cell) {
        cell = [[GGT_ScheduleUnFinishedCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"GGT_ScheduleUnFinishedCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGT_ScheduleUnFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    [cell getCellModel:model];
    
    //取消课程
    cell.classCancleButton.tag = 100 + indexPath.row;
    [cell.classCancleButton addTarget:self action:@selector(cancleClassButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //课前预习
    cell.classBeforeButton.tag = 200 + indexPath.row;
    [cell.classBeforeButton addTarget:self action:@selector(courseExercisesButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //进入教室
    cell.classEnterButton.tag = 300 + indexPath.row;
    [cell.classEnterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(198);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGT_ScheduleUnFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    GGT_ScheduleUnFinishedDetailViewController *vc = [[GGT_ScheduleUnFinishedDetailViewController alloc]init];
    vc.lessonId = model.DetailRecordID;
    vc.refreshLoadData = ^(BOOL is) {
        //刷新
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 取消课程
- (void)cancleClassButtonClick:(UIButton *)button {
    GGT_ScheduleUnFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:button.tag - 100];
    
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
        

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
}




#pragma mark 课前预习
- (void)courseExercisesButtonClick:(UIButton *)button {
    GGT_ScheduleUnFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:button.tag - 200];

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
    GGT_ScheduleUnFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:button.tag - 300];
    
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


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
