//
//  UIImage+Category.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

//按钮设置背景色
+ (UIImage *)imageWithColor:(UIColor *)color;

//对图片尺寸进行压缩--
- (UIImage *)imageScaledToSize:(CGSize)newSize;

//虚线
+ (UIImage *)imageWithLineWithImageView:(UIImageView *)imageView;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)xc_getLaunchImage;
//高斯模糊
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end
