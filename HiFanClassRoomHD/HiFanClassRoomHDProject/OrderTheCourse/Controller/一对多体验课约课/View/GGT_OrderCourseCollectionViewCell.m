//
//  GGT_OrderCourseCollectionViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderCourseCollectionViewCell.h"

static CGFloat const xc_cellCornerRadius = 10.0f;

@interface GGT_OrderCourseCollectionViewCell ()
@property (nonatomic, strong) UIView *xc_contentView;
@property (nonatomic, strong) UILabel *xc_weekDayLabel;
@property (nonatomic, strong) UILabel *xc_timeLabel;
@end

@implementation GGT_OrderCourseCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString *GGT_OrderCourseCollectionViewCellID = NSStringFromClass([self class]);
    GGT_OrderCourseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGT_OrderCourseCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

// 必须得在init方法中config 否则会有重用问题
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildWithIndexPath:nil];
    }
    return self;
}

// 创建UI
- (void)buildWithIndexPath:(NSIndexPath *)indexPath {
    // 父view
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.xc_contentView];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
    
    // 星期
    self.xc_weekDayLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(20);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.xc_contentView addSubview:self.xc_weekDayLabel];
    
    [self.xc_weekDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_contentView).offset(LineY(margin10));
        make.left.right.equalTo(self.xc_contentView);
//        make.height.equalTo(@28);
    }];
    
    // 日期
    self.xc_timeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(20);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.xc_contentView addSubview:self.xc_timeLabel];
    
    [self.xc_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_weekDayLabel.mas_bottom).offset(LineY(margin5));
        make.left.right.equalTo(self.xc_contentView);
    }];
    
}


- (void)setXc_model:(GGT_DateModel *)xc_model {
    _xc_model = xc_model;
    if ([xc_model.WeekDay isKindOfClass:[NSString class]] && xc_model.WeekDay.length > 0) {
        self.xc_weekDayLabel.text = xc_model.WeekDay;
    } else {
        self.xc_weekDayLabel.text = @"";
    }
    
    if ([xc_model.Time isKindOfClass:[NSString class]] && xc_model.Time.length > 0) {
        self.xc_timeLabel.text = xc_model.Time;
    } else {
        self.xc_timeLabel.text = @"";
    }

    if (xc_model.selectType == XCCellITypeSelect) {
        self.xc_contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFF6600);
        self.xc_weekDayLabel.textColor = [UIColor whiteColor];
        self.xc_timeLabel.textColor = [UIColor whiteColor];
        [self.xc_contentView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(ColorFF6600) CornerRadius:xc_cellCornerRadius];
    } else {
        
        self.xc_contentView.backgroundColor = [UIColor whiteColor];
        // 0 不是周末  1是周末
        if (xc_model.IsPuncTuation == 0) {
            self.xc_timeLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
            self.xc_weekDayLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
            [self.xc_contentView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(Color4A4A4A) CornerRadius:xc_cellCornerRadius];
        } else {
            self.xc_timeLabel.textColor = UICOLOR_FROM_HEX(ColorFF6600);
            self.xc_weekDayLabel.textColor = UICOLOR_FROM_HEX(ColorFF6600);
            [self.xc_contentView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(ColorFF6600) CornerRadius:xc_cellCornerRadius];
        }
    }
}

@end
