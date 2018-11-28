//
//  GGT_ApplySucceedViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/2.
//  Copyright © 2018年 Chn. All rights reserved.
//

#import "GGT_ApplySucceedViewController.h"

@interface GGT_ApplySucceedViewController ()
//教材
@property (nonatomic, strong) UILabel *jiaocaiLabel;
//已申请06-12（周一）18:30 的课程
@property (nonatomic, strong) UILabel *chengbanLabel;

//二维码
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIImageView *codeImgView;

//申请成功！还差1人开班
@property (nonatomic, strong) UILabel *shenqingLabel;
@end

@implementation GGT_ApplySucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //隐藏导航下的黑线
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.navigationController.navigationBar  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    [self initUI];
}

- (void)initUI {
    //关闭
    UIImageView *closeImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = UIIMAGE_FROM_NAME(@"close");
        imgView;
    });
    [self.view addSubview:closeImgView];
    
    [closeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(24);
        make.right.equalTo(self.view.mas_right).offset(-24);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    
    
    UIButton *closeButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, 50, 50);
        xc_button;
    });
    [closeButton addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    //教材
    self.jiaocaiLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
//        label.text = @"已申请06-12（周一）18:30 的课程";
        label;
    });
    self.jiaocaiLabel.text = self.jiaocaiStr;
    [self.view addSubview:self.jiaocaiLabel];
    
    [self.jiaocaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(40);
        make.height.mas_equalTo(18);
    }];
    
    
    //申请成功！还差1人开班
    self.shenqingLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
//        label.text = @"申请成功！还差1人开班";
        label;
    });
    self.shenqingLabel.text = self.shenqingStr;
    [self.view addSubview:self.shenqingLabel];
    
    [self.shenqingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.mas_equalTo(18);
    }];

    
    //已申请06-12（周一）18:30 的课程
    self.chengbanLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(16);
        label.textColor = UICOLOR_FROM_HEX(ColorFF6600);
//        label.text = @"还差1人开班";
        label;
    });
    self.chengbanLabel.text = self.chengbanStr;
    [self.view addSubview:self.chengbanLabel];
    
    [self.chengbanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.jiaocaiLabel.mas_bottom).offset(margin20);
        make.height.mas_equalTo(16);
    }];
    
    
    
    //底部文字提醒
    UILabel *footerLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(14);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.numberOfLines = 0;

        /*扫描二维码分享至微信好友或朋友圈\n邀请更多好友参与申请，新用户可专享9元试听。*/
        NSString *titleStr = @"扫描二维码分享至微信好友或朋友圈\n邀请更多好友参与申请，新用户可专享9元试听。";
        NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        if ([titleStr containsString:@"新用户可专享9元试听。"]) {
            NSRange rang = [titleStr rangeOfString:@"新用户可专享9元试听。"];
            [mutableAttriStr addAttribute:NSForegroundColorAttributeName value:UICOLOR_FROM_HEX(ColorFF6600) range:NSMakeRange(rang.location,rang.length)];
        }

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [mutableAttriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
        label.attributedText = mutableAttriStr;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:footerLabel];
    
    
    [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.mas_equalTo(46);
    }];

    
    
    
    //二维码图像---如果只是二维码，外边的边线会没有间距，需要底部添加一个view承载
    self.codeView = ({
        UIView *imgView = [UIView new];
        imgView.layer.borderWidth = 1;
        imgView.layer.borderColor = UICOLOR_FROM_HEX(ColorFF6600).CGColor;
        imgView;
    });
    [self.view addSubview:self.codeView];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(footerLabel.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(134, 134));
    }];
    
    
    self.codeImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView;
    });
    [self getCodeStr:self.codeStr];
    [self.codeView addSubview:self.codeImgView];
    
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeView.mas_centerX);
        make.centerY.equalTo(self.codeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(124, 124));
    }];
    
    
    
    if ([self.classTypeName isEqualToString:@"邀请好友"]) {
        self.shenqingLabel.hidden = YES;
    } else {
        self.jiaocaiLabel.hidden = YES;
        self.chengbanLabel.hidden = YES;
    }
    
}


- (void)getCodeStr:(NSString *)coreStr {
        //1. 实例化二维码滤镜
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2. 恢复滤镜的默认属性
        [filter setDefaults];
        // 3. 将字符串转换成NSData
        NSString *urlStr = coreStr;
        NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
        // 4. 通过KVO设置滤镜inputMessage数据
        [filter setValue:data forKey:@"inputMessage"];
        // 5. 获得滤镜输出的图像
        CIImage *outputImage = [filter outputImage];
        // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
        self.codeImgView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:124];//重绘二维码,使其显示清晰
}


/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)rightAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
