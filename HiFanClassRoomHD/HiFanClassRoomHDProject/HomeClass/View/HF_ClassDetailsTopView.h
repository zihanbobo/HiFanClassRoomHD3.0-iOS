//
//  HF_ClassDetailsTopView.h
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/19.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeClassDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HF_ClassDetailsTopView : UIView
//关闭按钮
@property(nonatomic, strong) UIButton *closeButton;
//课程图片
@property(nonatomic, strong) UIImageView *classImageView;
//课程名称
@property(nonatomic, strong) UILabel *classTitleLabel;
//课程级别
@property(nonatomic, strong) UILabel *levelLabel;
//关于本课按钮
@property(nonatomic, strong) UIButton *aboutButton;
//预习按钮
@property(nonatomic, strong) UIButton *previewButton;
//练习按钮
@property(nonatomic, strong) UIButton *practiceButton;
//按钮下划线
@property(nonatomic, strong) UIView *buttonLine;
@property(nonatomic, strong) HF_HomeClassDetailModel *headerModel;


@end

NS_ASSUME_NONNULL_END
