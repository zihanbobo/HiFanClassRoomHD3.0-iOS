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
#import "HF_HomeUnitJiangyiDownLoadViewController.h" //课堂讲义下载  练习册下载
#import "HF_HomeGetUnitInfoListModel.h"
#import "HF_HomeUnitCellModel.h"
#import "HF_HomeUnitChooseView.h"
#import "HF_PracticeViewController.h"

@interface HF_HomeViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *unitArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, copy) NSString *unitString;
@property (nonatomic, strong) NSDictionary *assistDataDic;
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
            NSMutableArray *array = [NSMutableArray array];
            [subscriber sendNext:array];
        }];
        
        return nil;
    }];
    
    //请求2
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送请求
        NSString *urlStr = [NSString stringWithFormat:@"%@?level=%@",URL_GetUnitInfoList,[UserDefaults() objectForKey:K_Level]];
        [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
            NSMutableArray *dataArray = [NSMutableArray array];
            NSMutableArray *array1 = [NSMutableArray array];
            NSMutableArray *array2 = [NSMutableArray array];

            if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
                NSArray *dataArray = responseObject[@"data"];
                [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HF_HomeGetUnitInfoListModel *model = [HF_HomeGetUnitInfoListModel yy_modelWithDictionary:obj];
                    if (idx == 0) {
                        NSString *unitIdStr = [NSString stringWithFormat:@"%ld",(long)model.UnitID];
                        [array2 addObject:unitIdStr];
                        self.unitString = model.UnitName;
                    }
                    
                    [array1 addObject:model];
                }];
            }

            dataArray = [NSMutableArray arrayWithObjects:array1,array2, nil];
            [subscriber sendNext:dataArray];
            
        } failure:^(NSError *error) {
            NSMutableArray *dataArray = [NSMutableArray array];
            NSMutableArray *array1 = [NSMutableArray array];
            NSMutableArray *array2 = [NSMutableArray array];
            dataArray = [NSMutableArray arrayWithObjects:array1,array2, nil];

            [subscriber sendNext:dataArray];
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
    self.sectionArray = [NSMutableArray array];
    //拿到数据，更新UI
    self.headerArray = [NSMutableArray array];
    self.unitArray = [NSMutableArray array];
    
    
    self.headerArray = headerArray;
    self.unitArray = [unitArray safe_objectAtIndex:0];
    NSInteger unitid = [[[unitArray safe_objectAtIndex:1] safe_objectAtIndex:0] integerValue];
    
    
    
    if (!IsArrEmpty(self.headerArray)) {
        [self.sectionArray addObject:self.headerArray];
    }
    
    if (!IsArrEmpty(self.unitArray)) {
        [self.sectionArray addObject:self.unitArray];
        self.dataArray = [NSMutableArray array];
        [self.sectionArray addObject:self.dataArray];
    }
    
    [self.tableView reloadData];
    [self getUnitCellListData:unitid];
}



-(void)getUnitCellListData:(NSInteger)unitId {
    self.dataArray = [NSMutableArray array];

    NSString *urlStr = [NSString stringWithFormat:@"%@?unitId=%ld",URL_GetChapterList,(long)unitId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"][@"chapterData"] isKindOfClass:[NSArray class]] && [responseObject[@"data"][@"chapterData"] count] >0) {
            self.assistDataDic = responseObject[@"data"][@"assistData"];
            for (NSDictionary *dic in responseObject[@"data"][@"chapterData"]) {
                HF_HomeUnitCellModel *model = [HF_HomeUnitCellModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        [self.tableView reloadData];
        
        if (self.sectionArray.count == 3) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        } else {
             [self.tableView reloadData];
        }
       

        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        [self.tableView reloadData];
        
        if (self.sectionArray.count == 3) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.tableView reloadData];
        }
        
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
        

        //MARK:课后练习----进入教室
        cell.cellRightButtonBlock1 = ^(UIButton *button, NSInteger index) {
            HF_HomeHeaderModel *model = [self.headerArray safe_objectAtIndex:index];

            
            if ([button.titleLabel.text isEqualToString:@"课后练习"]) {
                HF_PracticeViewController *vc = [[HF_PracticeViewController alloc] init];
                vc.webUrl = model.BeforeFilePath;
                vc.titleStr = model.ChapterName;
                vc.lessonid = model.ChapterID;
                [self presentViewController:vc animated:YES completion:nil];
            } else if ([button.titleLabel.text isEqualToString:@"进入教室"]) {
                //0 是未开始  1 上课中 2 即将开始 3 已结束
                if (model.StatusName == 0) {
                    
                    LOSAlertPRO(@"请在开课前10分钟内进入教室", @"知道了");
                    
                } else if (model.StatusName == 1 || model.StatusName == 2) {
                    
                    HF_ClassRoomModel *tkModel = [[HF_ClassRoomModel alloc] init];
                    tkModel.serial = model.Serial;
                    tkModel.host = model.Host;
                    tkModel.port = model.Port;
                    tkModel.nickname = model.Nickname;
                    tkModel.userrole = model.Userrole;
                    tkModel.LessonId = model.AttendLessonID;
                    
                    [HF_ClassRoomManager tk_enterClassroomWithViewController:self courseModel:tkModel leftRoomBlock:^{
                        
                    }];
                }
            }
            
        };
     
        
        return cell;
        
    } else if (indexPath.row == 1) {
        static NSString *cellID = @"HF_HomeUnitChooseView";
        HF_HomeUnitChooseView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HF_HomeUnitChooseView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
//        cell.collectionUnitArray = [NSMutableArray array];
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
            HF_HomeUnitJiangyiDownLoadViewController *vc = [[HF_HomeUnitJiangyiDownLoadViewController alloc] init];
            vc.urlStr = self.assistDataDic[@"HandoutUrl"];
            vc.title = @"课堂讲义";
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        //MARK:练习册下载
        cell.lianxiceDownBlock = ^{
            HF_HomeUnitJiangyiDownLoadViewController *vc = [[HF_HomeUnitJiangyiDownLoadViewController alloc] init];
            vc.urlStr = self.assistDataDic[@"WorkBook"];
            vc.title = @"练习册";
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sectionArray.count;
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
