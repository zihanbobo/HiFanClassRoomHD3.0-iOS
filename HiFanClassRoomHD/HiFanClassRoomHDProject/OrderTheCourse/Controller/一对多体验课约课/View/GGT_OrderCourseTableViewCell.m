//
//  GGT_OrderCourseTableViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderCourseTableViewCell.h"

@interface GGT_OrderCourseTableViewCell()
@property (nonatomic, strong) UIView *xc_contentView;
@property (nonatomic, strong) UIImageView *xc_iconImgView;
@property (nonatomic, strong) UILabel *xc_timeLabel;
@property (nonatomic, strong) UILabel *xc_levelLabel;
@property (nonatomic, strong) UILabel *xc_typeLabel;
@property (nonatomic, strong) UILabel *xc_classInfoLabel;

@property (nonatomic, strong) UIView *xc_lineView;
@end

@implementation GGT_OrderCourseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_OrderCourseTableViewCellID = NSStringFromClass([self class]);
    GGT_OrderCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_OrderCourseTableViewCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_OrderCourseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_OrderCourseTableViewCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildUI];
    }
    return self;
}

// 创建UI
- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];
    
    // 父view
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.xc_contentView];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-LineH(margin20));
    }];
    
    
    // 底部灰线
    self.xc_lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        view;
    });
    [self addSubview:self.xc_lineView];
    
    [self.xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.xc_contentView.mas_bottom);
    }];
    
    // 图像
    self.xc_iconImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView;
    });
    [self.xc_contentView addSubview:self.xc_iconImgView];

    [self.xc_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_contentView).offset(LineY(16));
        make.left.equalTo(self.xc_contentView).offset(LineX(16));
        make.bottom.equalTo(self.xc_contentView).offset(-LineH(16));
        make.width.mas_equalTo(LineW(168));
    }];

    // 上课时间
    self.xc_timeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(22);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label;
    });
    [self.xc_contentView addSubview:self.xc_timeLabel];

    [self.xc_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_iconImgView.mas_top);
        make.left.equalTo(self.xc_iconImgView.mas_right).offset(LineX(margin20));
        make.height.mas_equalTo(LineH(30));
    }];

    // 课程级别
    self.xc_levelLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(40), LineH(26));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(kThemeColor);
        label.backgroundColor = UICOLOR_FROM_HEX_ALPHA(kThemeColor, 10);
        label;
    });
    [self.xc_contentView addSubview:self.xc_levelLabel];

    [self.xc_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_timeLabel.mas_bottom).offset(LineY(margin10));
        make.left.equalTo(self.xc_timeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(LineW(40), LineH(26)));
    }];

    // 课程类型
    self.xc_typeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label;
    });
    [self.xc_contentView addSubview:self.xc_typeLabel];

    [self.xc_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xc_levelLabel);
        make.left.equalTo(self.xc_levelLabel.mas_right).offset(LineX(margin10));
        make.height.mas_equalTo(LineH(22));
    }];

    //课程介绍
    self.xc_classInfoLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;
        label;
    });
    [self.xc_contentView addSubview:self.xc_classInfoLabel];

    [self.xc_classInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_levelLabel.mas_bottom).offset(LineY(margin10));
        make.left.equalTo(self.xc_timeLabel.mas_left);
        make.width.mas_equalTo(LineW(534));
        make.bottom.equalTo(self.xc_contentView.mas_bottom).offset(-LineY(10));
    }];

    // 加入按钮
    self.xc_enterButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(108), LineH(36));
        xc_button.titleLabel.font = Font(16);
        [xc_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [xc_button setBackgroundColor:UICOLOR_FROM_HEX(ColorFF6600)];
        [xc_button setTitle:@"加入" forState:UIControlStateNormal];
        [xc_button setTitle:@"加入" forState:UIControlStateHighlighted];
        xc_button;
    });
    [self.xc_contentView addSubview:self.xc_enterButton];

    [self.xc_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xc_contentView.mas_centerY);
        make.width.equalTo(@(self.xc_enterButton.width));
        make.height.equalTo(@(self.xc_enterButton.height));
        make.right.equalTo(self.xc_contentView.mas_right).offset(-LineX(margin30));
    }];
}

- (void)drawRect:(CGRect)rect
{
    [self.xc_contentView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
    [self.xc_iconImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(6)];
    [self.xc_enterButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(18)];
    
    [self.xc_levelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(13)];
    [self.xc_levelLabel addBorderForViewWithBorderWidth:0.5f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:LineH(13)];
}

- (void)setXc_model:(GGT_ExperienceCourseModel *)xc_model
{
    _xc_model = xc_model;
    xc_model.FilePath = [xc_model.FilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.xc_iconImgView sd_setImageWithURL:[NSURL URLWithString:xc_model.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认")];
    
    if ([xc_model.StartTimePad isKindOfClass:[NSString class]] && xc_model.StartTime.length > 0) {
        self.xc_timeLabel.text = xc_model.StartTimePad;
    } else {
        self.xc_timeLabel.text = @"";
    }
    
    if ([xc_model.BookingTitle isKindOfClass:[NSString class]] && xc_model.BookingTitle.length > 0) {
        self.xc_levelLabel.text = xc_model.BookingTitle;
    } else {
        self.xc_levelLabel.text = @"";
    }
    
    if ([xc_model.Describe isKindOfClass:[NSString class]] && xc_model.Describe.length > 0) {
        self.xc_classInfoLabel.text = xc_model.Describe;
    } else {
        self.xc_classInfoLabel.text = @"";
    }
    
    if ([xc_model.TiYanTitlePad isKindOfClass:[NSString class]] && xc_model.TiYanTitlePad.length > 0) {
        self.xc_typeLabel.text = xc_model.TiYanTitlePad;
    } else {
        self.xc_typeLabel.text = @"";
    }
    
}

@end
