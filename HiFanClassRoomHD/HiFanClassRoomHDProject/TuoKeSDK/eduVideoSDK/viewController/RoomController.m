//
//  RoomController.m
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//
// change openurl
//#import "ViewController.h"
#import "RoomController.h" 
#import "TKEduBoardHandle.h"
#import "TKEduSessionHandle.h"
#import <WebKit/WebKit.h>

#import "TKMacro.h"
#import "sys/utsname.h"
//chatView
#import "TKLiveViewChatTableViewCell.h"
#import "TKGrowingTextView.h"

#pragma pad
#import "TKDocumentListView.h"
#import "TKFolderDocumentListView.h"
#import "TKChooseAreaListView.h"
#import "TKChatView.h"
//#import "BITAttributedLabel.h"
//#import "UIButton+clickedOnce.h"

//#import "TKAreaChooseModel.h"
#import "TKMediaDocModel.h"
#import "TKDocmentDocModel.h"
#import "TKPlaybackMaskView.h"
//#import "PlaybackModel.h"
#import "TKProgressSlider.h"
//@import AVFoundation;
#import <AVFoundation/AVFoundation.h>
#pragma mark 上传图片
#import "TKUploadImageView.h"
//@import AssetsLibrary;
//@import PhotosUI;
//@import Photos;
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#pragma mark - 常用语
#import "GGT_PopoverController.h"
#import "TKEduSessionHandle.h"

//214 *142

#define VideoSmallViewMargins 6
#define VideoSmallViewHeigh (([UIScreen mainScreen].bounds.size.height -3*VideoSmallViewMargins-40)/ 4.0)
#define VideoSmallViewWidth VideoSmallViewHeigh * 4.0/3.0

@interface TGInputToolBarView : UIView
@end
@implementation TGInputToolBarView
- (void)drawRect:(CGRect) rect
{
    [super drawRect:rect];
    
    [RGBCOLOR(76,76,76) set];
    //[[UIColor redColor] set];
    
    CGRect frame = self.bounds;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext,1.0f);
    CGContextMoveToPoint(currentContext, frame.origin.x, frame.origin.y);
    CGContextAddLineToPoint(currentContext, frame.origin.x + frame.size.width, frame.origin.y);
    CGContextStrokePath(currentContext);
}

@end

//RGBCOLOR(121, 69, 67); 举手红色暗色 下课
//RGBCOLOR(207,65, 21); 红色
static const CGFloat sChatBarHeight = 47;

int expireSeconds;      // 课堂结束时间

//https://imtx.me/archives/1933.html 黑色背景
#pragma mark - 常用语
@interface RoomController() <TKEduBoardDelegate,TKEduSessionDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TKGrowingTextViewDelegate,CAAnimationDelegate,UIImagePickerControllerDelegate,TKEduNetWorkDelegate,UINavigationControllerDelegate,TKChooseAreaDelegate,UIPopoverPresentationControllerDelegate>

//@property (nonatomic, assign) BOOL isMuteAudio;//yes 静音 no 非静音
@property(nonatomic,strong)TKChatView *iChatView;//聊天
@property (nonatomic, strong) UIButton *leftButton;//离开按钮

@property (nonatomic, strong) UIButton *iDocumentButton;
@property (nonatomic, strong) UIButton *iMediaButton;
@property (nonatomic, strong) UIButton *iChooseAreaButton;

@property (nonatomic, assign) NSTimeInterval iLocalTime;
@property (nonatomic, assign) NSTimeInterval iClassStartTime;
@property (nonatomic, assign) NSTimeInterval iServiceTime;
@property(nonatomic,copy)     NSString * iRoomName;
@property (nonatomic, strong) NSTimer *iNavHideControltimer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) NSTimeInterval iClassReadyTime;
@property (nonatomic, strong) NSTimer *iClassReadyTimetimer;
#pragma mark pad
@property(nonatomic,retain)TKDocumentListView *iUsertListView;
@property(nonatomic,strong)TKChooseAreaListView *iAreaListView;
//白板
@property (nonatomic, assign) BOOL iShowBefore;//yes 出现过 no 没出现过
@property (nonatomic, assign) BOOL iShow;//yes 出现过 no 没出现过

//视频
@property (nonatomic, weak)  id<TKEduRoomDelegate> iRoomDelegate;

//重连
@property (nonatomic, strong) TKProgressHUD *connectHUD;

//聊天
@property (nonatomic, strong) TKGrowingTextView *inputField;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) TGInputToolBarView *inputContainer;
@property (nonatomic, strong) TGInputToolBarView *inputInerContainer;

@property(nonatomic,retain)UIView *iChatInputView;//全屏
@property (nonatomic, strong) UILabel *replyText;
@property (nonatomic,assign) CGFloat knownKeyboardHeight;
@property (nonatomic,strong ) NSArray  *iMessageList;

// 回放
@property (nonatomic, strong) TKPlaybackMaskView *playbackMaskView;

#pragma mark - 常用语
@property (nonatomic, strong) NSMutableArray *xc_phraseMuArray;
@property (nonatomic, strong) UIButton *xc_commonButton;
    
#pragma mark 上传图片
#define OpenAlbumActionSheetTag (0x45A912)
@property (nonatomic, strong) UIAlertController *OpenAlbumActionSheet;
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) TKUploadImageView * uploadImageView;
//@property (nonatomic, strong) TKEduNetManager * requestManager;
@end


@implementation RoomController

- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic
                       aRoomName:(NSString *)aRoomName
                   aRoomProperty:(TKEduRoomProperty *)aRoomProperty{
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iRoomProperty      = aRoomProperty;
        _iRoomName          = aRoomName;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        _networkRecovered   = YES;
       // _iBoardHandle  = [TKEduBoardHandle shareTKEduWhiteBoardHandleInstance];
        _iSessionHandle = [TKEduSessionHandle shareInstance];
        _iSessionHandle.isPlayback = NO;
        _iSessionHandle.isSendLogMessage = YES;
       
        // 下课定时器
        _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(onClassTimer)
                                                          userInfo:nil
                                                           repeats:YES];
        [_iClassTimetimer setFireDate:[NSDate distantFuture]];
        
        // 上课定时器
        _iClassReadyTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                 target:self
                                                               selector:@selector(onClassReady)
                                                               userInfo:nil
                                                                repeats:YES];
        [_iClassReadyTimetimer setFireDate:[NSDate distantFuture]];
        
        [_iSessionHandle configureSession:aParamDic aRoomDelegate:aRoomDelegate aSessionDelegate:self aBoardDelegate:self aRoomProperties:aRoomProperty];
        
    }
    return self;
}

