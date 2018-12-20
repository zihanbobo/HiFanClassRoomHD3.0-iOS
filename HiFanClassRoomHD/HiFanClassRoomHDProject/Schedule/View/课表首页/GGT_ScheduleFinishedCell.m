//
//  GGT_ScheduleFinishedCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/14.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleFinishedCell.h"
#import "GGT_ScheduleStudentIconView.h"

@interface GGT_ScheduleFinishedCell()
@property (nonatomic, strong) UIView *trophyView; //奖杯view
@property (nonatomic, strong) UILabel *trophyNumLabel; //奖杯🏆数量
@property (nonatomic, strong) GGT_ScheduleStudentIconView *iconView; //头像
@end

@implementation GGT_ScheduleFinishedCell

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
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(LineY(18));
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
        view.frame = CGRectMake(0, 0, LineX(60), LineY(26));
        view.backgroundColor = UICOLOR_FROM_HEX_ALPHA(ColorFFFFFF, 60);;
        view;
    });
    [self.classImgView addSubview:self.trophyView];
    
    [self.trophyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classImgView).offset(margin10);
        make.left.equalTo(self.classImgView).offset(margin10);
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
    
    
    //奖杯🏆数量
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
        make.top.equalTo(self.classImgView.mas_top).offset(-LineY(2));
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
        make.top.equalTo(self.classStartTimeLabel.mas_bottom).offset(LineY(16));
        make.left.equalTo(self.classStartTimeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(LineW(42), LineH(24)));
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
    self.evaluateStatusButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(108), LineH(36));
        xc_button.titleLabel.font = Font(16);
        xc_button;
    });
    [self.classBgView addSubview:self.evaluateStatusButton];
    
    [self.evaluateStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(margin20));
        make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
        make.height.mas_equalTo(LineH(36));
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
    
    
    
    //头像View
    self.iconView = [GGT_ScheduleStudentIconView new];
    self.iconView.backgroundColor = UICOLOR_RANDOM_COLOR();
    self.iconView.viewHeight = LineH(56);
    [self addSubview:self.iconView];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(13));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(26));
        make.size.mas_equalTo(CGSizeMake(LineW(386), LineH(56)));

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



- (void)getCellModel:(GGT_ScheduleFinishedHomeModel *)model {
    if (!IsStrEmpty(model.FilePath)) {
        [self.classImgView sd_setImageWithURL:[NSURL URLWithString:model.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(203), LineW(152))];
            self.classImgView.image = image;
        }];
    }
    
    //奖杯数量
    self.trophyNumLabel.text = [NSString stringWithFormat:@"x%ld",(long)model.GiftCount];
    
    //时间
    if (!IsStrEmpty(model.StartTime)) {
        self.classStartTimeLabel.text = model.StartTimePad;
    }
    
    //等级
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
                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                }
                self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);

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

                }else{
                    //Not Found
                    self.classNameLabel.text = model.FileTittle;
                }
                self.classNameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);

            }
            break;
        default:
            break;
    }
    
    
    
    //评价状态   IsComment  1 已评价  0 未评价
    switch (model.IsComment) {
        case 0:
            [self.evaluateStatusButton setTitle:@"待评价" forState:UIControlStateNormal];
            [self.evaluateStatusButton setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:UIControlStateNormal];
            break;
        case 1:
            [self.evaluateStatusButton setTitle:@"已评价" forState:UIControlStateNormal];
            [self.evaluateStatusButton setTitleColor:UICOLOR_FROM_HEX(Color4A4A4A) forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
    //课前预习
    [self classBeforeButtonUI];
    
    
    //课后练习
    [self classAfterButtonUI];

    
    //给头像传值
    if ([model.StudentList isKindOfClass:[NSArray class]] && model.StudentList.count >0 ) {
        [self.iconView getCellArr:model.StudentList];
    }
    
}
@end
