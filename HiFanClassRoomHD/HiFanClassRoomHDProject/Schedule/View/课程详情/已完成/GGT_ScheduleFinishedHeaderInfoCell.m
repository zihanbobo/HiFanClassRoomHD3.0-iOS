//
//  GGT_ScheduleFinishedHeaderInfoCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ScheduleFinishedHeaderInfoCell.h"

@interface GGT_ScheduleFinishedHeaderInfoCell()
@property (nonatomic, strong) UIView *trophyView; //奖杯view
@property (nonatomic, strong) UILabel *trophyNumLabel; //奖杯🏆数量
@end

@implementation GGT_ScheduleFinishedHeaderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        [self initUI];
    }
    return self;
}


// 创建UI
- (void)initUI {

    // 父view
    self.classBgView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.classBgView];
    
    [self.classBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
    
    

    // 图像
    self.classImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.image = UIIMAGE_FROM_NAME(@"默认");
        imgView;
    });
    [self.classBgView addSubview:self.classImgView];
    
    [self.classImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView).offset(LineY(14));
        make.left.equalTo(self.classBgView).offset(LineX(14));
        make.bottom.equalTo(self.classBgView).offset(-LineY(14));
        make.width.mas_equalTo(LineW(203));
    }];
    
    
    
    //奖杯🏆
    self.trophyView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, LineW(60), LineH(26));
        view.backgroundColor = UICOLOR_FROM_HEX_ALPHA(ColorFFFFFF, 60);;
        view;
    });
    [self.classImgView addSubview:self.trophyView];
    
    [self.trophyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classImgView).offset(LineY(margin10));
        make.left.equalTo(self.classImgView).offset(LineX(margin10));
        make.size.mas_offset(CGSizeMake(LineW(60), LineH(26)));
    }];
    
    
    
    UIImageView *trophyImgView = [UIImageView new];
    trophyImgView.image = UIIMAGE_FROM_NAME(@"奖杯");
    [self.trophyView addSubview:trophyImgView];
    
    [trophyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trophyView).offset(LineY(4));
        make.left.equalTo(self.trophyView).offset(LineX(7));
        make.size.mas_offset(CGSizeMake(LineW(17), LineH(18)));
    }];
    
    
    //奖杯个数
    self.trophyNumLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(0xFFC800);
//        label.text = @"x6";
        label;
    });
    [self.trophyView addSubview:self.trophyNumLabel];
    
    [self.trophyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trophyView.mas_top).offset(LineY(2));
        make.left.equalTo(trophyImgView.mas_right).offset(LineX(4));
        make.height.mas_equalTo(LineH(22));
    }];
    

    // 上课时间
    self.classStartTimeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
//        label.text = @"今日（周一） 12:00";
        label;
    });
    [self.classBgView addSubview:self.classStartTimeLabel];
    
    [self.classStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(16));
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(margin20));
        make.height.mas_equalTo(LineH(25));
    }];
    
    
    // 课程级别
    self.classLevelLabel = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, LineW(42), LineH(24));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(kThemeColor);
        label.backgroundColor = UICOLOR_FROM_HEX_ALPHA(kThemeColor, 10);
//        label.text = @"A2";
        label;
    });
    [self.classBgView addSubview:self.classLevelLabel];
    
    [self.classLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classStartTimeLabel.mas_bottom).offset(LineY(margin15));
        make.left.equalTo(self.classStartTimeLabel.mas_left);
        make.width.equalTo(@(self.classLevelLabel.width));
        make.height.equalTo(@(self.classLevelLabel.height));
    }];
    
    
    // 课程标题
    self.classNameLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;