// 回放初始化接口
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic
                               aRoomName:(NSString *)aRoomName
                           aRoomProperty:(TKEduRoomProperty *)aRoomProperty {
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iRoomProperty      = aRoomProperty;
        _iRoomName          = aRoomName;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        _networkRecovered   = YES;
        //_iRoomProperty.iMaxVideo = [[NSNumber alloc] initWithInt:6];
        _iSessionHandle = [TKEduSessionHandle shareInstance];
        _iSessionHandle.isPlayback = YES;
        
        // 下课定时器
        _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(onClassTimer)
                                                          userInfo:nil
                                                           repeats:YES];
        [_iClassTimetimer setFireDate:[NSDate distantFuture]];
        
        // 上课定时器
        _iClassReadyTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                 target:self
                                                               selector:@selector(onClassReady)
                                                               userInfo:nil
                                                                repeats:YES];
        [_iClassReadyTimetimer setFireDate:[NSDate distantFuture]];
        
        [_iSessionHandle configurePlaybackSession:aParamDic aRoomDelegate:aRoomDelegate aSessionDelegate:self aBoardDelegate:self aRoomProperties:aRoomProperty];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self addNotification];
    if (!_iCheckPlayVideotimer) {
        [self createTimer];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    TKLog(@"tlm----- viewDidAppear: %@", [TKUtil currentTimeToSeconds]);
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (!_iPickerController) {
        [self invalidateTimer];
    }
    [self removeNotificaton];
    
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fullScreenToLc:) name:sChangeWebPageFullScreen object:nil];
    /** 1.先设置为外放 */
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    //    });
    /** 2.判断当前的输出源 */
    // [self routeChange:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(routeChange:)
                                                name:AVAudioSessionRouteChangeNotification
                                              object:[AVAudioSession sharedInstance]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapTable:)
                                                name:sTapTableNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData)
                                                name:@"test"
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMediaServicesReset:)
                                                 name:AVAudioSessionMediaServicesWereResetNotification object:nil];
    
     [[UIApplication sharedApplication] addObserver:self forKeyPath:@"idleTimerDisabled" options:NSKeyValueObservingOptionNew context:nil];
    
    //拍摄照片、选择照片上传
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotos:)
                                                name:sTakePhotosUploadNotification
                                              object:sTakePhotosUploadNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotos:)
                                                 name:sChoosePhotosUploadNotification
                                               object:sChoosePhotosUploadNotification];
}
-(void)removeNotificaton{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIApplication sharedApplication]removeObserver:self forKeyPath:@"idleTimerDisabled"];
    
}
//全屏通知方法
-(void)fullScreenToLc:(NSNotification*)aNotification{
    
    bool isFull = [aNotification.object boolValue];
    _iClassTimeView.hidden = isFull;
    [TKEduSessionHandle shareInstance].iIsFullState = isFull;
    if (isFull) {
        [_iScroll bringSubviewToFront:_iTKEduWhiteBoardView];
    }else{
        [_iScroll sendSubviewToBack:_iTKEduWhiteBoardView];
        [self refreshUI];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.isConnect = NO;
    
    [_iSessionHandle sessionHandleSetVideoOrientation:(UIDeviceOrientationLandscapeLeft)];
    //判断课堂中视频最大路数，如果超过7路，则设置底部显示区域为12路视频的高度否则还是6路高度
    if (_iRoomProperty.iMaxVideo.intValue > 7) {
        self.maxVideo = 12;
    }else{
        self.maxVideo = 6;
    }
    self.VideoSmallViewLittleWidth =((ScreenW-sRightWidth*Proportion -(self.maxVideo+1)*VideoSmallViewMargins)/ self.maxVideo);
    self.VideoSmallViewLittleHeigh = (self.VideoSmallViewLittleWidth / 4.0*3.0)+(self.VideoSmallViewLittleWidth /4.0 * 3.0)/7;


    CGRect tFrame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars             = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets         =NO;
  
    _iUserType = _iRoomProperty.iUserType;
   
    _iIsCanRaiseHandUp    = YES;
    _iShow     = false;
    _iRoomType = _iRoomProperty.iRoomType;
  
    _iScroll = ({
    
        UIScrollView *tScrollView = [[UIScrollView alloc]initWithFrame:tFrame];
        tScrollView.userInteractionEnabled = YES;
        tScrollView.delegate = self;
        tScrollView.contentSize = CGSizeMake(CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
        tScrollView.backgroundColor =  RGBCOLOR(62,62,62);
        tScrollView;
    
    });
    
    [self.view addSubview:_iScroll];
    
    _iStudentVideoViewArray = [NSMutableArray arrayWithCapacity:_iRoomProperty.iMaxVideo.intValue];
    _iStudentSplitScreenArray = [NSMutableArray arrayWithCapacity:_iRoomProperty.iMaxVideo.intValue];
    _iStudentSplitViewArray =[NSMutableArray arrayWithCapacity:_iRoomProperty.iMaxVideo.intValue];
    _iPlayVideoViewDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iScaleVideoDict = [NSDictionary dictionary];
    
    
    [self initNavigation:tFrame];
    [self initRightView];
    [self initBottomView];
    [self initWhiteBoardView];//初始化白板
    [self initSplitScreenView];//初始化分屏视图
    [self initTapGesTureRecognizer];
    //[self initAutoReconection];
    [self createTimer];
    [_iScroll bringSubviewToFront:_iTKEduWhiteBoardView];
    [_iScroll bringSubviewToFront:_iClassTimeView];
//todo
    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
        //FIXME:todo
    [self initAudioSession];
   

    // 如果是回放，那么放上遮罩页
    if (_iSessionHandle.isPlayback == YES) {
        [self initPlaybackMaskView];
    }
    
//    self.requestManager = [TKEduNetManager initTKEduNetManagerWithDelegate:self];
#pragma mark - 常用语
    [self xc_loadPhraseData];
}

#pragma mark Pad 初始化

-(void)initAudioSession{
    
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError* error;
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth  error:&error];
//    [session setMode:AVAudioSessionModeVoiceChat error:nil];
//    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance]currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        
        if ([[desc portType]isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
            [TKEduSessionHandle shareInstance].isHeadphones = NO;
            [TKEduSessionHandle shareInstance].iVolume = 1;
            [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        }else{
            [TKEduSessionHandle shareInstance].isHeadphones = YES;
            [TKEduSessionHandle shareInstance].iVolume = 0.5;
        }
        /*
        if ([[desc portType] isEqualToString:@"Headphones"] || [[desc portType] isEqualToString:@"BluetoothHFP"])
        {
            [TKEduSessionHandle shareInstance].isHeadphones = YES;
            [TKEduSessionHandle shareInstance].iVolume = 0.5;
        }
        else
        {
            [TKEduSessionHandle shareInstance].isHeadphones = NO;
            [TKEduSessionHandle shareInstance].iVolume = 1;
            [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        }*/
        
    }
    
}
-(void)initNavigation:(CGRect)aFrame{
    self.navigationController.navigationBar.hidden = YES;
    //导航栏
    _titleView = ({
        
        UIView *tTitleView = [[UIView alloc] initWithFrame: CGRectMake(0, 20, CGRectGetWidth(aFrame), sDocumentButtonWidth*Proportion)];
        tTitleView.backgroundColor =  RGBCOLOR(41, 41, 41) ;
        tTitleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tTitleView;
    });
    
    _leftButton =({
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tLeftButton.frame = CGRectMake(0, 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tLeftButton setImage: LOADIMAGE(@"btn_back_normal") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"btn_back_pressed") forState:UIControlStateHighlighted];
        tLeftButton;
    });
    
    [_titleView addSubview:_leftButton];
    
    _iClassTimeView = ({
        CGFloat h = sClassTimeViewHeigh*Proportion;
        CGFloat w = h * 3;
        CGFloat x = 65;
        CGFloat y = 0;
        TKClassTimeView *tClassTimeView = [[TKClassTimeView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        tClassTimeView.backgroundColor = [UIColor clearColor];
        tClassTimeView.backgroundColor = RGBCOLOR(28, 28, 28);
        [tClassTimeView setClassTime:0];
        tClassTimeView;
        
    });
    
    
    
    if (_iSessionHandle.isPlayback == NO) {
        [_titleView addSubview:_iClassTimeView];
    }
    
    _titleLable = ({
        
        //UILabel *tTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, self.view.frame.size.width-65-sDocumentButtonWidth*4- 8* 4, sDocumentButtonWidth*Proportion)];
        CGFloat w = self.view.frame.size.width-65-sDocumentButtonWidth*4-8*4;
        CGFloat h = sDocumentButtonWidth*Proportion;
        CGFloat x = (self.view.frame.size.width - w)/2;
        CGFloat y = 0;
        UILabel *tTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[_iSessionHandle.roomName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        tTitleLabel.text = attrStr.string ;
        tTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tTitleLabel.backgroundColor = [UIColor clearColor];
        tTitleLabel.textAlignment = NSTextAlignmentCenter;
        tTitleLabel.font = TKFont(21);
        tTitleLabel.textColor = RGBCOLOR(255, 255, 255);
        tTitleLabel;
        
    });
    [_titleView addSubview:_titleLable];
    
//    _iChooseAreaButton = ({
//
//        UIButton *tUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        tUserButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion-8, 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
//
//        tUserButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        [tUserButton addTarget:self action:@selector(chooseAreaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [tUserButton setImage: LOADIMAGE(@"icon_choose_area_normal") forState:UIControlStateNormal];
//        tUserButton;
//
//    });
    
    _iUserButton = ({
        
        UIButton *tUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tUserButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*((1))-8*(1), 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
        
        tUserButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tUserButton addTarget:self action:@selector(userButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tUserButton setImage: LOADIMAGE(@"btn_user_normal") forState:UIControlStateNormal];
        [tUserButton setImage: LOADIMAGE(@"btn_user_pressed") forState:UIControlStateSelected];
        tUserButton;
        
    });
   
    
    _iMediaButton = ({
        
        UIButton *tMediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tMediaButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*((2))-8*(2), 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
        
        tMediaButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tMediaButton addTarget:self action:@selector(mediaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tMediaButton setImage: LOADIMAGE(@"btn_media_normal") forState:UIControlStateNormal];
        [tMediaButton setImage: LOADIMAGE(@"btn_media_pressed") forState:UIControlStateSelected];
        tMediaButton;
        
    });
   
    _iDocumentButton = ({
        
        UIButton *tDocumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tDocumentButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*(3)-8*((3)), 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
        
        tDocumentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tDocumentButton addTarget:self action:@selector(documentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tDocumentButton setImage: LOADIMAGE(@"btn_document_normal") forState:UIControlStateNormal];
        [tDocumentButton setImage: LOADIMAGE(@"btn_document_pressed") forState:UIControlStateSelected];
        tDocumentButton;
        
    });
    
    {//测试
//        _cpuLabel = ({
//            UILabel *label = [[UILabel alloc]init];
//            label.frame = CGRectMake(CGRectGetMinX(_iDocumentButton.frame)-100, 0, 100, sDocumentButtonWidth*Proportion);
//            [_titleView addSubview:label];
//            label;
//        });
//
//        _memoryLabel = ({
//            UILabel *label = [[UILabel alloc]init];
//            label.frame = CGRectMake(CGRectGetMinX(_cpuLabel.frame)-100, 0, 100, sDocumentButtonWidth*Proportion);
//            [_titleView addSubview:label];
//            label;
//        });
    }
    
    
    if ((_iUserType == UserType_Teacher) && !_iSessionHandle.isPlayback) {
        [_titleView addSubview:_iDocumentButton];
        [_titleView addSubview:_iMediaButton];
        [_titleView addSubview:_iUserButton];
        [_titleView addSubview:_iChooseAreaButton];
    }
    
    if ((_iUserType != UserType_Teacher) && !_iSessionHandle.isPlayback) {
        [_titleView addSubview:_iChooseAreaButton];
    }
    
    [_iScroll addSubview:_titleView];
    
    UIButton *leaveBtn =[[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 240, sDocumentButtonWidth*Proportion)];
    [leaveBtn addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:leaveBtn];
    
    
}
#pragma mark 点击上课
- (void)handTouchDown{
    if (_iUserType != UserType_Student || _iSessionHandle.localUser.publishState == 0) {
        return;
    }
    [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(YES) completion:nil];
}
- (void)handTouchUp{
    if (_iUserType != UserType_Student || _iSessionHandle.localUser.publishState == 0) {
        return;
    }
    [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(NO) completion:nil];
}

-(void)classBeginAndRaiseHandButtonClicked:(UIButton *)aButton{

    if (_iUserType == UserType_Teacher || _iUserType == UserType_Patrol) {
        aButton.selected = [TKEduSessionHandle shareInstance].isClassBegin;
        if (!aButton.selected) {
            if([_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag && _iUserType == UserType_Teacher){
                [[TKEduSessionHandle shareInstance]sessionHandleDelMsg:sAllAll ID:sAllAll To:sTellNone Data:@{} completion:nil];
            }
            
            TKLog(@"开始上课");
            UIButton *tButton = _iClassBeginAndRaiseHandButton;
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
            
            [TKEduNetManager classBeginStar:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
                tButton.backgroundColor = RGBACOLOR_ClassEnd_Red;
                [tButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                //  {"recordchat" : true};
                NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
                //[_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true completion:nil];
                [_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                return 0;
            } aNetError:^int(id  _Nullable response) {
                
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                return 0;
            }];
            
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.prompt") message:MTLocalized(@"Prompt.FinishClass") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                TKLog(@"下课");
                UIButton *tButton = _iClassBeginAndRaiseHandButton;
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
                [_iClassTimetimer invalidate];      // 下课后计时器销毁
                
                // 下课关闭MP3和MP4
                if ([TKEduSessionHandle shareInstance].isPlayMedia == YES) {
                    [TKEduSessionHandle shareInstance].isPlayMedia          = NO;
                    [[TKEduSessionHandle shareInstance] sessionHandleUnpublishMedia:nil];
                }
                
                if(![_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
                    
                    // 下课清理聊天日志
                    [_iSessionHandle clearMessageList];
                    [self refreshData];
                    // 下课文档复位
                    [_iSessionHandle fileListResetToDefault];
                    // 下课后showpage
                    [_iSessionHandle docmentDefault:[_iSessionHandle getClassOverDocument]];
                }
                
                [TKEduNetManager classBeginEnd:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
                    
                    [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{} completion:nil];
                    [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
              
                    [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
                    
                    return 0;
                }aNetError:^int(id  _Nullable response) {
                    
                  
                    [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
                    
                    return 0;
                }];
                
            }];
            
            UIAlertAction *tActionCancel = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            
            [ac addAction:tActionSure];
            [ac addAction:tActionCancel];
            
            [self presentViewController:ac animated:YES completion:nil];
        }
        
       
    }else{
         TKLog(@"---举手1");
        
        // 在台上点击举手按钮无效，只响应长按
        if (_iSessionHandle.localUser.publishState > 0) {
//            if (_iUserType != UserType_Student || _iSessionHandle.localUser.publishState == 0) {
//                return;
//            }
//
//            [_iClassBeginAndRaiseHandButton setBackgroundColor:RGBACOLOR_RAISEHAND_HOLD];
//            [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(YES) completion:nil];
            return;
        }
        
        aButton.selected = ![[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
        [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(aButton.selected) completion:nil];
        if (aButton.selected) {
            if (_iSessionHandle.localUser.publishState > 0) {
                [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
            } else {
                [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
            }
            
        }else{
          
            [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
            
        }
    }
   
    
}

-(void)muteAduoButtonClicked:(UIButton *)aButton{
    TKLog(@"全体静音");
    if (_iUserType == UserType_Student) {
        // 如果当前用户是学生
        [[TKEduSessionHandle shareInstance] disableMyAudio:!aButton.selected];
        
        // 如果禁用音视频，已经举手，举起的手要放下
        BOOL handState = [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
        if (handState == YES) {
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(!handState) completion:nil];
            if (!handState) {
                if (_iSessionHandle.localUser.publishState > 0) {
                    [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
                } else {
                    [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
                }
            } else {
                [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
            }
        }
        
        aButton.selected = !aButton.selected;
        [self refreshUI];
        
    } else {
        // 如果当前用户是老师
        if (![TKEduSessionHandle shareInstance].isMuteAudio) {
            
            for (TKRoomUser *tUser in [_iSessionHandle userStdntAndTchrArray]) {
                
                if ((tUser.role != UserType_Student))
                    continue;
                
                // [_iSessionHandle sessionHandleChangeUserProperty:tUser.peerID TellWhom:tUser.peerID Key:sGiftNumber Value:@(currentGift+1) completion:nil];
                PublishState tState = (PublishState)tUser.publishState;
                if (tState == PublishState_BOTH) {
                    tState = PublishState_VIDEOONLY;
                }else if(tState == PublishState_AUDIOONLY){
                    tState = PublishState_NONE;
                }
                _isLocalPublish = false;
                [_iSessionHandle sessionHandleChangeUserPublish:tUser.peerID Publish:tState completion:nil];
            }
            [TKEduSessionHandle shareInstance].isMuteAudio = YES;
            _iMuteAudioButton.enabled = NO;
            _iMuteAudioButton.backgroundColor = RGBACOLOR_muteAudio_Normal;
            
        }

    }
}

-(void)unMuteAllButtonClicked:(UIButton *)aButton{
    TKLog(@"全体发言");
    if (_iUserType == UserType_Student) {
        // 如果当前用户是学生
        [[TKEduSessionHandle shareInstance] disableMyAudio:aButton.selected];
        
        // 如果禁用音视频，已经举手，举起的手要放下
        BOOL handState = [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
        if (handState == YES) {
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(!handState) completion:nil];
            if (!handState) {
                if (_iSessionHandle.localUser.publishState > 0) {
                    [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
                } else {
                    [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
                }
            } else {
                [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
            }
        }
        
        aButton.selected = !aButton.selected;
        [self refreshUI];
        
    } else {
        // 如果当前用户是老师
        if (![TKEduSessionHandle shareInstance].isunMuteAudio) {
            
            for (TKRoomUser *tUser in [_iSessionHandle userStdntAndTchrArray]) {
                
                if ((tUser.role != UserType_Student))
                    continue;
                
                PublishState tState = (PublishState)tUser.publishState;
//                if (tState == PublishState_BOTH) {
//                    tState = PublishState_VIDEOONLY;
//                }else if(tState == PublishState_AUDIOONLY){
//                    tState = PublishState_NONE;
//                }
                if(tState == PublishState_VIDEOONLY){
                    tState = PublishState_BOTH;
                }
                _isLocalPublish = false;
                [_iSessionHandle sessionHandleChangeUserPublish:tUser.peerID Publish:tState completion:nil];
            }
            [TKEduSessionHandle shareInstance].isunMuteAudio = YES;
            _iunMuteAllButton.enabled = NO;
            _iunMuteAllButton.backgroundColor = RGBACOLOR_unMuteAudio_Normal;
            
        }
        
    }
}
-(void)rewardButtonClicked:(UIButton *)aButton{
    TKLog(@"全员奖励");
    if (_iUserType == UserType_Student) {
        
        // 如果当前用户是学生
        [[TKEduSessionHandle shareInstance] disableMyVideo:!aButton.selected];
        aButton.selected = !aButton.selected;
        
    } else {
        
        // 如果当前用户是老师
        [TKEduNetManager sendGifForRoomUser:[[TKEduSessionHandle shareInstance] userStdntAndTchrArray] roomID:_iRoomProperty.iRoomId  aMySelf:[TKEduSessionHandle shareInstance].localUser aHost:_iRoomProperty.sWebIp aPort:_iRoomProperty.sWebPort aSendComplete:^(id  _Nullable response) {
            
            for (TKRoomUser *tUser in [[TKEduSessionHandle shareInstance] userStdntAndTchrArray]) {
                int currentGift = 0;
                if ((tUser.role != UserType_Student))
                    continue;
                
                if(tUser && tUser.properties && [tUser.properties objectForKey:sGiftNumber])
                    currentGift = [[tUser.properties objectForKey:sGiftNumber] intValue];
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tUser.peerID TellWhom:sTellAll Key:sGiftNumber Value:@(currentGift+1) completion:nil];
            }
            
        }aNetError:nil];
    }
}

- (void)refreshUI
{
    
    if (_iPickerController) {
        return;
    }
    
    //right
    CGFloat tViewCap = sViewCap * Proportion;
    //老师
    CGFloat tViewWidth = (sRightWidth-2*sViewCap)*Proportion;
    CGFloat tTeacherHeight = tViewWidth/4*3+30;
    {
        if ([TKEduSessionHandle shareInstance].iStdOutBottom) {
            _iTeacherVideoView.frame = CGRectMake(tViewCap, tViewCap, tViewWidth, tTeacherHeight);
        } 
    }
    //多人时 bottom和whiteview
    {
        
        [self refreshWhiteBoard:YES];
        [self sScaleVideo:_iScaleVideoDict];
        [self moveVideo:self.iMvVideoDic];
        [self sVideoSplitScreen:_iStudentSplitScreenArray];

    }
    
    //我
    {
        
        CGFloat tOurVideoViewHeight = (_iRoomType == RoomType_OneToOne)?sTeacherVideoViewHeigh*Proportion:0;
        _iOurVideoView.frame = CGRectMake(tViewCap,CGRectGetMaxY(_iTeacherVideoView.frame)+tViewCap, tViewWidth, tOurVideoViewHeight);
        _iOurVideoView.hidden = !tOurVideoViewHeight;
    }
    
    //静音与奖励
    {
        //非老师
        BOOL tIsHide = (self.iUserType != UserType_Teacher) || (![TKEduSessionHandle shareInstance].isClassBegin) || (self.iRoomType==RoomType_OneToOne);
        
        // 一对一老师不显示全体静音与奖励按钮
        if (self.iRoomType == RoomType_OneToOne && self.iUserType == UserType_Teacher) {
            tIsHide = YES;
        }
        
        CGFloat tMuteAudioAndRewardViewHeight = !tIsHide?(40*Proportion):0;
        self.iMuteAudioAndRewardView.hidden = tIsHide;
        self.iMuteAudioAndRewardView.frame = CGRectMake(tViewCap, CGRectGetMaxY(self.iOurVideoView.frame), tViewWidth, tMuteAudioAndRewardViewHeight);
        self.iunMuteAllButton.hidden = tIsHide;
        
        //修改部分
        self.iMuteAudioButton.frame = CGRectMake(tViewCap - 10, 0, tViewWidth / 2 - 5, tMuteAudioAndRewardViewHeight);
        self.iMuteAudioButton.hidden = tIsHide;
        self.iRewardButton.frame = CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap, tViewWidth, (40*Proportion));
        
        // 如果是老师，需要管理全体静音按钮的背景色
        if (self.iUserType == UserType_Teacher) {
            if ([TKEduSessionHandle shareInstance].isMuteAudio) {
                self.iMuteAudioButton.enabled = NO;
                self.iMuteAudioButton.backgroundColor = RGBACOLOR_muteAudio_Normal;
                
            }else{
                self.iMuteAudioButton.enabled = YES;
                self.iMuteAudioButton.backgroundColor =  RGBACOLOR_muteAudio_Select;
                
            }
            if ([TKEduSessionHandle shareInstance].isunMuteAudio) {
                self.iunMuteAllButton.enabled = NO;
                self.iunMuteAllButton.backgroundColor = RGBACOLOR_unMuteAudio_Normal;
                
            }else{
                self.iunMuteAllButton.enabled = YES;
                self.iunMuteAllButton.backgroundColor =  RGBACOLOR_unMuteAudio_Select;
                
            }
        }
        
    }
    //举手按钮
    {
        BOOL tIsHide = NO;
        if ([[self.iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
            
            tIsHide = (![TKEduSessionHandle shareInstance].isClassBegin && (self.iUserType == UserType_Student));
        } else {
            // 非英联邦点击下课后，老师的上下课按钮可见
            tIsHide = NO;
            //            if (_iUserType == UserType_Teacher) {
            //                tIsHide = NO;
            //            } else {
            //                tIsHide = (![TKEduSessionHandle shareInstance].isClassBegin);
            //            }
        }
        BOOL tIsStdAndRoomOne = (self.iUserType == UserType_Student && self.iRoomType == RoomType_OneToOne);
        BOOL tIsTeacherOrAssis  = ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher ||
                                   [TKEduSessionHandle shareInstance].localUser.role ==UserType_Assistant ||
                                   [TKEduSessionHandle shareInstance].localUser.role ==UserType_Patrol);
        
        CGFloat tOpenAlumWidth = tIsStdAndRoomOne ?tViewWidth:(tViewWidth / 2 - 5) ;
        tOpenAlumWidth = tIsTeacherOrAssis ?tViewWidth:tOpenAlumWidth;
        
        CGFloat tLeftY =([TKEduSessionHandle shareInstance].isClassBegin && self.iRoomType != RoomType_OneToOne && self.iUserType == UserType_Teacher)? 40*Proportion+tViewCap:0;
        
        CGRect tLeftFrame = CGRectMake(0, 0, tOpenAlumWidth, (40*Proportion));
        
        CGRect tRightFrame = CGRectMake(tOpenAlumWidth+tViewCap*1, 0, tOpenAlumWidth, (40*Proportion));
        
        self.iClassBeginAndOpenAlumdView.frame = CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap+tLeftY, tViewWidth, (40*Proportion));
        
        self.iClassBeginAndRaiseHandButton.frame = CGRectMake(0, 0, self.iClassBeginAndOpenAlumdView.frame.size.width, (40*Proportion));
        
        self.iClassBeginAndRaiseHandButton.hidden = tIsHide;
        
        self.iOpenAlumButton.frame = tLeftFrame;
        self.iOpenAlumButton.hidden = tIsTeacherOrAssis;
        
        [TKUtil setCornerForView:self.iClassBeginAndRaiseHandButton];
        [TKUtil setCornerForView:self.iOpenAlumButton];
        BOOL isCanDraw = [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sCandraw] boolValue];
        self.iOpenAlumButton.backgroundColor = isCanDraw?RGBACOLOR_ClassBegin_RedDeep:RGBACOLOR_ClassEnd_Red;
        self.iOpenAlumButton.enabled = isCanDraw;
        
        BOOL isNeedSelected =  NO;
        if (self.iUserType == UserType_Student) {
            bool tIsRaisHand =  [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
            isNeedSelected = self.iSessionHandle.localUser.publishState == PublishState_BOTH || self.iSessionHandle.localUser.publishState == PublishState_AUDIOONLY || tIsRaisHand;
            if (isNeedSelected) {
                if (tIsRaisHand) {
                    if (self.iSessionHandle.localUser.publishState > 0) {
                        [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
                    } else {
                        [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
                    }
                }
                
            }else{
                
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
                
            }
            
            // 当学生禁用自己音频时，无法举手
            if ([TKEduSessionHandle shareInstance].isClassBegin) {
                self.iIsCanRaiseHandUp = YES;       // 总是可以举手
            }else{
                self.iIsCanRaiseHandUp = NO;
            }
            
            if (_iIsCanRaiseHandUp) {
                _iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBegin_RedDeep;
            } else {
                _iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassEnd_Red;
            }
            
            self.iClassBeginAndRaiseHandButton.enabled = self.iIsCanRaiseHandUp;
            // [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(_iIsCanRaiseHandUp) completion:nil];
            
        } else if (self.iUserType == UserType_Teacher) {
            
            isNeedSelected = [TKEduSessionHandle shareInstance].isClassBegin;
            
            if (isNeedSelected)
            {
                self.iRewardButton.hidden = (self.iRoomType == RoomType_OneToOne)?YES:NO;
                if ([[self.iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                } else {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                }
            } else {
                
                self.iRewardButton.hidden = YES;
                self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
            }
        }else if (self.iUserType == UserType_Patrol){
            isNeedSelected = [TKEduSessionHandle shareInstance].isClassBegin;
            
            if (isNeedSelected)
            {
                self.iClassBeginAndRaiseHandButton.enabled = YES;
                if ([[self.iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                } else {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                    
                }
                
            } else {
                
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
                self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                
                self.iClassBeginAndRaiseHandButton.enabled = NO;
                
            }
            
            
        }
        
        [self.iRightView bringSubviewToFront:self.iClassBeginAndOpenAlumdView];
        
        
    }
    //聊天
    {
       
        [self refreshChatAndNavUI:tViewCap];
        
    }
   
    // 判断上下课按钮是否需要隐藏
    if (([_iSessionHandle.roomMgr getRoomConfigration].hideClassBeginEndButton == YES && _iSessionHandle.roomMgr.localUser.role != UserType_Student) || _iSessionHandle.isPlayback == YES) {
        _iClassBeginAndRaiseHandButton.hidden = YES;
        _iClassBeginAndOpenAlumdView.hidden   = YES;
    }
    if(_iSessionHandle.localUser.role == UserType_Patrol && [self.iSessionHandle.roomMgr getRoomConfigration].hideClassBeginEndButton == NO){
        if(_iSessionHandle.isClassBegin){
            _iClassBeginAndRaiseHandButton.hidden = NO;
            _iClassBeginAndOpenAlumdView.hidden   = NO;
        }else{
            _iClassBeginAndRaiseHandButton.hidden = YES;
            _iClassBeginAndOpenAlumdView.hidden   = YES;
        }
    }
}
- (void)refreshChatAndNavUI:(CGFloat)tViewCap{
    //聊天
    {
        
        CGFloat tChatHeight       = sRightViewChatBarHeight*Proportion;
        CGFloat tChatTableHeight  = CGRectGetHeight(_iRightView.frame)-CGRectGetMaxY(_iClassBeginAndOpenAlumdView.frame)-tChatHeight-tViewCap;
        
        _iChatTableView.frame = CGRectMake(0, CGRectGetMaxY(_iClassBeginAndOpenAlumdView.frame)+tViewCap, CGRectGetWidth(_iRightView.frame), tChatTableHeight);
        
        
        _inputContainerFrame      = CGRectMake(0, CGRectGetMaxY(_iChatTableView.frame), sRightWidth*Proportion, tChatHeight);
        _inputContainer.frame     = _inputContainerFrame;
        _inputInerContainer.frame =  CGRectMake(0, 0, CGRectGetWidth(_inputContainer.frame), CGRectGetHeight(_inputContainer.frame));
        
        {
            CGFloat tInPutInerContainerWidth = CGRectGetWidth(_inputInerContainer.frame);
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
            CGRect rectInputFieldFrame = CGRectMake(0, 0, tInPutInerContainerWidth, tInPutInerContainerHeigh);
            _inputField.frame = rectInputFieldFrame;
            
        }
        {
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
            CGFloat tInPutInerContainerWidth = CGRectGetWidth(_inputInerContainer.frame);
            CGRect tReplyTextFrame = CGRectMake(0, 0, tInPutInerContainerWidth, tInPutInerContainerHeigh);
            _replyText.frame = tReplyTextFrame;
            
        }
        {
            
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
            CGFloat tSendButtonX = (sRightWidth-sSendButtonWidth-4)*Proportion;
            _sendButton.frame = CGRectMake(tSendButtonX, 4, sSendButtonWidth*Proportion, tInPutInerContainerHeigh-4*2);
            
        }
        
    }
    //导航栏
    {
        if (_iUserType == UserType_Student) {
            _iUserButton.hidden = YES;
            _iMediaButton.hidden = YES;
            _iDocumentButton.hidden = YES;
            
        }
        
        for (TKRoomUser *tUser in [TKEduSessionHandle shareInstance].userStdntAndTchrArray) {
            BOOL isHaveRasieHandUser = [[tUser.properties objectForKey:sRaisehand]boolValue];
            _iUserButton.selected = isHaveRasieHandUser;
            
        }
        
    }
}
-(void)initRightView{

    {
        CGFloat tRightY = CGRectGetMaxY(_titleView.frame);
        CGRect tRithtFrame = CGRectMake(ScreenW-sRightWidth*Proportion, tRightY, sRightWidth*Proportion, ScreenH-tRightY);
        
        _iRightView = ({
            
            UIView *tRightView = [[UIView alloc] initWithFrame: tRithtFrame];
            
            tRightView.backgroundColor =  RGBCOLOR(62, 62, 62) ;
            tRightView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            tRightView;
            
        });
        [_iScroll addSubview:_iRightView];
    
    }
    CGFloat tViewCap = sViewCap*Proportion;
    //老师
    CGFloat tViewWidth = (sRightWidth-2*sViewCap)*Proportion;
    CGFloat tTeacherHeight = (sRightWidth-2*sViewCap)*Proportion/4*3+30;
    {
    
        _iTeacherVideoView= ({
            
            TKVideoSmallView *tTeacherVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tViewCap, tViewCap, tViewWidth, tTeacherHeight) aVideoRole:EVideoRoleTeacher];
//            sTeacherVideoViewHeigh*Proportion
            tTeacherVideoView.iPeerId = @"";
            tTeacherVideoView.iVideoViewTag = -1;
            tTeacherVideoView.isNeedFunctionButton = (_iUserType==UserType_Teacher);
            tTeacherVideoView.iEduClassRoomSessionHandle = _iSessionHandle;
            tTeacherVideoView;
            
            
        });
        
        __weak typeof(self) weakSelf = self;
        _iTeacherVideoView.oneKeyResetBlock = ^{//全部恢复
            
            [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:@{} completion:nil];
            
            NSArray *sArray = [NSArray arrayWithArray:weakSelf.iStudentSplitViewArray];
            for (TKVideoSmallView *view in sArray) {
                
                view.isSplit = YES;
                [weakSelf beginTKSplitScreenView:view];
               
            }
            
            //将拖拽的视频还原
            for (TKVideoSmallView *view  in weakSelf.iStudentVideoViewArray) {
                
                [weakSelf updateMvVideoForPeerID:view.iPeerId];
                view.isDrag = NO;
                view.isDragWhiteBoard = NO;
            }
            
            [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
           
            [weakSelf refreshBottom];
        };
        
        [_iRightView addSubview:_iTeacherVideoView];
        
       
    }
    //我
    {
        CGFloat tOurVideoViewHeight = (_iRoomType == RoomType_OneToOne)?sTeacherVideoViewHeigh*Proportion:0;
        _iOurVideoView= ({
            
            TKVideoSmallView *tOurVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tViewCap,CGRectGetMaxY(_iTeacherVideoView.frame)+tViewCap, tViewWidth, tOurVideoViewHeight) aVideoRole:EVideoRoleOur];
            tOurVideoView.iPeerId = @"";
             tOurVideoView.iEduClassRoomSessionHandle = _iSessionHandle;
            tOurVideoView.iVideoViewTag = -2;
            tOurVideoView.isNeedFunctionButton = (_iUserType==UserType_Teacher);
            tOurVideoView;
            
        });
        [_iRightView addSubview:_iOurVideoView];
        _iOurVideoView.hidden = !tOurVideoViewHeight;
    }
   
    //静音与奖励
    {
        //不是老师，或没上课，隐藏 有1为1
        BOOL tIsHide = (self.iUserType != UserType_Teacher) || (![TKEduSessionHandle shareInstance].isClassBegin)|| (self.iRoomType==RoomType_OneToOne);
        CGFloat tMuteAudioAndRewardViewHeight = !tIsHide?(40*Proportion):0;
        
        self.iMuteAudioAndRewardView = ({
            
            UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(tViewCap, CGRectGetMaxY(self.iOurVideoView.frame), tViewWidth, tMuteAudioAndRewardViewHeight)];
            //tView.backgroundColor = [UIColor yellowColor];
            tView;
            
            
        });
        self.iMuteAudioAndRewardView.hidden = tIsHide;
        
        //全体静音
        self.iMuteAudioButton = ({
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(tViewCap, 0, tViewWidth / 2 - 5, (40*Proportion))];
            tButton.titleLabel.font = TKFont(13);
            [tButton addTarget:self action:@selector(muteAduoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.iUserType == UserType_Student) {
                [tButton setTitle:MTLocalized(@"Button.CloseAudio") forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenAudio") forState:UIControlStateSelected];
                //                tButton.backgroundColor = RGBACOLOR_ClassBegin_RedDeep;
                tButton.backgroundColor = UIColorRGB(0xecbec0);
            } else {
                [tButton setTitle:MTLocalized(@"Button.MuteAudio") forState:UIControlStateNormal];
                //                tButton.backgroundColor = RGBACOLOR_ClassBegin_RedDeep;
                tButton.backgroundColor = UIColorRGB(0xecbec0);
            }
            
            [TKUtil setCornerForView:tButton];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
            
        });
        
        [self.iMuteAudioAndRewardView addSubview:self.iMuteAudioButton];
        
        //全体发言
        self.iunMuteAllButton = ({
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.iMuteAudioButton.frame)+tViewCap, 0, tViewWidth / 2 - 5, (40*Proportion))];
            tButton.titleLabel.font = TKFont(13);
            
            // [tButton button_exchangeImplementations];
            
            [tButton addTarget:self action:@selector(unMuteAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (self.iUserType == UserType_Student) {
                [tButton setTitle:MTLocalized(@"Button.CloseVideo") forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenVideo") forState:UIControlStateSelected];
            } else {
                tButton.itk_acceptEventInterval = 2;
                [tButton setTitle:MTLocalized(@"Button.MuteAll") forState:UIControlStateNormal];
            }
            
            [TKUtil setCornerForView:tButton];
            tButton.backgroundColor = UIColorRGBA(0x94c4e8, 1);
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
        });
        [self.iMuteAudioAndRewardView addSubview:self.iunMuteAllButton];
        [self.iRightView addSubview:self.iMuteAudioAndRewardView];
        
        //全员奖励
        self.iRewardButton = ({
            
            UIButton *tButton = [[UIButton alloc]initWithFrame: CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap, tViewWidth, (40*Proportion))];
            tButton.titleLabel.font = TKFont(13);
            
            [tButton addTarget:self action:@selector(rewardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.iUserType == UserType_Student) {
                [tButton setTitle:MTLocalized(@"Button.CloseVideo") forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenVideo") forState:UIControlStateSelected];
            } else {
                tButton.itk_acceptEventInterval = 2;
                [tButton setTitle:MTLocalized(@"Button.Reward") forState:UIControlStateNormal];
            }
            
            [TKUtil setCornerForView:tButton];
            tButton.backgroundColor = RGBACOLOR_RewardColor;
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
            
        });
        self.iRewardButton.hidden = tIsHide;
        [self.iRightView addSubview:self.iRewardButton];
        //        [self.iRightView addSubview:self.iMuteAudioAndRewardView];
    }
    //举手按钮
    {
        
        CGFloat tClassBeginAndRaiseHeight =  40*Proportion;
        self.iClassBeginAndOpenAlumdView = ({
            
            UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap+40*Proportion, tViewWidth, tClassBeginAndRaiseHeight)];
            tView.backgroundColor = [UIColor clearColor];
            tView;
            
        });
        
        bool tIsTeacherOrAssis  = (self.iUserType ==UserType_Teacher || self.iUserType ==UserType_Assistant || self.iUserType == UserType_Patrol);
        
        BOOL tIsStdAndRoomOne = (self.iUserType == UserType_Student && self.iRoomType == RoomType_OneToOne);
        
        
        CGFloat tOpenAlumWidth = tIsStdAndRoomOne ?tViewWidth:(tViewWidth / 2 - 5) ;
        tOpenAlumWidth = tIsTeacherOrAssis ?tViewWidth:tOpenAlumWidth;
        CGRect tLeftFrame = CGRectMake(0, 0, tOpenAlumWidth, (40*Proportion));
        CGRect tRightFrame = CGRectMake(tOpenAlumWidth+tViewCap*1, 0, tOpenAlumWidth, (40*Proportion));
        
        
        self.iOpenAlumButton = ({
            
            UIButton *tButton = [[UIButton alloc]initWithFrame:tLeftFrame];
            [tButton addTarget:self action:@selector(openAlbum:) forControlEvents:UIControlEventTouchUpInside];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(15);
            
            [tButton setBackgroundColor:RGBACOLOR_ClassEnd_Red];
            [tButton setTitle:MTLocalized(@"Button.UploadPhoto") forState:UIControlStateNormal];
            tButton.enabled = NO;
            tButton.hidden = tIsTeacherOrAssis;
            [TKUtil setCornerForView:tButton];
            tButton;
            
        });
        
        //上课、下课
        self.iClassBeginAndRaiseHandButton = ({
            
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.iClassBeginAndOpenAlumdView.frame.size.width, (40*Proportion))];
            [tButton addTarget:self action:@selector(classBeginAndRaiseHandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(15);
            
            [tButton setBackgroundColor:RGBACOLOR_ClassBeginAndEnd];
            if (self.iUserType == UserType_Student) {
                tButton.enabled = NO;
                [tButton setBackgroundColor:RGBACOLOR_ClassBeginAndEnd];
                [tButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
                
            }else if(self.iUserType == UserType_Teacher){
                [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
            }else if (self.iUserType == UserType_Patrol){
                [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
                [tButton setBackgroundColor:RGBACOLOR_ClassBeginAndEnd];
                tButton.enabled = NO;
            }
            [TKUtil setCornerForView:tButton];
            tButton;
            
            
        });
        [self.iClassBeginAndOpenAlumdView addSubview:self.iClassBeginAndRaiseHandButton];
//        [self.iClassBeginAndOpenAlumdView addSubview:self.iOpenAlumButton];
        [self.iRightView addSubview:self.iClassBeginAndOpenAlumdView];
        
        // 举手按钮添加长按手势
//        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handsupPressHold:)];
//        [self.iClassBeginAndRaiseHandButton addGestureRecognizer:longPressGR];
//        [self.iClassBeginAndRaiseHandButton addTarget:self action:@selector(handsupPressHold:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        
        //处理按钮点击事件
        [self.iClassBeginAndRaiseHandButton addTarget:self action:@selector(handTouchDown)forControlEvents: UIControlEventTouchDown];
        //处理按钮松开状态
        [self.iClassBeginAndRaiseHandButton addTarget:self action:@selector(handTouchUp)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    
    [self loadChatView:tViewCap];
    
    
}
- (void)loadChatView:(CGFloat)tViewCap{
    //聊天
    {
        CGFloat tChatHeight       = sRightViewChatBarHeight*Proportion;
        
        CGFloat tChatTableHeight  = CGRectGetHeight(_iRightView.frame)-CGRectGetMaxY(_iClassBeginAndOpenAlumdView.frame)-tChatHeight-tViewCap;
        _iChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iClassBeginAndOpenAlumdView.frame)+tViewCap, CGRectGetWidth(_iRightView.frame), tChatTableHeight) style:UITableViewStylePlain];
        _iChatTableView.backgroundColor = [UIColor clearColor];
        _iChatTableView.separatorColor  = [UIColor clearColor];
        _iChatTableView.showsHorizontalScrollIndicator = NO;
        
        _iChatTableView.delegate   = self;
        _iChatTableView.dataSource = self;
        _iChatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_iChatTableView registerClass:[TKMessageTableViewCell class] forCellReuseIdentifier:sMessageCellIdentifier];
        [_iChatTableView registerClass:[TKStudentMessageTableViewCell class] forCellReuseIdentifier:sStudentCellIdentifier];
        [_iChatTableView registerClass:[TKTeacherMessageTableViewCell class] forCellReuseIdentifier:sDefaultCellIdentifier];
        [_iRightView addSubview:_iChatTableView];
        
        //初始化点击手势
        UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTranslation:)];
        tagGesture.numberOfTapsRequired = 1;
        [_iChatTableView addGestureRecognizer:tagGesture];
        
        _inputContainerFrame = CGRectMake(0, CGRectGetMaxY(_iChatTableView.frame), sRightWidth*Proportion, tChatHeight);
        _inputContainer  = ({
            
            TGInputToolBarView *tTollBarView =  [[TGInputToolBarView alloc] initWithFrame:_inputContainerFrame];
            tTollBarView.backgroundColor       = RGBCOLOR(62,62,62);
            //tTollBarView.layer.backgroundColor = RGBCOLOR(247,247,247).CGColor;
            tTollBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
            tTollBarView;
            
        });
        if (_iUserType != UserType_Patrol) {
            [_iRightView addSubview:_inputContainer];
        }
        
        _iChatView = [[TKChatView alloc]init];
        UIButton *tButton = ({
            
            CGRect tInPutInerContainerRect = CGRectMake(1, 1, CGRectGetWidth(_inputContainer.frame)-1, CGRectGetHeight(_inputContainer.frame)-1);
            UIButton *tSendButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            tSendButton.frame = tInPutInerContainerRect;
            
            [tSendButton setTitle:MTLocalized(@"Say.say") forState:UIControlStateNormal];
            tSendButton.titleLabel.font = TKFont(10);
            tSendButton.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
            [tSendButton addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
            tSendButton;
        });
        
        [_inputContainer addSubview:tButton];
        
#pragma mark - 常用语
        self.xc_commonButton = ({
            UIImage *xc_img = UIIMAGE_FROM_NAME(@"changyongyu_wei");
            CGFloat tSendButtonX = (sRightWidth-xc_img.size.width-4)*Proportion-10;
            UIButton *tSendButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            tSendButton.frame = CGRectMake(tSendButtonX, (tButton.height-xc_img.size.height)/2.0, xc_img.size.width, xc_img.size.height);
            [tSendButton setImage:UIIMAGE_FROM_NAME(@"changyongyu_wei") forState:UIControlStateNormal];
            [tSendButton setImage:UIIMAGE_FROM_NAME(@"chongyongyu_yi") forState:UIControlStateSelected];
            
            tSendButton.titleLabel.font = TKFont(10);
            
#pragma mark - 注销  不然button会移动
            //            tSendButton.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
            
            [tSendButton addTarget:self action:@selector(replyAction2:) forControlEvents:UIControlEventTouchUpInside];
            tSendButton;
        });
        [tButton addSubview:self.xc_commonButton];
#pragma mark - 常用语
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
   
}
#pragma mark - 分屏/取消分屏
- (void)beginTKSplitScreenView:(TKVideoSmallView*)videoView{
    
    if (!videoView.isSplit) {
        
        //1.在_iStudentVideoViewArray 中删除视图
        NSArray *videoArray = [NSArray arrayWithArray:_iStudentVideoViewArray];
        
        for (TKVideoSmallView *view in videoArray) {
            
            if (view.iVideoViewTag == videoView.iVideoViewTag) {
                
                [_iStudentVideoViewArray removeObject:view];
                
            }
        }
        //2.在_iStudentSplitViewArray 分屏数组中添加视图
        [_iStudentSplitViewArray addObject:videoView];
        _splitScreenView.hidden = NO;
        videoView.isSplit = YES;
        [_splitScreenView addVideoSmallView:videoView];
        BOOL isbool = [_iStudentSplitScreenArray containsObject: videoView.iRoomUser.peerID];
        if (!isbool) {
            [_iStudentSplitScreenArray addObject:videoView.iRoomUser.peerID];
            
        }
        
    }else{//取消分屏
        
        
        [_iStudentVideoViewArray addObject:videoView];
        
        [_iStudentSplitScreenArray removeObject:videoView.iRoomUser.peerID];
        
        [_splitScreenView deleteVideoSmallView:videoView];
        
        [_iStudentSplitViewArray removeObject:videoView];
        
        if (_iStudentSplitScreenArray.count<=0) {
            _splitScreenView.hidden = YES;
        }
        [self sendMoveVideo:_iPlayVideoViewDic aSuperFrame:_iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
        
        videoView.isSplit = NO;
    }
    
    videoView.isDrag = NO;
    videoView.isDragWhiteBoard = NO;
    
    if (_iUserType == UserType_Teacher) {//发送分屏信令
        NSString *str = [TKUtil dictionaryToJSONString:@{@"userIDArry":_iStudentSplitScreenArray}];
        [_iSessionHandle sessionHandlePubMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        
    }
    
    [self refreshBottom];
   
}

-(void)initWhiteBoardView{
   
    CGFloat tWidth =  ScreenW-sRightWidth*Proportion;
    CGFloat tHeight = ScreenH - CGRectGetMaxY(_titleView.frame);
    CGRect tFrame = CGRectMake(0, CGRectGetMaxY(_titleView.frame),tWidth, tHeight);
    if (_iRoomType == RoomType_OneToOne) {
        tFrame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), tWidth, tHeight);
    }
    
    TKEduRoomProperty *tClassRoomProperty  = _iRoomProperty;
    NSDictionary *tDic = _iParamDic;
    _iTKEduWhiteBoardView = [_iSessionHandle.iBoardHandle createWhiteBoardWithFrame:tFrame UserName:@"" aBloadFinishedBlock:^{
        
        [TKEduNetManager getGiftinfo:tClassRoomProperty.iRoomId aParticipantId: tClassRoomProperty.iUserId  aHost:tClassRoomProperty.sWebIp aPort:tClassRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
#if TARGET_IPHONE_SIMULATOR
                int result = 0;
                result = [[response objectForKey:@"result"]intValue];
                if (!result || result == -1) {
                    
                    NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                    int giftnumber = 0;
                    for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                        if (![tClassRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
                            NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                            if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:tClassRoomProperty.iUserId]) {
                                
                                giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                                break;
                                
                            }
                        }
                    }
                    
                    [[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:tDic aProperties:@{sGiftNumber:@(giftnumber)}];
                    
                }
#else
           
                int result = 0;
                result = [[response objectForKey:@"result"]intValue];
                if (!result || result == -1) {
                    
                    NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                    int giftnumber = 0;
                    for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                        if (![tClassRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
                            NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                            if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:tClassRoomProperty.iUserId]) {
                                
                                giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                                break;
                                
                            }
                        }
                    }
                  
                    [[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:tDic aProperties:@{sGiftNumber:@(giftnumber)}];
                    
                }
#endif
            });
            
        } aGetGifInfoError:^int(NSError * _Nullable aError) {
         
            dispatch_async(dispatch_get_main_queue(), ^{
              
                 [[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:tDic aProperties:nil];
            });
            
            return 1;
        }];
    } aRootView:_iScroll];
    
    tk_weakify(self);
    _iSessionHandle.iBoardHandle.WarningAlert = ^{
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"白板警告" message:@"WKWebView 总体内存占用过大，页面即将白屏" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *tAction = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Know") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alter addAction:tAction];
        [weakSelf presentViewController:alter animated:YES completion:nil];
    };
    
    [_iScroll addSubview:_iTKEduWhiteBoardView];
    
    _iMidView = ({
       
        UIView *tMidView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iTKEduWhiteBoardView.frame), ScreenW-sRightWidth*Proportion,0)];
        tMidView;
        
    });
  
    
    [_iScroll addSubview:_iMidView];
    [self refreshWhiteBoard:NO];

}
//初始化分屏视图
- (void)initSplitScreenView{
    
    CGFloat tWidth =  ScreenW-sRightWidth*Proportion;
    CGFloat tMidHeight = CGRectGetHeight(_iClassTimeView.frame);
    CGRect tFrame = CGRectMake(0, 0, tWidth, (CGRectGetHeight(_iRightView.frame) - tMidHeight*2));
    self.splitScreenView = [[TKSplitScreenView alloc]initWithFrame:tFrame];
    [self.iTKEduWhiteBoardView addSubview:self.splitScreenView];
    self.splitScreenView.hidden = YES;
}

-(void)refreshWhiteBoard:(BOOL)hasAnimate{
    
    CGFloat tWidth =  ScreenW-sRightWidth*Proportion;
    CGFloat tHeight = ScreenH - CGRectGetMaxY(_titleView.frame);
    
    CGRect tFrame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), tWidth, tHeight);
    
    [_iScroll bringSubviewToFront:_iTKEduWhiteBoardView];
    
    // 去掉了判断1对1
    _iBottomView.hidden = (_iRoomType == RoomType_OneToOne)? ![self onlyAssistantOrTeacherPublished] : ![TKEduSessionHandle shareInstance].iHasPublishStd;
    if (_iRoomType == RoomType_OneToOne) {
        tFrame =  [self onlyAssistantOrTeacherPublished] ? CGRectMake(0, CGRectGetMaxY(_titleView.frame), tWidth, tHeight-(self.VideoSmallViewLittleHeigh+2*VideoSmallViewMargins)) : tFrame;
    } else {
        tFrame = [TKEduSessionHandle shareInstance].iHasPublishStd ?CGRectMake(0, CGRectGetMaxY(_titleView.frame), tWidth, tHeight-(self.VideoSmallViewLittleHeigh+2*VideoSmallViewMargins)) : tFrame;
    }
    
    if (hasAnimate) {
        [UIView animateWithDuration:0.1 animations:^{
            _iTKEduWhiteBoardView.frame = tFrame;
            
            _splitScreenView.frame = CGRectMake(0, 0, CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
            // MP3图标位置变化,但是MP4的位置不需要变化
            if (!_iMediaView.hasVideo) {
                _iMediaView.frame = CGRectMake(0, CGRectGetMaxY(_iTKEduWhiteBoardView.frame)-57, CGRectGetWidth(self.iTKEduWhiteBoardView.frame), 57);
            }
            _iMidView.frame =  CGRectMake(0, CGRectGetMaxY(_iTKEduWhiteBoardView.frame), ScreenW-sRightWidth*Proportion,0);
            [[TKEduSessionHandle shareInstance].iBoardHandle refreshWebViewUI];
            [self refreshBottom];
            if (_iMvVideoDic && _iStudentSplitViewArray.count<=0) {
                [self moveVideo:_iMvVideoDic];//视频位置会乱掉所以注释掉了
                
            }
            
        }];
    }else{
        
        _iTKEduWhiteBoardView.frame = tFrame;
        
        _splitScreenView.frame = CGRectMake(0, 0, CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
        _iMidView.frame =  CGRectMake(0, CGRectGetMaxY(_iTKEduWhiteBoardView.frame), ScreenW-sRightWidth*Proportion,0);
        [[TKEduSessionHandle shareInstance].iBoardHandle refreshWebViewUI];
        [self refreshBottom];
        if (_iMvVideoDic) {
            
            [self moveVideo:_iMvVideoDic];
            
        }
    }
    
}
- (BOOL)onlyAssistantOrTeacherPublished {
    for (TKRoomUser *user in [_iSessionHandle.iPublishDic allValues]) {
        if (user.role == UserType_Assistant) {
            return YES;
        }
    }
    return NO;
}

-(void)initBottomView{
    
    _iBottomView = ({
        UIView *tBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - (self.VideoSmallViewLittleHeigh+2*VideoSmallViewMargins), ScreenW-sRightWidth*Proportion, self.VideoSmallViewLittleHeigh+2*VideoSmallViewMargins)];
        tBottomView;
    });
    
    _iBottomView.backgroundColor = RGBCOLOR(48, 48, 48);
    [_iScroll addSubview:_iBottomView];

    CGFloat tWidth = self.VideoSmallViewLittleWidth;
    CGFloat tHeight = self.VideoSmallViewLittleHeigh;
    CGFloat tCap = VideoSmallViewMargins;
    CGFloat w = ((ScreenW-sRightWidth*Proportion-7*VideoSmallViewMargins)/6);
    for (NSInteger i = 0; i < _iRoomProperty.iMaxVideo.intValue-1; ++i) {
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*2 + tWidth,tCap + CGRectGetMinY(_iBottomView.frame), tWidth, tHeight) aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.originalWidth = w;
        tOurVideoBottomView.originalHeight = (w/4.0 * 3.0)+(w /4.0 * 3.0)/7;
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = i;
        tOurVideoBottomView.isDrag          = NO;
        tOurVideoBottomView.isSplit         = NO;
        tOurVideoBottomView.isNeedFunctionButton = (_iUserType==UserType_Teacher);
        tOurVideoBottomView.iEduClassRoomSessionHandle = _iSessionHandle;
        tOurVideoBottomView.hidden = NO;
        tOurVideoBottomView.iNameLabel.text = [NSString stringWithFormat:@"%@",@(i)];
        
        // 判断当前视频窗口是否与白板相交
        __weak typeof(TKVideoSmallView *) wtOurVideoBottomView = tOurVideoBottomView;
        tOurVideoBottomView.isWhiteboardContainsSelfBlock = ^BOOL{
            return CGRectContainsRect(self.iTKEduWhiteBoardView.frame, wtOurVideoBottomView.frame);
        };
        
        // 接收到调整大小的信令
        tOurVideoBottomView.onRemoteMsgResizeVideoViewBlock = ^CGRect(CGFloat scale) {
            CGRect wbRect = self.iTKEduWhiteBoardView.frame;
            CGRect videoRect = wtOurVideoBottomView.frame;
            CGFloat height = wtOurVideoBottomView.originalHeight * scale;
            CGFloat width = wtOurVideoBottomView.originalWidth *scale;
            CGPoint oldCenter = wtOurVideoBottomView.center;
            
            
//             top 1, right 2, bottom 3, left 4
            NSInteger vcrossEdge = 0;
            NSInteger hcrossEdge = 0;

            if (videoRect.origin.x <= wbRect.origin.x) {
                // 垂直边左相交
                vcrossEdge = 4;
            }
            if (videoRect.origin.x + videoRect.size.width >= wbRect.origin.x + wbRect.size.width) {
                // 垂直边右相交
                vcrossEdge = 2;
            }
            if (videoRect.origin.y <= wbRect.origin.y) {
                // 水平便顶相交
                hcrossEdge = 1;
            }
            if (videoRect.origin.y + videoRect.size.height >= wbRect.origin.y + wbRect.size.height) {
                // 水平便底相交
                hcrossEdge = 3;
            }

            if (vcrossEdge == 0 && hcrossEdge == 0) {

                return CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
            }

            if (vcrossEdge == 0 && hcrossEdge == 1) {//水平便顶相交
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }

            if (vcrossEdge == 0 && hcrossEdge == 3) {//水平便底相交
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }

            if (vcrossEdge == 2 && hcrossEdge == 0) {//垂直边右相交
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }

            if (vcrossEdge == 4 && hcrossEdge == 0) {//垂直边左相交
                CGFloat x = wbRect.origin.x;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }

            if (vcrossEdge == 4 && hcrossEdge == 1) {//垂直边左相交 水平便顶相交
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }

            if (vcrossEdge == 4 && hcrossEdge == 3) {//垂直边左相交 水平便底相交
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }

            if (vcrossEdge == 2 && hcrossEdge == 1) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }

            if (vcrossEdge == 2 && hcrossEdge == 3) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            return CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
            
        };
        
        
        
        
        // 当缩放的视频窗口超出白板区域，调整视频窗口大小
        tOurVideoBottomView.resizeVideoViewBlock = ^CGRect{
            CGRect wbRect = self.iTKEduWhiteBoardView.frame;
            CGRect videoRect = wtOurVideoBottomView.frame;
            CGFloat height = 0;
            CGFloat width = 0;
            
            // 如果横边和竖边都相交
            if ((videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width || videoRect.origin.x < wbRect.origin.x) &&
                (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height || videoRect.origin.y < wbRect.origin.y)) {
                width = (wtOurVideoBottomView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) ? (wtOurVideoBottomView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) * 2;
                height = (wtOurVideoBottomView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) ? (wtOurVideoBottomView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) * 2;
                if (width <= height * sStudentVideoViewWidth / sStudentVideoViewHeigh) {
                    height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                    return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
                }
                
                if (height <= width * sStudentVideoViewHeigh / sStudentVideoViewWidth) {
                    width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                    return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
                }
                
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
           
            // 如果是竖边界相交
            if (videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width ||
                videoRect.origin.x < wbRect.origin.x) {
                width = (wtOurVideoBottomView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) ? (wtOurVideoBottomView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) * 2;
                height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            // 如果是横边相交
            if (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height ||
                videoRect.origin.y < wbRect.origin.y) {
                height = (wtOurVideoBottomView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) ? (wtOurVideoBottomView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) * 2;
                width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
        };
        
        __weak typeof(self) weakSelf = self;
        tOurVideoBottomView.finishScaleBlock = ^{
            //缩放之后发布一下位移
            if (_iUserType == UserType_Teacher) {
                [weakSelf sendMoveVideo:_iPlayVideoViewDic aSuperFrame:_iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            }
            
        };
        //分屏按钮回调
        tOurVideoBottomView.splitScreenClickBlock = ^(EVideoRole aVideoRole) {
            //学生分屏开始
            [weakSelf beginTKSplitScreenView:wtOurVideoBottomView];
            
            NSArray *videoArray = [NSArray arrayWithArray:_iStudentVideoViewArray];
            NSArray *array = [NSArray arrayWithArray:_iStudentSplitScreenArray];
            for (TKVideoSmallView *view in videoArray) {
                BOOL isbool = [self.iStudentSplitScreenArray containsObject: view.iRoomUser.peerID];
                if (view.isDrag && !view.isSplit && !isbool && array.count>0) {
                    [self.iStudentSplitScreenArray addObject:view.iRoomUser.peerID];
                    [self beginTKSplitScreenView:view];
                }
            }
        };
        // 添加长按手势
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        [tOurVideoBottomView addGestureRecognizer:longGes];
        [_iStudentVideoViewArray addObject:tOurVideoBottomView];
    }

}

-(void)refreshBottom{
 
    CGFloat tWidth = self.VideoSmallViewLittleWidth;
    CGFloat tHeight = self.VideoSmallViewLittleHeigh;
    CGFloat tCap = VideoSmallViewMargins;
    CGFloat left    = tCap;
    
    BOOL tStdOutBottom = NO;
    
    for (TKVideoSmallView *view in _iStudentVideoViewArray) {

        if (view.iRoomUser) {
            
            if (!view.isSplit && view.isDrag == NO) {//判断是否分屏
                [_iScroll addSubview:view];
                view.alpha  = 1;
                view.frame = CGRectMake(left, tCap+CGRectGetMaxY(_iMidView.frame), tWidth, tHeight);
                left += tCap + tWidth;
                
            }else{
                if (view.isDragWhiteBoard) {
                    view.frame = CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
                }
                BOOL isEndMvToScrv = ((CGRectGetMaxY(view.frame) <= CGRectGetMinY(_iBottomView.frame)));
                if (!view.superview) {
                    [_iScroll addSubview:view];
                }
                if (isEndMvToScrv) {

                    view.isDrag = YES;
                    view.isDragWhiteBoard = YES;
                    tStdOutBottom = YES;
                    //view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    continue;
                }
                //view.transform = CGAffineTransformIdentity;
                view.isDrag = NO;
                
                
                
                view.alpha  = 1;
                view.frame = CGRectMake(left, tCap+CGRectGetMaxY(_iMidView.frame), tWidth, tHeight);
                left += tCap + tWidth;
                
            }
            
        }
        else {

            if (view.superview) {
                [view removeFromSuperview];
            }
        }
        
        if(view.iRoomUser.peerID){
            
            [_iPlayVideoViewDic setObject:view forKey:view.iRoomUser.peerID];
        }

    }
    [TKEduSessionHandle shareInstance].iStdOutBottom = tStdOutBottom;
    //修改文档全屏状态下层级关系
    if ([TKEduSessionHandle shareInstance].iIsFullState) {
        [_iScroll bringSubviewToFront:_iTKEduWhiteBoardView];
    }else{
        [_iScroll sendSubviewToBack:_iTKEduWhiteBoardView];
    }
    
    
}
#pragma mark - 初始化回放工具条
- (void)initPlaybackMaskView {
    self.playbackMaskView = [[TKPlaybackMaskView alloc] initWithFrame:CGRectMake(0, 20+sDocumentButtonWidth*Proportion, ScreenW, ScreenH - 20+sDocumentButtonWidth*Proportion)];
    [self.view addSubview:self.playbackMaskView];
    
    UITapGestureRecognizer* tapMaskViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlaybackMaskTool:)];
//    tapMaskViewGesture.delegate = self;
    [self.playbackMaskView addGestureRecognizer:tapMaskViewGesture];
}
- (void)showPlaybackMaskTool:(UIGestureRecognizer *)gesture {
    self.playbackMaskView.bottmView.hidden = !self.playbackMaskView.bottmView.hidden;
}
- (void)createTimer {
    
    if (!_iCheckPlayVideotimer) {
         __weak typeof(self)weekSelf = self;
        _iCheckPlayVideotimer = [[TKTimer alloc]initWithTimeout:0.5 repeat:YES completion:^{
            __strong typeof(self)strongSelf = weekSelf;
            
            [strongSelf checkPlayVideo];
            
            
        } queue:dispatch_get_main_queue()];
        
        [_iCheckPlayVideotimer start];
       
        
    }
    
}
- (void)invalidateTimer {
    
    if (_iCheckPlayVideotimer) {
        [_iCheckPlayVideotimer invalidate];
        _iCheckPlayVideotimer = nil;
    }
    [self invalidateClassReadyTime];
    [self invalidateClassBeginTime];
    [self invalidateClassCurrentTime];
}

#pragma mark play video  在定时器中检测音视频状态，举手状态
-(void)checkPlayVideo{
    
/*
  usr->_properties:
 candraw = 0;
 hasaudio = 1;
 hasvideo = 1;
 nickname = test;
 publishstate = 3;
 role = 0;
 */

    BOOL tHaveRaiseHand = NO;
    BOOL tIsMuteAudioState = YES;
    for (TKRoomUser *usr in [_iSessionHandle userStdntAndTchrArray]) {
        BOOL tBool = [[usr.properties objectForKey:@"raisehand"]boolValue];
        if (tBool && !tHaveRaiseHand) {
            tHaveRaiseHand = YES;
        }
        if ((usr.publishState == PublishState_AUDIOONLY || usr.publishState == PublishState_BOTH) &&usr.role != UserType_Teacher && tIsMuteAudioState) {
           
            tIsMuteAudioState = NO;
        }
        
    }
    
    if (_iUserType == UserType_Teacher) {
        
        if (tIsMuteAudioState) {
            [TKEduSessionHandle shareInstance].isMuteAudio = YES;
            self.iMuteAudioButton.enabled = NO;
            self.iMuteAudioButton.backgroundColor = RGBACOLOR_muteAudio_Normal;
            
            
            [TKEduSessionHandle shareInstance].isunMuteAudio = NO;
            self.iunMuteAllButton.enabled = YES;
            self.iunMuteAllButton.backgroundColor = RGBACOLOR_unMuteAudio_Select;
            
        }else{
            [TKEduSessionHandle shareInstance].isMuteAudio = NO;
            self.iMuteAudioButton.enabled = YES;
            self.iMuteAudioButton.backgroundColor = RGBACOLOR_muteAudio_Select;
            
            
            [TKEduSessionHandle shareInstance].isunMuteAudio = YES;
            self.iunMuteAllButton.enabled = NO;
            self.iunMuteAllButton.backgroundColor = RGBACOLOR_unMuteAudio_Normal;
        }
        
        

    }
    
    _iUserButton.selected = tHaveRaiseHand;
    
     //TKLog(@"1------checkPlayVideo:%@,%@",tHaveRaiseHand?@"举手":@"取消举手",tIsMuteAudioState?@"静音":@"非静音");
}
#pragma mark - 播放
-(void)playVideo:(TKRoomUser *)user {
   
    NSLog(@"播放%@的视频", user.nickName);
    
    [_iSessionHandle delUserPlayAudioArray:user.peerID];
    
    TKVideoSmallView* viewToSee = nil;
    if (user.role == UserType_Teacher)
        viewToSee = _iTeacherVideoView;
    else if ((_iRoomType == RoomType_OneToOne && user.role == UserType_Student) ||(_iRoomType == RoomType_OneToOne && user.role == UserType_Patrol)) {
        viewToSee = _iOurVideoView;
    }
    else
        for (TKVideoSmallView* view in _iStudentVideoViewArray) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:user.peerID]) {
                viewToSee = nil;
                break;
            }
            else if(view.iRoomUser == nil && !viewToSee) {
                viewToSee = view;
            }
        }
    
    if (viewToSee && viewToSee.iRoomUser == nil) {
        
        [self myPlayVideo:user aVideoView:viewToSee completion:^(NSError *error) {
            
            if (!error) {
                [_iPlayVideoViewDic setObject:viewToSee forKey:user.peerID];
                
                if (_iSessionHandle.iIsFullState) {
                    return;
                }
                [self refreshUI];
            }
        }];
    }
}

-(void)unPlayVideo:(NSString *)peerID {
    
    TKVideoSmallView* viewToSee = nil;
    if ([peerID isEqualToString:_iTeacherVideoView.iPeerId])
        viewToSee = _iTeacherVideoView;
    else if (_iRoomType == RoomType_OneToOne && [peerID isEqualToString:_iOurVideoView.iPeerId]) {
        viewToSee = _iOurVideoView;
    }
    else
    {
        for (TKVideoSmallView* view in _iStudentVideoViewArray) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
                viewToSee = view;
                break;
            }
        }
        for (TKVideoSmallView* view in _splitScreenView.videoSmallViewArray) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
                
               viewToSee = view;
                break;
            }
        }
        
    }
    
    if (viewToSee && viewToSee.iRoomUser != nil && [viewToSee.iRoomUser.peerID isEqualToString:peerID]) {
        
        __weak typeof(self)weekSelf = self;
        NSMutableDictionary *tPlayVideoViewDic = _iPlayVideoViewDic;
        
        NSArray *array = [NSArray arrayWithArray:_iStudentSplitScreenArray];
        for (NSString *peerId in array) {
            if([peerId isEqualToString:peerID]) {

                [_iStudentVideoViewArray addObject:viewToSee];
                
                [_iStudentSplitViewArray removeObject:viewToSee];
                
            }
        }
        
        [self myUnPlayVideo:peerID aVideoView:viewToSee completion:^(NSError *error) {
            
            [tPlayVideoViewDic removeObjectForKey:peerID];
            
            __strong typeof(weekSelf) strongSelf =  weekSelf;
            
            [strongSelf updateMvVideoForPeerID:peerID];
            if (!_iSessionHandle.iIsFullState) {
                [strongSelf refreshUI];
            }
            
        }];
    }
     [_iSessionHandle delePendingUser:peerID];
}

//更新视频窗口的位置以及拖放状态
-(void)updateMvVideoForPeerID:(NSString *)aPeerId {
    
    if (!aPeerId) {
        return;
    }
    NSDictionary *tVideoViewDic = (NSDictionary*) [_iMvVideoDic objectForKey:aPeerId];
    NSMutableDictionary *tVideoViewDicNew = [NSMutableDictionary dictionaryWithDictionary:tVideoViewDic];
    [tVideoViewDicNew setObject:@(NO) forKey:@"isDrag"];
    [tVideoViewDicNew setObject:@(0) forKey:@"percentTop"];
    [tVideoViewDicNew setObject:@(0) forKey:@"percentLeft"];
    [_iMvVideoDic setObject:tVideoViewDicNew forKey:aPeerId];
    
    
}
-(void)myUnPlayVideo:(NSString *)peerID aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    [_iSessionHandle sessionHandleUnPlayVideo:peerID completion:^(NSError *error) {
        
        //更新uiview
        [aVideoView clearVideoData];
        
        TKLog(@"----unplay:%@ frame:%@ VideoView:%@",peerID,@(aVideoView.frame.size.width),@(aVideoView.iVideoViewTag));
        completion(error);
        
    }];
}
-(void)myPlayVideo:(TKRoomUser *)aRoomUser aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    
    TKLog(@"----play:%@ aVideoView.iPeerId:%@ frame:%@ VideoView:%@",aRoomUser.nickName,aRoomUser.peerID,@(aVideoView.frame.size.width),@(aVideoView.iVideoViewTag));
    
    [_iSessionHandle sessionHandlePlayVideo:aRoomUser.peerID renderType:1 window:aVideoView completion:^(NSError *error) {
        aVideoView.iPeerId        = aRoomUser.peerID;
        aVideoView.iRoomUser      = aRoomUser;
        [aVideoView changeAudioDisabledState]; // 当用户初始播放时，没有发送属性改变的通知，需要手动设置
        [aVideoView changeVideoDisabledState]; // 当用户初始播放时，没有发送属性改变的通知，需要手动设置
        if ([aRoomUser.peerID isEqualToString:_iSessionHandle.localUser.peerID]) {
            [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Me")]];
        }else if (aRoomUser.role == UserType_Teacher){
            [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Teacher")]];
        }else{
            [aVideoView changeName:aRoomUser.nickName];
        }
            //进入后台的提示
        BOOL isInBackGround = [aRoomUser.properties[sIsInBackGround] boolValue];
        
        [aVideoView endInBackGround:isInBackGround];
        completion(error);
    }];
   
}

-(void)initTapGesTureRecognizer{
    UITapGestureRecognizer* tapTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
    tapTableGesture.delegate = self;
    [_iScroll addGestureRecognizer:tapTableGesture];
}


-(void)leftButtonPress:(UIButton *)sender{
    
    if (_isQuiting) {return;}
    [self tapTable:nil];
    
 
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.prompt") message:MTLocalized(@"Prompt.Quite") preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sender.enabled = NO;
        _isQuiting = YES;
        [self prepareForLeave:YES];
    }];
    UIAlertAction *tActionCancel = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        sender.enabled = YES;
        _isQuiting = NO;
    }];
    [alter addAction:tActionSure];
    [alter addAction:tActionCancel];
    
    [self presentViewController:alter animated:YES completion:nil];
    
   
   
}

