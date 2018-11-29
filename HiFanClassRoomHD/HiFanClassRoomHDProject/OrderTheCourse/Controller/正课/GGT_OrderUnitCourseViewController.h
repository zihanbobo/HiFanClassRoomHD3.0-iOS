//
//  GGT_OrderUnitCourseViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseViewController.h"
#import "GGT_UnitBookListModel.h"


typedef void(^RefreshCell)(BOOL fresh);
@interface GGT_OrderUnitCourseViewController : BaseViewController
@property (nonatomic, strong) GGT_UnitBookListModel *unitBookListModel;

@property (nonatomic, copy) RefreshCell refreshCell;
@end
