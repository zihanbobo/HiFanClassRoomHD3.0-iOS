//
//  HF_HomeContentCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeContentCell.h"
#import "HF_HomeUnitCollectionViewCell.h"
#import "HF_HomeUnitLastCell.h"

@interface HF_HomeContentCell()
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HF_HomeUnitLastCell *lastView;
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

- (void)setUnitNameString:(NSString *)unitNameString {
    self.lastView.unitNameString = unitNameString;
}


-(void)initUI {
    self.lastView = [[HF_HomeUnitLastCell alloc] init];
    @weakify(self);
    self.lastView.firstBtnBlock = ^{
        @strongify(self);
        if (self.jiangyiDownBlock) {
            self.jiangyiDownBlock();
        }
    };
    self.lastView.secondBtnBlock = ^{
        @strongify(self);
        if (self.lianxiceDownBlock) {
            self.lianxiceDownBlock();
        }
    };
    [self.contentView addSubview:self.lastView];
    
    [self.lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.size.mas_equalTo(CGSizeMake(186, 223));
    }];
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
 
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.lastView.mas_left).offset(-8);
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
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *identify = @"HF_HomeUnitCollectionViewCell";
        HF_HomeUnitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        HF_HomeUnitCellModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
        cell.cellModel = model;
        
        return cell;

}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(159),LineH(223));
}



//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        return UIEdgeInsetsMake(0, LineX(17), 0, LineX(9));
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
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.row);
    }
}


@end
