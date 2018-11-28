//
//  TKDocumentListView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/13.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKDocumentListView.h"

#import "TKUtil.h"
#import "TKUserListTableViewCell.h"
#import "TKMediaDocModel.h"
#import "TKDocmentDocModel.h"
#import "RoomController.h"
#import "TKProgressHUD.h"
#import "TKEduNetManager.h"

#define kMargin 20
#define kBtnHeight 40

@interface TKDocumentListView ()<listProtocol>
@property (nonatomic,retain)UILabel  *iFileHeadLabel;
@property (nonatomic,assign)FileListType  iFileListType;
@property (nonatomic,retain)NSMutableArray *iFileMutableArray;
@property (nonatomic,retain)UITableView    *iFileTableView;

@property (nonatomic,assign)BOOL  isClassBegin;
@property (nonatomic,strong)UIButton*  iCurrrentButton;
@property (nonatomic,strong)UIButton*  iPreButton;

@property (nonatomic,strong)TKProgressHUD*  iVideoPlayerHud;

@property (nonatomic, strong) UIButton *takePhotoBtn;//拍照上传
@property (nonatomic, strong) UIButton *choosePicBtn;//选择照片
@end

@implementation TKDocumentListView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(35, 35, 35, 0.6);
        _iFileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:UITableViewStyleGrouped];
        _iFileTableView.backgroundColor = [UIColor clearColor];
        _iFileTableView.separatorColor  = [UIColor clearColor];
        _iFileTableView.showsHorizontalScrollIndicator = NO;
        _iFileTableView.delegate   = self;
        _iFileTableView.dataSource = self;
        _isClassBegin = NO;
        _iFileTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _iFileHeadLabel = ({
            UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 60)];
            
            tLabel.text = MTLocalized(@"Title.UserList.two");
            tLabel.font = TITLE_FONT;
            tLabel.textAlignment = NSTextAlignmentCenter;
            tLabel.textColor = RGBCOLOR(225, 225, 225);
            tLabel;
            
        });
        _iFileTableView.tableHeaderView = _iFileHeadLabel;
        [_iFileTableView registerClass:[TKUserListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        [self addSubview:_iFileTableView];
        _isShow = NO;
        [self createUploadPhotosButton];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}

- (void)createUploadPhotosButton
{
    if (_takePhotoBtn && _choosePicBtn) {
        return;
    }
    CGFloat btnWidth = (self.width - kMargin * 3) / 2;
    
    _takePhotoBtn = [self createCommonButtonWithFrame:CGRectMake(kMargin, self.height - kBtnHeight - kMargin, btnWidth, kBtnHeight) title:MTLocalized(@"UploadPhoto.TakePhoto") backgroundColor:UIColorRGB(0x30b3e4) selector:@selector(takePhotosAction:)];
    
    [self addSubview:_takePhotoBtn];
    
    _choosePicBtn = [self createCommonButtonWithFrame:CGRectMake(_takePhotoBtn.x + _takePhotoBtn.width + kMargin, self.height - kBtnHeight - kMargin, btnWidth, kBtnHeight) title:MTLocalized(@"UploadPhoto.FromGallery") backgroundColor:UIColorRGB(0xed9f3b)  selector:@selector(choosePicturesAction:)];
    
    [self addSubview:_choosePicBtn];
}

//只在显示文档列表时才会显示上传图片按钮
- (void)showUploadButton:(BOOL)show
{
    if (_takePhotoBtn && _choosePicBtn) {
        if (show)
            _iFileTableView.height = self.height - kBtnHeight - kMargin;
        else
            _iFileTableView.height = self.height;
        
        _takePhotoBtn.hidden = !show;
        _choosePicBtn.hidden = !show;
    }
}

//拍摄照片
- (void)takePhotosAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:sTakePhotosUploadNotification object:sTakePhotosUploadNotification];
}
//选择照片
- (void)choosePicturesAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:sChoosePhotosUploadNotification object:sChoosePhotosUploadNotification];
}
- (UIButton *)createCommonButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)color selector:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [TKUtil setCornerForView:btn];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    return btn;
}
//382

