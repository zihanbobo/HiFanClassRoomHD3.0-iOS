//
//  HF_MyScheduleHomeUnfishedListViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MyScheduleHomeUnfishedListViewController.h"
#import "HF_MyScheduleHomeUnFinishedCell.h"
#import "HF_MyScheduleHomeUnFinishedListModel.h"

@interface HF_MyScheduleHomeUnfishedListViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HF_PlaceHolderView *placeHolderView;
@end

@implementation HF_MyScheduleHomeUnfishedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.collectionView.mj_header beginRefreshing];

    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self initData];
    }];
}


//MARK:数据初始化
-(void)initData {
    [self.dataArray removeAllObjects];
    self.dataArray = [NSMutableArray array];
    [self getLoadData];
}


#pragma mark 数据请求
- (void)getLoadData {
    [[BaseService share] sendGetRequestWithPath:URL_GetNotMyLess token:YES viewController:self showMBProgress:NO success:^(id responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]] && (dataArray.count > 0)) {
                for (NSDictionary *dic in dataArray) {
                    HF_MyScheduleHomeUnFinishedListModel *model = [HF_MyScheduleHomeUnFinishedListModel yy_modelWithDictionary:dic];
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
    [self.collectionView registerClass:[HF_MyScheduleHomeUnFinishedCell class] forCellWithReuseIdentifier:@"HF_MyScheduleHomeUnFinishedCell"];
    
    
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
    static NSString *identify = @"HF_MyScheduleHomeUnFinishedCell";
    HF_MyScheduleHomeUnFinishedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(285.3),LineH(213));
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
