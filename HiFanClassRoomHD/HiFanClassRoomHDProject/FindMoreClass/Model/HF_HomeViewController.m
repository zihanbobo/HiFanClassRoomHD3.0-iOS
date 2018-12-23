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
#import "HF_PracticeViewController.h"

@interface HF_HomeViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *unitArray;
@property (nonatomic, copy) NSString *unitString;
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
        [self getLoadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(void)getLoadData {
    //使用场景：当一个界面有多个数据请求，或者一个页面分模块请求，当所有的数据都请求回来之后，在更新UI，可使用此方法
    //请求1
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送请求

        [[BaseService share] sendGetRequestWithPath:URL_GetLessonList token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    HF_HomeHeaderModel *model = [HF_HomeHeaderModel yy_modelWithDictionary:dic];
                    [array addObject:model];
                }
            }
            
            [subscriber sendNext:array];
        } failure:^(NSError *error) {
            
        }];
        
        return nil;
    }];
    
    //请求2
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送请求
        [[BaseService share] sendGetRequestWithPath:URL_GetUnitInfoList token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
            NSMutableArray *dataArray = [NSMutableArray array];
            NSMutableArray *array1 = [NSMutableArray array];
            NSMutableArray *array2 = [NSMutableArray array];

            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    HF_HomeGetUnitInfoListModel *model = [HF_HomeGetUnitInfoListModel yy_modelWithDictionary:dic];
                    [array1 addObject:model];
                }
            }
            
            for (NSInteger i=0; i<array1.count; i++) {
                if (i == 0) {
                    HF_HomeGetUnitInfoListModel *model = [array1 safe_objectAtIndex:0];
                    NSString *unitIdStr = [NSString stringWithFormat:@"%ld",(long)model.UnitID];
                    [array2 addObject:unitIdStr];
                    self.unitString = model.UnitName;
                }
            }
            dataArray = [NSMutableArray arrayWithObjects:array1,array2, nil];
            [subscriber sendNext:dataArray];
            
        } failure:^(NSError *error) {
            
        }];

        
        return nil;
    }];
    
    //数组
    //当数组中的所有信号都发送了数据，才会执行Selector
    //方法的参数：必须和数组的信号一一对应
    //方法的参数：就是每一个信号发送的数据
    [self rac_liftSelector:@selector(updateUIWithHeaderArray:unitArray:) withSignalsFromArray:@[signal1,signal2]];
}

-(void)updateUIWithHeaderArray:(NSMutableArray *)headerArray unitArray:(NSMutableArray *)unitArray {
    //拿到数据，更新UI
    self.headerArray = [NSMutableArray array];
    self.unitArray = [NSMutableArray array];
    
    self.headerArray = headerArray;
    self.unitArray = [unitArray safe_objectAtIndex:0];
    NSInteger unitid = [[[unitArray safe_objectAtIndex:1] safe_objectAtIndex:0] integerValue];
    [self.tableView reloadData];
    [self getUnitCellListData:unitid];
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
        
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        [self.tableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        [self.tableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}


//MARK:UITableView 代理
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
            vc.lessonId = model.ChapterID;
            [self presentViewController:nav animated:YES completion:nil];
        };
        
        //MARK:课前预习
        cell.classBeforeBtnBlock1 = ^(NSInteger index){
            HF_HomeHeaderModel *model = [self.headerArray safe_objectAtIndex:index];
            HF_PracticeViewController *vc = [[HF_PracticeViewController alloc] init];
            vc.webUrl = model.BeforeFilePath;
            vc.titleStr = model.ChapterName;
            vc.lessonid = model.ChapterID;
            [self presentViewController:vc animated:YES completion:nil];
        };
        

        //MARK:课后复习
        cell.classAfterBtnBlock1 = ^(NSInteger index){
            HF_HomeHeaderModel *model = [self.headerArray safe_objectAtIndex:index];
            HF_PracticeViewController *vc = [[HF_PracticeViewController alloc] init];
            vc.webUrl = model.BeforeFilePath;
            vc.titleStr = model.ChapterName;
            vc.lessonid = model.ChapterID;
            [self presentViewController:vc animated:YES completion:nil];
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
        
        @weakify(self);
        //MARK:切换等级数据
        cell.selectedUnitIdBlock = ^(HF_HomeGetUnitInfoListModel *model) {
            self.unitString = model.UnitName;
            [self getUnitCellListData:model.UnitID];
        };
        
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
        cell.unitNameString = self.unitString;

        //MARK:点击章节-进行跳转
        cell.selectedBlock = ^(NSInteger index) {
            HF_HomeUnitCellModel *model = [self.dataArray safe_objectAtIndex:index];
            HF_HomeClassDetailViewController *vc = [HF_HomeClassDetailViewController new];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            nav.popoverPresentationController.delegate = self;
            vc.lessonId = model.ChapterID;
            [self presentViewController:nav animated:YES completion:nil];
        };
        
        //MARK:课堂讲义下载
        cell.jiangyiDownBlock = ^{
            NSLog(@"课堂讲义下载");
        };
        
        //MARK:练习册下载
        cell.lianxiceDownBlock = ^{
            NSLog(@"练习册下载");
        };
        
        
        return cell;
    }
    
    return nil;
}

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
