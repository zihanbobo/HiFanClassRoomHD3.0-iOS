//
//  HF_FindMoreHomeCycleCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdCycleScrollView.h"
#import "HF_FindMoreAdvertModel.h"

typedef void(^FavoriteBtnBlock)(void);
typedef void(^AdCycleClickBlock)(NSInteger index);
@interface HF_FindMoreHomeCycleCell : UIView <AdCycleScrollViewDelegate>
@property (nonatomic, strong) AdCycleScrollView *adScroll;
@property (nonatomic, copy) FavoriteBtnBlock favoriteBtnBlock;
@property (nonatomic, copy) AdCycleClickBlock adCycleClickBlock;

@end
