//
//  HF_HomeUnitLastCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/21.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FirstBtnBlock)(void);
typedef void(^SecondBtnBlock)(void);
@interface HF_HomeUnitLastCell : UIView
@property (nonatomic,copy) NSString *unitNameString;
@property (nonatomic,copy) FirstBtnBlock firstBtnBlock;
@property (nonatomic,copy) SecondBtnBlock secondBtnBlock;
@end


@interface HF_HomeUnitLastView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *unitLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@end
