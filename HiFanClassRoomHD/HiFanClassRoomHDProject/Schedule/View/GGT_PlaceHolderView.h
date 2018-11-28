//
//  GGT_PlaceHolderView.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_PlaceHolderView : UIView
@property (nonatomic, strong) UIImageView *xc_imgView;
@property (nonatomic, strong) UILabel *xc_label;

@property (nonatomic, strong) GGT_ResultModel *xc_model;

- (instancetype)initWithFrame:(CGRect)frame withImgYHeight:(CGFloat)YHeight;

@end
