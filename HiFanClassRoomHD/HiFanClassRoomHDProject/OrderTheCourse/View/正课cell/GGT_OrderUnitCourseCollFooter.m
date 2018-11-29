//
//  GGT_OrderUnitCourseCollFooter.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/7.
//  Copyright © 2018年 XieHenry. All rights reserved.
//

#import "GGT_OrderUnitCourseCollFooter.h"

@implementation GGT_OrderUnitCourseCollFooter

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark 初始化界面
- (void)initView {
//    加入班级：加入成功后即表示约课成功，请您注意按时上课。
//    申请开班：相同章节，同一时间下满3位小伙伴申请即可成功开班，开班成功后请您注意按时上课。
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.font = Font(12);
    label1.textColor = UICOLOR_FROM_HEX(0x777474);
    label1.textAlignment = NSTextAlignmentLeft;
    NSString *titleStr = @"加入班级：加入成功后即表示约课成功，请您注意按时上课。\n申请开班：相同章节，同一时间下满3位小伙伴申请即可成功开班，开班成功后请您注意按时上课。";
    label1.text = titleStr;
    label1.numberOfLines = 0;
    [label1 changeLineSpaceWithSpace:5];
    [self.contentView addSubview:label1];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(LineH(30));
        make.left.equalTo(self.contentView.mas_left).offset(LineX(20));
        make.height.mas_equalTo(LineH(40));
    }];
}


@end
