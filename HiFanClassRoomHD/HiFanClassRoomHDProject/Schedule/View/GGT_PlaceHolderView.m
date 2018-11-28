//
//  GGT_PlaceHolderView.m
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PlaceHolderView.h"

@interface GGT_PlaceHolderView ()
@property CGFloat YHeight;
@end

@implementation GGT_PlaceHolderView


- (instancetype)initWithFrame:(CGRect)frame withImgYHeight:(CGFloat)YHeight {
    if (self = [super initWithFrame:frame]) {
        self.YHeight = YHeight;
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.xc_imgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(0, 0, 258, 190);
        imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");
        imgView.contentMode = UIViewContentModeCenter;
        imgView;
    });
    [self addSubview:self.xc_imgView];
    
    [self.xc_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(self.YHeight);
        make.size.mas_equalTo(CGSizeMake(258, 190));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.xc_label = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color777777);
        label.text = @" ";
        [label changeLineSpaceWithSpace:10.0];
        // 需要放到设置行间距的后面
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self addSubview:self.xc_label];
    
    [self.xc_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_imgView.mas_bottom).offset(margin30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

- (void)setXc_model:(GGT_ResultModel *)xc_model {
    _xc_model = xc_model;
    
    // 不明所以
    xc_model.msg = [xc_model.msg stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    //1：获取信息成功  2：目前只有我的课时使用（未购买过课程）
    if ([xc_model.result isEqualToString:@"1"]) {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");

    } else if ([xc_model.result isEqualToString:@"2"]) {
        self.xc_label.font = Font(16);
        
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            
            /*您还没有购买课时，如需购买请登录“hi翻外教课堂”官网：www.hi-fan.cn
            或联系客服：400-6767-671*/
            NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:xc_model.msg];
            
            if ([xc_model.msg containsString:@"www.hi-fan.cn"]) {
                NSRange range = [xc_model.msg rangeOfString:@"www.hi-fan.cn"];
                [mutableAttriStr addAttribute:NSForegroundColorAttributeName value:UICOLOR_FROM_HEX(kThemeColor) range:NSMakeRange(range.location,range.length)];
            }
            
            
            if ([xc_model.msg containsString:@"400-6767-671"]) {
                NSRange rang = [xc_model.msg rangeOfString:@"400-6767-671"];
                [mutableAttriStr addAttribute:NSForegroundColorAttributeName value:UICOLOR_FROM_HEX(kThemeColor) range:NSMakeRange(rang.location,rang.length)];
            }
            
            self.xc_label.attributedText = mutableAttriStr;

        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"Empty_state");

    } else {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");
    }
    
}


@end
