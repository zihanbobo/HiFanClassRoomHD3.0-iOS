//
//  HF_PreviewView.h
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^ClassBeforeBtnBlock)(void);
@interface HF_PreviewView : UIView
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) NSString *imagePath;
@property(nonatomic, strong) UIButton *previewButton;
@property(nonatomic, copy) ClassBeforeBtnBlock classBeforeBtnBlock;

@end

NS_ASSUME_NONNULL_END
