//
//  GGT_ScheduleFinishedStuEvaluateCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/18.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleFinishedStuEvaluateCell.h"

@interface GGT_ScheduleFinishedStuEvaluateCell()
@property (nonatomic, strong) UIView *trophyView; //奖杯view
@property (nonatomic, strong) UIView *xc_lineView; //底部灰线
@property (nonatomic, strong) UIImageView *xc_iconImgView; //学生图片
@property (nonatomic, strong) UILabel *xc_nameLabel; //学生姓名
@property (nonatomic, strong) UILabel *trophyNumLabel; //奖杯🏆数量
@property (nonatomic, strong) UILabel *xc_teacherInfoLabel; //对老师的评价
@property (nonatomic, strong) UILabel *xc_evaluateTimeLabel; //时间
@end

@implementation GGT_ScheduleFinishedStuEvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self buildUI];
    }
    return self;
}

// 创建UI
- (void)buildUI {
    //学生头像
    self.xc_iconImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(0, 0, LineH(100), LineH(100));
        imgView.image = UIIMAGE_FROM_NAME(@"headPortrait_default_avatar");
        imgView;
    });
    [self addSubview:self.xc_iconImgView];
    
    [self.xc_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(LineX(margin40));
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(LineH(100), LineH(100)));
    }];
    
    
    //学生姓名
    self.xc_nameLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
//        label.text = @"Winner";
        label;
    });
    [self addSubview:self.xc_nameLabel];

    [self.xc_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(LineY(26));
        make.left.equalTo(self.xc_iconImgView.mas_right).offset(LineX(margin30));
        make.height.mas_equalTo(LineH(25));
    }];


    //奖杯🏆
    self.trophyView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, LineW(60), LineH(26));
        view.backgroundColor = UICOLOR_FROM_HEX_ALPHA(ColorFFFFFF, 0.6);;
        view;
    });
    [self addSubview:self.trophyView];

    [self.trophyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(LineY(25));
        make.left.equalTo(self.xc_nameLabel.mas_right).offset(LineX(12));
        make.size.mas_offset(CGSizeMake(LineW(60), LineH(26)));
    }];



    UIImageView *trophyImgView = [UIImageView new];
    trophyImgView.image = UIIMAGE_FROM_NAME(@"奖杯");
    [self.trophyView addSubview:trophyImgView];

    [trophyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trophyView.mas_top).offset(LineY(4));
        make.left.equalTo(self.trophyView.mas_left).offset(LineX(7));
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


    

    //评价view
    self.starRatingView = [[ASStarRatingView alloc]init];
//    self.starRatingView.frame = CGRectMake(0, 0, LineW(134), LineH(18));
    self.starRatingView.starWidth = LineW(18);
    self.starRatingView.canEdit = NO;
    [self addSubview:self.starRatingView];
    
    
    [self.starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-LineX(margin40));
        make.top.equalTo(self.mas_top).offset(LineY(margin30));
        make.size.mas_equalTo(CGSizeMake(LineW(134), LineH(18)));
    }];
    
    
    
    //对老师的评价
    self.xc_teacherInfoLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
//        label.text = @"特别喜欢这个老师！";
        label.numberOfLines = 0;
        label;
    });
    [self addSubview:self.xc_teacherInfoLabel];
    
    [self.xc_teacherInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_nameLabel.mas_bottom).offset(LineY(margin10));
        make.left.equalTo(self.xc_iconImgView.mas_right).offset(LineX(margin30));
        make.right.equalTo(self.starRatingView.mas_left).offset(-LineX(margin40));
    }];


    //时间
    self.xc_evaluateTimeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(Color9B9B9B);
//        label.text = @"2017-06-15 12:00";
        label;
    });
    [self addSubview:self.xc_evaluateTimeLabel];

    [self.xc_evaluateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starRatingView.mas_bottom).offset(LineY(14));
        make.right.equalTo(self.mas_right).offset(-LineX(margin40));
        make.height.mas_equalTo(LineH(22));
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
        make.top.equalTo(self.mas_bottom).offset(-LineY(1));
        make.height.mas_equalTo(LineH(1));
    }];
    
}


- (void)drawRect:(CGRect)rect {
    [self.xc_iconImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(50)];
    [self.trophyView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(13)];
    [self.trophyView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(0xFFC800) CornerRadius:LineH(13)];
}


- (void)getCellModel :(GGT_ScheduleFinishedDetailStuEvaluateModel *)model {
    //如果model为空，代表没有学生预约，需要显示默认头像
    if ((model== nil) || ([model isEqual:[NSNull null]])) {
        self.xc_iconImgView.image = UIIMAGE_FROM_NAME(@"headPortrait_default_avatar");
        return;
    }
    
    
    //Gender 0女 girl  1男 boy
    if (model.Sex == 0) {
        if (IsStrEmpty(model.HeadImg)) {
            self.xc_iconImgView.image = UIIMAGE_FROM_NAME(@"girl");
        } else {
            [self.xc_iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.HeadImg]] placeholderImage:UIIMAGE_FROM_NAME(@"girl")];
        }
    } else {
        if (IsStrEmpty(model.HeadImg)) {
            self.xc_iconImgView.image = UIIMAGE_FROM_NAME(@"boy");
        } else {
            [self.xc_iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.HeadImg]] placeholderImage:UIIMAGE_FROM_NAME(@"boy")];
        }
    }
    
    
    //姓名
    if (!IsStrEmpty(model.EnglistName)) {
        self.xc_nameLabel.text = model.EnglistName;
    }
    
    
    //奖杯
    self.trophyNumLabel.text = [NSString stringWithFormat:@"x%ld",(long)model.GiftCount];
    
    
    //评价
    if (!IsStrEmpty(model.EvaluateContent)) {
        self.xc_teacherInfoLabel.text = [NSString stringWithFormat:@"%@",model.EvaluateContent];
    } else {
        self.xc_teacherInfoLabel.text = @"这个学员很懒，没课后评价。";
    }

    
    //星星
    self.starRatingView.rating = model.Points;
    
    
    //时间
    if (!IsStrEmpty(model.EvaluateTime)) {
        self.xc_evaluateTimeLabel.text = model.EvaluateTime;
    }
    
}


@end
