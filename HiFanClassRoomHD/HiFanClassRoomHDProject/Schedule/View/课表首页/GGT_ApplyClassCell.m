//
//  GGT_ApplyClassCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/8.
//  Copyright © 2018年 Chn. All rights reserved.
//

#import "GGT_ApplyClassCell.h"

@interface GGT_ApplyClassCell()
@property (nonatomic, strong) UIView *xc_contentView; //背景
@property (nonatomic, strong) UIImageView *xc_iconImgView; //教材图片
@property (nonatomic, strong) UILabel *xc_timeLabel; //开课时间
@property (nonatomic, strong) UILabel *xc_levelLabel; //等级
@property (nonatomic, strong) UILabel *xc_classTypeLabel; //课程类型 正课 体验课
@property (nonatomic, strong) UILabel *xc_classInfoLabel; //课程介绍
@property (nonatomic, strong) UILabel *alertLabel; //提醒文字

@end


@implementation GGT_ApplyClassCell
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
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.xc_contentView];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(LineY(18));
    }];
    
    
    // 图像
    self.xc_iconImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = UIIMAGE_FROM_NAME(@"默认");
        imgView;
    });
    [self.xc_contentView addSubview:self.xc_iconImgView];
    
    [self.xc_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_contentView).offset(LineY(14));
        make.left.equalTo(self.xc_contentView).offset(LineX(14));
        make.bottom.equalTo(self.xc_contentView).offset(-LineY(14));
        make.width.mas_equalTo(LineW(203));
    }];
    
    
    // 上课时间
    self.xc_timeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        //        label.text = @"今日（周一） 12:00";
        label;
    });
    [self.xc_contentView addSubview:self.xc_timeLabel];
    
    [self.xc_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_iconImgView.mas_top).offset(-LineY(2));
        make.left.equalTo(self.xc_iconImgView.mas_right).offset(LineX(margin20));
        make.height.mas_equalTo(LineH(25));
    }];
    
    
    
    // 取消申请
    self.cancleClassButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(108), LineH(36));
        xc_button.titleLabel.font = Font(16);
        [xc_button setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:UIControlStateNormal];
        [xc_button setTitle:@"取消申请" forState:UIControlStateNormal];
        [xc_button setTitle:@"取消申请" forState:UIControlStateHighlighted];
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn_copy") forState:UIControlStateNormal];
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn_copy") forState:UIControlStateHighlighted];
        xc_button;
    });
    [self.xc_contentView addSubview:self.cancleClassButton];
    
    [self.cancleClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_contentView.mas_top).offset(LineY(14));
        make.right.equalTo(self.xc_contentView.mas_right).offset(-LineW(18));
        make.size.mas_equalTo(CGSizeMake(LineW(108), LineH(36)));
    }];
    
    // 课程级别
    self.xc_levelLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(42), LineH(24));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(kThemeColor);
        label.backgroundColor = UICOLOR_FROM_HEX_ALPHA(kThemeColor, 10);
        //        label.text = @"A2";
        label;
    });
    [self.xc_contentView addSubview:self.xc_levelLabel];
    
    [self.xc_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_timeLabel.mas_bottom).offset(LineY(16));
        make.left.equalTo(self.xc_timeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(LineW(42), LineH(24)));
    }];
    
    //课程类型
    self.xc_classTypeLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(70), LineH(25));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(18);
        //label.text = @"[体验课]";
        label;
    });
    [self.xc_contentView addSubview:self.xc_classTypeLabel];
    
    [self.xc_classTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_levelLabel);
        make.left.equalTo(self.xc_levelLabel.mas_right).offset(LineX(12));
        make.height.mas_equalTo(LineH(25));
    }];
    
    

    //邀请好友
    self.yaoqingButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(114), LineH(38));
        xc_button.titleLabel.font = Font(16);
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn") forState:UIControlStateNormal];
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn") forState:UIControlStateHighlighted];
        [xc_button setTitle:@"邀请好友" forState:UIControlStateNormal];
        [xc_button setTitle:@"邀请好友" forState:UIControlStateHighlighted];
        xc_button;
    });
    [self.xc_contentView addSubview:self.yaoqingButton];

    [self.yaoqingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_contentView.mas_right).offset(-LineX(18));
        make.bottom.equalTo(self.xc_contentView.mas_bottom).offset(-LineH(35));
        make.size.mas_equalTo(CGSizeMake(LineW(114), LineH(38)));
    }];

    

    //提醒文字
    self.alertLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(14);
        label.textColor = UICOLOR_FROM_HEX(ColorFF6600);
