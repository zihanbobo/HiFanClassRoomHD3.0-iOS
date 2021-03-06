//
//  HF_PlaceHolderView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/19.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_ResultModel.h"

@interface HF_PlaceHolderView : UIView
@property (nonatomic, strong) UIImageView *xc_imgView;
@property (nonatomic, strong) UILabel *xc_label;

@property (nonatomic, strong) HF_ResultModel *xc_model;

- (instancetype)initWithFrame:(CGRect)frame withImgYHeight:(CGFloat)YHeight;

@end
