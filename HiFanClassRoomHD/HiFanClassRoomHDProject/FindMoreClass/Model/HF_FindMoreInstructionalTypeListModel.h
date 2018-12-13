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
//CoverImage = "http://gogotalk.oss-cn-beijing.aliyuncs.com/PictureBook/ce5064ca-e8ce-4d8c-83e0-18987b8be753.png?Expires=4668653890&amp;OSSAccessKeyId=LTAIKtWnie86aI6T&amp;Signature=%2BaB3g51dNmwNYpRYURBPOEXu9Mk%3D";
//ResourcesID = 1;
//SubTitle = "字母时间副标题";
//Title = "字母时间";
@end
