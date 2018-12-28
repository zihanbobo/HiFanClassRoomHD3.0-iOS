//
//  HF_MyScheduleHomeFishedListViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MyScheduleHomeFishedListViewController.h"
#import "HF_MyScheduleHomeFinishedCell.h"
#import "HF_MyScheduleHomeFinishedListModel.h"
#import "HF_PracticeViewController.h"

@interface HF_MyScheduleHomeFishedListViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HF_PlaceHolderView *placeHolderView;
@end

@implementation HF_MyScheduleHomeFishedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
                    HF_MyScheduleHomeFinishedListModel *model = [HF_MyScheduleHomeFinishedListModel yy_modelWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                
                self.placeHolderView.hidden = YES;
                
            } else {
                HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:responseObject];
                self.placeHolderView.xc_model = model;
                self.placeHolderView.hidden = NO;
            }
        }
        
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        self.collectionView.mj_footer.hidden = NO;
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        HF_ResultModel *model = [HF_ResultModel yy_modelWithDictionary:error.userInfo];
        self.placeHolderView.xc_model = model;
        self.placeHolderView.hidden = NO;
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        self.collectionView.mj_footer.hidden = YES;
        [self.collectionView reloadData];
    }];
}



-(void)initUI {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
        
    }];
    
    //注册cell
    [self.collectionView registerClass:[HF_MyScheduleHomeFinishedCell class] forCellWithReuseIdentifier:@"HF_MyScheduleHomeFinishedCell"];
    
    [self.collectionView addSubview:self.placeHolderView];
    self.placeHolderView.hidden = YES;
    
}

-(HF_PlaceHolderView *)placeHolderView {
    if (!_placeHolderView) {
        self.placeHolderView = [[HF_PlaceHolderView alloc] initWithFrame:CGRectZero withImgYHeight:LineY(120)];
        self.placeHolderView.frame = CGRectMake(0, 0, home_right_width, SCREEN_HEIGHT());
    }
    return _placeHolderView;
}


-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource =self;
        self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}



#pragma mark -- UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"HF_MyScheduleHomeFinishedCell";
    HF_MyScheduleHomeFinishedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    HF_MyScheduleHomeFinishedListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.listModel = model;
    
    cell.practiceButtonBlock = ^(UIButton *button) {
        [self cellButtonClick:button indexRow:indexPath.row];
    };
    
    return cell;
}




//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(285.3),LineH(418));
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(LineY(8.5), LineX(17), LineY(8.5), LineX(17));
    
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(17);
    
}

//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(17);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    if (self.scrollHeightBlock) {
        self.scrollHeightBlock(offset_Y);
    }
}


-(void)cellButtonClick:(UIButton *)button indexRow:(NSInteger)index{
    switch (button.tag) {
        case 10: //评价
            
            break;
        case 11: //课前预习
            [self classBeforeButtonWithIndex:index];
            break;
        case 12: //课后练习
            [self classAfterButtonWithIndex:index];
            break;
        default:
            break;
    }
}


//MARK:课前预习
- (void)classBeforeButtonWithIndex:(NSInteger)index {
    HF_MyScheduleHomeFinishedListModel *model = [self.dataArray safe_objectAtIndex:index];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&LessonID=%ld",URL_AddBeforeLog,(long)model.DetailRecordID];
    [[BaseService share] sendAFGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:xc_returnCode] integerValue] > 0) {
            HF_PracticeViewController*vc = [[HF_PracticeViewController alloc]init];
            vc.titleStr = model.FileTittle;
            vc.webUrl = model.BeforeFilePath;
            vc.lessonid = [NSString stringWithFormat:@"%ld",(long)model.LessonId];
            [self presentViewController:vc animated:YES completion:nil];
            
//            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
    }];
}

//MARK:课后练习
- (void)classAfterButtonWithIndex:(NSInteger)index {
    HF_MyScheduleHomeFinishedListModel *model = [self.dataArray safe_objectAtIndex:index];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?&LessonID=%ld",URL_AddAfterLog ,(long)model.DetailRecordID];
    
    [[BaseService share] sendAFGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:xc_returnCode] integerValue] > 0) {
            HF_PracticeViewController*vc = [[HF_PracticeViewController alloc]init];
            vc.titleStr = model.FileTittle;
            vc.webUrl = model.AfterClassUrl;
            vc.lessonid = [NSString stringWithFormat:@"%ld",(long)model.LessonId];
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
