//
//  BaseTableViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/9/27.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell


/**
  所上课程-课前预习按钮UI
 */
-(void)classBeforeButtonUI {
    //课前预习  0为未预习   1为已预习
    [self.classBeforeButton setTitle:@"课前预习" forState:UIControlStateNormal];
    [self.classBeforeButton setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:UIControlStateNormal];
    [self.classBeforeButton setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn_copy") forState:UIControlStateNormal];
    [self.classBeforeButton setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn_copy") forState:UIControlStateHighlighted];
}


/**
 所上课程-课后练习按钮UI
 */
-(void)classAfterButtonUI {
    //课后练习   0为未复习   1为已预习
    [self.classAfterButton setTitle:@"课后练习" forState:UIControlStateNormal];
    [self.classAfterButton setTitleColor:UICOLOR_FROM_HEX(ColorFF6600) forState:UIControlStateNormal];
    [self.classAfterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn_copy") forState:UIControlStateNormal];
    [self.classAfterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"practiceBtn_copy") forState:UIControlStateHighlighted];
}




/**
 所上课程-进入教室的按钮状态
 @param status YES:可以点击，进入教室  YES:置灰，无法点击进入教室
 */
- (void)enterClassButton:(BOOL)status {
    //YES为上课   NO为不上课状态
    if (status == YES) {
        [self.classEnterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:UIControlStateNormal];
        [self.classEnterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:UIControlStateHighlighted];
        [self.classEnterButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
    } else {
        [self.classEnterButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
        [self.classEnterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:UIControlStateNormal];
        [self.classEnterButton setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonN") forState:UIControlStateHighlighted];
    }
}


@end
