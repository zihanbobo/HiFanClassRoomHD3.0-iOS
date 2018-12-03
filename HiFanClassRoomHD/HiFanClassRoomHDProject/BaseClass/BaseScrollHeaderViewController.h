//
//  BaseScrollHeaderViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/30.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollHeaderViewController : UIViewController
@property (nonatomic, strong) UIView *navView;        //导航View
@property (nonatomic, strong) UIImageView *navImgView;//导航背景图片
@property (nonatomic, strong) UILabel *titleLabel;    //导航文字
@property (nonatomic, strong) UIButton *rightButton;  //导航按钮
@end
