//
//  GGT_OrderUnitCourseInfoCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/27.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderUnitCourseInfoCell.h"

@interface GGT_OrderUnitCourseInfoCell()
//@property (nonatomic, strong) UILabel *enterAlertLabel; //加入课程提醒
@end


@implementation GGT_OrderUnitCourseInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        [self initUIView];
    }
    return self;
}

// 创建UI
- (void)initUIView {
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
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(14));
        make.left.equalTo(self.classBgView.mas_left).offset(LineX(14));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(14));
        make.width.mas_equalTo(LineW(203));
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
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(15));
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(13));
        make.size.mas_equalTo(CGSizeMake(LineW(42), LineH(24)));
    }];
    
    
    
    //课程名称
    self.classNameLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        //label.text = @"Lesson1-1";
        label;
    });
    [self.classBgView addSubview:self.classNameLabel];
    
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classLevelLabel.mas_centerY);
        make.left.equalTo(self.classLevelLabel.mas_right).offset(LineX(12));
        make.height.mas_equalTo(LineH(25));
    }];

    
    //即将上课文字
    self.classStatusLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(ColorFF6600);
//        label.text = @"即将开课：09:12";
        label;
    });
    [self.classBgView addSubview:self.classStatusLabel];
    
    [self.classStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classBgView.mas_top).offset(LineY(21));
        make.right.equalTo(self.classBgView.mas_right).offset(-LineX(18));
        make.height.mas_equalTo(LineH(16));
    }];
    
    
    //即将上课图片
    self.classStatusView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeCenter;
//        imgView.image = UIIMAGE_FROM_NAME(@"正在上课1");
        imgView;
    });
    [self.classBgView addSubview:self.classStatusView];
    
    [self.classStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classStatusLabel.mas_bottom);
        make.right.equalTo(self.classStatusLabel.mas_left).offset(-LineX(8.2));
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    

    
   
    //进入教室
    self.classEnterButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(114), LineH(38));
        xc_button.titleLabel.font = Font(16);
        [xc_button setTitle:@"进入教室" forState:UIControlStateNormal];
        xc_button;
    });
    [self.classBgView addSubview:self.classEnterButton];
    
    [self.classEnterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(14));
        make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
        make.size.mas_equalTo(CGSizeMake(LineW(114), LineH(38)));
    }];
    
    
    // 邀请好友
//    self.yaoqingButton = ({
//        UIButton *xc_button = [UIButton new];
//        xc_button.frame = CGRectMake(0, 0, LineW(114), LineH(38));
//        xc_button.titleLabel.font = Font(16);
//        xc_button;
//    });
//    [self.classBgView addSubview:self.yaoqingButton];
//
//    [self.yaoqingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(14));
//        make.right.equalTo(self.classEnterButton.mas_left).offset(-LineW(20));
//        make.size.mas_equalTo(CGSizeMake(LineW(114), LineH(38)));
//    }];
    
    
    //加入课程的提醒
//    self.enterAlertLabel = ({
//        UILabel *label = [UILabel new];
//        label.font = Font(15);
//        label.textColor = UICOLOR_FROM_HEX(ColorFF6600);
//        //label.text = @"已加入 11月26日 (周六) 18：30 的课程";
//        label;
//    });
//    [self.classBgView addSubview:self.enterAlertLabel];
//
//    [self.enterAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.classImgView.mas_right).offset(LineX(12.7));
//        make.right.equalTo(self.yaoqingButton.mas_left).offset(-LineW(12));
//        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(23));
//        make.height.mas_equalTo(LineH(15));
//    }];
    
    
    //课程介绍
    self.classInfoLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;
//        label.text = @"to introduce vocabulary about foodschocolate, coo pizza, sandwich, hamburger, French frieamburger, French fries, to introduce vocabulary about foodschocolate, coo pizza, sandwich, hamburger, French frieamburger, French fries";
        label;
    });
    [self.classBgView addSubview:self.classInfoLabel];

    [self.classInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classLevelLabel.mas_bottom).offset(LineY(12));
        make.left.equalTo(self.classImgView.mas_right).offset(LineX(12.6));
        make.right.equalTo(self.classEnterButton.mas_left).offset(-LineW(12));
        make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(5));
    }];
}




- (void)getModel:(GGT_ClassBookDetailModel *)model {
    
    //教材图片
    if ([model.FilePath isKindOfClass:[NSString class]] && model.FilePath.length >0) {
        //请求图片
        [self.classImgView sd_setImageWithURL:[NSURL URLWithString:model.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(203), LineW(152))];
            self.classImgView.image = image;
        }];
    }
    
    //等级
    if (!IsStrEmpty(model.LevelName)) {
        self.classLevelLabel.text = [NSString stringWithFormat:@"%@",model.LevelName];
    }
    
    //课程名称
    if (!IsStrEmpty(model.FileTittle)) {
        //课程名称
        NSRange range;
        range = [model.FileTittle rangeOfString:@" "];
        if (range.location != NSNotFound) {
            NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
            self.classNameLabel.text = titleStr;
        }else{
            //Not Found
            self.classNameLabel.text = model.FileTittle;
        }
        
    }
    
   
    //课程介绍
    if (!IsStrEmpty(model.Describe)) {
        self.classInfoLabel.text = [NSString stringWithFormat:@"%@",model.Describe];
    }
    
    
