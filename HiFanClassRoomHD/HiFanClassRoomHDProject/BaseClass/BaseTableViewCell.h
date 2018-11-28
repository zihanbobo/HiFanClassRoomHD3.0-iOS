//
//  BaseTableViewCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/9/27.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

/**
 所上课程-背景
 */
@property (nonatomic,strong) UIView *classBgView;
/**
 所上课程-封面
 */
@property (nonatomic,strong) UIImageView *classImgView;
/**
 所上课程-上课时间
 */
@property (nonatomic,strong) UILabel *classStartTimeLabel;
/**
 所上课程-等级
 */
@property (nonatomic,strong) UILabel *classLevelLabel;
/**
 所上课程-教材名称
 */
@property (nonatomic,strong) UILabel *classNameLabel;
/**
 所上课程-课前预习
 */
@property (nonatomic,strong) UIButton *classBeforeButton;
/**
 所上课程-课后练习
 */
@property (nonatomic,strong) UIButton *classAfterButton;
/**
 所上课程-进入教室
 */
@property (nonatomic,strong) UIButton *classEnterButton;
/**
 所上课程-取消课程
 */
@property (nonatomic,strong) UIButton *classCancleButton;
/**
 所上课程-课程介绍
 */
@property (nonatomic,strong) UILabel *classInfoLabel;
/**
 所上课程-即将上课/正在上课 图片
 */
@property (nonatomic,strong) UIImageView *classStatusView;
/**
 所上课程-即将上课/正在上课 文字
 */
@property (nonatomic,strong) UILabel *classStatusLabel;


/**
 所上课程-课后练习按钮UI
 */
-(void)classAfterButtonUI;

/**
 所上课程-课前预习按钮UI
 */
-(void)classBeforeButtonUI;

/**
  所上课程-进入教室的按钮状态
 @param status YES:可以点击，进入教室  YES:置灰，无法点击进入教室
 */
- (void)enterClassButton:(BOOL)status;

@end
