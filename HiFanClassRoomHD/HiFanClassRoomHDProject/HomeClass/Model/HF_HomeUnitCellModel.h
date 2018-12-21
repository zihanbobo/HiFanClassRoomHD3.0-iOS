//
//  HF_HomeUnitCellModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/21.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_HomeUnitCellModel : NSObject
@property (nonatomic, assign) NSInteger ChapterID;
@property (nonatomic, copy) NSString *ChapterImagePath;
@property (nonatomic, copy) NSString * ChapterName;
@property (nonatomic, assign) NSInteger ChapterStatus;


//ChapterID = 236;
//ChapterImagePath = "http://file.gogo-talk.com/UploadFiles/Booking/A0/Images/A0-4-2.png";
//ChapterName = "Lesson4-2";
//ChapterStatus = 2;
@end
