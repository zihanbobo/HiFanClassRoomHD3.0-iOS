//
//  GGT_ScheduleFinishedDetailViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleFinishedDetailViewController.h"
#import "GGT_ScheduleFinishedHeaderInfoCell.h"
#import "GGT_ScheduleFinishedStuEvaluateCell.h"
#import "GGT_ScheduleFinishedEvaluateHeaderView.h"
#import "GGT_ScheduleDetailModel.h"
#import "GGT_NoEvaluationViewController.h"
#import "GGT_HasEvaluationViewController.h"
#import "GGT_PracticeViewController.h"
#import "GGT_ScheduleFinishedDetailStuEvaluateModel.h"


@interface GGT_ScheduleFinishedDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *studentInfoArray;
@end

@implementation GGT_ScheduleFinishedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self setLeftItem:@"fanhui_white" title:@"课表"];
    self.navigationItem.title = @"课程详情";
    self.dataArray = [NSMutableArray array];
    self.studentInfoArray = [NSMutableArray array];

    
    [self initTableView];
    
    [self getLoadData];
    [self GetCompleteLessonInfoData];
}

#pragma mark 获取学生对老师的评价
- (void)GetCompleteLessonInfoData {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?lessonId=%ld",URL_GetCompleteLessonInfo,(long)self.lessonId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];

            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *bigDic in dataArray) {
                    //学生数据
                    GGT_ScheduleFinishedDetailStuEvaluateModel *model = [GGT_ScheduleFinishedDetailStuEvaluateModel yy_modelWithDictionary:bigDic];
                    [self.studentInfoArray addObject:model];
                }
            }
        }

        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
    }];
}


#pragma mark 获取课程详情
- (void)getLoadData {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?lessonId=%ld",URL_GetLessonDeatil,(long)self.lessonId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];
            
            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *bigDic in dataArray) {
                    //大数据
                    GGT_ScheduleDetailModel *model = [GGT_ScheduleDetailModel yy_modelWithDictionary:bigDic];
                    [self.dataArray addObject:model];
                }
            }
        }

        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
    }];
}




- (void)initTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(18);
        make.right.equalTo(self.view.mas_right).with.offset(-18);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];
}


#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.studentInfoArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GGT_ScheduleFinishedHeaderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGT_ScheduleFinishedHeaderInfoCell"];
        if (!cell) {
            cell = [[GGT_ScheduleFinishedHeaderInfoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"GGT_ScheduleFinishedHeaderInfoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
        [cell getCellModel:model];
        
       //评价状态
        cell.xc_evaluateStatusButton.tag = 100 + indexPath.row;
        [cell.xc_evaluateStatusButton addTarget:self action:@selector(evaluateStatusButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        //课后练习
        cell.classAfterButton.tag = 200 + indexPath.row;
        [cell.classAfterButton addTarget:self action:@selector(courseExercisesButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //课前预习
        cell.classBeforeButton.tag = 300 + indexPath.row;
        [cell.classBeforeButton addTarget:self action:@selector(keqianyuxiButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        return cell;

    } else if (indexPath.section == 1){
        GGT_ScheduleFinishedStuEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGT_ScheduleFinishedStuEvaluateCell"];
        if (!cell) {
            cell = [[GGT_ScheduleFinishedStuEvaluateCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"GGT_ScheduleFinishedStuEvaluateCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        if (!IsArrEmpty(self.studentInfoArray) ) {
            if (indexPath.row == self.studentInfoArray.count-1) {
                [self cornCell:cell sideType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            }
        }
        
        GGT_ScheduleFinishedDetailStuEvaluateModel *model = [self.studentInfoArray safe_objectAtIndex:indexPath.row];
        [cell getCellModel:model];
        
        
        return cell;
        
    } else {
        NSLog(@"Some exception message for unexpected tableView");
        abort();  //__attribute__((noreturn)) 静态内存泄漏解决办法
    }
}



- (void)cornCell:(UITableViewCell *)cell sideType:(UIRectCorner)corners{
    CGSize cornerSize = CGSizeMake(LineH(margin10),LineH(margin10));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _tableView.width,LineH(148))
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, _tableView.width, LineH(148));
    maskLayer.path = maskPath.CGPath;
    
    cell.layer.mask = maskLayer;
    [cell.layer setMasksToBounds:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
       return LineH(180);
    } else if (indexPath.section == 1){
        return LineH(148);
    }
    return 0.0001;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return LineH(17);
    } else if (section == 1) {
        return LineH(174);
    }
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        GGT_ScheduleFinishedEvaluateHeaderView *headerView = [[GGT_ScheduleFinishedEvaluateHeaderView alloc]initWithFrame:CGRectMake(0, 0, home_right_width, LineH(174))];
        headerView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:0];
        [headerView getCellModel:model];
        
        return headerView;
    }
    return nil;
}

#pragma mark 评价状态
- (void)evaluateStatusButtonClick:(UIButton *)button {
    GGT_ScheduleDetailModel *model = [self.dataArray safe_objectAtIndex:button.tag - 100];
    //IsComment  1 已评价  0 未评价
    switch (model.IsComment) {
        case 0:
        {
            GGT_NoEvaluationViewController *vc = [GGT_NoEvaluationViewController new];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            nav.popoverPresentationController.delegate = self;
            vc.scheduleDetailModel = model;
            vc.vcType = @"课程详情";
            vc.refreshCell = ^(BOOL refresh) {
                //刷新已完成的列表，改变评价的状态
                if (self.refreshLoadData) {
                    self.refreshLoadData(YES);
                }
                
                
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray array];
                
                [self.studentInfoArray removeAllObjects];
                self.studentInfoArray = [NSMutableArray array];
                [self getLoadData];
                [self GetCompleteLessonInfoData];
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
            vc.lessonId = model.DetailRecordID;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark 课后练习
- (void)courseExercisesButtonClick:(UIButton *)button {
    GGT_ScheduleFinishedHomeModel *model = [self.dataArray safe_objectAtIndex:button.tag - 200];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&LessonID=%ld",URL_AddAfterLog ,(long)model.DetailRecordID];
    [[BaseService share] sendAFGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:xc_returnCode] integerValue] > 0) {
            GGT_PracticeViewController*vc = [[GGT_PracticeViewController alloc]init];
            vc.titleStr = model.FileTittle;
            vc.webUrl = model.AfterClassUrl;
            vc.lessonid = [NSString stringWithFormat:@"%ld",(long)model.DetailRecordID];
            
            //刷新数据
            //课前课后的状态目前不需要标记了，无需刷新，暂时先注释掉。
//            vc.refreshLoadData = ^(BOOL is) {
//                //刷新已完成的列表，改变课后练习的状态
//                if (self.refreshLoadData) {
//                    self.refreshLoadData(YES);
//                }
//
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
            vc.refreshLoadData = ^(BOOL is) {
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray array];
                [self getLoadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