//如果是自己退出，则先掉leftroom。否则，直接退出。
-(void)prepareForLeave:(BOOL)aQuityourself
 {
     
    [self tapTable:nil];
    
     [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
    [self invalidateTimer];
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
   
    if ([UIApplication sharedApplication].statusBarHidden) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication]
         setStatusBarHidden:NO
         withAnimation:UIStatusBarAnimationNone];
        
#pragma clang diagnostic pop
        
    }
    
     if (aQuityourself) {
         [self unPlayVideo:_iSessionHandle.localUser.peerID];         // 进入教室不点击上课就退出，需要关闭自己视频
         [_iSessionHandle.iBoardHandle clearAllWhiteBoardData];
         [_iSessionHandle sessionHandleLeaveRoom:nil];
         [_iSessionHandle.iBoardHandle cleanup];
         [TKEduSessionHandle destory];
     }else{
         // 清理数据
         [self quitClearData];
         
         [_iSessionHandle clearAllClassData];
         _iSessionHandle.roomMgr = nil;
         _iSessionHandle = nil;
          [_iSessionHandle.iBoardHandle clearAllWhiteBoardData];
//          [_iTKEduWhiteBoardHandle cleanup];
//         _iTKEduWhiteBoardHandle = nil;
         dispatch_block_t blk = ^
         {
             [TKEduSessionHandle destory];
             [self dismissViewControllerAnimated:YES completion:^{
                 // change openurl
                 if (self.networkRecovered == NO) {
                     [TKUtil showMessage:MTLocalized(@"Error.WaitingForNetwork")];
                 }
                   [[NSNotificationCenter defaultCenter] postNotificationName:sTKRoomViewControllerDisappear object:nil];
             }];
         };
         blk();
     }
    
     _iSessionHandle.iIsClassEnd = NO;

}

