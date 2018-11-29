//
//  GGT_QuestionCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/29.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_QuestionCell.h"

@interface GGT_QuestionCell()
@property (nonatomic, strong) UILabel *xc_titleLabel;
@end

@implementation GGT_QuestionCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_QuestionCellID = NSStringFromClass([self class]);
    GGT_QuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGT_QuestionCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

// 必须得在init方法中config 否则会有重用问题
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildWithIndexPath:nil];
    }
    return self;
}

- (void)buildWithIndexPath:(NSIndexPath *)indexPath
{
    self.xc_titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color9B9B9B);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:self.xc_titleLabel];
    
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [self layoutIfNeeded];
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void)setXc_answerModel:(GGT_AnswerModel *)xc_answerModel
{
    _xc_answerModel = xc_answerModel;
    self.xc_titleLabel.text = xc_answerModel.Text;
    
    if (xc_answerModel.type == XCAnswerTypeSelect) {
        self.xc_titleLabel.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
        self.xc_titleLabel.textColor = [UIColor whiteColor];
        [self.xc_titleLabel addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:self.xc_titleLabel.height/2.0f];
        [self.xc_titleLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:self.xc_titleLabel.height];
    } else {
        self.xc_titleLabel.backgroundColor = [UIColor whiteColor];
        self.xc_titleLabel.textColor = UICOLOR_FROM_HEX(Color9B9B9B);
        [self.xc_titleLabel addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(Color9B9B9B) CornerRadius:self.xc_titleLabel.height/2.0f];
    }
}


@end