//        label.text = @"已申请 02月10日 (周六) 08:00 的课程，还差2人即可成班";
        label;
    });
    [self.xc_contentView addSubview:self.alertLabel];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_iconImgView.mas_right).offset(LineX(12.7));
        make.right.equalTo(self.yaoqingButton.mas_left).offset(-LineW(28));
        make.bottom.equalTo(self.xc_contentView.mas_bottom).offset(-LineY(13));
        make.height.mas_equalTo(LineH(14));
    }];
    
    
    //课程介绍
    self.xc_classInfoLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(70), LineH(25));
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;
        //         label.text = @"to introduce vocabulary about foodschocolate, coo pizza, sandwich, hamburger, French frieamburger, French fries";
        label;
    });
    [self.xc_contentView addSubview:self.xc_classInfoLabel];
    
    [self.xc_classInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_levelLabel.mas_bottom).offset(LineY(12));
        make.left.equalTo(self.xc_iconImgView.mas_right).offset(LineX(12.7));
        make.right.equalTo(self.yaoqingButton.mas_left).offset(-LineW(28));
        make.bottom.equalTo(self.alertLabel.mas_top).offset(-LineY(13));
    }];
}


- (void)getModel:(GGT_ApplyClassModel *)model {
    if (!IsStrEmpty(model.FilePath)) {
        [self.xc_iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.FilePath]] placeholderImage:UIIMAGE_FROM_NAME(@"默认")];
    }

    
    //开课时间
    if (!IsStrEmpty(model.StartTime)) {
        self.xc_timeLabel.text = model.StartTimePad;
    }
    
    //级别
    if (!IsStrEmpty(model.LevelName)) {
        self.xc_levelLabel.text = [NSString stringWithFormat:@"%@",model.LevelName];
    }
    
    //课程名称     //课程类型 ClassType 0和2正课 1:体验课
    switch (model.ClassType) {
        case 0:
            if (!IsStrEmpty(model.FileTittle)) {
                NSRange range;
                range = [model.FileTittle rangeOfString:@" "];
                if (range.location != NSNotFound) {
                    NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                    self.xc_classTypeLabel.text = titleStr;
                    self.xc_classTypeLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                    
                }else{
                    //Not Found
                    self.xc_classTypeLabel.text = model.FileTittle;
                    self.xc_classTypeLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                }
            }
            break;
        case 1:
            self.xc_classTypeLabel.text = @"[体验课]";
            self.xc_classTypeLabel.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
            break;
        case 2:
            if (!IsStrEmpty(model.FileTittle)) {
                NSRange range;
                range = [model.FileTittle rangeOfString:@" "];
                if (range.location != NSNotFound) {
                    NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                    self.xc_classTypeLabel.text = titleStr;
                    self.xc_classTypeLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                    
                }else{
                    //Not Found
                    self.xc_classTypeLabel.text = model.FileTittle;
                    self.xc_classTypeLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                }
            }
            break;
        default:
            break;
    }
    
    
    //课程介绍
    if (!IsStrEmpty(model.Describe)) {
        self.xc_classInfoLabel.text = model.Describe;
    }
    
    
    //提醒文字
    if (!IsStrEmpty(model.StartTimePad)) {
        self.alertLabel.text = [NSString stringWithFormat:@"已申请 %@ 的课程，还差%ld人即可开班",model.StartTimePad,(long)model.ResidueNum];
    }
}


- (void)drawRect:(CGRect)rect {
    [self.xc_contentView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
    [self.xc_iconImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(6)];
    [self.cancleClassButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(18)];
    [self.yaoqingButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(18)];

    
    [self.xc_levelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(12)];
    [self.xc_levelLabel addBorderForViewWithBorderWidth:0.5f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:LineH(12)];
}

@end