//        label.text = @"Lesson1-1";
        label;
    });
    [self.classBgView addSubview:self.classNameLabel];
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classStartTimeLabel.mas_bottom).offset(LineY(14));
        make.left.equalTo(self.classLevelLabel.mas_right).offset(LineX(12));
        make.height.mas_equalTo(LineH(25));
    }];
    
    
   
    
    //评价状态
    self.xc_evaluateStatusButton = ({
        UIButton *button = [UIButton new];
        button.titleLabel.font = Font(16);
        button;
    });
    [self.classBgView addSubview:self.xc_evaluateStatusButton];
    
    [self.xc_evaluateStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(margin20));
        make.right.equalTo(self.classBgView.mas_right).offset(-LineX(18));
        make.height.mas_equalTo(LineH(22));
    }];
    
    

    
    //课后练习
    self.classAfterButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(108), LineH(36));
        xc_button.titleLabel.font = Font(16);
        xc_button;
    });
    [self.classBgView addSubview:self.classAfterButton];
    
    [self.classAfterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(35));
        make.size.mas_equalTo(CGSizeMake(LineW(108), LineH(36)));
    }];
    
    //课前预习
    self.classBeforeButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(108), LineH(36));
        xc_button.titleLabel.font = Font(16);
        xc_button;
    });
    [self.classBgView addSubview:self.classBeforeButton];
    
    [self.classBeforeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.classAfterButton.mas_left).offset(-LineW(margin10));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineH(35));
        make.size.mas_equalTo(CGSizeMake(LineW(108), LineH(36)));
    }];
    

    //课程介绍
    self.classInfoLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;
//        label.text = @"to introduce vocabulary about foodschocolate, coo pizza, sandwich, hamburger, French frieamburger, French fries";
        label;
    });
    [self.classBgView addSubview:self.classInfoLabel];
    
    [self.classInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classNameLabel.mas_bottom).offset(LineY(12));
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(12.7));
        make.right.equalTo(self.classBeforeButton.mas_left).offset(-LineW(margin10));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(13));
    }];
}


- (void)drawRect:(CGRect)rect {
    [self.classBgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
    [self.classImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(6)];
    [self.trophyView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(13)];
    [self.trophyView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(0xFFC800) CornerRadius:LineH(13)];
    [self.classLevelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(12)];
    [self.classLevelLabel addBorderForViewWithBorderWidth:0.5f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:LineH(12)];
}

- (void)getCellModel :(GGT_ScheduleDetailModel *)model {
    if (!IsStrEmpty(model.FilePath)) {
        //请求图片
        [self.classImgView sd_setImageWithURL:[NSURL URLWithString:model.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(203), LineW(152))];
            self.classImgView.image = image;
        }];
        
        
        
//        [self.classImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.FilePath]] placeholderImage:UIIMAGE_FROM_NAME(@"默认")];

    }
    
    
    //奖杯数量
    self.trophyNumLabel.text = [NSString stringWithFormat:@"x%ld",(long)model.GiftCount];
    
    
    //开课时间
    if (!IsStrEmpty(model.StartTime)) {
        self.classStartTimeLabel.text = model.StartTimePad;
    }
    
    
    
    //级别
    if (!IsStrEmpty(model.LevelName)) {
        self.classLevelLabel.text = [NSString stringWithFormat:@"%@",model.LevelName];
    }
    
    //课程名称     //课程类型 ClassType 0和2正课 1:体验课
    switch (model.ClassType) {
        case 0:
            if (!IsStrEmpty(model.FileTittle)) {
                NSRange range;
                range = [model.FileTittle rangeOfString:@" "];
                if (range.location != NSNotFound) {
                    NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                    self.classNameLabel.text = titleStr;
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                    
                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                }
            }
            break;
        case 1:
            self.classNameLabel.text = @"[体验课]";
            self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
            break;
        case 2:
            if (!IsStrEmpty(model.FileTittle)) {
                NSRange range;
                range = [model.FileTittle rangeOfString:@" "];
                if (range.location != NSNotFound) {
                    NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
                    self.classNameLabel.text = titleStr;
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                    
                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                    self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
                }
            }
            break;
        default:
            break;
    }
    
    
    //课程介绍
    if (!IsStrEmpty(model.Describe)) {
        self.classInfoLabel.text = model.Describe;
    }
    
    
    //课前预习
    [self classBeforeButtonUI];
    
    
    //课后练习
    [self classAfterButtonUI];
    
    
    //IsComment  1 已评价  0：待评价
    if (model.IsComment == 0) {
        [self.xc_evaluateStatusButton setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:(UIControlStateNormal)];
        [self.xc_evaluateStatusButton setTitle:@"待评价" forState:(UIControlStateNormal)];
    } else {
        [self.xc_evaluateStatusButton setTitleColor:UICOLOR_FROM_HEX(Color4A4A4A) forState:(UIControlStateNormal)];
        [self.xc_evaluateStatusButton setTitle:@"已评价" forState:(UIControlStateNormal)];
    }
}

@end
