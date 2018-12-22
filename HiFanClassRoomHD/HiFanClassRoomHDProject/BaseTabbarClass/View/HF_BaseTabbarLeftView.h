//
//  HF_BaseTabbarLeftView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCButtonClickBlock)(UIButton *button);
@interface HF_BaseTabbarLeftView : UIView
@property (nonatomic, copy) XCButtonClickBlock buttonClickBlock;
@property (nonatomic, strong) UIImageView *sanjiaoImgView;
@property (nonatomic,strong) UILabel *levelLabel;

@end
