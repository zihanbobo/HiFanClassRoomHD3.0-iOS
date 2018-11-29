//
//  HF_LoadingView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/8/18.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoadingFailedBlock) (UIButton *button);

@interface HF_LoadingView : UIView

@property (nonatomic, copy) LoadingFailedBlock loadingFailedBlock;

- (void)hideLoadingView;


@end
