//
//  HF_FindMoreMoviePlayViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreMoviePlayViewController.h"
#import "HF_FindMoreMoviePlayCell.h"
#import "HF_FindMoreMoviePlayView.h"

@interface HF_FindMoreMoviePlayViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UIBarButtonItem *likeBtn;//喜欢
@property(nonatomic,strong) UIBarButtonItem *shareBtn;//分享

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HF_FindMoreMoviePlayView *headerView;
@end

@implementation HF_FindMoreMoviePlayViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftItem:@"箭头"];
    self.navigationItem.title = self.model.Title;
    self.dataArray = [NSMutableArray array];

    [self initUI];
    [self getLoadData];
}

-(void)getLoadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@?resourcesID=%ld",URL_GetInstructionalInfoList,(long)self.ResourcesID];
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


#pragma mark -- UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"HF_FindMoreMoviePlayCell";
    HF_FindMoreMoviePlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    HF_FindMoreInstructionalListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.cellModel = model;
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(230),LineH(221));
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, LineX(17), 0, LineX(17));
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(17);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
}


//MAEK:UI加载
-(void)initUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 20;
    self.navigationItem.rightBarButtonItems = @[self.shareBtn,fixedSpaceBarButtonItem,self.likeBtn];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.height.mas_equalTo(456);
    }];
    
    [self.view addSubview:self.collectionView];
    //注册cell
    [self.collectionView registerClass:[HF_FindMoreMoviePlayCell class] forCellWithReuseIdentifier:@"HF_FindMoreMoviePlayCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(25);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);
    }];
}


//MARK:懒加载
-(HF_FindMoreMoviePlayView *)headerView {
    if (!_headerView) {
        self.headerView = [[HF_FindMoreMoviePlayView alloc] init];
    }
    return _headerView;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource =self;
        self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

//喜欢
-(UIBarButtonItem *)likeBtn{
    if (!_likeBtn) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:UIIMAGE_FROM_NAME(@"灰爱心") forState:UIControlStateNormal];
        [btn setTitle:@"喜欢" forState:(UIControlStateNormal)];
        btn.frame = CGRectMake(0, 0, LineW(60), LineH(16));
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Font(16);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(3), 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(3));
        [btn sizeToFit];
        self.likeBtn =  [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _likeBtn;
}

//分享
-(UIBarButtonItem *)shareBtn{
    if (!_shareBtn) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:UIIMAGE_FROM_NAME(@"灰分享") forState:UIControlStateNormal];
        [btn setTitle:@"分享" forState:(UIControlStateNormal)];
        btn.frame = CGRectMake(0, 0, LineW(60), LineH(16));
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Font(16);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(3), 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(3));
        [btn sizeToFit];
        self.shareBtn =  [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _shareBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
