//
//  GGT_PracticeViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/19.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshLoadData)(BOOL is);
@interface GGT_PracticeViewController : BaseViewController

//h5
@property (nonatomic, copy) NSString *webUrl;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *lessonid;

@property (nonatomic, copy) RefreshLoadData refreshLoadData;

@end
