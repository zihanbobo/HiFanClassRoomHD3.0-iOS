//
//  HF_FindMoreMoviePlayCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreMoviePlayCell.h"


@interface HF_FindMoreMoviePlayCell()
//教材 封面
@property (nonatomic, strong) UIImageView *bookImgView;
//课程名称
@property (nonatomic, strong) UILabel *classNameLabel;
@end


@implementation HF_FindMoreMoviePlayCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    //教材 封面
    self.bookImgView = [[UIImageView alloc]init];
    self.bookImgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.bookImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bookImgView];
    
    [self.bookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(18);
        make.left.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(230, 180));
    }];
    
    
    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.font = Font(16);
    self.classNameLabel.text = @"Alphabet JKL";
    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.contentView addSubview:self.classNameLabel];
    
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookImgView.mas_bottom).with.offset(17);
        make.left.equalTo(self.bookImgView.mas_left);
        make.height.mas_equalTo(16);
    }];

}

- (void)drawRect:(CGRect)rect {
    [self.bookImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
}

@end
