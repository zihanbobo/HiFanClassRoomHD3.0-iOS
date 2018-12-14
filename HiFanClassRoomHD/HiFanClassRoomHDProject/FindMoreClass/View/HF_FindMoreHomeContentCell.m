//
//  HF_FindMoreHomeContentCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreHomeContentCell.h"
#import "HF_FindMoreHomeCollectionViewCell.h"

@interface HF_FindMoreHomeContentCell()
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
@implementation HF_FindMoreHomeContentCell


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
    //课程名称
    UILabel *classNameLabel = [[UILabel alloc]init];
    classNameLabel.font = Font(26);
    classNameLabel.text = @"hi翻放映厅";
    classNameLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.contentView addSubview:classNameLabel];
    
    
    [classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.height.mas_equalTo(26);
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
        make.top.equalTo(classNameLabel.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
    }];
    
    
    //注册cell
    [self.collectionView registerClass:[HF_FindMoreHomeCollectionViewCell class] forCellWithReuseIdentifier:@"HF_FindMoreHomeCollectionViewCell"];
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

    static NSString *identify = @"HF_FindMoreHomeCollectionViewCell";
    HF_FindMoreHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

    HF_FindMoreInstructionalTypeListModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.model = model;
    
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
    NSLog(@"%ld",(long)indexPath.row);
    
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.row);
    }
}

@end
