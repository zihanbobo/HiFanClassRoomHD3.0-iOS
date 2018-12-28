//
//  HF_FindMoreInstructionalListModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_FindMoreInstructionalListModel : NSObject
@property (nonatomic, assign) NSInteger BillType;
@property (nonatomic, copy) NSString *CoverImage;
@property (nonatomic, assign) NSInteger RecordID;
@property (nonatomic, copy) NSString *RelationUrl;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, assign) NSInteger ResourcesInfoID;  //我喜欢的
@property (nonatomic, copy) NSString *ShareUrl;
@property (nonatomic, assign) NSInteger IsLike;     //1 喜欢  0不喜欢

//BillType = 1;
//CoverImage = "http://gogotalk.oss-cn-beijing.aliyuncs.com/PictureBook/d3ea65da-27e0-4470-b69b-73117b9b3243.png?Expires=4670034358&amp;OSSAccessKeyId=LTAIKtWnie86aI6T&amp;Signature=0D06zzkKgXMkjMrjBUX7kA%2FQ6Xs%3D";
//IsLike = 0;
//RecordID = 1;
//RelationUrl = "http://o2mzy.gogo-talk.com/guanwang/videos/web_3.mp4";
//ShareUrl = "www.baidu.com";
//Title = letter1;
@end
