//
//  HF_FindMoreInstructionalTypeListModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/13.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_FindMoreInstructionalTypeListModel : NSObject
@property (nonatomic, assign) NSInteger Count;
@property (nonatomic, copy) NSString *CoverImage;
@property (nonatomic, assign) NSInteger ResourcesID;
@property (nonatomic, copy) NSString *SubTitle;
@property (nonatomic, copy) NSString *Title;

//Count = 30;
//CoverImage = "http://gogotalk.oss-cn-beijing.aliyuncs.com/PictureBook/94984333-aee1-42e2-9a94-26a84b2f5713.png?Expires=4670040257&amp;OSSAccessKeyId=LTAIKtWnie86aI6T&amp;Signature=q%2Fz3bSsl%2BVPYkfmfc1gJjTLiI6M%3D";
//ResourcesID = 4;
//SubTitle = "辅修课副标题";
//Title = "辅修2";
@end
