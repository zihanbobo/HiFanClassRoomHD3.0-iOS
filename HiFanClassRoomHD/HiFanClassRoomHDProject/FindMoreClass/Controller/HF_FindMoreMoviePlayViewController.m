//
//  HF_FindMoreMoviePlayViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreMoviePlayViewController.h"
#import "HF_FindMoreMoviePlayCell.h"

@interface HF_FindMoreMoviePlayViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation HF_FindMoreMoviePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftItem:@"fanhui_top" title:@"自然拼读课"];
    
    
    UIView *moviePlayerView = [[UIView alloc] init];
    moviePlayerView.backgroundColor = UICOLOR_RANDOM_COLOR();
    [self.view addSubview:moviePlayerView];
    
    [moviePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(25);
        make.left.equalTo(self.view.mas_left).with.offset(133);
        make.right.equalTo(self.view.mas_right).with.offset(-133);
        make.height.mas_equalTo(370);
    }];
    
    //课程名称
    UILabel *moviePlayerViewNameLabel = [[UILabel alloc]init];
    moviePlayerViewNameLabel.font = Font(18);
    moviePlayerViewNameLabel.text = @"Phonics - R Blends";
    moviePlayerViewNameLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [self.view addSubview:moviePlayerViewNameLabel];
    
    
    [moviePlayerViewNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerView.mas_bottom).with.offset(17);
        make.left.equalTo(moviePlayerView.mas_left);
        make.height.mas_equalTo(18);
    }];

    
    //MARK:分享
    UIButton *shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [shareButton setTitleColor:UICOLOR_FROM_HEX(Color000000) forState:UIControlStateNormal];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setImage:UIIMAGE_FROM_NAME(@"爱心") forState:(UIControlStateNormal)];
    shareButton.titleLabel.font = Font(16);
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(2.5), 0, 0);
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(2.5));
    [self.view addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerView.mas_bottom).with.offset(17);
        make.right.equalTo(moviePlayerView.mas_right);
        make.height.mas_equalTo(16);
    }];
    
    
    //MARK:喜欢
    UIButton *collectionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [collectionButton setTitleColor:UICOLOR_FROM_HEX(Color000000) forState:UIControlStateNormal];
    [collectionButton setTitle:@"喜欢" forState:UIControlStateNormal];
    [collectionButton setImage:UIIMAGE_FROM_NAME(@"爱心") forState:(UIControlStateNormal)];
    collectionButton.titleLabel.font = Font(16);
    collectionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(2.5), 0, 0);
    collectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(2.5));
    [self.view addSubview:collectionButton];
    
    [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerView.mas_bottom).offset(17);
        make.right.equalTo(shareButton.mas_left).offset(-20);
        make.height.mas_equalTo(16);
    }];
    
    
    //MARK:导航分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePlayerViewNameLabel.mas_bottom).offset(25);
        make.left.equalTo(self.view.mas_left).offset(17);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.height.mas_equalTo(1);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(17);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.height.mas_equalTo(223); //180 17 16 10
    }];
    
    
    //注册cell
    [self.collectionView registerClass:[HF_FindMoreMoviePlayCell class] forCellWithReuseIdentifier:@"HF_FindMoreMoviePlayCell"];
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


- (CGSize)collectionViewContentSize {
    CGSize size = CGSizeMake(LineW(264)*15, LineH(258));
    return size;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"HF_FindMoreMoviePlayCell";
    HF_FindMoreMoviePlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor yellowColor];
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