#pragma mark TKEduSessionDelegate

// 获取礼物数
- (void)sessionManagerGetGiftNumber:(dispatch_block_t)completion {
    
    // 老师断线重连不需要获取礼物
    if (_iSessionHandle.localUser.role == UserType_Teacher || _iSessionHandle.localUser.role == UserType_Assistant ||
        _iSessionHandle.isPlayback == YES) {
        if (completion) {
            completion();
        }
        return;
    }
    
    // 学生断线重连需要获取礼物
    [TKEduNetManager getGiftinfo:_iRoomProperty.iRoomId aParticipantId: _iRoomProperty.iUserId  aHost:_iRoomProperty.sWebIp aPort:_iRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![_iRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_iRoomProperty.iUserId]) {
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                self.iSessionHandle.localUser.properties[sGiftNumber] = @(giftnumber);
                
                if (completion) {
                    completion();
                }
                
                //[[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:_iParamDic aProperties:@{sGiftNumber:@(giftnumber)}];
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion();
            }
            
            //[[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:_iParamDic aProperties:nil];
        });
        return 1;
    }];
    
}

//自己进入课堂
- (void)sessionManagerRoomJoined{

    self.isConnect = NO;
    
    if([_iSessionHandle.roomMgr getRoomConfigration].endClassTimeFlag) {
        
        [TKEduNetManager systemtime:self.iParamDic Complete:^int(id  _Nullable response) {
            
            if (response) {
                int time =  self.iRoomProperty.iEndTime - [response[@"time"] intValue];//计算距离课堂结束的时间
                //(2)未到下课时间： 老师未点下课->下课时间到->课程结束，一律离开
                //(3)到下课时间->提前5分钟给出提示语（老师，助教）->课程结束，一律离开
                if ((time >0 && time<=300) && self.iSessionHandle.localUser.role == UserType_Teacher) {
                    int ratio = time/60;
                    int remainder = time % 60;
                    if (ratio == 0 && remainder>0) {
                        [TKUtil showClassEndMessage:[NSString stringWithFormat:@"%d%@",remainder,MTLocalized(@"Prompt.ClassEndTimeseconds")]];
                    }else if(ratio>0){
                        [TKUtil showClassEndMessage:[NSString stringWithFormat:@"%d%@",ratio,MTLocalized(@"Prompt.ClassEndTime")]];
                    }
                }
                if (time<=0) {
                    [TKUtil showClassEndMessage:MTLocalized(@"Error.RoomDeletedOrExpired")];
                    [self prepareForLeave:YES];
                    
                }
            }
            
            
            
            return 0;
        } aNetError:^int(id  _Nullable response) {
            
            return 0;
        }];
        _iClassCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(onClassCurrentTimer)
                                                             userInfo:nil
                                                              repeats:YES];
        [_iClassCurrentTimer setFireDate:[NSDate date]];
        
    }
    
    if ([_iSessionHandle.roomMgr getRoomConfigration].documentCategoryFlag) {//文件夹列表显示判断
        _iDocumentListView = [[TKFolderDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH)];
        TKFolderDocumentListView *view = [[TKFolderDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH)];
        view.delegate = self;
        _iMediaListView = view;
    }else{
        _iDocumentListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH)];
        TKDocumentListView *view = [[TKDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH)];
        view.delegate = self;
        _iMediaListView = view;
    }
    [TKEduSessionHandle shareInstance].iMediaListView = _iMediaListView;
    [TKEduSessionHandle shareInstance].iDocumentListView = _iDocumentListView;
    
    _iUsertListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH) ];
    
    
    if (_iUserType == UserType_Teacher) {
        [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
    }
    // 记录选择的服务器
    [[NSUserDefaults standardUserDefaults] setObject:self.currentServer forKey:@"server"];
    
//    [TKEduNetManager getDefaultAreaWithComplete:^int(id  _Nullable response) {
//        if (response) {
//            NSString *serverName = [response objectForKey:@"name"];
//            if (serverName != nil && [TKUtil isDomain:sHost] == YES) {
//                NSArray *array = [sHost componentsSeparatedByString:@"."];
//                NSString *defaultServer = [NSString stringWithFormat:@"%@", array[0]];
//                if ([self.currentServer isEqualToString:defaultServer]) {
//                    self.currentServer = serverName;
//                }
//            }
//            [[TKRoomManager instance] changeCurrentServer:self.currentServer];
//        }
//        return 0;
//    } aNetError:^int(id  _Nullable response) {
//        [[TKRoomManager instance] changeCurrentServer:self.currentServer];
//        return -1;
//    }];
    
    // 断线重连后主动获取奖杯数目
    if (self.networkRecovered == NO) {
        [self getTrophyNumber];
    }
    
    self.networkRecovered = YES;
    
    bool isConform = [TKUtil  deviceisConform];
    if (_iSessionHandle.localUser.role == UserType_Teacher) {
        if (!isConform) {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@YES, @"maxvideo":@(2)}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        } else {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@NO, @"maxvideo":@(_iRoomProperty.iMaxVideo.intValue)}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
    
    // 低能耗老师进入一对多房间，进行提示
    if (!isConform && _iSessionHandle.localUser.role == UserType_Teacher && _iRoomType != RoomType_OneToOne) {
        NSString *message = [NSString stringWithFormat:@"%@", MTLocalized(@"Prompt.devicetPrompt")];
        TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:_iSessionHandle.localUser.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:_iSessionHandle.localUser.nickName aTime:[TKUtil currentTimeToSeconds]];
        [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
        [self refreshData];
    }
    
    // 低能耗学生进入一对多房间，进行提示
    if (!isConform && _iSessionHandle.localUser.role != UserType_Teacher && _iRoomType != RoomType_OneToOne) {
        NSString *message = [NSString stringWithFormat:@"%@", MTLocalized(@"Prompt.devicetPrompt")];
        TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:_iSessionHandle.localUser.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:_iSessionHandle.localUser.nickName aTime:[TKUtil currentTimeToSeconds]];
        [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
        [self refreshData];
    }
    
    // 如果断网之前在后台，回到前台时的时候需要发送回到前台的信令
    if ([_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] &&
        [[_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] boolValue] == YES &&
        _iSessionHandle.localUser.role == UserType_Student &&
        _iSessionHandle.roomMgr.inBackground == NO) {
        
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
    }
    
    [TKEduSessionHandle shareInstance].iIsJoined = YES;
    //设置画笔等权限
    [[TKEduSessionHandle shareInstance] configureDrawAndPageWithControl:[_iSessionHandle.roomMgr getRoomProperty].chairmancontrol];
    
   BOOL isStdAndRoomOne = ([TKEduSessionHandle shareInstance].roomType == RoomType_OneToOne && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student);
   bool tIsTeacherOrAssis  = ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher || [TKEduSessionHandle shareInstance].localUser.role ==UserType_Assistant);
    //巡课不能翻页
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol || [TKEduSessionHandle shareInstance].isPlayback) {
        [[TKEduSessionHandle shareInstance]configurePage:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
        
    }else {
        
         // 翻页权限根据配置项设置
        [[TKEduSessionHandle shareInstance]configurePage:tIsTeacherOrAssis?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
        
        // 涂鸦权限:1.1v1学生根据配置项设置 2.其他情况，没有涂鸦权限 3 非老师断线重连不可涂鸦。 发送:1 1v1 学生发送 2 学生发送，老师不发送
        //[[TKEduSessionHandle shareInstance]configureDraw:isStdAndRoomOne?[TKEduSessionHandle shareInstance].iIsCanDrawInit:false isSend:isStdAndRoomOne?YES:!tIsTeacher to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
        
        
        /*
        if (isStdAndRoomOne) {
            
             [TKEduSessionHandle shareInstance].iIsCanPage =  [TKEduSessionHandle shareInstance].iIsCanPageInit;
             [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission:[TKEduSessionHandle shareInstance].iIsCanPage];
        
            
            [TKEduSessionHandle shareInstance].iIsCanDraw =  [TKEduSessionHandle shareInstance].iIsCanDrawInit;
            [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)([TKEduSessionHandle shareInstance].iIsCanDraw)) completion:nil];
        }else{
            
            // 非老师断线重连不可涂鸦
            if (_iUserType != UserType_Teacher) {
                [TKEduSessionHandle shareInstance].iIsCanDraw = NO;
                [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)([TKEduSessionHandle shareInstance].iIsCanDraw)) completion:nil];
            }
            
            [TKEduSessionHandle shareInstance].iIsCanPage = true;
            [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission: [TKEduSessionHandle shareInstance].iIsCanPage];
        }*/
        
    }
    TKLog(@"tlm-----myjoined 时间: %@", [TKUtil currentTimeToSeconds]);
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    //  [[NSNotificationCenter defaultCenter] addObserver:self
    //  selector:@selector(proximityStateDidChange:)
    //  name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    _iTKEduWhiteBoardView.hidden = NO;
    
    _iUserType       = (UserType)[TKEduSessionHandle shareInstance].localUser.role;
    _iRoomType       = (RoomType)_iSessionHandle.roomType;
    _iRoomProperty.iUserType = _iUserType;
    _isQuiting        = NO;
    _iRoomProperty.iRoomType = _iRoomType;
    _iRoomProperty.iRoomName =_iSessionHandle.roomName;
    _iRoomProperty.iRoomId   =[_iSessionHandle.roomMgr getRoomProperty].roomid;
    _iRoomProperty.iUserId   = _iSessionHandle.localUser.peerID;
    
    NSString* endtime = [_iSessionHandle.roomMgr getRoomProperty].newendtime;
//    [_iSessionHandle.roomProperties objectForKey:@"newendtime"];
  
    if (endtime && [endtime isKindOfClass:[NSString class]] && endtime.length > 0)
    {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceTokendefaultFormatter;
        dispatch_once(&onceTokendefaultFormatter, ^{
            dateFormatter = [[NSDateFormatter alloc]init];
        });
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:endtime];
        _iRoomProperty.iEndTime = [date timeIntervalSince1970];
    }
    else{
         _iRoomProperty.iEndTime  = 0;
    }
    NSString* starttime =  [_iSessionHandle.roomMgr getRoomProperty].newstarttime;
    if (starttime && [starttime isKindOfClass:[NSString class]] && starttime.length > 0)
    {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceTokendefaultFormatter;
        dispatch_once(&onceTokendefaultFormatter, ^{
            dateFormatter = [[NSDateFormatter alloc]init];
        });
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:starttime];
        _iRoomProperty.iStartTime = [date timeIntervalSince1970];
    }
    else{
        _iRoomProperty.iStartTime  = 0;
    }
    _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970];
    

    NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[_iSessionHandle.roomName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
    _titleLable.text =  attrStr.string;
   // _iGiftCount = [[_iSessionHandle.localUser.properties objectForKey:sGiftNumber]integerValue];
    BOOL meHasVideo = _iSessionHandle.localUser.hasVideo;
    BOOL meHasAudio = _iSessionHandle.localUser.hasAudio;
    [_iSessionHandle sessionHandleUseLoudSpeaker:NO];
    
//    if (_connectHUD) {
//        [_connectHUD hide:YES];
//        _connectHUD = nil;
//    }
    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
    if(!meHasVideo){
//        RoomClient.getInstance().warning(1);
        TKLog(@"没有视频");
    }
    if(!meHasAudio){
//        RoomClient.getInstance().warning(2);
         TKLog(@"没有音频");
    }
   
  
    [_iSessionHandle addUserStdntAndTchr:_iSessionHandle.localUser];
    [[TKEduSessionHandle shareInstance] addUser:_iSessionHandle.localUser];
    [self refreshData];
    [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
   
    TKLog(@"tlm----- 课堂加载完成时间: %@", [TKUtil currentTimeToSeconds]);
    
    [_iSessionHandle.iBoardHandle setPageParameterForPhoneForRole:_iUserType];
   
    // 非自动上课房间需要上课定时器
    if ([[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
        [self startClassReadyTimer];
    }
    
    //[_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:NO completion:nil];
    [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:NO AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    
    // 判断上下课按钮是否需要隐藏
    if ( (([_iSessionHandle.roomMgr getRoomConfigration].hideClassBeginEndButton == YES && _iSessionHandle.roomMgr.localUser.role != UserType_Student) || _iSessionHandle.isPlayback == YES)) {
        _iClassBeginAndRaiseHandButton.hidden = YES;
        _iClassBeginAndOpenAlumdView.hidden   = YES;
    }
    
    // 计算课堂结束时间
    expireSeconds = (int)_iRoomProperty.iEndTime + 300;
    
    //是否是自动上课
    if ([_iSessionHandle.roomMgr getRoomConfigration].autoStartClassFlag == YES && _iSessionHandle.isClassBegin == NO && _iSessionHandle.localUser.role == UserType_Teacher && ![[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
    
        [TKEduNetManager classBeginStar:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
            
            _iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassEnd_Red;
            [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
            NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
            //[_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true completion:nil];
            [_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
        
            return 0;
        }aNetError:^int(id  _Nullable response) {
            
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
           
            return 0;
        }];
    }
    //如果是上课的状态则不进行推流的任何操作
    if([TKEduSessionHandle shareInstance].isClassBegin && _iUserType != UserType_Teacher){
        return;
    }
    // 进入房间就可以播放自己的视频
    if (_iUserType != UserType_Patrol && _iSessionHandle.isPlayback == NO) {
        _isLocalPublish = false;
        if ([_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag) {//发布视频
            [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_BOTH) completion:^(NSError *error) {

            }];
        }else{//显示本地视频不发布
            _isLocalPublish = true;
            _iSessionHandle.localUser.publishState = PublishState_Local_NONE;
            [[TKEduSessionHandle shareInstance] addPublishUser:_iSessionHandle.localUser];
            [[TKEduSessionHandle shareInstance] delePendingUser:_iSessionHandle.localUser.peerID];
            [_iSessionHandle.roomMgr enableAudio:YES];
            [_iSessionHandle.roomMgr enableVideo:YES];
            [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
            [self playVideo:_iSessionHandle.localUser];
            
//            [self sessionManagerUserPublished:_iSessionHandle.localUser];
        }
    }
}

//自己离开课堂
- (void)sessionManagerRoomLeft {
    TKLog(@"-----roomManagerRoomLeft");
     _isQuiting = NO;
     [TKEduSessionHandle shareInstance].iIsJoined = NO;
     [_iSessionHandle configurePlayerRoute:NO isCancle:YES];
     [_iSessionHandle delUserStdntAndTchr:_iSessionHandle.localUser.peerID];
     [[TKEduSessionHandle shareInstance]delUser:_iSessionHandle.localUser.peerID];
     [self prepareForLeave:NO];
  
}
//踢出课堂
-(void) sessionManagerSelfEvicted:(NSDictionary *)reason{
    int rea;
    reason = [TKUtil processDictionaryIsNSNull:reason];
    if(reason && [[reason allKeys] containsObject:@"reason"]){
        rea = [reason[@"reason"] intValue];
    }else{
        rea = 0;
    }
    if (_iPickerController) {
        [_iPickerController dismissViewControllerAnimated:YES completion:^{
            
            [self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
            _iPickerController = nil;
            [self sessionManagerRoomLeft];
        }];
    }else{
        [self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
        
        [self sessionManagerRoomLeft];
        TKLog(@"---------SelfEvicted");
    }
   
    
}

//观看视频
- (void)sessionManagerUserPublished:(TKRoomUser *)user {
//    {
//        NSString *msg = [NSString stringWithFormat:@"播放：%@的视频,peerid:%@",user.nickName,user.peerID];
//        //测试删除
//        [self showMessage:msg];
//    }
    
    // ToDo: 线程安全
    [[TKEduSessionHandle shareInstance] addPublishUser:user];
    [[TKEduSessionHandle shareInstance] delePendingUser:user.peerID];
    
    /// 仝磊鸣修改，原来是大于1，由于现在只发布一次，所以先发布音频后发布视频会看不到
    TKLog(@"jin------publish:%@",user.nickName);
    if ([user.peerID isEqualToString:_iSessionHandle.localUser.peerID]) {
        _iSessionHandle.localUser.publishState = user.publishState;
    }
    if (user.publishState >0) {
        
        if (![TKEduSessionHandle shareInstance].isPlayMedia) {
            TKLog(@"---jin sessionManagerUserPublished");
            [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
            
        }
        [self playVideo:user];
    }
    
    if (user.publishState == 1) {
        [_iSessionHandle addOrReplaceUserPlayAudioArray:user];
    }
}

//取消视频
- (void)sessionManagerUserUnpublished:(NSString *)userID {
    
    
    TKLog(@"1------unpublish:%@",userID);
    [_iSessionHandle delUserPlayAudioArray:userID];
    [[TKEduSessionHandle shareInstance] delePublishUser:userID];
    [[TKEduSessionHandle shareInstance] delePendingUser:userID];
    if (_iSessionHandle.localUser.role == UserType_Teacher && _iSessionHandle.iIsClassEnd == YES && [userID isEqualToString:_iTeacherVideoView.iPeerId]) {
        // 老师发布的视频下课不取消播放
    } else {
        [self unPlayVideo:userID];
    }
    
    if (([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) && _iMvVideoDic) {
        NSDictionary *tMvVideoDic = @{@"otherVideoStyle":_iMvVideoDic};
        [[TKEduSessionHandle shareInstance]publishVideoDragWithDic:tMvVideoDic To:sTellAllExpectSender];
    }
   
    if (_iSessionHandle.iHasPublishStd == NO && !_iSessionHandle.iIsFullState) {
        [self refreshUI];
    }
}

//用户进入
- (void)sessionManagerUserJoined:(NSString *)peerID InList:(BOOL)inList {
    TKRoomUser *user = [[TKEduSessionHandle shareInstance].roomMgr getRoomUserWithUId:peerID];
    
   TKLog(@"1------otherJoined:%@ peerID:%@",user.nickName,user.peerID);
    
    UserType tMyRole =(UserType) [TKEduSessionHandle shareInstance].localUser.role;
    RoomType tRoomType = (RoomType)[TKEduSessionHandle shareInstance].roomType;
    if (inList) {
        //1 大班课 //0 小班课
        if ((user.role == UserType_Teacher && tMyRole == UserType_Teacher) || (tRoomType == RoomType_OneToOne && (int)user.role == tMyRole && tMyRole == UserType_Student)) {
            
            [_iSessionHandle sessionHandleEvictUser:user.peerID completion:nil];
            
        }
        
    }
    
    if (tMyRole == UserType_Teacher) {
//        NSString* tChairmancontrol = [_iSessionHandle.roomProperties objectForKey:sChairmancontrol];
//        NSRange range5 = NSMakeRange(23, 1);
//        NSString *str = [tChairmancontrol substringWithRange:range5];
//        if ([str integerValue]) {
//
//        }
    }
    [[TKEduSessionHandle shareInstance] addUser:user];
    //巡课不提示
    NSString *userRole;
    switch (user.role) {
        case UserType_Teacher:
            userRole = MTLocalized(@"Role.Teacher");
            break;
        case UserType_Student:
            userRole = MTLocalized(@"Role.Student");
            break;
        case UserType_Assistant:
            userRole = MTLocalized(@"Role.Assistant");
            break;
        default:
            break;
    }
    if (user.role !=UserType_Patrol) {
        TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:MessageType_Message aMessage:[NSString stringWithFormat:@"%@(%@)%@",user.nickName,userRole, MTLocalized(@"Action.EnterRoom")] aUserName:nil aTime:[TKUtil currentTime]];
        [_iSessionHandle addOrReplaceMessage:tModel];
    }
    BOOL tISpclUser = (user.role != UserType_Student && user.role != UserType_Teacher);
    if (tISpclUser) {
        [[TKEduSessionHandle shareInstance] addSecialUser:user];
    } else {
        [_iSessionHandle addUserStdntAndTchr:user];
    }
   
    [self.iUsertListView reloadData];

    [self refreshData];
    
    // 提示在后台的学生
    //[[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]
    if (_iUserType == UserType_Teacher || _iUserType == UserType_Assistant || _iUserType == UserType_Patrol) {
        if ([user.properties objectForKey:sIsInBackGround] != nil &&
            [[user.properties objectForKey:sIsInBackGround] boolValue] == YES) {
            NSString *deviceType = [user.properties objectForKey:@"devicetype"];
            NSString *message = [NSString stringWithFormat:@"%@ (%@) %@", user.nickName, deviceType, MTLocalized(@"Prompt.HaveEnterBackground")];
            TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:user.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:user.nickName aTime:[TKUtil currentTimeToSeconds]];
            [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
            [self refreshData];
        }
    }
    
}
//用户离开
- (void)sessionManagerUserLeft:(NSString *)peerID {
  
     TKLog(@"1------otherleft:%@",peerID);
    
    [self unPlayVideo:peerID];
   
    BOOL tIsMe = [[NSString stringWithFormat:@"%@",peerID] isEqualToString:[NSString stringWithFormat:@"%@",[TKEduSessionHandle shareInstance].localUser.peerID]];
    
    TKRoomUser *user = [_iSessionHandle getUserWithPeerId:peerID];
    NSString *userRole;
    switch (user.role) {
        case UserType_Teacher:
            userRole = MTLocalized(@"Role.Teacher");
            break;
        case UserType_Student:
            userRole = MTLocalized(@"Role.Student");
            break;
        case UserType_Assistant:
            userRole = MTLocalized(@"Role.Assistant");
            break;
        default:
            break;
    }
    if (user.role != UserType_Patrol && !tIsMe) {
        TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:MessageType_Message aMessage:[NSString stringWithFormat:@"%@(%@)%@",user.nickName,userRole, MTLocalized(@"Action.ExitRoom")] aUserName:nil aTime:[TKUtil currentTime]];
        [_iSessionHandle addOrReplaceMessage:tModel];
    }
   
    //去掉助教等特殊身份
    BOOL tISpclUser = (user.role !=UserType_Student && user.role !=UserType_Teacher);
    if (tISpclUser)
        {[[TKEduSessionHandle shareInstance] delSecialUser:peerID];}
    else
        {[_iSessionHandle delUserStdntAndTchr:peerID];}
    [[TKEduSessionHandle shareInstance] delUser:peerID];
    [self refreshData];
}

//用户信息变化 
- (void)sessionManagerUserChanged:(TKRoomUser *)user Properties:(NSDictionary*)properties fromId:(NSString *)fromId {
    
     TKLog(@"------UserChanged:%@ properties:(%@)",user.nickName,properties);
  
    NSInteger tGiftNumber = 0;
    if ([properties objectForKey:sGiftNumber]) {
         tGiftNumber = [[properties objectForKey:sGiftNumber]integerValue];
       
    }
    
    if ([properties objectForKey:sCandraw] && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID] && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
        bool tCanDraw = [[properties objectForKey:sCandraw]boolValue];
        
        if ([TKEduSessionHandle shareInstance].iIsCanDraw != tCanDraw) {
           
            [[TKEduSessionHandle shareInstance]configureDraw:tCanDraw isSend:NO to:sTellAll peerID:user.peerID];
            
            // 翻页权限：1.有画笔权限，则可以翻页 2.无画笔权限根据配置项
            [[TKEduSessionHandle shareInstance]configurePage:tCanDraw?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:user.peerID];
           
            _iOpenAlumButton.backgroundColor = tCanDraw?RGBACOLOR_ClassBegin_RedDeep:RGBACOLOR_ClassEnd_Red;
            _iOpenAlumButton.enabled = tCanDraw;
            if (!tCanDraw && _OpenAlbumActionSheet) {
                 [_OpenAlbumActionSheet dismissViewControllerAnimated:YES completion:nil];
            }
           
        }
      
    }
    BOOL isRaiseHand = NO;
    if ([properties objectForKey:sRaisehand]) {
        //如果没做改变的话，就不变化
        NSLog(@"------raiseHand%@",[properties objectForKey:sRaisehand]);
        isRaiseHand  = [[properties objectForKey:sRaisehand]boolValue];
        
        // 当用户状态发生变化，用户列表状态也要发生变化
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setValue:@(isRaiseHand) forKey:sRaisehand];
                
                [self.iUsertListView reloadData];
                break;
            }
        }
    }
   
    if ([properties objectForKey:sPublishstate]) {
        PublishState tPublishState = (PublishState)[[properties objectForKey:sPublishstate]integerValue];
        if([_iSessionHandle.localUser.peerID isEqualToString:user.peerID] ) {
            _iSessionHandle.localUser.publishState = (TKPublishState)tPublishState;
            NSLog(@"------sPublishstate%@",[properties objectForKey:sPublishstate]);
            
            if([TKEduSessionHandle shareInstance].isClassBegin){
                if((tPublishState == PublishState_NONE) || (tPublishState == PublishState_VIDEOONLY)) {
                    
                    _iIsCanRaiseHandUp                = YES;
                } else {
                    _iIsCanRaiseHandUp                = NO;
                }
            }else{
                _iIsCanRaiseHandUp                = NO;
            }
            
            if (!_iSessionHandle.iIsFullState) {
                
                [self refreshUI];
            }
        }
        
        if ((tPublishState == PublishState_VIDEOONLY || tPublishState == PublishState_BOTH) &&
            [[_iSessionHandle userPlayAudioArray] containsObject:user.peerID]) {
            [self playVideo:user];
        }
        
        // 当用户状态发生变化，用户列表状态也要发生变化
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.publishState = (TKPublishState)tPublishState;
                [self.iUsertListView reloadData];
                break;
            }
        }
        //当为老师时
        
        NSArray *array = [NSArray arrayWithArray:_iStudentSplitViewArray];
      
        if (tPublishState == PublishState_NONE && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && [array containsObject:user.peerID]) {
            [_iStudentSplitViewArray removeObject:user.peerID];
           
            NSString *str = [TKUtil dictionaryToJSONString:@{@"userIDArry":_iStudentSplitScreenArray}];
            
            [_iSessionHandle sessionHandlePubMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }

    }
    
    if (_iUserType == UserType_Student && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID]) {
        
        _iClassBeginAndRaiseHandButton.enabled = _iIsCanRaiseHandUp;
        if (isRaiseHand) {
            if (_iSessionHandle.localUser.publishState > 0) {
                [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
            } else {
                [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
            }
        } else {
            [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
        }
        
        if (_iIsCanRaiseHandUp) {
            _iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBegin_RedDeep;
        } else {
            _iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassEnd_Red;
        }
        
    }
    
    if ([properties objectForKey:sDisableAudio]) {
        // 修改TKEduSessionHandle中iUserList中用户的属性
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.disableAudio = [[properties objectForKey:sDisableAudio] boolValue];
                [self.iUsertListView reloadData];
                break;
            }
        }
    }
    
    if ([properties objectForKey:sDisableVideo]) {
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.disableVideo = [[properties objectForKey:sDisableVideo] boolValue];
                [self.iUsertListView reloadData];
                break;
            }
        }
    }
  
    if ([properties objectForKey:sUdpState]) {
        NSInteger updState = [[properties objectForKey:sUdpState] integerValue];
        // 用户列表的属性进行变更
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setObject:@(updState) forKey:sUdpState];
                [self.iUsertListView reloadData];
                break;
            }
        }
    }
    
    if ([properties objectForKey:sServerName]) {
        
        if ([user.peerID isEqualToString:_iSessionHandle.localUser.peerID] &&
            ![fromId isEqualToString:_iSessionHandle.localUser.peerID]) {
            
            // 其他用户修改自己的服务器
            NSString *serverName = [NSString stringWithFormat:@"%@", [properties objectForKey:sServerName]];
            if (serverName != nil) {
                TKLog(@"助教协助修改了服务器地址:%@", serverName);
                // 修改本地默认服务器选项
                //[self.iAreaListView setServerName:serverName];
                [self changeServer:serverName];
                NSError *error = [NSError errorWithDomain:@"" code:TKRoomWarning_ReConnectSocket_ServerChanged userInfo:nil];
                
                [self sessionManagerDidFailWithError:error];
            }
            
        }
        
    }
    
    NSDictionary *tDic = @{sRaisehand:[properties objectForKey:sRaisehand]?[properties objectForKey:sRaisehand]:@(isRaiseHand),
                           sPublishstate:[properties objectForKey:sPublishstate]?[properties objectForKey:sPublishstate]:@(user.publishState),
                           sCandraw:[properties objectForKey:sCandraw]?[properties objectForKey:sCandraw]:@(user.canDraw),
                           sGiftNumber:@(tGiftNumber),
                           sDisableAudio:[properties objectForKey:sDisableAudio]?@([[properties objectForKey:sDisableAudio] boolValue]):@(user.disableAudio),
                           sDisableVideo:[properties objectForKey:sDisableVideo]?@([[properties objectForKey:sDisableVideo] boolValue]):@(user.disableVideo),
                           sFromId:fromId
                           };
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sRaisehand,user.peerID] object:tDic];
    [[NSNotificationCenter defaultCenter]postNotificationName:sDocListViewNotification object:nil];

    if ([properties objectForKey:sIsInBackGround]) {
        BOOL isInBackground = [[properties objectForKey:sIsInBackGround] boolValue];
        
        // 发送通知告诉视频控件后台状态
        NSDictionary *dict = @{sIsInBackGround:[properties objectForKey:sIsInBackGround]};
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@%@",sIsInBackGround,user.peerID] object:nil userInfo:dict];
        
        
        // 当用户发生前后台切换，用户列表状态也要发生变化
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setObject:[properties objectForKey:sIsInBackGround] forKey:sIsInBackGround];
                [self.iUsertListView reloadData];
                break;
            }
        }
        
        if (_iUserType == UserType_Teacher || _iUserType == UserType_Assistant || _iUserType == UserType_Patrol) {
            NSString *deviceType = [user.properties objectForKey:@"devicetype"];
            NSString *content;
            if (isInBackground) {
                content = MTLocalized(@"Prompt.HaveEnterBackground");
            } else {
                content = MTLocalized(@"Prompt.HaveBackForground");
            }
            NSString *message = [NSString stringWithFormat:@"%@ (%@) %@", user.nickName, deviceType, content];
            TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:user.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:user.nickName aTime:[TKUtil currentTimeToSeconds]];
            [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
            [self refreshData];
        }
        
    }
    
}
//聊天信息
//- (void)sessionManagerMessageReceived:(NSString *)message ofUser:(TKRoomUser *)user {
//
//     TKLog(@"------MessageReceived:%@ userName:(%@)",message,user.nickName);
//    NSString *tMyPeerId = _iSessionHandle.localUser.peerID;
//    //自己发送的收不到
//    if (!user) {
//        user = _iSessionHandle.localUser;
//    }
//    BOOL isMe = [user.peerID isEqualToString:tMyPeerId];
//    BOOL isTeacher = user.role == UserType_Teacher?YES:NO;
//    MessageType tMessageType = (isMe)?MessageType_Me:(isTeacher?MessageType_Teacher:MessageType_OtherUer);
//    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:user.peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:message aUserName:user.nickName aTime:[TKUtil currentTime]];
//   
//    [_iSessionHandle addOrReplaceMessage:tChatMessageModel];
//    [self refreshData];
//    
//}

