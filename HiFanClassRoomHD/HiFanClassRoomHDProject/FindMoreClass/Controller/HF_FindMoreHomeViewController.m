//
//  HF_FindMoreHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_FindMoreHomeViewController.h"
#import "HF_FindMoreHomeCycleCell.h"
#import "HF_FindMoreHomeContentCell.h"
#import "HF_FindMoreMoviePlayViewController.h"
#import "HF_FindMoreAdvertModel.h"
#import "HF_FindMoreInstructionalTypeListModel.h"
#import "HF_FindMoreInstructionalListViewController.h"
#import "HF_FindMoreAdvertPositionViewController.h"

@interface HF_FindMoreHomeViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerAdArray;
@end

@implementation HF_FindMoreHomeViewController

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
        [self getInstructionalTypeListData];
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
//        [self getInstructionalTypeListData];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
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
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
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
        HF_FindMoreInstructionalTypeListModel *model = [self.dataArray safe_objectAtIndex:index];
        HF_FindMoreInstructionalListViewController *vc = [[HF_FindMoreInstructionalListViewController alloc] init];
        vc.listModel = model;
        vc.isLikeVc = NO;
        vc.navigationItem.title = model.Title;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HF_FindMoreHomeCycleCell *headerView = [[HF_FindMoreHomeCycleCell alloc] init];
    headerView.frame = CGRectMake(0, 0, home_right_width, LineH(208));
    headerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    NSMutableArray *picArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.headerAdArray.count; i++) {
        HF_FindMoreAdvertModel *dic = [self.headerAdArray safe_objectAtIndex:i];
        [picArray addObject:dic.AdvertImagePath];
    }
    
    headerView.adScroll.imagesUrlArray = picArray;
    [headerView.adScroll refreshPageControlStyle];
    
    //MARK:我喜欢的
    headerView.favoriteBtnBlock = ^{
        HF_FindMoreInstructionalListViewController *vc = [[HF_FindMoreInstructionalListViewController alloc] init];
        vc.isLikeVc = YES;
        vc.navigationItem.title = @"我喜欢的";
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //MARK:点击轮播图
    headerView.adCycleClickBlock = ^(NSInteger index) {
        HF_FindMoreAdvertModel *model = [self.headerAdArray safe_objectAtIndex:index];
        HF_FindMoreAdvertPositionViewController *vc = [HF_FindMoreAdvertPositionViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        vc.cellModel = model;
        [self presentViewController:nav animated:YES completion:nil];
    };
    
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LineH(391);
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
//        if (@available(iOS 11.0, *)) {
//            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
