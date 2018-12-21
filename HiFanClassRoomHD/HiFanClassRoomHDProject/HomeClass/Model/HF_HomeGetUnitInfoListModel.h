//
//  HF_HomeGetUnitInfoListModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/21.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_HomeGetUnitInfoListModel : NSObject
@property (nonatomic, copy) NSString *HandoutUrl;
@property (nonatomic, assign) NSInteger UnitID;
@property (nonatomic, assign) NSInteger UnitLessonStatus;
@property (nonatomic, copy) NSString *UnitName;
@property (nonatomic, copy) NSString *WorkBook;

//HandoutUrl = "";
//UnitID = 1;
//UnitLessonStatus = 0;
//UnitName = unit1;
//WorkBook = "";

@end