- (void)sessionManagerMessageReceived:(NSString *)message ofUser:(TKRoomUser *)user {
    /*
     
     {
     msg = "\U963f\U9053\U592b";
     type = 0;
     }
     
     */

    NSString *tDataString = [NSString stringWithFormat:@"%@",message];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];

    NSNumber *type = [tDataDic objectForKey:@"type"];
    NSString *msgtype = @"";
    if([[tDataDic allKeys]  containsObject: @"msgtype"]){
         msgtype = [tDataDic objectForKey:@"msgtype"];
    }
    // 问题信息不显示 0 聊天， 1 提问
    if ([type integerValue] != 0) {
        return;
    }
    //接收到pc端发送的图片不进行显示
    if ([msgtype isEqualToString:@"onlyimg"]) {
        return;
    }
    
    NSString *msg = [tDataDic objectForKey:@"msg"];
    TKLog(@"------ type:%@ MessageReceived:%@ userName:(%@)",type,msg,user.nickName);
    NSString *tMyPeerId = _iSessionHandle.localUser.peerID;
    //自己发送的收不到
    if (!user) {
        user = _iSessionHandle.localUser;
    }
    BOOL isMe = [user.peerID isEqualToString:tMyPeerId];
    BOOL isTeacher = user.role == UserType_Teacher?YES:NO;
    MessageType tMessageType = (isMe)?MessageType_Me:(isTeacher?MessageType_Teacher:MessageType_OtherUer);
    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:user.peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:user.nickName aTime:[NSString stringWithFormat:@"%f",[TKUtil getNowTimeTimestamp]]];
    
    [_iSessionHandle addOrReplaceMessage:tChatMessageModel];
    [self refreshData];
    
}

- (void)sessionManagerPlaybackMessageReceived:(NSString *)message ofUser:(TKRoomUser *)user ts:(NSTimeInterval)ts {
    NSString *tDataString = [NSString stringWithFormat:@"%@",message];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSNumber *type = [tDataDic objectForKey:@"type"];
    
    // 问题信息不显示
    if ([type integerValue] != 0) {
        return;
    }
    NSString *msgtype = @"";
    
    if([[tDataDic allKeys]  containsObject: @"msgtype"]){
        msgtype = [tDataDic objectForKey:@"msgtype"];
    }
    // 问题信息不显示 0 聊天， 1 提问
    if ([type integerValue] != 0) {
        return;
    }
    //接收到pc端发送的图片不进行显示
    if ([msgtype isEqualToString:@"onlyimg"]) {
        return;
    }
    
    NSString *msg = [tDataDic objectForKey:@"msg"];
    TKLog(@"------ type:%@ MessageReceived:%@ userName:(%@)",type,msg,user.nickName);
    NSString *tMyPeerId = _iSessionHandle.localUser.peerID;
    //自己发送的收不到
    if (!user) {
        user = _iSessionHandle.localUser;
    }
    BOOL isMe = [user.peerID isEqualToString:tMyPeerId];
    BOOL isTeacher = user.role == UserType_Teacher?YES:NO;
    MessageType tMessageType = (isMe)?MessageType_Me:(isTeacher?MessageType_Teacher:MessageType_OtherUer);
    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:user.peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:user.nickName aTime:[TKUtil timestampToFormatString:ts]];
    
    [_iSessionHandle addOrReplaceMessage:tChatMessageModel];
    [self refreshData];
}

//进入会议失败,重连
- (void)sessionManagerDidFailWithError:(NSError *)error {
    if (!(error.code == TKErrorCode_ConnectSocketError || error.code == TKRoomWarning_ReConnectSocket_ServerChanged || error.code == TKErrorCode_Subscribe_RoomNotExist)) {
        return;
    }
    //todo 
    self.networkRecovered = NO;
    self.currentServer = nil;
    
    [self clearAll];
}

