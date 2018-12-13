//
//  HF_FindMoreAdvertModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/13.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_FindMoreAdvertModel : NSObject
@property (nonatomic, copy) NSString *AdvertDetailsLink;
@property (nonatomic, assign) NSInteger AdvertID;
@property (nonatomic, copy) NSString *AdvertImagePath;
@property (nonatomic, copy) NSString *AdvertNote;
@property (nonatomic, copy) NSString *AdvertTitle;

//AdvertDetailsLink = "https://www.baidu.com/";
//AdvertID = 1;
//AdvertImagePath = "http://gogotalk.oss-cn-beijing.aliyuncs.com/PictureBook/86e66318-c362-4adf-ac3f-38c570765c14.png?Expires=4668661463&amp;OSSAccessKeyId=LTAIKtWnie86aI6T&amp;Signature=Gx99cL8TyC%2F3MzUt0ORnUP43Qqg%3D";
//AdvertNote = "说明";
//AdvertTitle = "哈哈哈哈";
@end
