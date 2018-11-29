//
//  GGT_OrderUnitCourseDateView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/28.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderUnitCourseDateView.h"

@interface GGT_OrderUnitCourseDateView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *xc_collectionView;
@property (nonatomic, strong) NSMutableArray *xc_dateMuArray;
@end


@implementation GGT_OrderUnitCourseDateView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildUI];
    }
    return self;
}


-(void)getArray:(NSArray *)array {
    self.xc_dateMuArray = [NSMutableArray array];
    self.xc_dateMuArray = (NSMutableArray *) array;
    
    //计算总共几页
    self.pageControl.numberOfPages = self.xc_dateMuArray.count / 7;
    
    [self.xc_collectionView reloadData];
}

#pragma mark - 创建UI
- (void)buildUI {
    self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    self.reFresh = YES;

    UIView *bgView = [UIView new];
    bgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = LineH(10);
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(-0);
        make.top.equalTo(self.mas_top).with.offset(LineY(margin20));
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
    }];
    
    
    
    // collectionView
    UICollectionViewFlowLayout *xc_layout = [[UICollectionViewFlowLayout alloc] init];
    xc_layout.itemSize = CGSizeMake(LineW(xc_cellWidth), LineH(xc_cellHeight));
    xc_layout.minimumLineSpacing = 0;
    xc_layout.minimumInteritemSpacing = 0;
    xc_layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.xc_collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:xc_layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView;
    });
    [bgView addSubview:self.xc_collectionView];
    
    [self.xc_collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(LineX(11));
        make.right.equalTo(self.mas_right).offset(-LineX(11));
        make.top.equalTo(bgView.mas_top).with.offset(LineY(18));
        make.height.mas_equalTo(LineY(xc_cellHeight));
    }];
    
    // 注册collectionViewCell
    [self.xc_collectionView registerClass:[GGT_OrderCourseCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GGT_OrderCourseCollectionViewCell class])];
    
    
    self.pageControl = [[HF_PageControl alloc]initWithFrame:CGRectMake(0, 0, LineW(12), LineH(12))];
    self.pageControl.bounds = CGRectMake(0, 0, LineW(12), LineH(12));
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPageIndicatorTintColor = UICOLOR_FROM_HEX(ColorFF6600);
    self.pageControl.pageIndicatorTintColor = UICOLOR_FROM_HEX_ALPHA(ColorFF6600, 20);
    self.currentPageControl = self.pageControl;
    [self addSubview:self.pageControl];
    
    [self.pageControl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_collectionView.mas_bottom).offset(LineY(margin20));
        make.left.right.equalTo(self.xc_collectionView);
        make.height.mas_equalTo(LineH(12));
    }];
    
}





#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.xc_collectionView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger count =  (int)ceil(x /self.xc_collectionView.width);
        self.currentPageControl.currentPage = count;
    }
}


// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.xc_dateMuArray.count;
}

// 设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(xc_cellWidth), LineH(xc_cellHeight));
}

//返回行内部cell（item）之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return LineH(xc_cellMargin);
}

//返回行间距 上下间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineH(20);
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(LineY(0), LineX(20), LineY(0), LineX(20));
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_OrderCourseCollectionViewCell *cell = [GGT_OrderCourseCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.xc_model = self.xc_dateMuArray[indexPath.row];
    
    if (cell.xc_model.selectType == XCCellITypeSelect) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

// 设置header和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

// collectionView的footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

// collectionView的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}


// 选中cell的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGT_DateModel *model = self.xc_dateMuArray[indexPath.row];
    model.selectType = XCCellITypeSelect;
    [collectionView reloadData];
    
    
    
    // 选中上面的cell时 要刷新下面数据 请求接口
    if (self.getDateBlock) {
        self.getDateBlock(model.DateTime);
    }
}


// 取消选中cell的时候
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGT_DateModel *model = self.xc_dateMuArray[indexPath.row];
    model.selectType = XCCellTypeDeselect;
    [self.xc_dateMuArray replaceObjectAtIndex:indexPath.row withObject:model];
    
}



@end

