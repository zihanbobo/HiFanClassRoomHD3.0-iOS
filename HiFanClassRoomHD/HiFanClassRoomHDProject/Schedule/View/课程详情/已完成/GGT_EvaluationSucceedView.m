//
//  GGT_EvaluationSucceedView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/21.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_EvaluationSucceedView.h"

@interface GGT_EvaluationSucceedView()
//二维码
@property (nonatomic, strong) UIImageView *codeImgView;
//文字提醒
@property (nonatomic, strong) UILabel *alertLabel;
@end

@implementation GGT_EvaluationSucceedView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        
        [self buildUI];
    }
    return self;
}

-(void)buildUI {
    //完成
    self.closeButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, LineW(20), LineH(20));
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"close") forState:(UIControlStateNormal)];
        xc_button;
    });
    [self addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(LineY(25));
        make.right.equalTo(self.mas_right).offset(-LineY(25));
        make.size.mas_equalTo(CGSizeMake(LineW(20), LineH(20)));
    }];
    
    
    UIImageView *iconImgView = [UIImageView new];
    iconImgView.image = UIIMAGE_FROM_NAME(@"评价成功");
    [self addSubview:iconImgView];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(LineY(28));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(131), LineH(119)));
    }];
    
    
    //评价成功
    UILabel *successLabel = [UILabel new];
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.font = Font(18);
    successLabel.textColor = UICOLOR_FROM_HEX(Color0D0101);
    successLabel.text = @"评价成功！";
    [self addSubview:successLabel];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset(LineY(12));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(LineH(25)));
    }];
    
    
    //星星评价
    self.starRatingView = [[ASStarRatingView alloc]init];
    self.starRatingView.starWidth = LineW(25);
    self.starRatingView.canEdit = NO;
    [self addSubview:self.starRatingView];
    
    [self.starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(LineY(margin10));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(181), LineH(25)));
    }];
    
    
    //二维码
    self.codeImgView = [UIImageView new];
    [self addSubview:self.codeImgView];
    
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starRatingView.mas_bottom).offset(LineY(margin15));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LineW(124), LineH(124)));
    }];
    

    
    //文字提醒
    self.alertLabel = [UILabel new];
    self.alertLabel.textAlignment = NSTextAlignmentCenter;
    self.alertLabel.font = Font(12);
    self.alertLabel.textColor = UICOLOR_FROM_HEX(Color9B9B9B);
    [self addSubview:self.alertLabel];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-LineY(margin15));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(LineH(17)));
    }];
}


- (void)getMessageDic:(NSDictionary *)dic {
    if ([dic[@"data"] isKindOfClass:[NSString class]] && !IsStrEmpty(dic[@"data"])) {
        //1. 实例化二维码滤镜
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2. 恢复滤镜的默认属性
        [filter setDefaults];
        // 3. 将字符串转换成NSData
        NSString *urlStr = dic[@"data"];
        NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
        // 4. 通过KVO设置滤镜inputMessage数据
        [filter setValue:data forKey:@"inputMessage"];
        // 5. 获得滤镜输出的图像
        CIImage *outputImage = [filter outputImage];
        // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
        self.codeImgView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:LineW(124)];//重绘二维码,使其显示清晰
    }
    
    
    if ([dic[@"msg"] isKindOfClass:[NSString class]] && !IsStrEmpty(dic[@"msg"])) {
        self.alertLabel.text = [NSString stringWithFormat:@"%@",dic[@"msg"]];
    }else {
//        self.alertLabel.text = @"微信扫码，分享课后评价成功到朋友圈再获10积分！";
        self.alertLabel.text = @"";
    }
    
}


/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
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



@end