- (void)reloadData {
    [self.iFileTableView reloadData];
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 2;
    return _iFileMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tHeight = 60;
    return tHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TKUserListTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    tCell.iListDelegate = self;
    tCell.iIndexPath = indexPath;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKMediaDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
            
            [tCell configaration:tMediaDocModel withFileListType:FileListTypeAudioAndVideo isClassBegin:_isClassBegin];
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
            // NSString *tString = [NSString stringWithFormat:@"文档列表"];
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text =MTLocalized(tString);
            TKDocmentDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
            
            [tCell configaration:tMediaDocModel withFileListType:FileListTypeDocument isClassBegin:_isClassBegin];
        }
            break;
        case FileListTypeUserList:
        {
            //用户列表
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            tCell.iIndexPath = indexPath;
            TKRoomUser *tRoomUser = [_iFileMutableArray objectAtIndex:indexPath.row];
            [tCell configaration:tRoomUser withFileListType:FileListTypeUserList isClassBegin:_isClassBegin];
            
            // 设置为NO后cell无法响应cell内的按钮点击事件
            tCell.contentView.userInteractionEnabled = NO;
            
        }
            break;
        default:
            break;
    }
    
    return tCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_iFileListType != FileListTypeUserList) {
        [self hide];
    }
    if( [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol){
        return;
    }
    
    // 如果没有上课，不能点击学生上台
    if ([TKEduSessionHandle shareInstance].isClassBegin == NO) {
        //[tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    TKLog(@"%@",@(indexPath.row));
    if ((indexPath.row == 0)&&(_iFileListType == FileListTypeDocument)) {
        TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
        if (_isClassBegin) {
            [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
            
        }else{
            [[TKEduSessionHandle shareInstance] docmentDefault:tDocmentDocModel];
            
        }
        
        if(_iPreButton) {
            [_iPreButton setSelected:NO];
            _iPreButton = nil;
            
        }
        
    }
    
    // 如果是用户列表，则上下台
    if (_iFileListType == FileListTypeUserList) {
        
        NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
        _iFileHeadLabel.text = MTLocalized(tString);
        TKRoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:indexPath.row];
        
        // 助教不能上下台
        if (tRoomUser.role == UserType_Assistant && [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish == NO) {
            //[tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        
        // 助教1对1不能上下台
        //        if (tRoomUser.role == UserType_Assistant && [TKEduSessionHandle shareInstance].roomMgr.roomType == RoomType_OneToOne) {
        //            return;
        //        }
        
        // 如果用户没有在台上，上台时需要判断最大人数
        if (tRoomUser.publishState < 1 && !(tRoomUser.disableVideo == YES && tRoomUser.disableAudio == YES)) {
            
            // 如果台上人员超限，不允许上台
            if ([TKEduSessionHandle shareInstance].iPublishDic.count >= [[TKEduSessionHandle shareInstance].iRoomProperties.iMaxVideo intValue]) {
                NSArray *array = [UIApplication sharedApplication].windows;
                int count = (int)array.count;
                [TKRCGlobalConfig HUDShowMessage:MTLocalized(@"Prompt.exceeds") addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
                //[tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;
            }
            
            // 在后台的学生不能上台
            if ([tRoomUser.properties objectForKey:sIsInBackGround] != nil && [[tRoomUser.properties objectForKey:sIsInBackGround] boolValue] == YES) {
                NSArray *array = [UIApplication sharedApplication].windows;
                int count = (int)array.count;
                //拼接上用户名
                NSString *logStr = [NSString stringWithFormat:@"%@%@",tRoomUser.nickName,MTLocalized(@"Prompt.BackgroundCouldNotOnStage")];
                [TKRCGlobalConfig HUDShowMessage:logStr addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
                return;
            }
            
            int isSucess = [[TKEduSessionHandle shareInstance] addPendingUser:tRoomUser];
            if (!isSucess) {
                //[tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;
            }
        }
        PublishState tState = (PublishState)tRoomUser.publishState;
        BOOL isShowVideo = tRoomUser.publishState >= 1;      // isShowVideo现在是是否在台上的判断结果
        if (isShowVideo) {
            tState = PublishState_NONE;
            // 助教始终有画笔权限
            if (tRoomUser.role != UserType_Assistant) {
                [[TKEduSessionHandle shareInstance]configureDraw:false isSend:true to:sTellAll peerID:tRoomUser.peerID];
                //[[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(false) completion:nil];
            }
            
        } else {
            
            if (tRoomUser.disableVideo == YES && tRoomUser.disableAudio == NO) {
                tState = PublishState_AUDIOONLY;
            }
            if (tRoomUser.disableVideo == NO && tRoomUser.disableAudio == YES) {
                tState = PublishState_VIDEOONLY;
            }
            if (tRoomUser.disableVideo == NO && tRoomUser.disableAudio == NO) {
                tState = PublishState_BOTH;
            }
            if (tRoomUser.disableVideo == YES && tRoomUser.disableAudio == YES) {
                // 此时学生在台下并且禁用了音视频，不能上台
                tState = PublishState_NONE;
                NSArray *array = [UIApplication sharedApplication].windows;
                int count = (int)array.count;
                [TKRCGlobalConfig HUDShowMessage:MTLocalized(@"Prompt.CanotOn") addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
            }
            //tState = PublishState_BOTH;
        }
        
        [self.iFileTableView reloadData];
        
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
    }
    
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)show:(FileListType)aFileListType aFileList:(NSArray *)aFileList isClassBegin:(BOOL)isClassBegin{
    
    [self refreshData:aFileListType aFileList:aFileList isClassBegin:isClassBegin];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    // [UIView setAnimationDelegate:self];
    // [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    [TKUtil setLeft:self To:ScreenW-CGRectGetWidth(self.frame)];
    
    [UIView commitAnimations];
    _isShow = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:sDocListViewNotification object:nil];
    
}
-(void)hide{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    //   [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [TKUtil setLeft:self To:ScreenW];
    [UIView commitAnimations];
    _isShow = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)updateData{
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"), @([_iFileMutableArray count])];
            _iFileMutableArray = [[[TKEduSessionHandle shareInstance] mediaArray]mutableCopy];
            _iFileHeadLabel.text = MTLocalized(tString);
        }
            break;
        case FileListTypeDocument:
        {
            //@"文档列表"
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            _iFileMutableArray = [[[TKEduSessionHandle shareInstance] docmentArray]mutableCopy];
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            NSMutableArray *tUserArray = [[[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]mutableCopy];
            _iFileMutableArray = tUserArray;
            
        }
            break;
        default:
            break;
    }
    [_iFileTableView reloadData];
}


-(void)refreshData:(FileListType)aFileListType aFileList:(NSArray *)aFileList isClassBegin:(BOOL)isClassBegin{
    _iFileMutableArray = [aFileList mutableCopy];
    _iFileListType    = aFileListType;
    _isClassBegin = isClassBegin;
    switch (aFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
        }
            break;
        case FileListTypeDocument:
        {
            //@"文档列表"
            [self showUploadButton:YES];
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            
        }
            break;
        default:
            break;
    }
    [_iFileTableView reloadData];
}

#pragma mark  listProtocol
//举手标志
-(void)listButton1:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    
}
//上台
-(void)listButton2:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    [self hide];
    if( [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol){
        return;
    }
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            tMediaDocModel.isPlay =@( aButton.selected);
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
            
            //TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKRoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            PublishState tState = (PublishState)tRoomUser.publishState;
            BOOL isShowVideo = tRoomUser.publishState >1;
            
            if (isShowVideo) {
                
                tState = PublishState_NONE;
                [[TKEduSessionHandle shareInstance]configureDraw:false isSend:true to:sTellAll peerID:tRoomUser.peerID];
                //[[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(false) completion:nil];
                
            }else{
                
                int isSucess = [[TKEduSessionHandle shareInstance]addPendingUser:tRoomUser];
                if (!isSucess) {break;}
                tState = PublishState_BOTH;
            }
            
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
            
        }
            break;
        default:
            break;
    }
}

