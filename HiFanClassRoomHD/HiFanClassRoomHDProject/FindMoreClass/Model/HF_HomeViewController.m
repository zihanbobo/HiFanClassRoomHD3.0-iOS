//
//  HF_HomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeViewController.h"
#import "HF_HomeHeaderView.h"


#import "HF_FindMoreHomeCycleCell.h"
#import "HF_FindMoreHomeContentCell.h"
#import "HF_FindMoreMoviePlayViewController.h"
#import "BaseScrollHeaderCell.h"
#import "HF_FindMoreAdvertModel.h"
#import "HF_FindMoreInstructionalTypeListModel.h"
#import "HF_FindMoreFavoriteViewController.h"
#import "HF_FindMoreInstructionalListViewController.h"


@interface HF_HomeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerAdArray;
@end

@implementation HF_HomeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.headerAdArray = [NSMutableArray array];
        self.dataArray = [NSMutableArray array];
        [self getAdvertPositionListData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//MARK:广告位轮播图数据请求
-(void)getAdvertPositionListData {
    
    [[BaseService share] sendGetRequestWithPath:URL_GetAdvertPositionList token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                HF_FindMoreAdvertModel *model = [HF_FindMoreAdvertModel yy_modelWithDictionary:dic];
                [self.headerAdArray addObject:model];
            }
        }
        [self getInstructionalTypeListData];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//MARK:获取教学资源类型
-(void)getInstructionalTypeListData {
    [[BaseService share] sendGetRequestWithPath:URL_GetInstructionalTypeList token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                HF_FindMoreInstructionalTypeListModel *model = [HF_FindMoreInstructionalTypeListModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


//MARK:UITableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LineH(309);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"HF_FindMoreHomeContentCell";
    HF_FindMoreHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HF_FindMoreHomeContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.collectionArray = [NSMutableArray array];
    cell.collectionArray = self.dataArray;
    
    cell.selectedBlock = ^(NSInteger index) {
        NSLog(@"点击的是 %ld 个",(long)index);
        HF_FindMoreInstructionalTypeListModel *model = [self.dataArray safe_objectAtIndex:index];
        HF_FindMoreInstructionalListViewController *vc = [[HF_FindMoreInstructionalListViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HF_HomeHeaderView *headerView = [[HF_HomeHeaderView alloc] init];
//    headerView.frame = CGRectMake(0, 0, home_right_width, LineH(340));
    headerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LineH(340); //106+234
}


//MARK:UI加载
- (void)initUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
}

//MARK:懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}



@end
