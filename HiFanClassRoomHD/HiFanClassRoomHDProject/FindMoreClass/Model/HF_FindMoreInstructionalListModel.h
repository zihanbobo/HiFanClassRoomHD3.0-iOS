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
@property (nonatomic, copy) NSString *RelationUrl;
@property (nonatomic, copy) NSString *Title;

//BillType = 2;
//CoverImage = "http://gogotalk.oss-cn-beijing.aliyuncs.com/PictureBook/750930fc-4ce7-49cb-bd9f-a6de85617ce1.png?Expires=4669165074&amp;OSSAccessKeyId=LTAIKtWnie86aI6T&amp;Signature=fZKyLvixZCVeyCPKQ6MIvqfbSpA%3D";
//RelationUrl = "http://o2mzy.gogo-talk.com/guanwang/videos/web_3.mp4";
//Title = "儿歌1";
@end