//切换动态ppt，音频
-(void)listButton3:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    [self hide];
    if( [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol){
        return;
    }
    
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            if ([[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] isEqualToString:[NSString stringWithFormat:@"%@",[TKEduSessionHandle shareInstance].iCurrentMediaDocModel.fileid]]) {
                return;
            }
            aButton.selected = YES;
            
            NSString *tNewURLString2 = [TKUtil absolutefileUrl:tMediaDocModel.swfpath webIp:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp webPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort];
            
            if ([TKEduSessionHandle shareInstance].iCurrentMediaDocModel) {
                [TKEduSessionHandle shareInstance].iPreMediaDocModel = [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            }
            
            [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = tMediaDocModel;
            if ([TKEduSessionHandle shareInstance].isPlayMedia) {
                [TKEduSessionHandle shareInstance].isChangeMedia = YES;
                [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
            }else{
                BOOL tIsVideo = [TKUtil isVideo:tMediaDocModel.filetype];
                NSString * toID = [TKEduSessionHandle shareInstance].isClassBegin?sTellAll:[TKEduSessionHandle shareInstance].localUser.peerID;
                [[TKEduSessionHandle shareInstance]sessionHandlePublishMedia:tNewURLString2 hasVideo:tIsVideo fileid:[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] filename:tMediaDocModel.filename toID:toID block:nil];
                
            }
            
            
            //[self prepareVideoOrAudio:tMediaDocModel SendToOther:YES inList:NO];
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            [aButton setSelected:YES];
            
            // 上课后再下课之后点击上课时最后点击的文档
            //            if (aButton == _iPreButton && ![TKEduSessionHandle shareInstance].iIsClassEnd) {
            //                return;
            //            }
            
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            if (_isClassBegin) {
                [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
                
            }else{
                
                [[TKEduSessionHandle shareInstance] docmentDefault:tDocmentDocModel];
            }
            
            
            _iCurrrentButton = aButton;
            if (_iPreButton) {
                [_iPreButton setSelected:NO];
            }
            
            _iPreButton = _iCurrrentButton;
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKRoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            PublishState tState =(PublishState) tRoomUser.publishState;
            switch (tRoomUser.publishState) {
                    
                case PublishState_AUDIOONLY:
                {
                    tState = PublishState_NONE;
                    
                }
                    break;
                case PublishState_BOTH:
                {
                    tState = PublishState_VIDEOONLY;
                }
                    break;
                case PublishState_NONE:
                {
                    tState = PublishState_AUDIOONLY;
                    
                }
                    break;
                case PublishState_VIDEOONLY:
                {
                    tState = PublishState_BOTH;
                    
                }
                    break;
                default:
                    break;
            }
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
            
            
        }
            break;
        default:
            break;
    }
}
//涂鸦，删除文件，影音
-(void)listButton4:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    //[self hide];
    if( [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol){
        return;
    }
    TKEduRoomProperty *tRoomProperty = [TKEduSessionHandle shareInstance].iRoomProperties;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            // 按钮点击后需要等待网络回调后才可用
            aButton.enabled = NO;
            
            //@"影音列表"
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.MediaList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            [TKEduNetManager delRoomFile:tRoomProperty.iRoomId docid:[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] isMedia:false aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort  aDelComplete:^int(id  _Nullable response) {
                
                
                BOOL isCurrntDM = [[TKEduSessionHandle shareInstance] isEqualFileId:tMediaDocModel aSecondModel:[TKEduSessionHandle shareInstance].iCurrentMediaDocModel];
                if (isCurrntDM) {
                    [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
                }
                
                [[TKEduSessionHandle shareInstance] deleteaMediaDocModel:tMediaDocModel To:sTellAllExpectSender];
                [[TKEduSessionHandle shareInstance] delMediaArray:tMediaDocModel];
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] mediaArray]mutableCopy];
                
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                [_iFileTableView reloadData];
                return 1;
            }aNetError:^int(id  _Nullable response) {
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                return -1;
            }];
            
        }
            break;
        case FileListTypeDocument:
        {
            // 按钮点击后需要等待网络回调后才可用
            aButton.enabled = NO;
            
            //@"文档列表"
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.DocumentList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            [TKEduNetManager delRoomFile:tRoomProperty.iRoomId docid:[NSString stringWithFormat:@"%@",tDocmentDocModel.fileid] isMedia:false aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort  aDelComplete:^int(id  _Nullable response) {
                
                [[TKEduSessionHandle shareInstance] deleteDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
                BOOL isCurrntDM = [[TKEduSessionHandle shareInstance] isEqualFileId:tDocmentDocModel aSecondModel:[TKEduSessionHandle shareInstance].iCurrentDocmentModel];
                if (isCurrntDM) {
                    
                    TKDocmentDocModel *tDocmentDocNextModel = [[TKEduSessionHandle shareInstance] getNextDocment:[TKEduSessionHandle shareInstance].iCurrentDocmentModel];
                    if (_isClassBegin) {
                        [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocNextModel To:sTellAllExpectSender aTellLocal:YES];
                        
                    }else{
                        [[TKEduSessionHandle shareInstance] docmentDefault:tDocmentDocNextModel];
                        
                    }
                    
                }
                
                [[TKEduSessionHandle shareInstance] delDocmentArray:tDocmentDocModel];
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] docmentArray]mutableCopy];
                
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                [_iFileTableView reloadData];
                return 1;
            }aNetError:^int(id  _Nullable response) {
                // 网络回调完成，按钮可用
                aButton.enabled = YES;
                return -1;
            }];
            
            
        }
            break;
        case FileListTypeUserList:
        {
            [self hide];
            //关闭涂鸦
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKRoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            if (tRoomUser.publishState>1) {
                [[TKEduSessionHandle shareInstance]configureDraw:!tRoomUser.canDraw isSend:true to:sTellAll peerID:tRoomUser.peerID];
                //[[TKEduSessionHandle shareInstance]  sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)(!tRoomUser.canDraw)) completion:nil];
                
            }
            
            
        }
            break;
        default:
            break;
    }
    
}




@end
