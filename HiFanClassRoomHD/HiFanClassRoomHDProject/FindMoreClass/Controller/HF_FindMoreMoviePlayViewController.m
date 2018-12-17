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
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) HF_FindMoreMoviePlayView *headerView;
@end

@implementation HF_FindMoreMoviePlayViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftItem:@"箭头" title:@"自然拼读课"];
    [self initUI];
}




#pragma mark -- UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"HF_FindMoreMoviePlayCell";
    HF_FindMoreMoviePlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(LineW(230),LineH(258));
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
}

//MAEK:UI加载
-(void)initUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
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
        make.top.equalTo(self.headerView.mas_bottom).offset(17);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.height.mas_equalTo(230);
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
        self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        self.collectionView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
