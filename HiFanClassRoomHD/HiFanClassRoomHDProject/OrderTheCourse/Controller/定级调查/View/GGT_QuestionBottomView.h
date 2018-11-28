//
//  GGT_QuestionBottomView.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/11/29.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getNameFieldDelegate <NSObject>
-(void)getNameField:(NSString *)nameStr;
@end


@interface GGT_QuestionBottomView : UIView <UITextFieldDelegate>

/// 英文名
@property (nonatomic, strong) UITextField *xc_nameTextField;
/// 右侧父view
@property (nonatomic, strong) UIView *xc_rightTFParentView;
/// 生日
@property (nonatomic, strong) UILabel *xc_birthdayLabel;
/// 男孩
@property (nonatomic, strong) UIButton *xc_manButton;
/// 女孩
@property (nonatomic, strong) UIButton *xc_womanButton;
/// 提交按钮
@property (nonatomic, strong) UIButton *xc_commitButton;



@property (nonatomic,strong) id <getNameFieldDelegate>delegate;
@end
