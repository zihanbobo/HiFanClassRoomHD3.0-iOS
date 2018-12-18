//
//  HF_HomeHeaderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeHeaderView.h"
#import "HF_HomeHeaderCollectionViewCell.h"


@interface HF_HomeHeaderView()
@property (nonatomic,strong) BaseScrollHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HF_HomeHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        
    }
    return self;
}


- (void)setCollectionDataArray:(NSMutableArray *)collectionDataArray {
    self.dataArray = [NSMutableArray array];
    self.dataArray = collectionDataArray;
    [self.collectionView reloadData];
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
    
    static NSString *identify = @"HF_HomeHeaderCollectionViewCell";
    HF_HomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    HF_HomeHeaderModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.cellModel = model;
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(LineW(480),LineH(159));
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
    NSLog(@"%ld",(long)indexPath.row);

}

//MARK:UI加载
-(void)initUI {
    self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.height.mas_equalTo(106);
    }];
    
    @weakify(self);
    [[self.headerView.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.gonglueBtnBlock) {
             self.gonglueBtnBlock();
         }
     }];
    
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(50);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(-0);
        make.bottom.equalTo(self.mas_bottom).offset(-0);
    }];
    //注册cell
    [self.collectionView registerClass:[HF_HomeHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"HF_HomeHeaderCollectionViewCell"];
}


//MARK:懒加载
-(BaseScrollHeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [[BaseScrollHeaderView alloc] init];
        self.headerView.navBigLabel.text = @"Good Afternoon";
        self.headerView.titleLabel.text = @"下午好";
        [self.headerView.rightButton setTitle:@"课程攻略" forState:(UIControlStateNormal)];
        [self.headerView.rightButton setImage:UIIMAGE_FROM_NAME(@"攻略1") forState:(UIControlStateNormal)];
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

@end
