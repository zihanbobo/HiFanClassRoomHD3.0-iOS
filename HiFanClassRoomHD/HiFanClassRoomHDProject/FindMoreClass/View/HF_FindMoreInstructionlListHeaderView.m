//
//  HF_FindMoreInstructionlListHeaderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreInstructionlListHeaderView.h"

@interface HF_FindMoreInstructionlListHeaderView()
//封面
@property (nonatomic, strong) UIImageView *bookImgView;
@end


@implementation HF_FindMoreInstructionlListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    //教材 封面
    self.bookImgView = [[UIImageView alloc]init];
    self.bookImgView.backgroundColor = UICOLOR_RANDOM_COLOR();
    self.bookImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bookImgView];
    
    [self.bookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.height.mas_equalTo(210);
    }];
    
}

- (void)drawRect:(CGRect)rect {
    [self.bookImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
}

@end
