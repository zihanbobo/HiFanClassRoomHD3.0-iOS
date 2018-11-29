//
//  GGT_ScheuleUnFinishedIconCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheuleUnFinishedIconCell.h"

@interface GGT_ScheuleUnFinishedIconCell()
@property (nonatomic, strong) UIView *xc_contentView; //背景
@property (nonatomic, strong) GGT_ScheduleStudentIconView *iconView; //头像
@end


@implementation GGT_ScheuleUnFinishedIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildUI];
    }
    return self;
}


// 创建UI
- (void)buildUI {
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);

    // 父view
    self.xc_contentView = [UIView new];
    self.xc_contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.xc_contentView];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(LineY(18));
        make.height.mas_equalTo(LineH(170));
    }];
    

    //头像View
    self.iconView = [GGT_ScheduleStudentIconView new];
    self.iconView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.iconView.viewHeight = LineH(133);
    [self.xc_contentView addSubview:self.iconView];

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_contentView.mas_left).offset(LineX(margin40));
        make.right.equalTo(self.xc_contentView.mas_right).offset(-LineX(margin40));
        make.top.equalTo(self.xc_contentView.mas_top).offset(LineY(margin20));
        make.height.mas_equalTo(LineH(133));
    }];
}


- (void)drawRect:(CGRect)rect {
    [self.xc_contentView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
}


- (void)getCellModel :(GGT_ScheduleDetailModel *)model {
    if ([model.StudentList isKindOfClass:[NSArray class]] && model.StudentList.count >0) {
        [self.iconView getCellArr:model.StudentList];
    }
    
}


@end
