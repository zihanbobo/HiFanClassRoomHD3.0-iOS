//
//  HF_HomeClassDetailModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/25.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_HomeClassDetailModel : NSObject
@property (nonatomic, copy) NSString *AfterFilePath;
@property (nonatomic, copy) NSString *BeforeFilePath;
@property (nonatomic, copy) NSString *BookName;
@property (nonatomic, copy) NSString *ChIntroduction;
@property (nonatomic, assign) NSInteger ChapterID;
@property (nonatomic, copy) NSString *ChapterImagePath;
@property (nonatomic, copy) NSString *ChapterName;
@property (nonatomic, copy) NSString *EnIntroduction;


//AfterFilePath = "https://file.gogo-talk.com/UploadFiles/Web/courseware/After/A0/A0L1-4/index.html";
//BeforeFilePath = "https://file.gogo-talk.com/UploadFiles/Web/courseware/Before/A0/H5A0-U1-L4/index.html";
//BookName = "<null>";
//ChIntroduction = "小朋友们在结交新朋友时，会不会用英文介绍自己呢？今天，让我们一起来 show 出自己吧！";
//ChapterID = 226;
//ChapterImagePath = "http://file.gogo-talk.com/UploadFiles/Booking/A0/Images/A0-1-4.png";
//ChapterName = "Lesson1-4";
//EnIntroduction = "to make a simple self-introduction and review the whole unit";
@end