//    model.OpenClassType = 2;
//    model.DemandId = 100;
//    model.StartTime = @"2018-02-05 16:10:00";
    switch (model.OpenClassType) {
        case 1://1 加入班级
        {
//            self.enterAlertLabel.hidden = NO;
//            self.enterAlertLabel.text = [NSString stringWithFormat:@"已加入%@的课程，记得按时上课",model.StartTimePad];
//            self.yaoqingButton.hidden = NO;
            self.classEnterButton.hidden = NO;
            
            //邀请好友
//            [self.yaoqingButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:(UIControlStateNormal)];
//            [self.yaoqingButton setTitle:@"邀请好友" forState:(UIControlStateNormal)];
//            [self.yaoqingButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
  
            
            //加入课程提醒  DemandId>0表示约课了
            if (model.DemandId >0) {
               
                [self showTimeLabel:model];
        
            } else {
//                self.enterAlertLabel.hidden = YES;
//                self.yaoqingButton.hidden = YES;

                //即将上课文字及图片
                self.classStatusLabel.hidden = YES;
                self.classStatusView.hidden = YES;
                self.classEnterButton.hidden = YES;
            }
        }
            break;
        case 2://2 申请开班
        {
           
            //即将上课文字及图片
            self.classStatusLabel.hidden = YES;
            self.classStatusView.hidden = YES;
            
//            self.enterAlertLabel.hidden = NO;
//            self.yaoqingButton.hidden = NO;
//             self.enterAlertLabel.text = [NSString stringWithFormat:@"已申请%@的课程，还差%ld人即可开班",model.StartTimePad,(long)model.ResidueNum];
            
            //邀请好友
//            [self.yaoqingButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:(UIControlStateNormal)];
//            [self.yaoqingButton setTitle:@"邀请好友" forState:(UIControlStateNormal)];
//            [self.yaoqingButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
//
//            [self.yaoqingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.classBgView.mas_bottom).offset(-LineY(14));
//                make.right.equalTo(self.classBgView.mas_right).offset(-LineW(18));
//                make.size.mas_equalTo(CGSizeMake(LineW(114), LineH(38)));
//            }];
            
        }
            break;
        default:
            break;
    }
}


//MARK:倒计时
-(void)showTimeLabel:(GGT_ClassBookDetailModel *)model {
    //对后台请求的数据进行处理，如果没有带秒。添加上
    if (model.StartTime.length == 16) {
        model.StartTime = [NSString stringWithFormat:@"%@:00",model.StartTime];
    }
    
    //如果是未开始状态，就进行时间判断。
    HF_Singleton *sin = [HF_Singleton sharedSingleton];
    //获取时间差
    NSTimeInterval timeCount = [sin pleaseInsertStarTime:sin.nowDateString andInsertEndTime:model.StartTime class:@"GGT_OrderUnitCourseInfoCell"];
    self.countDown = timeCount;
    
    if (self.countDown <=0) {
        self.classEnterButton.userInteractionEnabled = YES;
        
        //如果开课时间小于当前时间，都暂时设置为进入教室
        [self enterClassButton:YES];
        //即将上课文字及图片
        self.classStatusLabel.hidden = NO;
        self.classStatusView.hidden = NO;
        //        self.yaoqingButton.hidden = YES;
        
        self.classStatusView.image = UIIMAGE_FROM_NAME(@"正在上课1");
        self.classStatusLabel.text = @"正在上课";
        
        //是否隐藏取消课程按钮
        if ([self.degegate respondsToSelector:@selector(getClassStatus:)]) {
            [self.degegate getClassStatus:YES];
        }

        return;
    }
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (void)handleTimer {
    if (self.countDown <= 0) return;
    
    self.countDown --;
//    NSLog(@"倒计时：%ld   class:%@",(long)self.countDown,[self class]);
    
    if (self.countDown <=0) {
        self.classEnterButton.userInteractionEnabled = YES;
        
        //如果开课时间小于当前时间，都暂时设置为进入教室
        [self enterClassButton:YES];
        //即将上课文字及图片
        self.classStatusLabel.hidden = NO;
        self.classStatusView.hidden = NO;
        //        self.yaoqingButton.hidden = YES;
        
        self.classStatusView.image = UIIMAGE_FROM_NAME(@"正在上课1");
        self.classStatusLabel.text = @"正在上课";
        
        //是否隐藏取消课程按钮
        if ([self.degegate respondsToSelector:@selector(getClassStatus:)]) {
            [self.degegate getClassStatus:YES];
        }
        
        //销毁计时器
        self.countDown = 0;
        [self.timer invalidate];
        self.timer = nil;
        
        return;
    } else if (self.countDown <=600 && self.countDown >0) { //即将上课
        //进入教室
        self.classEnterButton.userInteractionEnabled = YES;
        [self enterClassButton:YES];
        //即将上课文字及图片
        self.classStatusLabel.hidden = NO;
        self.classStatusView.hidden = NO;
        //        self.yaoqingButton.hidden = YES;
        
        // 重新赋值
        self.classStatusView.image = UIIMAGE_FROM_NAME(@"沙漏");
        self.classStatusLabel.text = [NSString stringWithFormat:@"即将开课:%02zd:%02zd", (self.countDown/60)%60, self.countDown%60];
        
        //是否隐藏取消课程按钮
        if ([self.degegate respondsToSelector:@selector(getClassStatus:)]) {
            [self.degegate getClassStatus:YES];
        }
        
    } else if (self.countDown >0 && self.countDown > 600) { //未开始
        self.classEnterButton.userInteractionEnabled = NO;
        [self enterClassButton:NO];
        
        //即将上课文字及图片
        self.classStatusLabel.hidden = YES;
        self.classStatusView.hidden = YES;
        //        self.yaoqingButton.hidden = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    [self.classBgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(10)];
    [self.classImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(6)];
    [self.classEnterButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(19)];
//    [self.yaoqingButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(19)];

    [self.classLevelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(12)];
    [self.classLevelLabel addBorderForViewWithBorderWidth:0.5f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:LineH(12)];
}

@end
