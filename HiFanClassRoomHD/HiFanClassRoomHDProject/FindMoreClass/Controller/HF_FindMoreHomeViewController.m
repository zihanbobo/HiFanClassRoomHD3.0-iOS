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
        [self getInstructionalTypeListData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//MARK:获取教学资源类型
-(void)getInstructionalTypeListData {
    //使用场景：当一个界面有多个数据请求，或者一个页面分模块请求，当所有的数据都请求回来之后，在更新UI，可使用此方法
    //请求1
    
    RACSignal *signal0 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    [[BaseService share] sendGetRequestWithPath:URL_GetAdvertPositionList token:YES viewController:self success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                HF_FindMoreAdvertModel *model = [HF_FindMoreAdvertModel yy_modelWithDictionary:dic];
                [array addObject:model];
            }
        }
        [subscriber sendNext:array];

    } failure:^(NSError *error) {
        NSMutableArray *array = [NSMutableArray array];
        [subscriber sendNext:array];
    }];
        
        return nil;
    }];
    
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *urlStr = [NSString stringWithFormat:@"%@?type=1",URL_GetInstructionalTypeList];
        [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    HF_FindMoreInstructionalTypeListModel *model = [HF_FindMoreInstructionalTypeListModel yy_modelWithDictionary:dic];
                    [array addObject:model];
                }
            }
            
            [subscriber sendNext:array];
            
        } failure:^(NSError *error) {
            NSMutableArray *array = [NSMutableArray array];
            [subscriber sendNext:array];
        }];
        
        
        return nil;
    }];
    
    //请求2
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送请求
        NSString *urlStr = [NSString stringWithFormat:@"%@?type=2",URL_GetInstructionalTypeList];
        [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    HF_FindMoreInstructionalTypeListModel *model = [HF_FindMoreInstructionalTypeListModel yy_modelWithDictionary:dic];
                    [array addObject:model];
                }
            }
            
            [subscriber sendNext:array];
            
        } failure:^(NSError *error) {
            NSMutableArray *array = [NSMutableArray array];
            [subscriber sendNext:array];
        }];
        
        return nil;
    }];
    
    //数组
    //当数组中的所有信号都发送了数据，才会执行Selector
    //方法的参数：必须和数组的信号一一对应
    //方法的参数：就是每一个信号发送的数据
    [self rac_liftSelector:@selector(updateUIWithHeaderArray:SectionOneArray:SectionTwoArray:) withSignalsFromArray:@[signal0,signal1,signal2]];
}

-(void)updateUIWithHeaderArray:(NSMutableArray *)headerArray  SectionOneArray:(NSMutableArray *)sectionOneArray SectionTwoArray:(NSMutableArray *)sectionTwoArray {
    self.dataArray = [NSMutableArray array];
    self.headerAdArray = [NSMutableArray array];
    
    self.headerAdArray = headerArray;
    self.dataArray = [NSMutableArray arrayWithObjects:sectionOneArray,sectionTwoArray, nil];
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView reloadData];
}


//MARK:UITableView 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"HF_FindMoreHomeContentCell";
    HF_FindMoreHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HF_FindMoreHomeContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.collectionArray = [NSMutableArray array];
    cell.collectionArray = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.section = indexPath.row;
    
    if (indexPath.row == 0) {
        cell.sectionNameLabel.text = @"hi翻放映厅";
        cell.sectionInfoLabel.text = @"外教精讲 带你玩转英语";
    } else {
        cell.sectionNameLabel.text = @"综合拓展课";
        cell.sectionInfoLabel.text = @"外教精讲 带你玩转英语";
    }
    
    
    if (indexPath.row == self.dataArray.count-1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    
    
    cell.selectedBlock = ^(NSInteger section, NSInteger indexRow) {
        HF_FindMoreInstructionalTypeListModel *model = [[self.dataArray safe_objectAtIndex:section] safe_objectAtIndex:indexRow];
        HF_FindMoreInstructionalListViewController *vc = [[HF_FindMoreInstructionalListViewController alloc] init];
        vc.isLikeVc = NO;
        vc.shouyeResourcesID = model.ResourcesID;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LineH(311); //20+26+18+180+17+16+5+12+17
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LineH(376); //106+40+210+20
}


//MARK:UI加载
- (void)initUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
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
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
