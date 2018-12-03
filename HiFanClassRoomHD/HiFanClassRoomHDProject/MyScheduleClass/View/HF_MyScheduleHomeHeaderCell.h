//
//  HF_MyScheduleHomeHeaderCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/3.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UnFinishedBlock)(void);
typedef void(^FinishedBlock)(void);
@interface HF_MyScheduleHomeHeaderCell : UICollectionViewCell
@property (nonatomic,copy) UnFinishedBlock unFinishedBlock;
@property (nonatomic,copy) FinishedBlock finishedBlock;

@end
