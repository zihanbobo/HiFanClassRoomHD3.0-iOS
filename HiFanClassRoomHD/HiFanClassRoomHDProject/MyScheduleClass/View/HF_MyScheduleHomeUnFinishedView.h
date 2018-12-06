//
//  HF_MyScheduleHomeUnFinishedView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_MyScheduleHomeUnFinishedCell.h"

@interface HF_MyScheduleHomeUnFinishedView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end
