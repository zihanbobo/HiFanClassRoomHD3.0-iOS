//
//  HF_HomeContentCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeContentCell.h"
#import "HF_HomeUnitCollectionViewCell.h"
#import "HF_HomeUnitChooseView.h"

@interface HF_HomeContentCell()
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HF_HomeContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self initUI];
    }
    return self;
}


- (void)setCollectionArray:(NSMutableArray *)collectionArray {
    self.dataArray = [NSMutableArray array];
    self.dataArray = collectionArray;
    [self.collectionView reloadData];
}

-(void)initUI {
    //选择单元
    HF_HomeUnitChooseView *chooseUnitView = [[HF_HomeUnitChooseView alloc] init];
    chooseUnitView.layer.masksToBounds = YES;
    chooseUnitView.layer.cornerRadius = 24;
    chooseUnitView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
    [self.contentView addSubview:chooseUnitView];
    
    
    [chooseUnitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.height.mas_equalTo(48);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chooseUnitView.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
    }];


    //注册cell
    [self.collectionView registerClass:[HF_HomeUnitCollectionViewCell class] forCellWithReuseIdentifier:@"HF_HomeUnitCollectionViewCell"];
}


#pragma mark -- UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"HF_HomeUnitCollectionViewCell";
    HF_HomeUnitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(LineW(159),LineH(243));
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

//选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    

}


@end
