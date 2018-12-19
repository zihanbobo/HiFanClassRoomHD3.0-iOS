//
//  HF_FindMoreInstructionalListViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseViewController.h"
#import "HF_FindMoreInstructionalTypeListModel.h"

@interface HF_FindMoreInstructionalListViewController : BaseViewController
@property (nonatomic,strong) HF_FindMoreInstructionalTypeListModel *listModel;
@property (nonatomic,assign) BOOL isLikeVc;

@end
