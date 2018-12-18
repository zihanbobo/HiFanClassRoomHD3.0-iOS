//
//  HF_FindMoreInstructionalListViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreInstructionalListViewController.h"
#import "HF_FindMoreInstructionlListHeaderView.h"
#import "HF_FindMoreInstructionlListCell.h"
#import "HF_FindMoreMoviePlayCell.h"
#import "HF_FindMoreInstructionalListModel.h"
#import "HF_FindMoreMoviePlayViewController.h"

@interface HF_FindMoreInstructionalListViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HF_FindMoreInstructionalListViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftItem:@"箭头"];
    self.title = self.model.Title;
    
    [self initUI];

//    MJRefreshGifHeader *header = [HF_RefreshHeader headerWithRefreshingBlock:^{
//        self.dataArray = [NSMutableArray array];
//        [self getLoadData];
//    }];
//
//    [header setImages:self.refreshImages duration:1 forState:MJRefreshStateRefreshing];
////    [header setImages:self.pullingImages duration:1 forState:MJRefreshStateIdle];
//    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    self.collectionView.mj_header = header;
//    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
    }];
    [self.collectionView.mj_header beginRefreshing];
}


-(void)getLoadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@?resourcesID=%ld",URL_GetInstructionalInfoList,(long)self.model.ResourcesID];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] >0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                HF_FindMoreInstructionalListModel *model = [HF_FindMoreInstructionalListModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//MARK:UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"HF_FindMoreInstructionlListCell";
    HF_FindMoreInstructionlListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    HF_FindMoreInstructionalListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(210),LineH(210));
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(LineY(0), LineX(17), LineY(0), LineX(17));
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineW(17);
}


//设置header的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(home_right_width,LineH(265));
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HF_FindMoreInstructionlListHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HF_FindMoreInstructionlListHeaderView" forIndexPath:indexPath];
    
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HF_FindMoreInstructionalListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    HF_FindMoreMoviePlayViewController *vc = [[HF_FindMoreMoviePlayViewController alloc] init];
    vc.model = model;
    vc.ResourcesID = self.model.ResourcesID;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:UI加载
-(void)initUI {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
    
    // 注册头视图
    [self.collectionView registerClass:[HF_FindMoreInstructionlListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HF_FindMoreInstructionlListHeaderView"];
    //注册cell
    [self.collectionView registerClass:[HF_FindMoreInstructionlListCell class] forCellWithReuseIdentifier:@"HF_FindMoreInstructionlListCell"];
}

//MARK:懒加载
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource =self;
        self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
