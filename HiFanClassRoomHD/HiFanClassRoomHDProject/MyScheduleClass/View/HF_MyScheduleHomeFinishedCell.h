//
//  HF_MyScheduleHomeFinishedCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_MyScheduleHomeFinishedListModel.h"

typedef void(^PracticeButtonBlock)(UIButton *button);
@interface HF_MyScheduleHomeFinishedCell : UICollectionViewCell
@property (nonatomic,strong) HF_MyScheduleHomeFinishedListModel *listModel;
@property (nonatomic,copy) PracticeButtonBlock practiceButtonBlock;
@end