- (void)clearAll
{
    if (self.isConnect) {
        return;
    }
    
    self.isConnect = YES;
    
    [[TKEduSessionHandle shareInstance] configureHUD:MTLocalized(@"State.Reconnecting") aIsShow:YES];
    
    [[TKEduSessionHandle shareInstance] configureDraw:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
    [[TKEduSessionHandle shareInstance] docmentDefault:[[TKEduSessionHandle shareInstance] whiteBoardArray].firstObject];
    [[TKEduSessionHandle shareInstance].iBoardHandle disconnectCleanup];
    [_iSessionHandle clearAllClassData];
    [_iSessionHandle.iBoardHandle clearAllWhiteBoardData];
    
    [self clearVideoViewData:_iTeacherVideoView];
    [self clearVideoViewData:_iOurVideoView];
    for (TKVideoSmallView *view in _iStudentVideoViewArray) {
        [self clearVideoViewData:view];
    }
    [_iPlayVideoViewDic removeAllObjects];
    
    if (self.iDocumentListView) {
        [self.iDocumentListView removeFromSuperview];
        self.iDocumentListView = nil;
    }
    if (self.iMediaListView) {
        [self.iMediaListView removeFromSuperview];
        self.iMediaListView = nil;
    }
    
        // 播放的MP4前，先移除掉上一个MP4窗口
    
    [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
    if (self.iMediaView) {
        [self.iMediaView deleteWhiteBoard];
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    if (self.iFileView) {
        [self.iFileView deleteWhiteBoard];
        [self.iFileView removeFromSuperview];
        self.iFileView = nil;
    }
    
        //将分屏的数据删除
    NSArray *array = [NSArray arrayWithArray:_iStudentSplitViewArray];
    for (TKVideoSmallView *view in array) {
        
        [_iStudentVideoViewArray addObject:view];
        
        [_iStudentSplitViewArray removeObject:view];
        
        [self clearVideoViewData:view];
        
    }
    
    [_splitScreenView deleteAllVideoSmallView];
    
    
    [_iStudentSplitScreenArray removeAllObjects];
    
    _splitScreenView.hidden = YES;
}
- (void)clearVideoViewData:(TKVideoSmallView *)videoView {
    videoView.isDrag = NO;
    if (videoView.iRoomUser != nil) {
        [self myUnPlayVideo:videoView.iRoomUser.peerID aVideoView:videoView completion:^(NSError *error) {
            TKLog(@"清理视频窗口完成!");
        }];
    } else {
        [videoView clearVideoData];
    }
}

//相关信令 pub
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    
    
     TKLog(@"jin------remoteMsg:%@ msgID:%@",msgName,msgID);
    //添加
    if ([msgName isEqualToString:sClassBegin]) {
       
        NSString *tPeerId = _iSessionHandle.localUser.peerID;
        _iSessionHandle.isClassBegin = add;

      
         //上课
        if (add) {
            
            [self invalidateClassCurrentTime];
           
            
            _iClassTimeView.hidden = NO;
            [TKEduSessionHandle shareInstance].iIsClassEnd = NO;
            [TKEduSessionHandle shareInstance].isClassBegin = YES;
            
            // 上课之前将自己的音视频关掉
            if (![_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag && _isLocalPublish) {
                    _iSessionHandle.localUser.publishState = PublishState_NONE;
                    [self sessionManagerUserUnpublished:_iSessionHandle.localUser.peerID];
            }
            
            if (_iUserType == UserType_Student && [_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag &&![_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag) {
                
                if (_iSessionHandle.localUser.publishState != PublishState_NONE) {
                    _isLocalPublish = false;
                    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_NONE) completion:nil];
                }
            }else if(_iUserType == UserType_Student && !_isLocalPublish &&![_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag){
                if (_iSessionHandle.localUser.publishState != PublishState_NONE) {
                    _isLocalPublish = false;
                    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_NONE) completion:nil];
                }
            }
            
            if ([TKEduSessionHandle shareInstance].isPlayMedia) {
                
                [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
                
            }
            
            if (_iUserType == UserType_Teacher && _iSessionHandle.isPlayback == NO) {
                
                if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                    _isLocalPublish = false;
                    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_BOTH) completion:nil];
                }
                if ([TKEduSessionHandle shareInstance].iCurrentDocmentModel) {
                    [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:[TKEduSessionHandle shareInstance].iCurrentDocmentModel To:sTellAllExpectSender aTellLocal:NO];
                }
                
            }
            
            if ((self.playbackMaskView.iProgressSlider.sliderPercent < 0.01 && _iSessionHandle.isPlayback == YES && self.playbackMaskView.playButton.isSelected == YES) ||
                _iSessionHandle.isPlayback == NO) {
                [self showMessage:MTLocalized(@"Class.Begin")];
            }
            
            if (!_iSessionHandle.isPlayback && ![_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag && _iSessionHandle.isPlayback == NO) {
                if (_iUserType==UserType_Teacher || (_iUserType==UserType_Student && [_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag)) {
                    
                    if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                        _isLocalPublish = false;
                        [_iSessionHandle sessionHandleChangeUserPublish:tPeerId Publish:(PublishState_BOTH) completion:^(NSError *error) {
                            
                        }];
                    }
                    
                }
            }else if(_iUserType==UserType_Teacher && [_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag && _iSessionHandle.isPlayback == NO){
                if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                    _isLocalPublish = false;
                    [_iSessionHandle sessionHandleChangeUserPublish:tPeerId Publish:(PublishState_BOTH) completion:^(NSError *error) {
                        
                    }];
                }
            }else if(_iUserType == UserType_Student && [_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag  && _iSessionHandle.isPlayback == NO){
                if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                    _isLocalPublish = false;
                    [_iSessionHandle sessionHandleChangeUserPublish:tPeerId Publish:(PublishState_BOTH) completion:^(NSError *error) {
                        
                    }];
                }
            }
            
            
            _iClassStartTime = ts;
            bool tIsTeacherOrAssis  = (_iUserType==UserType_Teacher || _iUserType == UserType_Assistant);
            [_iSessionHandle.iBoardHandle setAddPagePermission:tIsTeacherOrAssis];
            BOOL isStdAndRoomOne = ([TKEduSessionHandle shareInstance].roomType == RoomType_OneToOne && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student);
            // 涂鸦权限:1.1v1学生根据配置项设置 2.其他情况，没有涂鸦权限 3 非老师断线重连不可涂鸦。 发送:1 1v1 学生发送 2 学生发送，老师不发送
            [[TKEduSessionHandle shareInstance]configureDraw:isStdAndRoomOne?[TKEduSessionHandle shareInstance].iIsCanDrawInit:tIsTeacherOrAssis isSend:isStdAndRoomOne?YES:!tIsTeacherOrAssis to:sTellAll peerID:tPeerId];
           
            //如果是学生需要重新设置翻页
            [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanDrawInit?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:isStdAndRoomOne?tPeerId:@""];
            
            
            /*
            if (isStdAndRoomOne) {
               [[TKEduSessionHandle shareInstance]configureDraw:TKEduSessionHandle shareInstance].iIsCanDrawInit isSend:NO to:sTellAll peerID:tPeerId];
                
            }else{
                [[TKEduSessionHandle shareInstance]configureDraw:tIsTeacher isSend:NO to:sTellAll peerID:tPeerId];
                [TKEduSessionHandle shareInstance].iIsCanDraw = tIsTeacher;
                if (tIsTeacher) {
                    [_iSessionHandle.iBoardHandle setDrawable:tIsTeacher];
                   
                }
            }*/
            
//            [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:tPeerId  Data:@"" Save:false completion:^(NSError *error) {
//
//            }];
            [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:tPeerId Data:@"" Save:false AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:^(NSError *error) {

            }];
            
            [self startClassBeginTimer];
            
            
            [self refreshUI];
            
            
        }else{
            
            // 下课后老师的视频还可以继续播放
//            if (_iSessionHandle.localUser.role == UserType_Teacher && _iSessionHandle.roomMgr.forbidLeaveClassFlag) {
//                _iSessionHandle.localUser.publishState = PublishState_BOTH;
//                [_iSessionHandle.roomMgr enableAudio:YES];
//                [_iSessionHandle.roomMgr enableVideo:YES];
//            }
            
            
            //未到下课时间： 老师点下课 —> 下课后不离开教室 _iSessionHandle.roomMgr.forbidLeaveClassFlag->下课时间到，课程结束，一律离开
            if ([_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag && [_iSessionHandle.roomMgr getRoomConfigration].endClassTimeFlag) {
                _iClassCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                       target:self
                                                                     selector:@selector(onClassCurrentTimer)
                                                                      userInfo:nil
                                                                       repeats:YES];
                [_iClassCurrentTimer setFireDate:[NSDate date]];
            }
            
            //下课
            [TKEduSessionHandle shareInstance].iIsClassEnd = YES;
            [TKEduSessionHandle shareInstance].isClassBegin = NO;
            [self showMessage:MTLocalized(@"Class.Over")];
            
            
            BOOL isStdAndRoomOne = ([TKEduSessionHandle shareInstance].roomType == RoomType_OneToOne && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student);
             [_iSessionHandle.iBoardHandle setAddPagePermission:false];
             bool tIsTeacherOrAssis  = ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher || [TKEduSessionHandle shareInstance].localUser.role == UserType_Assistant);
            [[TKEduSessionHandle shareInstance]configureDraw:isStdAndRoomOne?[TKEduSessionHandle shareInstance].iIsCanDrawInit:false isSend:isStdAndRoomOne?YES:!tIsTeacherOrAssis to:sTellAll peerID:tPeerId];
             //BOOL isStd = ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student);
            //如果是1v1学生需要重新设置翻页
            [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:isStdAndRoomOne?tPeerId:@""];
           
            //将所有全屏的视频还原
            [self cancelSplitScreen:nil];
            //将所有拖拽的视频还原
            for (TKVideoSmallView *view  in self.iStudentVideoViewArray) {
                [self updateMvVideoForPeerID:view.iPeerId];
                view.isDrag = NO;
                view.isDragWhiteBoard = NO;
            }
            [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
           
            [self refreshUI];
            [self invalidateClassBeginTime];
            _iClassTimeView.hidden = YES;
            [self tapTable:nil];
            if ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher) {
                /*删除所有信令的消息，从服务器上*/
                if(![_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
                    [[TKEduSessionHandle shareInstance]sessionHandleDelMsg:sAllAll ID:sAllAll To:sTellNone Data:@{} completion:nil];
                }
                
            }
            if (![[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
                [self showMessage:MTLocalized(@"Prompt.ClassEnd")];
                [_iClassTimeView setToZeroTime];
                // 非老师身份下课后退出教室
                if (_iUserType != UserType_Teacher && ![_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag) {//下课是否允许离开教室
                    
                    [self prepareForLeave:YES];
                    
                }else if(_iUserType == UserType_Teacher && ![_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
                    
                    if(![_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag){
                        _isLocalPublish = false;
                        [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:PublishState_NONE completion:^(NSError *error) {
                        }];
                    }
                    
                }
                
            }
        }
       
       
    } else if ([msgName isEqualToString:sUpdateTime]) {
        
        if (add) {
            _iServiceTime = ts;
            _iLocalTime   = _iServiceTime - _iClassStartTime;
            _iRoomProperty.iHowMuchTimeServerFasterThenMe = ts - [[NSDate date] timeIntervalSince1970];
           
            if ([TKEduSessionHandle shareInstance].isClassBegin) {
                if ([_iClassTimetimer isValid]) {
                    //[_iClassTimetimer setFireDate:[NSDate date]];
                } else {
                    _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                        target:self
                                                                      selector:@selector(onClassTimer)
                                                                      userInfo:nil
                                                                       repeats:YES];
                    [_iClassTimetimer setFireDate:[NSDate date]];
                }
            }
        }
        
    }else if ([msgName isEqualToString:sMuteAudio]){
        
        int tPublishState = _iSessionHandle.localUser.publishState;
        NSString *tPeerId = _iSessionHandle.localUser.peerID;
        [TKEduSessionHandle shareInstance].isMuteAudio = add ?true:false;
        _isLocalPublish = false;
        if (tPublishState != PublishState_VIDEOONLY) {
            [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:(tPublishState)+([TKEduSessionHandle shareInstance].isMuteAudio ?(-PublishState_AUDIOONLY):(PublishState_AUDIOONLY)) completion:^(NSError *error) {
                
            }];
        }else{
            [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:([TKEduSessionHandle shareInstance].isMuteAudio ?(PublishState_NONE):(PublishState_AUDIOONLY)) completion:^(NSError *error) {
                
            }];
        }
      

    }else if ([msgName isEqualToString:sStreamFailure]){
        
        // 收到用户发布失败的消息
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            tDataDic = (NSDictionary *)data;
        }
        
        NSString *tPeerId = [tDataDic objectForKey:@"studentId"];
        NSInteger failureType = [tDataDic objectForKey:@"failuretype"]?[[tDataDic objectForKey:@"failuretype"] integerValue] : 0;
        
        // 如果这个发布失败的用户是自己点击上台的，需要对自己进行上台失败错误原因进行提示。
        if ([[[_iSessionHandle pendingUserDic] allKeys] containsObject:tPeerId]) {
            switch (failureType) {
                case 1:
                    [TKUtil showMessage:MTLocalized(@"Prompt.StudentUdpOnStageError")];
                    break;
                    
                case 2:
                    [TKUtil showMessage:MTLocalized(@"Prompt.StudentTcpError")];
                    break;
                    
                case 3:
                    [TKUtil showMessage:MTLocalized(@"Prompt.exceeds")];
                    break;
                    
                case 4:
                {
                  
                    [TKUtil showMessage:[NSString stringWithFormat:@"%@%@",[[TKEduSessionHandle shareInstance] localUser].nickName,MTLocalized(@"Prompt.BackgroundCouldNotOnStage")]];//拼接上用户名
                    break;
                }
                case 5:
                    [TKUtil showMessage:MTLocalized(@"Prompt.StudentUdpError")];
                    break;
                    
                default:
                    break;
            }
        }
        
        [[TKEduSessionHandle shareInstance] delePendingUser:tPeerId];
        
    }else if ([msgName isEqualToString:sVideoDraghandle]){//拖拽回调
        if(_iStudentSplitScreenArray.count>0){
            return;
        }
        
        // 可能意外收到录制的拖拽信令，1对1回放不响应拖拽。
        if (_iRoomType == RoomType_OneToOne && _iSessionHandle.isPlayback == YES) {
            return;
        }
        
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            tDataDic = (NSDictionary *)data;
        }
    
        NSDictionary *tMvVideoDic = [tDataDic objectForKey:@"otherVideoStyle"];
        _iMvVideoDic = [NSMutableDictionary dictionaryWithDictionary:tMvVideoDic];
        
        if(_iUserType == UserType_Student && inlist){
            
            [self updateMvVideoForPeerID:[TKEduSessionHandle shareInstance].localUser.peerID];
            
        }
        
        [self moveVideo:tMvVideoDic];
        
        

    } else if ([msgName isEqualToString:sChangeServerArea]){
//        NSDictionary *tDataDic = @{};
//        if ([data isKindOfClass:[NSString class]]) {
//            NSString *tDataString = [NSString stringWithFormat:@"%@", data];
//            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
//            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
//        }
//        if ([data isKindOfClass:[NSDictionary class]]) {
//            tDataDic = (NSDictionary *)data;
//        }
//        NSString *serverName = [tDataDic objectForKey:@"servername"];
//        if (serverName != nil) {
//            TKLog(@"助教协助修改了服务器地址:%@", serverName);
//            // 修改本地默认服务器选项
//            [self.iAreaListView setServerName:serverName];
//        }
    } else if ([msgName isEqualToString:sVideoSplitScreen]){//分屏回调
    
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            tDataDic = (NSDictionary *)data;
        }
        
        NSLog(@"分屏回调：--------%@",tDataDic);
        NSMutableArray *array = [NSMutableArray arrayWithArray:tDataDic[@"userIDArry"]];
       
        //取消全屏的操作
        [self cancelSplitScreen:array];
        
        _iStudentSplitScreenArray = array;
        //白板全屏状态下不执行分屏回调
        if ([TKEduSessionHandle shareInstance].iIsFullState) {
            return;
        }
        [self sVideoSplitScreen:_iStudentSplitScreenArray];
        [_splitScreenView refreshSplitScreenView];
        
    } else if ([msgName isEqualToString:sVideoZoom]) {//缩放回调
        
        // 视频缩放
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@", data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        
        // 数据格式：{"ScaleVideoData":{"ffefbe63-50ae-4959-a872-3dd38397988d":{"scale":1.7285714285714286}}}
        NSDictionary *peerIdToScaleDic = [tDataDic objectForKey:@"ScaleVideoData"];
        _iScaleVideoDict = peerIdToScaleDic;
        
        //白板全屏状态下不执行缩放回调
        if ([TKEduSessionHandle shareInstance].iIsFullState) {
            return;
        }
        [self sScaleVideo:peerIdToScaleDic];
        
    } else if ([msgName isEqualToString:sVideoWhiteboard]){//视频标注回调
        
        _addVideoBoard = add;
        
        if (add) {
            if (_iMediaView) {//媒体
                
                [_iMediaView loadWhiteBoard];
            }
            if (_iFileView) {//电影
                
                [_iFileView loadWhiteBoard];
            }
        }else{
            if (_iMediaView){//媒体
                [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
                
                [_iMediaView hiddenVideoWhiteBoard];
            }
            if (_iFileView){
                [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
                [_iFileView hiddenVideoWhiteBoard];
            }
        }
    } else if ([msgName isEqualToString:sEveryoneBanChat]){//禁言
        if(add){//禁言
            
        }else{//取消禁言
            
        }
    }
}
- (void)sessionManagerIceStatusChanged:(NSString*)state ofUser:(TKRoomUser *)user {
    TKLog(@"------IceStatusChanged:%@ nickName:%@",state,user.nickName);
}

- (void)cancelSplitScreen:(NSMutableArray *)array{
    if (_iStudentSplitScreenArray.count>array.count) {
        
        __block NSMutableArray *difObject = [NSMutableArray arrayWithCapacity:10];
        //找到arr2中有,arr1中没有的数据
        [_iStudentSplitScreenArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number1 = obj;//[obj objectAtIndex:idx];
            __block BOOL isHave = NO;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([number1 isEqual:obj]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:obj];
            }
        }];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number1 = obj;//[obj objectAtIndex:idx];
            __block BOOL isHave = NO;
            [_iStudentSplitScreenArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([number1 isEqual:obj]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:obj];
            }
        }];
        
        for (NSString *peerID in difObject) {
            
            NSArray *sArray = [NSArray arrayWithArray:_iStudentSplitViewArray];
            for (TKVideoSmallView *view in sArray) {
                
                if([view.iRoomUser.peerID isEqualToString:peerID]){
                    view.isSplit = YES;
                    [self beginTKSplitScreenView:view];
                }
            }
        }
    }
}

#pragma mark media
- (void)sessionManagerOnShareMediaState:(NSString *)peerId state:(TKMediaState)state extension:(NSDictionary *)extension{
    
    if(state){
        [TKEduSessionHandle shareInstance].isPlayMedia = YES;
        [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
        [[TKEduSessionHandle shareInstance].iBoardHandle closeDynamicPptWebPlay:nil];
        
        //peerid设置为空，不设置本地的page变量
        [[TKEduSessionHandle shareInstance]configurePage:false isSend:NO to:sTellAll peerID:@""];
        
        //    [TKEduSessionHandle shareInstance].iIsCanPage = false;
        //    [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission:[TKEduSessionHandle shareInstance].iIsCanPage];
        
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        
        BOOL hasVideo = false;
        if([extension objectForKey:@"video"]){
            hasVideo = [extension[@"video"] boolValue];
        }
        
        //    NSString *filedId= [NSString stringWithFormat:@"%@",mediaStream.fileid];
        //不是视频的时候
        if (!hasVideo) {
            frame =CGRectMake(0, CGRectGetMaxY(_iTKEduWhiteBoardView.frame) - 57, CGRectGetWidth(self.iTKEduWhiteBoardView.frame), 57);
            if ([TKEduSessionHandle shareInstance].localUser.role == 2 || [TKEduSessionHandle shareInstance].localUser.role == TKUserType_Playback) {
                frame =CGRectMake(10, CGRectGetHeight(self.iTKEduWhiteBoardView.frame)-57+CGRectGetMinY(self.iTKEduWhiteBoardView.frame), 57, 57);
            }
        }
        
        // 播放的MP4前，先移除掉上一个MP4窗口
        if (self.iMediaView) {
            [self.iMediaView removeFromSuperview];
            self.iMediaView = nil;
        }
        
        
        TKBaseMediaView *tMediaView = [[TKBaseMediaView alloc] initWithMedia:extension frame:frame sessionHandle:_iSessionHandle];
        _iMediaView = tMediaView;
        
        
        // 如果是回放，需要将播放视频窗口放在回放遮罩页下
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iMediaView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iMediaView];
        }
        [[TKEduSessionHandle shareInstance] sessionHandlePlayMedia:peerId renderType:0 window:_iMediaView completion:^(NSError *error) {
            [_iMediaView setVideoViewToBack];
            if (hasVideo) { 
                [_iMediaView loadLoadingView];
                if(_iSessionHandle.localUser.role != UserType_Teacher){
                    [_iMediaView loadWhiteBoard];
                }
            }
        }];
       
        
//        [[TKEduSessionHandle shareInstance] sessionHandlePlayMedia:peerId completion:^(NSError *error, NSObject *view) {
//            UIView *tView = (UIView  *)view;
//            tView.tag = 10001;
//            tView.frame = tMediaView.frame;
//            [tMediaView insertSubview:tView atIndex:0];
//            if(_iSessionHandle.localUser.role != UserType_Teacher){
//                [_iMediaView loadWhiteBoard];
//            }
//        }];
        // 设置当前的媒体文档
        NSString *fileid = [TKUtil optString:extension Key:@"fileid"];
        for (TKMediaDocModel *mediaModel in _iSessionHandle.mediaArray) {
            if ([[NSString stringWithFormat:@"%@", mediaModel.fileid] isEqualToString:fileid]) {
                [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = mediaModel;
                break;
            }
        }
    }else{
        
        //媒体流停止后需要删除sVideoWhiteboard
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
        [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanPage isSend:NO to:sTellAll peerID:@""];
        
        [TKEduSessionHandle shareInstance].isPlayMedia = NO;
        [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
        
         
        [[TKEduSessionHandle shareInstance].roomMgr unPlayMediaFile:peerId completion:nil];
        [_iMediaView deleteWhiteBoard];
        
        [_iMediaView removeFromSuperview];
        _iMediaView = nil;
        [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
        if ( [TKEduSessionHandle shareInstance].isChangeMedia) {
            
            [TKEduSessionHandle shareInstance].isChangeMedia = NO;
            TKMediaDocModel *tMediaDocModel =  [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            NSString *tNewURLString2 = [TKUtil absolutefileUrl:tMediaDocModel.swfpath webIp:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp webPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort];
            
            BOOL tIsVideo = [TKUtil isVideo:tMediaDocModel.filetype];
           
            NSString * toID = [TKEduSessionHandle shareInstance].isClassBegin?sTellAll:[TKEduSessionHandle shareInstance].localUser.peerID;
            
            [[TKEduSessionHandle shareInstance]sessionHandlePublishMedia:tNewURLString2 hasVideo:tIsVideo fileid:[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] filename:tMediaDocModel.filename toID:toID block:nil];
            
        }
        [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = nil;
    }
}

- (void)sessionManagerUpdateMediaStream:(NSTimeInterval)duration
                                    pos:(NSTimeInterval)pos
                                 isPlay:(BOOL)isPlay
{
    
    [_iMediaView updatePlayUI:isPlay];
    if (isPlay) {
        [_iMediaView update:pos total:duration];
    }
    //TKLog(@"jin postion:%@ play:%@",@(pos),@(isPlay));
}
//收到流视频第一帧
- (void)sessionManagerMediaLoaded
{
    if (_iMediaView) {
        [_iMediaView hiddenLoadingView];
    }
    if (_iFileView) {
        [_iFileView hiddenLoadingView];
    }
}
#pragma mark Screen

- (void)sessionManagerOnShareScreenState:(NSString *)peerId state:(int)state extensionMessage:(NSDictionary *)message{
    if (state) {
        if (self.iScreenView) {
            [self.iScreenView removeFromSuperview];
            self.iScreenView = nil;
        }
        
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        TKBaseMediaView *tScreenView = [[TKBaseMediaView alloc] initScreenShare:frame];
        _iScreenView = tScreenView;
        
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iScreenView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iScreenView];
        }
        [[TKEduSessionHandle shareInstance] sessionHandlePlayScreen:peerId renderType:0 window:_iScreenView completion:nil];
//        [[TKEduSessionHandle shareInstance] sessionHandlePlayScreen:peerId completion:^(NSError *error, NSObject *view) {
//            UIView *tView = (UIView *)view;
//            tView.frame = tScreenView.frame;
//            [tScreenView insertSubview:tView atIndex:0];
//        }];
    }else{
        __weak typeof(self) wself = self;
        [[TKEduSessionHandle shareInstance] sessionHandleUnPlayScreen:peerId completion:^(NSError *error) {
            __strong RoomController *sself = wself;
            [sself.iScreenView removeFromSuperview];
            sself.iScreenView = nil;
        }];
    }
}
#pragma mark file
- (void)sessionManagerOnShareFileState:(NSString *)peerId state:(int)state extensionMessage:(NSDictionary *)message{
    if (state) {
        if (self.iFileView) {
            [self.iFileView removeFromSuperview];
            self.iFileView = nil;
        }        
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        TKBaseMediaView *tFilmView = [[TKBaseMediaView alloc] initFileShare:frame];
        _iFileView = tFilmView;
        [_iFileView loadLoadingView];
        
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iFileView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iFileView];
        }
        [[TKEduSessionHandle shareInstance] sessionHandlePlayFile:peerId renderType:0 window:_iFileView completion:^(NSError *error) {
            if( _iSessionHandle.localUser.role != UserType_Teacher){
                [_iFileView loadWhiteBoard];
            }
        }];
        
//        [[TKEduSessionHandle shareInstance] sessionHandlePlayFile:peerId completion:^(NSError *error, NSObject *view) {
//            UIView *tView = (UIView *)view;
//            tView.tag = 10001;
//            tView.frame = _iFileView.frame;
//            [_iFileView insertSubview:tView atIndex:0];
//            if( _iSessionHandle.localUser.role != UserType_Teacher){
//                [_iFileView loadWhiteBoard];
//            }
//            
//        }];
    }else{
        //媒体流停止后需要删除sVideoWhiteboard
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
        
        __weak typeof(self) wself = self;
        
        [[TKEduSessionHandle shareInstance] sessionHandleUnPlayFile:peerId completion:^(NSError *error) {
            __strong RoomController *sself = wself;
            
            [sself.iFileView deleteWhiteBoard];
            [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
            [sself.iFileView removeFromSuperview];
            sself.iFileView = nil;
            
        }];
        
    }
}
#pragma mark Playback

- (void)sessionManagerReceivePlaybackDuration:(NSTimeInterval)duration {
    //self.playbackMaskView.model.duration = duration;
    [self.playbackMaskView getPlayDuration:duration];
}

- (void)sessionManagerPlaybackUpdateTime:(NSTimeInterval)time {
    [self.playbackMaskView update:time];
}

- (void)sessionManagerPlaybackClearAll {
    [_iSessionHandle.iBoardHandle playbackSeekCleanup];
    //[_iSessionHandle clearAllClassData];
    [_iSessionHandle clearMessageList];
    [_iSessionHandle.iBoardHandle clearAllWhiteBoardData];
}

- (void)sessionManagerPlaybackEnd {
    [self.playbackMaskView playbackEnd];
    [_iSessionHandle.iBoardHandle playbackSeekCleanup];
    [self quitClearData];
}

#pragma mark 设备检测
- (void)noCamera {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:MTLocalized(@"Prompt.NeedCamera") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Sure") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:tActionSure];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)noMicrophone {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.NeedMicrophone.Title") message:MTLocalized(@"Prompt.NeedMicrophone") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Sure") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:tActionSure];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)noCameraAndNoMicrophone {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:MTLocalized(@"Prompt.NeedCameraNeedMicrophone") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Sure") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:tActionSure];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 首次发布或订阅失败3次
- (void)networkTrouble {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:MTLocalized(@"Prompt.NetworkException") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.OK") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:tActionSure];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)networkChanged {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:MTLocalized(@"Prompt.NetworkChanged") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.OK") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:tActionSure];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark TKEduBoardDelegate

- (void)boardOnFileList:(NSArray*)fileList{
     TKLog(@"------OnFileList:%@ ",fileList);
}
- (BOOL)boardOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    TKLog(@"------WhiteBoardOnRemoteMsg:%@ msgID:%@ ",msgName,msgID);
    return NO;
    
}
- (void)boardOnRemoteMsgList:(NSArray*)list{
    
}
#pragma mark scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    
#pragma clang diagnostic pop
    
    
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return 2;
    return _iMessageList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tHeight = 0;
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
    
    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {

//            CGSize titlesize = [TKMessageTableViewCell sizeFromText:tMessageModel.iMessage withLimitWidth:CGRectGetWidth(_iChatTableView.frame) Font:TKFont(15)];
            
//            CGSize titlesize = [TKMessageTableViewCell sizeFromAttributedString:tMessageModel.iMessage withLimitWidth:CGRectGetWidth(_iChatTableView.frame) Font:TKFont(15)];
            
            tHeight = 30;
            
        }
            break;
       
        case MessageType_OtherUer:
        case MessageType_Teacher:
        case MessageType_Me:
       
        {
            
            CGFloat tViewCap             = 10 *Proportion;
            CGFloat tContentWidth        = CGRectGetWidth(_iChatTableView.frame);
            CGFloat tTimeLabelHeigh      = 16*Proportion;
            CGFloat tTranslateLabelHeigh = 22*Proportion;
            
            CGSize titlesize = [TKStudentMessageTableViewCell sizeFromAttributedString:tMessageModel.iMessage withLimitWidth:tContentWidth-tTranslateLabelHeigh-tViewCap*2 Font:TKFont(15)];
                                
            CGSize tTranslationSize = [TKStudentMessageTableViewCell sizeFromText:tMessageModel.iTranslationMessage withLimitWidth:tContentWidth-2*tViewCap Font:TKFont(15)];
            
            tHeight = titlesize.height+tTranslationSize.height+20+tTimeLabelHeigh;
           
            //tHeight =100;
           
        }
            break;
        default:
            break;
    }
    
    
    return tHeight + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
 
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
   
    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {
            TKMessageTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:sMessageCellIdentifier forIndexPath:indexPath];
            tCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tCell.iMessageText = tMessageModel.iMessage;

            [tCell resetView];
            return tCell;
        }
            break;
        case MessageType_OtherUer:
        case MessageType_Teacher:
        case MessageType_Me:
        {
             TKStudentMessageTableViewCell* tCell =[tableView dequeueReusableCellWithIdentifier:sStudentCellIdentifier forIndexPath:indexPath];
            tCell.chatModel = tMessageModel;
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return tCell;

        }
            break;
        
        default:
            
            break;
    }

   UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sDefaultCellIdentifier];
    return cell;
    
    
}
- (void)tapGestureTranslation:(UITapGestureRecognizer *)gesture {
    
    //获得当前手势触发的在UITableView中的坐标
    CGPoint location = [gesture locationInView:_iChatTableView];
    //获得当前坐标对应的indexPath
    NSIndexPath *indexPath = [_iChatTableView indexPathForRowAtPoint:location];
    __weak typeof(self)weakSelf = self;
    if (_iMessageList.count <= indexPath.row) {
        return;
    }
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
    
    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {
            
        }
            break;
        case MessageType_OtherUer:
        case MessageType_Teacher:
        case MessageType_Me:
        {
            
            [TKEduNetManager translation:tMessageModel.iMessage aTranslationComplete:^int(id  _Nullable response, NSString * _Nullable aTranslationString) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                tMessageModel.iTranslationMessage = aTranslationString;
                [_iSessionHandle addTranslationMessage:tMessageModel];
                [strongSelf refreshData];
                return 0;
            }];
            
        }
            break;
            
        default:
            
            break;
    }
    [_iChatTableView deselectRowAtIndexPath:indexPath animated:NO];
    //    if (indexPath) {
    //        //通过indexpath获得对应的Cell
    //        UITableViewCell *cell = [_iChatTableView cellForRowAtIndexPath:indexPath];
    //
    //    }
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//      __weak typeof(self)weakSelf = self;
//     TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
//    switch (tMessageModel.iMessageType) {
//        case MessageType_Message:
//        {
//
//        }
//            break;
//        case MessageType_OtherUer:
//        case MessageType_Teacher:
//        case MessageType_Me:
//        {
//
//            [TKEduNetManager translation:tMessageModel.iMessage aTranslationComplete:^int(id  _Nullable response, NSString * _Nullable aTranslationString) {
//                  __strong typeof(weakSelf) strongSelf = weakSelf;
//                tMessageModel.iTranslationMessage = aTranslationString;
//                [_iSessionHandle addOrReplaceMessage:tMessageModel];
//                [strongSelf refreshData];
//                return 0;
//            }];
//
//        }
//            break;
//
//        default:
//
//            break;
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}
#pragma mark Event

