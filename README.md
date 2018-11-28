# HiFanClassRoomHD
hi翻外教课堂3.0 （章节约课版）



//WARK:拓课替换SDK--------上线版必须使用release版本。

1.
_choosePicBtn = [self createCommonButtonWithFrame:CGRectMake(_takePhotoBtn.rightX + kMargin, self.height - kBtnHeight - kMargin, btnWidth, kBtnHeight) title:MTLocalized(@"UploadPhoto.FromGallery") backgroundColor:UIColorRGB(0xed9f3b)  selector:@selector(choosePicturesAction:)];
改为：
_choosePicBtn = [self createCommonButtonWithFrame:CGRectMake(_takePhotoBtn.x + _takePhotoBtn.width + kMargin, self.height - kBtnHeight - kMargin, btnWidth, kBtnHeight) title:MTLocalized(@"UploadPhoto.FromGallery") backgroundColor:UIColorRGB(0xed9f3b)  selector:@selector(choosePicturesAction:)];

2.
-(void)refreshUI中的
self.iClassBeginAndRaiseHandButton.frame = tIsTeacherOrAssis?tLeftFrame:tRightFrame;
改为
self.iClassBeginAndRaiseHandButton.frame = CGRectMake(0, 0, self.iClassBeginAndOpenAlumdView.frame.size.width, (40*Proportion));

3.
UIButton *tButton = [[UIButton alloc]initWithFrame:tRightFrame];
改为
UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.iClassBeginAndOpenAlumdView.frame.size.width, (40*Proportion))];

4.
[self.iClassBeginAndOpenAlumdView addSubview:self.iOpenAlumButton];    注释


5.常用语修改，可以搜索RoomController.m中的常用语，都有注释。

6.如果麦克风或者照相机没开权限，进入教室，会提醒开权限，使用的是他们的本地文件，拓课云允许访问麦克风等，严格来说，需要改变他们的本地文件，可以自己搜索修改。

