//
//  HF_FindMoreMoviePlayView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WMPlayer/WMPlayer.h>

@interface HF_FindMoreMoviePlayView : UIView
@property (nonatomic,copy) NSString *playerUrlStr;
@property (nonatomic, strong) WMPlayer * wmPlayer;

@end