-(void)chooseAreaButtonClicked:(UIButton*)aButton{
    TKLog(@"选择区域");
    [self.iAreaListView showView];
}
-(void)userButtonClicked:(UIButton*)aButton{
    TKLog(@"用户列表");
    
    NSMutableArray *tUserArray = [[_iSessionHandle userListExpecPtrlAndTchr]mutableCopy];
    [_iUsertListView show:FileListTypeUserList aFileList:tUserArray isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
    
}
-(void)mediaButtonClicked:(UIButton *)aButton{
     TKLog(@"影音列表");
    if ([_iSessionHandle.roomMgr getRoomConfigration].documentCategoryFlag) {
        
        [(TKFolderDocumentListView *)_iMediaListView show:FileListTypeAudioAndVideo aFileList:[[TKEduSessionHandle shareInstance] mediaArray] isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
    }else{
        
        [(TKDocumentListView *)_iMediaListView show:FileListTypeAudioAndVideo aFileList:[[TKEduSessionHandle shareInstance] mediaArray] isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
    }
}
-(void)documentButtonClicked:(UIButton*)aButton{
     TKLog(@"文档列表");
    if ([_iSessionHandle.roomMgr getRoomConfigration].documentCategoryFlag) {

        [(TKFolderDocumentListView *)_iDocumentListView show:FileListTypeDocument aFileList:[[TKEduSessionHandle shareInstance] docmentArray]isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
    }else{
        
        [(TKDocumentListView *)_iDocumentListView show:FileListTypeDocument aFileList:[[TKEduSessionHandle shareInstance] docmentArray]isClassBegin:[TKEduSessionHandle shareInstance].isClassBegin];
    }
}


-(void)replyAction
{
    
    [_iChatView show];
}

- (void)refreshData
{
    _iMessageList = [_iSessionHandle messageList];
    
    [_iChatTableView reloadData];
//    [_iChatTableView layoutIfNeeded];
//    if(_iChatTableView.contentSize.height > _iChatTableView.frame.size.height)
//        [_iChatTableView setContentOffset:CGPointMake(0, _iChatTableView.contentSize.height -_iChatTableView.bounds.size.height) animated:YES];
    
    /* lyy 修改tableview接收聊天消息时，cell自动上滑的效果*/
    if (_iMessageList.count>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_iMessageList.count-1  inSection:0];
        [_iChatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark keyboard Notification
- (void)keyboardWillShow:(NSNotification*)notification
{
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
   // keyboardFrame = [self convertRect:keyboardFrame fromView:nil];
    //会掉两次notification
    if (_knownKeyboardHeight ==  keyboardFrame.size.height) {
        return;
    }

    _knownKeyboardHeight = keyboardFrame.size.height;
    double duration = ([[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone) animations:^
     {
      
         [TKUtil setBottom:_inputContainer To: CGRectGetHeight(_iRightView.frame)-_knownKeyboardHeight];
         //如果是举手状态或者已经显示，则直接跳过
         if (_iIsCanRaiseHandUp ) {
             return ;
         }
         
         
     }
                     completion:^(BOOL finished)
     {
         
     }];
    [self changeInputAreaHeight:(int)_knownKeyboardHeight duration:duration orientationChange:false dragging:false completion:nil];
    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
    if (_knownKeyboardHeight == 0) {
        return;
    }
    _replyText.hidden = _inputField.text.length != 0;

    
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _knownKeyboardHeight = 0;
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone) animations:^
     {
         
           [TKUtil setBottom:_inputContainer To: CGRectGetHeight(_iRightView.frame)-_knownKeyboardHeight];
         //[TKUtil setBottom:_inputContainer To: ScreenH-_knownKeyboardHeight];
         //如果是举手状态或者已经隐藏举手，则跳过
         if (_iIsCanRaiseHandUp) {
             return ;
         }
      
     }
                     completion:^(BOOL finished)
     {
        
     }];
    
    
    [self changeInputAreaHeight:_knownKeyboardHeight duration:duration orientationChange:false dragging:false completion:nil];
}

-(void)reSetTitleView:(BOOL)aIsHide aInputContainerIsHide:(BOOL)aInputContainerIsHide aStatusIsHide:(BOOL)aStatusIsHide{
    _titleView.hidden = aIsHide;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
     [[UIApplication sharedApplication] setStatusBarHidden:aStatusIsHide animated:YES];
    
#pragma clang diagnostic pop
   
   // _inputContainer.hidden = aInputContainerIsHide;
  
}
-(void)chatBegin{
    [_inputField becomeFirstResponder];
}
- (void)changeInputAreaHeight:(int)height duration:(NSTimeInterval)duration orientationChange:(bool)orientationChange dragging:(bool)__unused dragging completion:(void (^)(BOOL finished))completion
{
    

    
}
- (void)updatePlaceholderVisibility:(bool)firstResponder
{
    _replyText.hidden = firstResponder || _inputField.text.length != 0;
}
#pragma mark TKTextViewInternalDelegate
- (void)TKTextViewChangedResponderState:(bool)firstResponder
{
    [self updatePlaceholderVisibility:firstResponder];
}
#pragma mark TKGrowingTextViewDelegate
- (void)growingTextView:(TKGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    [self growingTextView:growingTextView willChangeHeight:height animated:true];
}

- (void)growingTextView:(TKGrowingTextView *)__unused growingTextView willChangeHeight:(float)height animated:(bool)animated
{
    CGRect inputContainerFrame = _inputContainer.frame;
    float newHeight = MAX(10 + height, sChatBarHeight);
    if (inputContainerFrame.size.height != newHeight)
    {
        int currentKeyboardHeight = _knownKeyboardHeight;
        inputContainerFrame.size.height = newHeight;
        inputContainerFrame.origin.y = _inputContainer.superview.frame.size.height - currentKeyboardHeight - inputContainerFrame.size.height;
         _inputContainer.frame = inputContainerFrame;
        _replyText.frame = CGRectMake(10, 5, _inputContainer.frame.size.width - 75 , _inputContainer.frame.size.height - 10);
        
        [TKUtil setHeight:_inputInerContainer To:newHeight-2*6];
        
        [TKUtil setHeight:_inputField To:CGRectGetHeight(_inputInerContainer.frame)];
        
        

        
    }
}

- (void)growingTextViewDidChange:(TKGrowingTextView *)growingTextView
{
    [self updatePlaceholderVisibility:[growingTextView.internalTextView isFirstResponder]];
}

- (BOOL)growingTextViewShouldReturn:(TKGrowingTextView *)growingTextView
{
    [self replyAction];
    return YES;
}

- (BOOL)growingTextViewShouldBeginEditing:(TKGrowingTextView *)growingTextView
{
    _replyText.hidden = YES;
    return YES;
}
- (BOOL)growingTextViewShouldEndEditing:(TKGrowingTextView *)growingTextView
{
    return YES;
}


#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"TKTextViewInternal"] ||  [NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"] )
    {
        return NO;
    }
    else
    {
        
        [self tapTable:nil];
        return ![TKEduSessionHandle shareInstance].iIsCanDraw;
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (void)tapTable:(UIGestureRecognizer *)gesture
{
    
    [_inputField resignFirstResponder];
    [_iUsertListView hide];
    
    if ([_iSessionHandle.roomMgr getRoomConfigration].documentCategoryFlag) {
        [(TKFolderDocumentListView *)_iDocumentListView hide];
        [(TKFolderDocumentListView *)_iMediaListView hide];
    }else{
        [(TKDocumentListView *)_iDocumentListView hide];
        [(TKDocumentListView *)_iMediaListView hide];
    }
    [_iAreaListView hideView];
    [_iTeacherVideoView hideFunctionView];
    [_iOurVideoView hideFunctionView];
    
    for (TKVideoSmallView * view in _iStudentVideoViewArray) {
        [view hideFunctionView];
    }
    //分屏模式下取消functionView的显示
    for (TKVideoSmallView * view in _iStudentSplitViewArray) {
        [view hideFunctionView];
    }
  
    //[self resetTimer];
    //[self moveNaviBar];

}

#pragma mark 横竖屏
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight ;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}
#pragma mark 状态栏
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
#pragma mark 拖动视频
- (void)longPressClick:(UIGestureRecognizer *)longGes
{
    TKVideoSmallView * currentBtn = (TKVideoSmallView *)longGes.view;
    
    //未开始上课禁止拖动视频
    if (![TKEduSessionHandle shareInstance].isClassBegin) {
        return;
    }
    
    // 巡课不能拖视频
    if (_iUserType == UserType_Patrol) {
        return;
    }
    
    // 学生只能在授权下拖拽自己的视频
    if (_iUserType == UserType_Student) {
        if (![TKEduSessionHandle shareInstance].iIsCanDraw) {
            return;
        }
    }
    
    //判断视图是否处于分屏状态，如果是分屏状态则不可以拖动
    for (NSString *peerID in _iStudentSplitScreenArray) {
        if ([peerID isEqualToString:currentBtn.iRoomUser.peerID] ) {
            return;
        }
    }
    
    if (([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol)) {
        return;
    }
    
    //把白板放到最下边
    [_iScroll sendSubviewToBack:_iTKEduWhiteBoardView];
    
    //拖拽视频后如果未放大需要初始化到6个均分的大小
    CGFloat w =((ScreenW-sRightWidth*Proportion-7*VideoSmallViewMargins)/ 6);
    CGFloat h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
    
    
    if (!currentBtn.isSplit && currentBtn.currentWidth<currentBtn.originalWidth) {
        
        currentBtn.frame = CGRectMake(CGRectGetMinX(currentBtn.frame)-(currentBtn.originalWidth - currentBtn.currentWidth), CGRectGetMinY(currentBtn.frame)- (currentBtn.originalHeight - currentBtn.currentHeight), w, h);
        
    }
    
    if (UIGestureRecognizerStateBegan == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
//            currentBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
//            currentBtn.alpha     = 0.7f;
            _iStrtCrtVideoViewP  = [longGes locationInView:currentBtn];
            _iCrtVideoViewC      = currentBtn.center;
        }];
    }
    if (UIGestureRecognizerStateChanged == longGes.state) {
        //移动距离
        CGPoint newP = [longGes locationInView:currentBtn];
        CGFloat movedX = newP.x - _iStrtCrtVideoViewP.x;
        CGFloat movedY = newP.y - _iStrtCrtVideoViewP.y;
        CGFloat tCurBtnCenterX = currentBtn.center.x+ movedX;
        CGFloat tCurBtnCenterY = currentBtn.center.y + movedY;
        //边界
        CGFloat tEdgLeft = CGRectGetWidth(currentBtn.frame)/2.0;
        CGFloat tEdgRight = CGRectGetMaxX(_iTKEduWhiteBoardView.frame) - CGRectGetWidth(currentBtn.frame)/2.0;
        CGFloat tEdgBtm = ScreenH - CGRectGetHeight(currentBtn.frame)/2.0-sViewCap;
        CGFloat tEdgTp = CGRectGetMinY(_iTKEduWhiteBoardView.frame) + CGRectGetHeight(currentBtn.frame)/2.0;
        BOOL isOverEdgLR = (tCurBtnCenterX <= tEdgLeft) || (tCurBtnCenterX >= tEdgRight) || (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        BOOL isOverEdgTD = (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        if (isOverEdgLR) {
            tCurBtnCenterX =  tCurBtnCenterX - movedX;
        }
        if (isOverEdgTD) {
            tCurBtnCenterY = tCurBtnCenterY - movedY;
        }
        currentBtn.center = CGPointMake(tCurBtnCenterX, tCurBtnCenterY);
    }
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
        
        //未完全拖拽到白板
        BOOL isEndEdgMvToScrv = ((currentBtn.center.y< CGRectGetMinY(_iBottomView.frame)) &&(CGRectGetMaxY(currentBtn.frame) > CGRectGetMinY(_iBottomView.frame)));

        //完全拖拽到白板
        BOOL isEndMvToScrv = ((CGRectGetMaxY(currentBtn.frame) <= CGRectGetMinY(_iBottomView.frame)));

        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.alpha     = 1.0f;
            currentBtn.transform = CGAffineTransformIdentity;
            if (isEndEdgMvToScrv ) {

//                currentBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
                currentBtn.isDrag = NO;
                currentBtn.frame= CGRectMake(CGRectGetMinX(currentBtn.frame), CGRectGetMinY(_iBottomView.frame)-CGRectGetHeight(currentBtn.frame), CGRectGetWidth(currentBtn.frame), CGRectGetHeight(currentBtn.frame));
                 

                
            }else if(isEndMvToScrv) {
//                currentBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
                currentBtn.isDrag = YES;
            }else {
//                currentBtn.transform = CGAffineTransformIdentity;
                currentBtn.isDrag = NO;
            }
            
            
            
            //拖动视频的时候判断下视频是否有分屏状态的
            if(_iStudentSplitScreenArray.count>0){
                
                [self beginTKSplitScreenView:currentBtn];
//
                return;
            }
            
            [self refreshBottom];
            [self sendMoveVideo:_iPlayVideoViewDic aSuperFrame:_iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];

        }];
    }
}

/**
 发送视频的位置

 @param aPlayVideoViewDic 位置存储字典
 @param aSuperFrame 父视图
 */
-(void)sendMoveVideo:(NSDictionary *)aPlayVideoViewDic aSuperFrame:(CGRect)aSuperFrame allowStudentSendDrag:(BOOL)isSendDrag{
    
    NSMutableDictionary *tVideosDic = @{}.mutableCopy;
    for (NSString *tKey in aPlayVideoViewDic) {
        
        TKVideoSmallView *tVideoView = [aPlayVideoViewDic objectForKey:tKey];
        CGFloat tX = CGRectGetWidth(aSuperFrame) - CGRectGetWidth(tVideoView.frame);
        CGFloat tY = CGRectGetHeight(aSuperFrame)-CGRectGetHeight(tVideoView.frame);
        CGFloat tLeft = CGRectGetMinX(tVideoView.frame)/tX;
        CGFloat tTop= (CGRectGetMinY(tVideoView.frame)-CGRectGetMinY(aSuperFrame))/tY;
        if(tVideoView.isSplit){
            tLeft = 0;
            tTop = 0;
        }
            
        NSDictionary *tDic = @{@"percentTop":@(tTop),@"percentLeft":@(tLeft),@"isDrag":@(tVideoView.isDrag)};
        if ((tVideoView.iRoomUser.role == UserType_Student) || (tVideoView.iRoomUser.role == UserType_Assistant) || (tVideoView.iRoomUser.role == UserType_Teacher) ) {
             [tVideosDic setObject:tDic forKey:tVideoView.iPeerId?tVideoView.iPeerId:@""];
        }
       
    }
    NSDictionary *tDic =   @{@"otherVideoStyle":tVideosDic};
    
    _iMvVideoDic = [NSMutableDictionary dictionaryWithDictionary:tVideosDic];
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher || isSendDrag) {
        [[TKEduSessionHandle shareInstance]publishVideoDragWithDic:tDic To:sTellAllExpectSender];
    }
    
}


-(void)moveVideo:(NSDictionary *)aMvVideoDic{
   
    for (NSString *peerId in aMvVideoDic) {
        NSDictionary *obj = [aMvVideoDic objectForKey:peerId];
        BOOL isDrag = [[obj objectForKey:@"isDrag"]boolValue];
        //对返回的数据做NSNull值判断
        if([[obj objectForKey:@"percentTop"] isKindOfClass:[NSNull class]]){
            return;
        }
        if([[obj objectForKey:@"percentLeft"] isKindOfClass:[NSNull class]]){
            return;
        }
        CGFloat top = [[obj objectForKey:@"percentTop"]floatValue];
        CGFloat left = [[obj objectForKey:@"percentLeft"]floatValue];
        TKVideoSmallView *tVideoView = [_iPlayVideoViewDic objectForKey:peerId];
        
        if (tVideoView) {
            tVideoView.isDrag = isDrag;
            tVideoView.isDragWhiteBoard = isDrag;
            if (isDrag) {
                
                if (!tVideoView.isSplit && tVideoView.currentWidth<tVideoView.originalWidth) {
                    CGFloat w =((ScreenW-sRightWidth*Proportion -7*VideoSmallViewMargins)/ 6);
                    CGFloat h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
                    
                    tVideoView.frame = CGRectMake(CGRectGetMinX(tVideoView.frame)-(tVideoView.originalWidth - tVideoView.currentWidth), CGRectGetMinY(tVideoView.frame)- (tVideoView.originalHeight - tVideoView.currentHeight), w, h);
                }
                    
                CGFloat tX = CGRectGetWidth(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(tVideoView.frame);
                CGFloat tY = CGRectGetHeight(self.iTKEduWhiteBoardView.frame) - CGRectGetHeight(tVideoView.frame);
                tVideoView.frame = CGRectMake(tX*left, CGRectGetMinY(self.iTKEduWhiteBoardView.frame)+ tY*top, CGRectGetWidth(tVideoView.frame), CGRectGetHeight(tVideoView.frame));
              
                
            }else{
                
                // 当老师拖拽后，网页助教再拖拽，收到的拖拽信令中有老师的peerID，因为从网页收到了老师view变化的错误信令
                if (tVideoView.iRoomUser.role != UserType_Teacher) {
//                    tVideoView.frame = CGRectMake(CGRectGetMinX(tVideoView.frame), CGRectGetMinY(_iBottomView.frame)+1, CGRectGetWidth(tVideoView.frame), CGRectGetHeight(tVideoView.frame));
                }
                
            }
            
        }
    }
    
    [self refreshBottom];
}
- (void)sScaleVideo:(NSDictionary *)peerIdToScaleDic{
    
    NSArray *peerIdArray = peerIdToScaleDic.allKeys;
    
    for (NSString *peerId in peerIdArray) {
        NSDictionary *scaleDict = [peerIdToScaleDic objectForKey:peerId];
        
        CGFloat scale = [scaleDict[@"scale"] floatValue];
        
        TKVideoSmallView *videoView = [self videoViewForPeerId:peerId];
        
        if (videoView && videoView.isDrag == YES) {
            [videoView changeVideoSize:scale];
        }
    }
}
- (void)sVideoSplitScreen:(NSMutableArray *)array{
    
    
    //在_iStudentVideoViewArray 中删除视图
    
    NSArray *vArray = [NSArray arrayWithArray:_iStudentVideoViewArray];
    
    for (TKVideoSmallView *videoView in vArray) {
        
        for (int i=0;i<array.count;i++) {
            
            NSString *peerId = array[i];
            
            if ([peerId isEqualToString:videoView.iRoomUser.peerID]) {
                
                [self beginTKSplitScreenView:videoView];
                
            }
        }
    }
}

#pragma mark 其他
- (void)showMessage:(NSString *)message {
    NSArray *array = [UIApplication sharedApplication].windows;
    int count = (int)array.count;
    [TKRCGlobalConfig HUDShowMessage:message addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
}
#pragma mark 声音
- (void)handleAudioSessionInterruption:(NSNotification*)notification {
    
    NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber *interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    
    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:{
            // • Audio has stopped, already inactive
            // • Change state of UI, etc., to reflect non-playing state
        } break;
        case AVAudioSessionInterruptionTypeEnded:{
            // • Make session active
            // • Update user interface
            // • AVAudioSessionInterruptionOptionShouldResume option
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                // Here you should continue playback.
                //[player play];
            }
        } break;
        default:
            break;
    }
    AVAudioSessionInterruptionType type = (AVAudioSessionInterruptionType)[notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    TKLog(@"---jin 当前category: 打断 %@",@(type));
}


-(void)handleMediaServicesReset:(NSNotification *)aNotification{
    
    
    
    AVAudioSessionInterruptionType type = (AVAudioSessionInterruptionType)[aNotification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    TKLog(@"---jin 当前AVAudioSessionMediaServicesWereResetNotification: 打断 %@",@(type));
    
    
    
}
- (void)routeChange:(NSNotification*)notify{
    if(notify){
        
        if (([AVAudioSession sharedInstance].categoryOptions !=AVAudioSessionCategoryOptionMixWithOthers )||([AVAudioSession sharedInstance].category !=AVAudioSessionCategoryPlayAndRecord) ) {
            //[[TKEduSessionHandle shareInstance]configurePlayerRoute:[TKEduSessionHandle shareInstance].isPlayMedia isCancle:NO];
        }
        
        [self pluggInOrOutMicrophone:notify.userInfo];
        [self printAudioCurrentCategory];
        [self printAudioCurrentMode];
        [self printAudioCategoryOption];
        
    }
    
}
// 插拔耳机
-(void)pluggInOrOutMicrophone:(NSDictionary *)userInfo{
    NSDictionary *interuptionDict = userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            
            TKLog(@"---jin 耳机插入");
            [TKEduSessionHandle shareInstance].isHeadphones = YES;
            [TKEduSessionHandle shareInstance].iVolume = 0.5;
           // [[TKEduSessionHandle shareInstance]configurePlayerRoute:[TKEduSessionHandle shareInstance].isPlayMedia isCancle:NO];
            [[TKEduSessionHandle shareInstance]configurePlayerRoute: NO isCancle:NO];
            if ([TKEduSessionHandle shareInstance].isPlayMedia){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:
                 sPluggInMicrophoneNotification
                                                                    object:nil];
            }
            
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            
            [TKEduSessionHandle shareInstance].isHeadphones = NO;
            [TKEduSessionHandle shareInstance].iVolume = 1;
             [[TKEduSessionHandle shareInstance]configurePlayerRoute: NO isCancle:NO];
            //[[TKEduSessionHandle shareInstance]configurePlayerRoute:[TKEduSessionHandle shareInstance].isPlayMedia isCancle:NO];
            if ([TKEduSessionHandle shareInstance].isPlayMedia) {
                [[NSNotificationCenter defaultCenter] postNotificationName:sUnunpluggingHeadsetNotification
                                                                    object:nil];
            }
            
            TKLog(@"---jin 耳机拔出，停止播放操作");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            TKLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
    
}
//打印日志
- (void)printAudioCurrentCategory{
    
    NSString *audioCategory =  [AVAudioSession sharedInstance].category;
    if ( audioCategory == AVAudioSessionCategoryAmbient ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryAmbient");
    } else if ( audioCategory == AVAudioSessionCategorySoloAmbient ){
        NSLog(@"---jin current category is : AVAudioSessionCategorySoloAmbient");
    } else if ( audioCategory == AVAudioSessionCategoryPlayback ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryPlayback");
    }  else if ( audioCategory == AVAudioSessionCategoryRecord ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryRecord");
    } else if ( audioCategory == AVAudioSessionCategoryPlayAndRecord ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryPlayAndRecord");
    } else if ( audioCategory == AVAudioSessionCategoryAudioProcessing ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryAudioProcessing");
    } else if ( audioCategory == AVAudioSessionCategoryMultiRoute ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryMultiRoute");
    }  else {
        NSLog(@"---jin current category is : unknow");
    }
    
}

- (void)printAudioCurrentMode{
    
    
    NSString *audioMode =  [AVAudioSession sharedInstance].mode;
    if ( audioMode == AVAudioSessionModeDefault ){
        NSLog(@"---jin current mode is : AVAudioSessionModeDefault");
    } else if ( audioMode == AVAudioSessionModeVoiceChat ){
        NSLog(@"---jin current mode is : AVAudioSessionModeVoiceChat");
    } else if ( audioMode == AVAudioSessionModeGameChat ){
        NSLog(@"---jin current mode is : AVAudioSessionModeGameChat");
    }  else if ( audioMode == AVAudioSessionModeVideoRecording ){
        NSLog(@"---jin current mode is : AVAudioSessionModeVideoRecording");
    } else if ( audioMode == AVAudioSessionModeMeasurement ){
        NSLog(@"---jin current mode is : AVAudioSessionModeMeasurement");
    } else if ( audioMode == AVAudioSessionModeMoviePlayback ){
        NSLog(@"---jin current mode is : AVAudioSessionModeMoviePlayback");
    } else if ( audioMode == AVAudioSessionModeVideoChat ){
        NSLog(@"---jin current mode is : AVAudioSessionModeVideoChat");
    }else if ( audioMode == AVAudioSessionModeSpokenAudio ){
        NSLog(@"---jin current mode is : AVAudioSessionModeSpokenAudio");
    } else {
        NSLog(@"---jin current mode is : unknow");
    }
    
}

-(void)printAudioCategoryOption{
    NSString *tSString = @"AVAudioSessionCategoryOptionMixWithOthers";
    switch ([AVAudioSession sharedInstance].categoryOptions) {
        case AVAudioSessionCategoryOptionDuckOthers:
            tSString = @"AVAudioSessionCategoryOptionDuckOthers";
            break;
        case AVAudioSessionCategoryOptionAllowBluetooth:
            tSString = @"AVAudioSessionCategoryOptionAllowBluetooth";
            if (![TKEduSessionHandle shareInstance].isPlayMedia) {
                NSLog(@"---jin sessionManagerUserPublished");
                [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
                
            }
            break;
        case AVAudioSessionCategoryOptionDefaultToSpeaker:
            tSString = @"AVAudioSessionCategoryOptionDefaultToSpeaker";
            break;
        case AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers:
            tSString = @"AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers";
            break;
        case AVAudioSessionCategoryOptionAllowBluetoothA2DP:
            tSString = @"AVAudioSessionCategoryOptionAllowBluetoothA2DP";
            break;
        case AVAudioSessionCategoryOptionAllowAirPlay:
            tSString = @"AVAudioSessionCategoryOptionAllowAirPlay";
            break;
        default:
            break;
    }
    
    TKLog(@"---jin current categoryOptions is :%@",tSString);
}

#pragma mark 开始
-(void)onClassReady{
    
    if(!_iRoomProperty.iHowMuchTimeServerFasterThenMe)
        return;
    
    if (![TKEduSessionHandle shareInstance].isClassBegin && _iUserType == UserType_Teacher) {
        _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iRoomProperty.iHowMuchTimeServerFasterThenMe;
        //1498569290.216449
        BOOL tEnabled = _iRoomProperty.iStartTime != 0 &&((int)((_iRoomProperty.iStartTime*1000 -_iRoomProperty.iCurrentTime*1000)/1000) < 60);
        [_iClassBeginAndRaiseHandButton setEnabled:tEnabled];
        _iClassBeginAndRaiseHandButton.backgroundColor = tEnabled ?RGBACOLOR_ClassBegin_RedDeep:RGBACOLOR_ClassEnd_Red ;
        
        
        if ((int)((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000)>=-60 &&((int)((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000)< 0 && !_iShowBefore)) {
            
            _iShowBefore = YES;
            [_iClassTimeView showPromte:PromptTypeStartReady1Minute aPassEndTime: ((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000) aPromptTime:5];
            
        }else if(((int)(_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000)/60>=1 && !_iShow &&(_iRoomProperty.iCurrentTime-_iRoomProperty.iStartTime)>0 ){
            
            [_iClassTimeView showPromte:PromptTypeStartPass1Minute aPassEndTime: (int)((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000) aPromptTime:5];
            _iShow = YES;
            
            
        }
        
    }
    
}

-(void)invalidateClassReadyTime{
    if (_iClassReadyTimetimer) {
        [_iClassReadyTimetimer invalidate];
        _iClassReadyTimetimer = nil;
        [_iClassTimeView hidePromptView];
    }
    
}
-(void)startClassReadyTimer{

    
     _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970];
    [_iClassReadyTimetimer setFireDate:[NSDate date]];
}

- (void)onClassCurrentTimer{
    
    if(!_iRoomProperty.iHowMuchTimeServerFasterThenMe)
        return;
    
    _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iRoomProperty.iHowMuchTimeServerFasterThenMe;
    
    NSTimeInterval interval = _iRoomProperty.iEndTime -_iRoomProperty.iCurrentTime;
    NSInteger time = interval;
    //（1）未到下课时间： 老师点下课 —> 下课后不离开教室forbidLeaveClassFlag—>提前5分钟给出提示语（老师、助教）—>下课时间到，课程结束，一律离开
    
    if(_iSessionHandle.iIsClassEnd && [_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
        
        if (time<=0) {
            [self showMessage:MTLocalized(@"Prompt.ClassEnd")];
            [self prepareForLeave:YES];
        }
    }
}
-(void)onClassTimer {
    
    //此处主要用于检测上课过程中进入后台后无法返回前台的状况
    BOOL isBackground = [_iSessionHandle.roomMgr.localUser.properties[sIsInBackGround] boolValue];
    if(([UIApplication sharedApplication].applicationState == UIApplicationStateActive) && isBackground){
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
        [TKEduSessionHandle shareInstance].roomMgr.inBackground = NO;
    }
    
    if(!_iRoomProperty.iHowMuchTimeServerFasterThenMe)
        return;
    
    _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iRoomProperty.iHowMuchTimeServerFasterThenMe;
    
    if ([self.iSessionHandle.roomMgr getRoomConfigration].endClassTimeFlag) {
        NSTimeInterval interval = _iRoomProperty.iEndTime -_iRoomProperty.iCurrentTime;
        NSInteger time = interval;
        //(2)未到下课时间： 老师未点下课->下课时间到->课程结束，一律离开
        //(3)到下课时间->提前5分钟给出提示语（老师，助教）->课程结束，一律离开

        if (time<=0) {
            [self showMessage:MTLocalized(@"Prompt.ClassEnd")];
            [self prepareForLeave:YES];
        }
    }
    
    //_iLocalTime = _iTKEduClassRoomProperty.iCurrentTime - _iTKEduClassRoomProperty.iStartTime;
    [_iClassTimeView setClassTime:_iLocalTime];
    
    //测试
    {

//        _cpuLabel.text = [NSString stringWithFormat:@"cpu:%f",[TKUtil GetCpuUsage]];
//        _memoryLabel.text = [NSString stringWithFormat:@"m:%f",[TKUtil GetCurrentTaskUsedMemory]];
    }
    
    [self invalidateClassReadyTime];
    if ([TKEduSessionHandle shareInstance].isClassBegin && _iUserType == UserType_Teacher) {
        
        int tDele = (int)(_iRoomProperty.iCurrentTime*1000 - _iRoomProperty.iEndTime*1000)/1000;
        //距离下课3分钟
        BOOL tEnabled;
        if ([[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
            tEnabled = _iRoomProperty.iEndTime != 0 && tDele+60 >= 0;
        } else {
            tEnabled = YES;    // 下课总是可以点击的
        }
        
        [_iClassBeginAndRaiseHandButton setEnabled:tEnabled];
        _iClassBeginAndRaiseHandButton.backgroundColor = tEnabled?RGBACOLOR_ClassBegin_RedDeep:RGBACOLOR_ClassEnd_Red;
        [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
        PromptType tPromptType = PromptTypeEndWill1Minute;
        
        // 只有YLB显示下课提示
        if ([[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
            if ((tDele >= -60) && (tDele <= -59)) {
                
                tPromptType = PromptTypeEndWill1Minute;
                [_iClassTimeView showPromte:tPromptType aPassEndTime:1 aPromptTime:5];
            }else if (tDele>=180 && tDele<=181){
                
                tPromptType = PromptTypeEndPass3Minute;
                [_iClassTimeView showPromte:tPromptType aPassEndTime:3 aPromptTime:5];
            }else if(tDele >=290 &&tDele<=291){
                
                tPromptType = PromptTypeEndPass5Minute;
                [_iClassTimeView showPromte:tPromptType aPassEndTime:0 aPromptTime:10];
            }
            
            if((tDele >60) ){
                tPromptType = PromptTypeEndPass;
                [_iClassTimeView showPromte:tPromptType aPassEndTime:0 aPromptTime:0];
            }
            //设置黄色
            BOOL tEnd1Minute = !(tDele>=-60 && tDele <-55) && (tDele>-55)&& (tDele<0);
            if ((tEnd1Minute)) {
                
                tPromptType = PromptTypeEndWill1Minute;
                [_iClassTimeView showPromte:tPromptType aPassEndTime:0 aPromptTime:0];
            }
        }
        
        // 下课时间到，下课（只有英联邦下课时间到才下课）
        if (tDele>300 && [[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
            
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
            UIButton *tButton = _iClassBeginAndRaiseHandButton;
            UIView *tView = _iClassBeginAndOpenAlumdView;
            [TKEduNetManager classBeginEnd:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
            
                [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
                [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{} completion:nil];
                tButton.hidden = YES;
                tView.hidden = YES;
                  [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                
                return 0;
            } aNetError:^int(id  _Nullable response) {
               
                  [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
             
                return 0;
            }];
            
        }
    }
    _iLocalTime ++;
    
}
-(void)invalidateClassBeginTime{
    
    if (_iClassTimetimer) {
        [_iClassTimetimer invalidate];
        _iLocalTime = 0;
        _iClassTimetimer = nil;
    }
   
}
- (void)invalidateClassCurrentTime{
    if (_iClassCurrentTimer) {
        [_iClassCurrentTimer invalidate];
        _iClassCurrentTimer = nil;
    }
}

-(void)startClassBeginTimer{
    _iLocalTime = 0;
    [_iClassTimetimer setFireDate:[NSDate date]];
    [self invalidateClassReadyTime];
}
-(void)dealloc{
    NSLog(@"roomController----dealloc");
}
    
    
#pragma mark 上传图片
// 学生端 上传图片
-(void)openAlbum:(UIButton*)sender{
    //上传文档
   self.OpenAlbumActionSheet  = [UIAlertController alertControllerWithTitle:MTLocalized(@"Action.Title") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    _OpenAlbumActionSheet.modalPresentationStyle = UIModalPresentationPopover;
    
    __weak  typeof(self) weekSelf = self;
    UIAlertAction *tAction2 = [UIAlertAction actionWithTitle:MTLocalized(@"Action.ChoosePhoto") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weekSelf)strongSelf = weekSelf;
        [strongSelf chooseAction:0 delay:NO];
        
    }];
    
    UIAlertAction *tAction = [UIAlertAction actionWithTitle:MTLocalized(@"Action.TakePhoto") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weekSelf)strongSelf = weekSelf;
        [strongSelf chooseAction:1 delay:NO];
    }];
    UIAlertAction *tAction3 = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        _OpenAlbumActionSheet.popoverPresentationController.sourceView = sender;
        // sourceView（触发弹出框的视图）和sourceRect（弹出框应指向的矩形区域）
        _OpenAlbumActionSheet.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
        _OpenAlbumActionSheet.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;
        
    }
    [_OpenAlbumActionSheet addAction:tAction];
    [_OpenAlbumActionSheet addAction:tAction2];
    [_OpenAlbumActionSheet addAction:tAction3];
    
    [self presentViewController:_OpenAlbumActionSheet animated:YES completion:nil];
    
    return;
}
// 老师端。文档列表页上传图片
- (void)uploadPhotos:(NSNotification *)notify
{
    if ([_iSessionHandle.roomMgr getRoomConfigration].documentCategoryFlag) {
        if (((TKFolderDocumentListView *)_iDocumentListView).isShow) {
            [(TKFolderDocumentListView *)_iDocumentListView hide];
        }
    } else {
        if (((TKDocumentListView *)_iDocumentListView).isShow) {
            [(TKDocumentListView *)_iDocumentListView hide];
        }
    }
    if ([notify.object isEqualToString:sTakePhotosUploadNotification]) {
        //拍照上传
        [self chooseAction:1 delay:NO];
    }else if ([notify.object isEqualToString:sChoosePhotosUploadNotification])
    {
        //从图库上传
        [self chooseAction:0 delay:YES];
    }
}

-(void)chooseAction:(int)buttonIndex delay:(BOOL)delay
{ 
    if (buttonIndex == 0) {
        // 打开相册
        //资源类型为图片库
        _iPickerController = [[UIImagePickerController alloc] init];
        [_iPickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        _iPickerController.navigationBar.tintColor = RGBCOLOR(255, 255, 255);
        _iPickerController.navigationBar.barTintColor = RGBCOLOR(42, 180, 242);
        
        _iPickerController.navigationBar.alpha = 1;
        _iPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑
        _iPickerController.allowsEditing = false;
        
        _iPickerController.delegate = self;
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:_iPickerController
                                   animated:true
                                 completion:nil];
            });
        } else {
            [self presentViewController:_iPickerController
                               animated:true
                             completion:nil];
        }
        _OpenAlbumActionSheet = nil;
        
    } else if (buttonIndex == 1) {
        //拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusAuthorized) {
                _iPickerController = [[UIImagePickerController alloc] init];
                //设置拍照后的图片可被编辑
                //资源类型为照相机
                _iPickerController.sourceType = sourceType;
                [[TKEduSessionHandle shareInstance] sessionHandleEnableVideo:NO];
                
                _iPickerController.delegate = self;
                [self presentViewController:_iPickerController
                                   animated:true
                                 completion:nil];
                
                _OpenAlbumActionSheet = nil;
            } else {
                TKLog(@"该设备无摄像头");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:MTLocalized(@"Prompt.NeedCamera") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Sure") style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:tActionSure];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } else {
            TKLog(@"该设备无摄像头");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:MTLocalized(@"Prompt.NeedCamera") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Sure") style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:tActionSure];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    //图片大于2M时会被旋转
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,
                                                   aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the
    // transform
    // calculated above.
    CGContextRef ctx =
    CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                          CGImageGetBitsPerComponent(aImage.CGImage), 0,
                          CGImageGetColorSpace(aImage.CGImage),
                          CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(
                               ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width),
                               aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(
                               ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height),
                               aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (void)cancelUpload
{
    [self removProgressView];
    
}
- (void)removProgressView {
    if (_uploadImageView) {
        [_uploadImageView removeFromSuperview];
        _uploadImageView = nil;
        _iPickerController = nil;
    }
}



#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //[_session resumeLocalCamera];
    // [self showWithGradient];
     [[TKEduSessionHandle shareInstance]sessionHandleEnableVideo:YES];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage *img;
    if (picker.allowsEditing)
    img = [info objectForKey:UIImagePickerControllerEditedImage];
    else
    img = [info objectForKey:UIImagePickerControllerOriginalImage];
    img = [self fixOrientation:img];
    _progress = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
          _iPickerController = nil;
        
        //[HUD hide:YES];
        //HUD = nil;
        if (!_uploadImageView) {
            _uploadImageView = [[TKUploadImageView alloc]
                                initWithImage:img];
            
            _uploadImageView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
            _uploadImageView.layer.masksToBounds = YES;
            _uploadImageView.layer.cornerRadius = 4;
            _uploadImageView.layer.borderWidth = 2.f;
            _uploadImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
            _uploadImageView.userInteractionEnabled = YES;
            //[self.view addSubview:_uploadImageView];
            _uploadImageView.target = self;
            _uploadImageView.action = @selector(cancelUpload);
            [_uploadImageView setProgress:0];
            
        }
    });
   
    tk_weakify(self);
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
      
//       昵称_入口_年-月-日_时_分_秒
        NSString *fileName  = [NSString stringWithFormat:@"%@_%@_%@.JPG",[TKEduSessionHandle shareInstance].localUser.nickName,sMobile, [TKUtil getCurrentDateTime]];
        
        NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
        tk_strongify(weakSelf);
        
        [TKEduNetManager uploadWithaHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort roomID:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId fileData:imgData fileName:fileName fileType:@"JPG" userName:[TKEduSessionHandle shareInstance].localUser.nickName userID:[TKEduSessionHandle shareInstance].localUser.peerID delegate:strongSelf];
        
    };
    
    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:^(NSError *error) {
                      TKLog(@"获取图片失败");

                  }];
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   
    [picker dismissViewControllerAnimated:YES completion:^{
        [[TKEduSessionHandle shareInstance]sessionHandleEnableVideo:YES];
        _iPickerController = nil;
        [self refreshUI];
        //[_session resumeLocalCamera];
    }];
   
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)uploadProgress:(int)req totalBytesSent:(int64_t)totalBytesSent bytesTotal:(int64_t)bytesTotal{
    float progress = totalBytesSent/bytesTotal;
     [_uploadImageView setProgress:progress];
}

- (void)uploadFileResponse:(id _Nullable )Response req:(int)req{
    
    if (!req && [Response isKindOfClass:[NSDictionary class]]) {
        /*
         downloadpath = "/upload/20171018_143749_erncmoyt.jpg";
         dynamicppt = 0;
         fileid = 25034;
         filename = "171018143748.JPG";
         fileprop = 0;
         pagenum = 1;
         result = 0;
         size = 86210;
         status = 1;
         swfpath = "/upload/20171018_143749_erncmoyt.jpg";
         */

        NSDictionary *tFileDic = (NSDictionary *)Response;
        TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
        [tDocmentDocModel setValuesForKeysWithDictionary:tFileDic];
        [tDocmentDocModel dynamicpptUpdate];
        tDocmentDocModel.filetype = @"jpeg";
        [[TKEduSessionHandle shareInstance] addOrReplaceDocmentArray:tDocmentDocModel];
        [[TKEduSessionHandle shareInstance]addDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
        [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
        [self removProgressView];
        [[TKEduSessionHandle shareInstance]sessionHandleEnableVideo:YES];
        [self refreshUI];
       
    }
}
- (void)getMeetingFileResponse:(id _Nullable )Response{
    
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([@"idleTimerDisabled" isEqualToString:keyPath] && [TKEduSessionHandle shareInstance].iIsJoined && ![[change objectForKey:@"new"]boolValue]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
   
}

- (void)changeServer:(NSString *)server {
    
    if ([server isEqualToString:self.currentServer]) {
        return;
    }
    self.currentServer = server;
    [[NSUserDefaults standardUserDefaults] setObject:self.currentServer forKey:@"server"];
//    // 改变底层的服务器数据
//    [[TKRoomManager instance] changeCurrentServer:server];
    
//    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_iParamDic];
//    [tempDic setObject:server forKey:@"server"];
//
//    TKEduRoomProperty *tClassRoomProperty  = _iRoomProperty;
//    NSDictionary *tDic = tempDic;
//    [TKEduNetManager getGiftinfo:tClassRoomProperty.iRoomId aParticipantId: tClassRoomProperty.iUserId  aHost:tClassRoomProperty.sWebIp aPort:tClassRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            int result = 0;
//            result = [[response objectForKey:@"result"]intValue];
//            if (!result || result == -1) {
//
//                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
//                int giftnumber = 0;
//                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
//                    if (![tClassRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
//                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
//                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:tClassRoomProperty.iUserId]) {
//
//                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
//                            break;
//
//                        }
//                    }
//                }
//
//                // 清空之前的数据
//                [self sessionManagerDidFailWithError:nil];
//                // 更新当前房间的区域
//                self.currentServer = server;
//
//                [[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:tDic aProperties:@{sGiftNumber:@(giftnumber)}];
//            }
//        });
//
//    } aGetGifInfoError:^int(NSError * _Nullable aError) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 清空之前的数据
//            [self sessionManagerDidFailWithError:nil];
//            // 更新当前房间的区域
//            self.currentServer = server;
//
//            [[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:tDic aProperties:nil];
//        });
//
//        return 1;
//    }];
}

#pragma mark TKChooseAreaDelegate 选择区域
- (void)chooseArea:(TKAreaChooseModel *)areaModel {
    // 记录选择的服务器
//    [[NSUserDefaults standardUserDefaults] setObject:areaModel.serverAreaName forKey:@"server"];
    
//    if ([areaModel.serverAreaName isEqualToString:_iRoomProperty.defaultServerArea]) {
//        [self.iAreaListView hideView];
//        return;
//    }
    
    // 改变底层的服务器数据
//    [[TKRoomManager instance] changeCurrentServer:areaModel.serverAreaName];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:_iParamDic];
//    [tempDic setObject:areaModel.serverAreaName forKey:@"server"];
    
    TKEduRoomProperty *tClassRoomProperty  = _iRoomProperty;
    NSDictionary *tDic = tempDic;
    [TKEduNetManager getGiftinfo:tClassRoomProperty.iRoomId aParticipantId: tClassRoomProperty.iUserId  aHost:tClassRoomProperty.sWebIp aPort:tClassRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![tClassRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:tClassRoomProperty.iUserId]) {
                            
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                // 清空之前的数据
                [self sessionManagerDidFailWithError:nil];
                // 更新当前房间的区域
//                self.iRoomProperty.defaultServerArea = areaModel.serverAreaName;
                
                [[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:tDic aProperties:@{sGiftNumber:@(giftnumber)}];

                [self.iAreaListView hideView];
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 清空之前的数据
            [self sessionManagerDidFailWithError:nil];
            // 更新当前房间的区域
//            self.iRoomProperty.defaultServerArea = areaModel.serverAreaName;
            
            [[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:tDic aProperties:nil];

            [self.iAreaListView hideView];
        });
        
        return 1;
    }];
}

#pragma mark Public
- (TKVideoSmallView *)videoViewForPeerId:(NSString *)peerId {
    if (peerId == nil) {
        return nil;
    }
    
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        if ([view.iRoomUser.peerID isEqualToString:peerId]) {
//        if([view.iPeerId isEqualToString:peerId]){
            return view;
        }
    }
    
    return nil;
}

#pragma mark Private

// 获取礼物数
- (void)getTrophyNumber {
    
    // 老师不需要获取礼物
    if (_iSessionHandle.localUser.role != UserType_Student || _iSessionHandle.isPlayback == YES) {
        return;
    }
    
    // 学生断线重连需要获取礼物
    [TKEduNetManager getGiftinfo:_iRoomProperty.iRoomId aParticipantId: _iRoomProperty.iUserId  aHost:_iRoomProperty.sWebIp aPort:_iRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![_iRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_iRoomProperty.iUserId]) {
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                self.iSessionHandle.localUser.properties[sGiftNumber] = @(giftnumber);
                [_iSessionHandle sessionHandleChangeUserProperty:self.iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sGiftNumber Value:@(giftnumber) completion:nil];
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        TKLog(@"获取奖杯数量失败");
        return -1;
    }];
    
}

- (void)quitClearData {
    [[TKEduSessionHandle shareInstance]configureDraw:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
    [[TKEduSessionHandle shareInstance].iBoardHandle disconnectCleanup];
    [_iSessionHandle clearAllClassData];
    [_iSessionHandle.iBoardHandle clearAllWhiteBoardData];
    [self clearVideoViewData:_iTeacherVideoView];
    [self clearVideoViewData:_iOurVideoView];
    for (TKVideoSmallView *view in _iStudentVideoViewArray) {
        [self clearVideoViewData:view];
    }
    [_iPlayVideoViewDic removeAllObjects];
    
    // 播放的MP4前，先移除掉上一个MP4窗口
    if (self.iMediaView) {
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    
    //将分屏的数据删除
    for (TKVideoSmallView *view in _iStudentSplitViewArray) {
        //[view clearVideoData];
        [self clearVideoViewData:view];
    }
    [_splitScreenView deleteAllVideoSmallView];
    [_iStudentSplitScreenArray removeAllObjects];
}

#pragma mark - 常用语
- (void)xc_loadPhraseData {
    self.xc_phraseMuArray = [NSMutableArray array];
    
    [[BaseService share] sendGetRequestWithPath:URL_GetContrastInfo token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        NSArray *data = responseObject[@"data"];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGT_CoursePhraseModel *model = [GGT_CoursePhraseModel yy_modelWithDictionary:obj];
            [self.xc_phraseMuArray addObject:model];
        }];
        
    } failure:^(NSError *error) {
        
    }];
}
//MARK:显示聊天弹窗
- (void)replyAction2:(UIButton *)button {
    button.selected = YES;
    [self.view endEditing:YES];
    [self showPopView:button];
}

- (void)showPopView:(UIButton *)button {
    //showPopView
    GGT_PopoverController *vc = [GGT_PopoverController new];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = self.xc_commonButton;
    vc.popoverPresentationController.sourceRect = button.bounds;
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    vc.popoverPresentationController.delegate = self;
    
    vc.xc_phraseMuArray = self.xc_phraseMuArray;
    
    // 修改弹出视图的size 在控制器内部修改更好
    //    vc.preferredContentSize = CGSizeMake(100, 100);
    [self presentViewController:vc animated:YES completion:nil];
    
    @weakify(self)
    vc.dismissBlock = ^(NSString *selectString) {
        @strongify(self);
        NSLog(@"点击了---%@", selectString);
        button.selected = NO;
        if ([selectString isKindOfClass:[NSString class]]) {
            if (selectString.length>0) {
                //                [self.room.chatVM sendMessage:selectString];
                self.inputField.text = selectString;
                //                [self replyAction];
                
                NSDictionary *messageDic = @{@"msg":selectString, @"type":@(0)};
                NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *messageConvertStr = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
                [[TKEduSessionHandle shareInstance] sessionHandleSendMessage:messageConvertStr toID:@"__all" extensionJson:nil];
                /**
                 发送聊天信息功能函数
                 @param message 发送的聊天消息文本 , 支持 NSString 、NSDictionary、JSONString
                 @param toID 发送给谁 , NSString  要通知给哪些用户。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
                 @param extension 扩展的发送的聊天消息数据 , 支持 NSString(JSON字符串string) 、NSDictionary
                 */
                
            }
        }
    };
}

#pragma mark - UIPopoverPresentationControllerDelegate
//默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//点击蒙版是否消失，默认为yes；
-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.xc_commonButton.selected = NO;
    return YES;
}

//弹框消失时调用的方法
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"弹框已经消失");
}


- (void)didReceiveMemoryWarning{
    
}

@end