//
//  GGT_ApplyClassViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/8.
//  Copyright © 2018年 XieHenry. All rights reserved.
//

#import "GGT_ApplyClassViewController.h"
#import "GGT_ApplyClassCell.h"
#import "GGT_PlaceHolderView.h"
#import "GGT_ApplyClassModel.h"
#import "GGT_ApplySucceedViewController.h"

@interface GGT_ApplyClassViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
//右边请求的数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GGT_PlaceHolderView *xc_placeHolderView;
@end

@implementation GGT_ApplyClassViewController

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
    [[BaseService share] sendGetRequestWithPath:URL_GetSubscribeLessonMyLess token:YES viewController:self success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *dic in dataArray) {
                    GGT_ApplyClassModel *model = [GGT_ApplyClassModel yy_modelWithDictionary:dic];
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
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:error.userInfo];
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
    
    GGT_ApplyClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGT_ApplyClassCell"];
    if (!cell) {
        cell = [[GGT_ApplyClassCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"GGT_ApplyClassCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GGT_ApplyClassModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    [cell getModel:model];
    
    //取消申请
    cell.cancleClassButton.tag = 100 + indexPath.row;
    [cell.cancleClassButton addTarget:self action:@selector(cancleClassButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //邀请好友
    cell.yaoqingButton.tag = 200 + indexPath.row;
    [cell.yaoqingButton addTarget:self action:@selector(yaoqingButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(198);
}

#pragma mark 取消申请
-(void)cancleClassButtonClick:(UIButton *)button {
    GGT_ApplyClassModel *model = [self.dataArray safe_objectAtIndex:button.tag-100];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定取消本次申请" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //取消申请
        [self CancelLessonData:model.DetailRecordID];
        
    }];
    
    alert.titleColor = UICOLOR_FROM_HEX(0x000000);
    cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
    doneAction.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
    
    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//取消申请
- (void)CancelLessonData : (NSInteger )DemandId {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&DemandId=%ld",URL_CancelLesson,(long)DemandId];
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


#pragma mark 邀请好友
-(void)yaoqingButtonClick:(UIButton *)button {
    GGT_ApplyClassModel *model = [self.dataArray safe_objectAtIndex:button.tag-200];
    
    
    GGT_ApplySucceedViewController *vc = [GGT_ApplySucceedViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    vc.preferredContentSize = CGSizeMake(460, 296);
    vc.classTypeName = @"邀请好友";
    
    
    //文字赋值
    vc.jiaocaiStr = [NSString stringWithFormat:@"已申请 %@ 的课程",model.StartTimePad];
    vc.chengbanStr = [NSString stringWithFormat:@"还差%ld人开班",(long)model.ResidueNum];
    
    if ([model.shareUrl isKindOfClass:[NSString class]] && model.shareUrl.length >0) {
        vc.codeStr = model.shareUrl;
    }
    
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
