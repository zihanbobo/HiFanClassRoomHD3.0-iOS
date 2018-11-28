//
//  HF_HomeLeftView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCButtonClickBlock)(UIButton *button);
@interface HF_HomeLeftView : UIView
@property (nonatomic, copy) XCButtonClickBlock buttonClickBlock;
//课表和我的view
@property (nonatomic,strong) UIView *optionsView;

@property (nonatomic,strong) UIButton *peopleIconButton;

@end
