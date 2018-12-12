//
//  GGT_ScheduleFinishedViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/13.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleFinishedViewController.h"
#import "GGT_ScheduleFinishedCell.h"
#import "GGT_ScheduleFinishedDetailViewController.h"
#import "HF_PlaceHolderView.h"
#import "GGT_ScheduleFinishedHomeModel.h"
#import "GGT_PracticeViewController.h"
#import "GGT_NoEvaluationViewController.h"
#import "GGT_HasEvaluationViewController.h"

@interface GGT_ScheduleFinishedViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
//右边请求的数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HF_PlaceHolderView *xc_placeHolderView;

@end

@implementation GGT_ScheduleFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getLoadData];
    }];
    
}

#pragma mark 数据请求
- (void)getLoadData {
    [[BaseService share] sendGetRequestWithPath:URL_GetCompleteMyLess token:YES viewController:self success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *dic in dataArray) {
                    GGT_ScheduleFinishedHomeModel *model = [GGT_ScheduleFinishedHomeModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                
                self.xc_placeHolderView.hidden = YES;
                
            } else {
                HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:responseObject];
                self.xc_placeHolderView.xc_model = model;
                self.xc_placeHolderView.hidden = NO;
            }
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:error.userInfo];
        self.xc_placeHolderView.xc_model = model;
        self.xc_placeHolderView.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;
        [self.tableView reloadData];
    }];
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
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(LineX(18));
        make.right.equalTo(self.view.mas_right).offset(-LineX(18));
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
    
    
    // HF_PlaceHolderView
    self.xc_placeHolderView = [[HF_PlaceHolderView alloc] initWithFrame:CGRectZero withImgYHeight:LineY(120)];
    self.xc_placeHolderView.frame = CGRectMake(0, 0, home_right_width, SCREEN_HEIGHT());
    [self.tableView addSubview:self.xc_placeHolderView];
    self.xc_placeHolderView.hidden = YES;
    
}


#pragma mark - Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_ScheduleFinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGT_ScheduleFinishedCell"];
    if (!cell) {
        cell = [[GGT_ScheduleFinishedCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"GGT_ScheduleFinishedCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGT_ScheduleFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    [cell getCellModel:model];
    
    
    //课前预习
    cell.classBeforeButton.tag = 300 + indexPath.row;
    [cell.classBeforeButton addTarget:self action:@selector(keqianyuxiButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //课后练习
    cell.classAfterButton.tag = 100 + indexPath.row;
    [cell.classAfterButton addTarget:self action:@selector(kehoulianxiButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //评价状态
    cell.evaluateStatusButton.tag = 200 + indexPath.row;
    [cell.evaluateStatusButton addTarget:self action:@selector(evaluateStatusButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(198);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGT_ScheduleFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    GGT_ScheduleFinishedDetailViewController *vc = [[GGT_ScheduleFinishedDetailViewController alloc] init];
    vc.lessonId = model.LessonId;
    vc.refreshLoadData = ^(BOOL is) {
        //刷新
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 课前预习
- (void)keqianyuxiButtonClick:(UIButton *)button {
    GGT_ScheduleFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:button.tag - 300];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&LessonID=%ld",URL_AddBeforeLog,(long)model.DetailRecordID];

    [[BaseService share] sendAFGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:xc_returnCode] integerValue] > 0) {
            GGT_PracticeViewController*vc = [[GGT_PracticeViewController alloc]init];
            vc.titleStr = model.FileTittle;
            vc.webUrl = model.BeforeFilePath;
            vc.lessonid = [NSString stringWithFormat:@"%ld",(long)model.LessonId];
            
            //刷新数据
            //课前课后的状态目前不需要标记了，无需刷新，暂时先注释掉。
//            vc.refreshLoadData = ^(BOOL is) {
//                [self.dataArray removeAllObjects];
//                self.dataArray = [NSMutableArray array];
//                [self getLoadData];
//            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}

#pragma mark 课后练习
- (void)kehoulianxiButtonClick:(UIButton *)button {
    GGT_ScheduleFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:button.tag - 100];

    NSString *urlStr = [NSString stringWithFormat:@"%@?&LessonID=%ld",URL_AddAfterLog ,(long)model.DetailRecordID];

    [[BaseService share] sendAFGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:xc_returnCode] integerValue] > 0) {
            GGT_PracticeViewController*vc = [[GGT_PracticeViewController alloc]init];
            vc.titleStr = model.FileTittle;
            vc.webUrl = model.AfterClassUrl;
            vc.lessonid = [NSString stringWithFormat:@"%ld",(long)model.LessonId];
            
            //刷新数据
            //课前课后的状态目前不需要标记了，无需刷新，暂时先注释掉。
//            vc.refreshLoadData = ^(BOOL is) {
//                [self.dataArray removeAllObjects];
//                self.dataArray = [NSMutableArray array];
//                [self getLoadData];
//            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
    
}


#pragma mark 评价状态
- (void)evaluateStatusButtonClick:(UIButton *)button {
    GGT_ScheduleFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:button.tag - 200];
    //IsComment  1 已评价  0 未评价
    switch (model.IsComment) {
        case 0:
        {
            GGT_NoEvaluationViewController *vc = [GGT_NoEvaluationViewController new];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            nav.popoverPresentationController.delegate = self;
            vc.scheduleFinishedHomeModel = model;
            vc.vcType = @"已结束";
            vc.refreshCell = ^(BOOL refresh) {
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray array];
                [self getLoadData];
            };
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            GGT_HasEvaluationViewController *vc = [GGT_HasEvaluationViewController new];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            nav.popoverPresentationController.delegate = self;
            vc.lessonId = model.LessonId;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
