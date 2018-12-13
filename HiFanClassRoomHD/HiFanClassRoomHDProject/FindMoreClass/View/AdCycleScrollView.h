//
//  AdCycleScrollView.h
//  Ad
//
//  Created by RF on 15/5/10.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageStyle){
    AdCycleScrollViewPageControlNone = 0,
    AdCycleScrollViewPageControlAlimentLeft,
    AdCycleScrollViewPageControlAlimentCenter,
    AdCycleScrollViewPageControlAlimentRight
};

@class AdCycleScrollView;

@protocol AdCycleScrollViewDelegate <NSObject>

-(void)cycleScrollView:(AdCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)selectedIndex;

@end

@interface AdCycleScrollView : UIView

@property (nonatomic, strong) NSArray *imagesUrlArray;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
@property (nonatomic, assign) PageStyle pageControlAliment;
@property (nonatomic, strong) UICollectionView *mainView;

@property (nonatomic, weak) id<AdCycleScrollViewDelegate> delegate;

+(instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray;

- (void)refreshPageControlStyle;

@end
