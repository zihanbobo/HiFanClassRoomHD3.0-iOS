//
//  HF_HomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeViewController.h"
#import "HF_HomeHeaderView.h"
#import "HF_HomeContentCell.h"
#import "HF_HomeHeaderModel.h"
#import "HF_HomeCourseStrategyViewController.h" //课程攻略
#import "HF_HomeClassDetailViewController.h"    //课程详情
#import "HF_HomeGetUnitInfoListModel.h"
#import "HF_HomeUnitCellModel.h"

@interface HF_HomeViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *unitArray;
@property (nonatomic, strong) HF_HomeHeaderView *headerView;

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
        [self getLessonListData];
        [self getUnitListData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//MARK:轮播课程列表
-(void)getLessonListData {
    self.headerArray = [NSMutableArray array];

    [[BaseService share] sendGetRequestWithPath:URL_GetLessonList token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                HF_HomeHeaderModel *model = [HF_HomeHeaderModel yy_modelWithDictionary:dic];
                [self.headerArray addObject:model];
            }
        }

//        self.headerView.collectionDataArray = [NSMutableArray array];
//        self.headerView.collectionDataArray = self.headerArray;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//MARK:获取Unit列表
-(void)getUnitListData {
    self.unitArray = [NSMutableArray array];

    [[BaseService share] sendGetRequestWithPath:URL_GetUnitInfoList token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                HF_HomeGetUnitInfoListModel *model = [HF_HomeGetUnitInfoListModel yy_modelWithDictionary:dic];
                [self.unitArray addObject:model];
            }
        }
        
        for (NSInteger i=0; i<self.unitArray.count; i++) {
            if (i == 0) {
                HF_HomeGetUnitInfoListModel *model = [self.unitArray safe_objectAtIndex:0];
                [self getUnitCellListData:model.UnitID];
            }
            
        }
        [self.tableView reloadData];

    } failure:^(NSError *error) {

    }];
}


-(void)getUnitCellListData:(NSInteger)unitId {
    self.dataArray = [NSMutableArray array];

    NSString *urlStr = [NSString stringWithFormat:@"%@?unitId=%ld",URL_GetChapterList,(long)unitId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"][@"chapterData"] isKindOfClass:[NSArray class]] && [responseObject[@"data"][@"chapterData"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"][@"chapterData"]) {
                HF_HomeUnitCellModel *model = [HF_HomeUnitCellModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        
    
//        HF_HomeUnitCellModel *model = [[HF_HomeUnitCellModel alloc] init];
//        [self.dataArray addObject:model];
        

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
//    return (self.dataArray.count/4) * LineH(223);
    return SCREEN_HEIGHT() - LineH(345);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"HF_HomeContentCell";
    HF_HomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HF_HomeContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UICOLOR_RANDOM_COLOR();
    }
    

    cell.collectionArray = [NSMutableArray array];
    cell.collectionUnitArray = [NSMutableArray array];

    cell.collectionArray = self.dataArray;
    cell.collectionUnitArray = self.unitArray;
    
    HF_HomeGetUnitInfoListModel *model = [self.unitArray safe_objectAtIndex:indexPath.row];
    @weakify(self);
    cell.getUnitIdBlock = ^(NSInteger unitId) {
        @strongify(self);
        NSLog(@"%ld",(long)unitId);
        [self getUnitCellListData:unitId];
    };
 
    cell.selectedBlock = ^(NSInteger index) {
        HF_HomeUnitCellModel *model = [self.dataArray safe_objectAtIndex:index];
        HF_HomeClassDetailViewController *vc = [HF_HomeClassDetailViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        vc.lessonId = model.ChapterID;
        [self presentViewController:nav animated:YES completion:nil];
    };
    
    return cell;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HF_HomeHeaderView *headerView = [[HF_HomeHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, home_right_width, LineH(345));
    headerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    headerView.collectionDataArray = [NSMutableArray array];
    headerView.collectionDataArray = self.headerArray;

    //MARK:课程攻略
    headerView.gonglueBtnBlock = ^{
        HF_HomeCourseStrategyViewController *vc = [[HF_HomeCourseStrategyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };

    //MARK:跳转到  课程详情
    headerView.classDetailVcBlock = ^(NSInteger index) {
        HF_HomeHeaderModel *model = [self.headerArray safe_objectAtIndex:index];
        HF_HomeClassDetailViewController *vc = [HF_HomeClassDetailViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        vc.lessonId = model.RecordID;
        [self presentViewController:nav animated:YES completion:nil];
    };
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LineH(345); //106+239
}


//MARK:UI加载
- (void)initUI {
//    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
//    self.headerView = [[HF_HomeHeaderView alloc] init];
//    self.headerView.frame = CGRectMake(0, 0, home_right_width, LineH(345));
//    self.headerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
//
//
//    //MARK:课程攻略
//    @weakify(self);
//    self.headerView.gonglueBtnBlock = ^{
//        @strongify(self);
//        HF_HomeCourseStrategyViewController *vc = [[HF_HomeCourseStrategyViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    };
//
//    //MARK:跳转到  课程详情
//    self.headerView.classDetailVcBlock = ^{
//        @strongify(self);
//        HF_HomeClassDetailViewController *vc = [HF_HomeClassDetailViewController new];
//        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//        nav.modalPresentationStyle = UIModalPresentationFormSheet;
//        nav.popoverPresentationController.delegate = self;
//        [self presentViewController:nav animated:YES completion:nil];
//    };
//
//
//    self.tableView.tableHeaderView = self.headerView;
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
        self.tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}



@end
