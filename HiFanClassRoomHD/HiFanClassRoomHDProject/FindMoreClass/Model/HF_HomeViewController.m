//
//  HF_HomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeViewController.h"
#import "HF_HomeHeaderViewCell.h"
#import "HF_HomeContentCell.h"
#import "HF_HomeHeaderModel.h"
#import "HF_HomeCourseStrategyViewController.h" //课程攻略
#import "HF_HomeClassDetailViewController.h"    //课程详情
#import "HF_HomeGetUnitInfoListModel.h"
#import "HF_HomeUnitCellModel.h"
#import "HF_HomeUnitChooseView.h"

@interface HF_HomeViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *unitArray;
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
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return LineH(346); //106+239
    } else if (indexPath.row == 1) {
        return LineH(48);
    } else if (indexPath.row == 2) {
        return self.tableView.height - LineH(394);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *cellID = @"HF_HomeHeaderViewCell";
        HF_HomeHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_HomeHeaderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.collectionDataArray = [NSMutableArray array];
        cell.collectionDataArray = self.headerArray;
        
        //MARK:课程攻略
        cell.gonglueBtnBlock = ^{
            HF_HomeCourseStrategyViewController *vc = [[HF_HomeCourseStrategyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        //MARK:跳转到  课程详情
        cell.classDetailVcBlock = ^(NSInteger index) {
            HF_HomeHeaderModel *model = [self.headerArray safe_objectAtIndex:index];
            HF_HomeClassDetailViewController *vc = [HF_HomeClassDetailViewController new];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            nav.popoverPresentationController.delegate = self;
            vc.lessonId = model.RecordID;
            [self presentViewController:nav animated:YES completion:nil];
        };
        
        
        return cell;
        
    } else if (indexPath.row == 1) {
        static NSString *cellID = @"HF_HomeUnitChooseView";
        HF_HomeUnitChooseView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_HomeUnitChooseView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        cell.collectionUnitArray = [NSMutableArray array];
        cell.collectionUnitArray = self.unitArray;
        
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *cellID = @"HF_HomeContentCell";
        HF_HomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_HomeContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        cell.collectionArray = [NSMutableArray array];
        cell.collectionArray = self.dataArray;

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
    
    return nil;
}


//MARK:UI加载
- (void)initUI {
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
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}



@end
