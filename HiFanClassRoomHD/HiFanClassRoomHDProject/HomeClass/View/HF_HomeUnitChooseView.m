//
//  HF_HomeUnitChooseView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnitChooseView.h"
#import "HF_HomeGetUnitInfoListModel.h"

@interface HF_HomeUnitChooseView()
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) NSMutableArray *UnitArray;
@end


@implementation HF_HomeUnitChooseView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


- (void)setCollectionUnitArray:(NSMutableArray *)collectionUnitArray {
    self.UnitArray = [NSMutableArray array];
    self.UnitArray = collectionUnitArray;
    //    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView reloadData];
}


-(void)initUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 24;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.bottom.equalTo(self);
    }];
    
    //左侧按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:UIIMAGE_FROM_NAME(@"左三角灰") forState:UIControlStateNormal];
    [self.leftButton setImage:UIIMAGE_FROM_NAME(@"左三角灰") forState:UIControlStateSelected];
    [bgView addSubview:self.leftButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(0);
        make.top.bottom.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(30, 48));
    }];
    
    //右侧按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角黑") forState:UIControlStateNormal];
    [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角黑") forState:UIControlStateSelected];
    [bgView addSubview:self.rightButton];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-0);
        make.top.bottom.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(30, 48));
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    [bgView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(0);
        make.left.equalTo(bgView.mas_left).offset(30);
        make.right.equalTo(bgView.mas_right).offset(-30);
        make.bottom.equalTo(bgView.mas_bottom).offset(-0);
    }];
    
    
    //注册cell
    [self.collectionView registerClass:[HF_HomeUnitChooseCell class] forCellWithReuseIdentifier:@"HF_HomeUnitChooseCell"];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"1111");
}


#pragma mark -- UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.UnitArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"HF_HomeUnitChooseCell";
    HF_HomeUnitChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (indexPath.row == 0) { //默认选中第一条数据
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        cell.contentView.backgroundColor = UICOLOR_FROM_HEX(0xe5ebf0);
        cell.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    }
    
    HF_HomeGetUnitInfoListModel *model = [self.UnitArray safe_objectAtIndex:indexPath.row];
    cell.cellModel = model;
    
    return cell;
}

//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(104),LineH(48));
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HF_HomeUnitChooseCell *cell = (HF_HomeUnitChooseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UICOLOR_FROM_HEX(0xe5ebf0);
    cell.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    HF_HomeGetUnitInfoListModel *model = [self.UnitArray safe_objectAtIndex:indexPath.row];
    
    if (self.selectedUnitIdBlock) {
        self.selectedUnitIdBlock(model.UnitID);
    }
}

//取消选中
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    HF_HomeUnitChooseCell *cell = (HF_HomeUnitChooseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
    cell.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    
}

@end
