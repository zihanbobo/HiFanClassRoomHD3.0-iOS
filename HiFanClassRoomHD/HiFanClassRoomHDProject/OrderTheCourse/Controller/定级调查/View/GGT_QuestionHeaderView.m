//
//  GGT_QuestionHeaderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/29.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_QuestionHeaderView.h"

@interface GGT_QuestionHeaderView()
@property (nonatomic, strong) UILabel *xc_titleLabel;
@end

@implementation GGT_QuestionHeaderView

+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_QuestionHeaderViewID = NSStringFromClass([self class]);
    GGT_QuestionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier:GGT_QuestionHeaderViewID
                                                                                      forIndexPath:indexPath];
    
    return headerView;
}

// 必须得在init方法中config 否则会有重用问题
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.xc_titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.textAlignment = NSTextAlignmentLeft;
        label;
    });
    [self addSubview:self.xc_titleLabel];
    
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}

- (void)setXc_questionModel:(GGT_QuestionModel *)xc_questionModel
{
    _xc_questionModel = xc_questionModel;
    if ([xc_questionModel.Question isKindOfClass:[NSString class]] && xc_questionModel.Question.length > 0) {
        self.xc_titleLabel.text = [NSString stringWithFormat:@"%@.%@", xc_questionModel.Key, xc_questionModel.Question];
    } else {
        self.xc_titleLabel.text = @"";
    }
}

@end
