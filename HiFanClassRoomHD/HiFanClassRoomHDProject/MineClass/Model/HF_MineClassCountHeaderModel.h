//
//  HF_MineClassCountHeaderModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/12.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_MineClassCountHeaderModel : NSObject
@property (nonatomic, copy) NSString *ExpireTime;
@property (nonatomic, assign) NSInteger SurplusCount;
@property (nonatomic, assign) NSInteger TotalCount;
//ExpireTime = "2019-04-01";
//SurplusCount = 12;
//TotalCount = 64;
@end
