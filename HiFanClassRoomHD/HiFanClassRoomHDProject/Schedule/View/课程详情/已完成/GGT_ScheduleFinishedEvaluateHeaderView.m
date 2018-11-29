//
//  GGT_ScheduleFinishedEvaluateHeaderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/18.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleFinishedEvaluateHeaderView.h"

@interface GGT_ScheduleFinishedEvaluateHeaderView()
@property (nonatomic, strong) UIView *xc_contentView; //背景
@property (nonatomic, strong) UIView *xc_iconbgView; //老师头像背景
@property (nonatomic, strong) UIImageView *xc_iconImgView; //老师头像
@property (nonatomic, strong) UILabel *xc_nameLabel; //老师姓名
@property (nonatomic, strong) UIView *xc_lineView; //底部灰线

@end

@implementation GGT_ScheduleFinishedEvaluateHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
    //白色
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.xc_contentView];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(LineY(69));
        make.height.mas_equalTo(LineH(105));
    }];
    

    
    
    //老师头像
    self.xc_iconbgView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.xc_iconbgView];
    
    [self.xc_iconbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(LineY(14));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(114), LineW(114)));
    }];
    
    
    self.xc_iconImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = UIIMAGE_FROM_NAME(@"默认头像");
        imgView;
    });
    [self.xc_iconbgView addSubview:self.xc_iconImgView];

    [self.xc_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_iconbgView.mas_top).offset(LineY(7));
        make.left.equalTo(self.xc_iconbgView.mas_left).offset(LineX(7));
        make.size.mas_equalTo(CGSizeMake(LineW(100), LineW(100)));
    }];

    
    //老师姓名
    self.xc_nameLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
//        label.text = @"Teacher";
        label;
    });
    [self addSubview:self.xc_nameLabel];
    
    [self.xc_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_iconbgView.mas_bottom).offset(LineY(2));
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(LineH(25));
    }];
  
    
    // 底部灰线
    self.xc_lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        view;
    });
    [self addSubview:self.xc_lineView];
    
    [self.xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(LineX(margin40));
        make.right.equalTo(self.mas_right).offset(-LineX(margin40));
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(LineH(1));
    }];
}


- (void)getCellModel :(GGT_ScheduleDetailModel *)model {
    if (!IsStrEmpty(model.TeacherImg)) {
        //请求图片
        [self.xc_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.TeacherImg] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(100), LineW(100))];
            self.xc_iconImgView.image = image;
        }];
    } else {
        self.xc_iconImgView.image = UIIMAGE_FROM_NAME(@"默认头像");
    }
    
    
    if (!IsStrEmpty(model.TeacherName)) {
        self.xc_nameLabel.text = [NSString stringWithFormat:@"%@",model.TeacherName];
    }
}



- (void)drawRect:(CGRect)rect {
    [self.xc_contentView xc_SetCornerWithSideType:XCSideTypeTopLine cornerRadius:LineH(10)];
    [self.xc_iconbgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineW(57)];
    [self.xc_iconImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineW(50)];
}

@end
