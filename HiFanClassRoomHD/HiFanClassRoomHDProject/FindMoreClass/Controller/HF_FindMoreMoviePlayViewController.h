//
//  HF_FindMoreMoviePlayViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseViewController.h"
#import "HF_FindMoreInstructionalListModel.h"

@interface HF_FindMoreMoviePlayViewController : BaseViewController
@property (nonatomic,strong) HF_FindMoreInstructionalListModel *model;
@property (nonatomic,assign) NSInteger ResourcesID;
@property (nonatomic,copy) NSString *playerUrlStr;
@property (nonatomic,assign) BOOL isLikeVc;

@end

