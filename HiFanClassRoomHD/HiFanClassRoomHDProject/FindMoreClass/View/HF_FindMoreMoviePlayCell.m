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
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    //教材 封面
    self.bookImgView = [[UIImageView alloc]init];
    self.bookImgView.image = UIIMAGE_FROM_NAME(@"默认");
    self.bookImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bookImgView];
    
    [self.bookImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(230, 180));
    }];
    
    
    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.font = Font(16);
//    self.classNameLabel.text = @"Alphabet JKL";
    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color000000);
    [self.contentView addSubview:self.classNameLabel];
    
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookImgView.mas_bottom).offset(17);
        make.left.equalTo(self.bookImgView.mas_left);
        make.height.mas_equalTo(16);
    }];
}

- (void)setCellModel:(HF_FindMoreInstructionalListModel *)cellModel {
    if (!IsStrEmpty(cellModel.CoverImage)) {
        [self.bookImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.CoverImage] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(230), LineW(180))];
            self.bookImgView.image = image;
        }];
    }
    
    
    if (!IsStrEmpty(cellModel.Title)) {
        self.classNameLabel.text = cellModel.Title;
    }
}

- (void)drawRect:(CGRect)rect {
    [self.bookImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
}

@end
