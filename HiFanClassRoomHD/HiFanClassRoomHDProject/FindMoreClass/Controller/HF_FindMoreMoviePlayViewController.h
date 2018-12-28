//
//  HF_FindMoreMoviePlayViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseViewController.h"
#import "HF_FindMoreInstructionalListModel.h"

typedef void(^RefreshLikeVc)(void);
@interface HF_FindMoreMoviePlayViewController : BaseViewController
@property (nonatomic,strong) HF_FindMoreInstructionalListModel *cellModel;
@property (nonatomic,assign) BOOL isLikeVc;
@property (nonatomic,assign) NSInteger shouyeResourcesID;
@property (nonatomic,copy) RefreshLikeVc refreshLikeVc;


@end

