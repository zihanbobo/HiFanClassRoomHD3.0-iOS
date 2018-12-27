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
//    if (collectionUnitArray.count > 8) {
//        [self.leftButton setImage:UIIMAGE_FROM_NAME(@"左三角灰") forState:UIControlStateNormal];
//        [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角黑") forState:UIControlStateNormal];
//    } else {
//        [self.leftButton setImage:UIIMAGE_FROM_NAME(@"左三角灰") forState:UIControlStateNormal];
//        [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角灰") forState:UIControlStateNormal];
//    }
    
    self.UnitArray = [NSMutableArray array];
    self.UnitArray = collectionUnitArray;
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
    
    //左侧按钮----暂时先指示左右滑动。后续实现 按钮操作
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:UIIMAGE_FROM_NAME(@"左三角灰") forState:UIControlStateNormal];
    self.leftButton.tag = 10;
//    [self.leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:self.leftButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(0);
        make.top.bottom.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(30, 48));
    }];
    
    //右侧按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角灰") forState:UIControlStateNormal];
    self.rightButton.tag = 20;
//    [self.rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
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
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentSize = CGSizeMake(self.collectionView.width, 48);
    [bgView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(0);
        make.left.equalTo(self.leftButton.mas_right).offset(0);
        make.right.equalTo(self.rightButton.mas_left).offset(-0);
        make.bottom.equalTo(bgView.mas_bottom).offset(-0);
    }];
    
    
    //注册cell
    [self.collectionView registerClass:[HF_HomeUnitChooseCell class] forCellWithReuseIdentifier:@"HF_HomeUnitChooseCell"];
}

//-(void)buttonClick:(UIButton *)button {
//    if (button.tag == 10) {
//        self.collectionView.contentOffset = CGPointMake(0, 0);
//    } else if (button.tag == 20) {
//        self.collectionView.contentOffset = CGPointMake(self.collectionView.width, 0);
//    }
//}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//
//    CGFloat x = scrollView.contentOffset.x; //偏移量
//    CGFloat w = self.collectionView.width; //(17+30)*2 = 94  home_right_width - LineW(94) = 830
//
//    NSLog(@"%f    %f",w,self.collectionView.contentSize.width);
//
//    if (x == 0 ) {
//        [self.leftButton setImage:UIIMAGE_FROM_NAME(@"左三角灰") forState:UIControlStateNormal];
//        if (self.collectionView.contentSize.width >= w) {
//            [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角黑") forState:UIControlStateNormal];
//        } else {
//            [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角灰") forState:UIControlStateNormal];
//        }
//    } else if (x >= w) {
//        [self.leftButton setImage:UIIMAGE_FROM_NAME(@"左三角黑") forState:UIControlStateNormal];
//        if (self.collectionView.contentSize.width >= w) {
//            [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角灰") forState:UIControlStateNormal];
//        } else {
//            [self.rightButton setImage:UIIMAGE_FROM_NAME(@"右三角灰") forState:UIControlStateNormal];
//        }
//    }
//}



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

    cell.contentView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
    cell.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    
    
    if (indexPath.row == 0) { //默认选中第一条数据
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        cell.contentView.backgroundColor = UICOLOR_FROM_HEX(0xe5ebf0);
        cell.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    }
    
    HF_HomeGetUnitInfoListModel *model = [self.UnitArray safe_objectAtIndex:indexPath.row];
    cell.cellModel = model;
    
    if (indexPath.row == self.UnitArray.count - 1 ) { //分割线
        cell.rightLineView.hidden = NO;
    } else {
        cell.rightLineView.hidden = YES;
    }
    
    return cell;
}

//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(103),LineH(48));
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
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HF_HomeUnitChooseCell *cell = (HF_HomeUnitChooseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UICOLOR_FROM_HEX(0xe5ebf0);
    cell.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    HF_HomeGetUnitInfoListModel *model = [self.UnitArray safe_objectAtIndex:indexPath.row];
    NSLog(@"选中");

    if (self.selectedUnitIdBlock) {
        self.selectedUnitIdBlock(model);
    }
}

//取消选中
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    HF_HomeUnitChooseCell *cell = (HF_HomeUnitChooseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UICOLOR_FROM_HEX(0xF4F6F9);
    cell.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    NSLog(@"取消选中");
}

@end
