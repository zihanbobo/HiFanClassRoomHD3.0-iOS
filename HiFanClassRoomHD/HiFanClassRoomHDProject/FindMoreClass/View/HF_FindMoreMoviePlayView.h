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


@protocol playerDelegate <NSObject>
//点击全屏按钮代理方法
-(void)player:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn;
@end

@interface HF_FindMoreMoviePlayView : UIView <WMPlayerDelegate>
@property (nonatomic,copy) NSString *playerUrlStr;
@property (nonatomic, strong) WMPlayer * wmPlayer;
@property(nonatomic,weak) id <playerDelegate> playerDelegate;

@end
