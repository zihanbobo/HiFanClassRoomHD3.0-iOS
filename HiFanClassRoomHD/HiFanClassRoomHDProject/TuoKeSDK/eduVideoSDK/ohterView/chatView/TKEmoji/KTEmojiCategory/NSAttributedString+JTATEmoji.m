//
//  NSAttributedString+JTATEmoji.m
//  EduClass
//
//  Created by lyy on 2017/11/16.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "NSAttributedString+JTATEmoji.h"

@implementation NSAttributedString (JTATEmoji)

+ (NSAttributedString *)emojiAttributedString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color
{
    
    if ([string isEqualToString:@""] || string == nil) {
        return nil;
    }
    
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName:color}];
    
    //图片格式[em_1]，正则表达式为\\[[a-z]+_[0-9]+\\]   代表1.png
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-z]+_[0-9]+\\]" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    
    NSDictionary *emojiPlistDic = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TKEmoji.bundle/Emoji.plist" ofType:nil]];
    
    // Make emoji the same size as text
    CGSize emojiSize = CGSizeMake(font.lineHeight, font.lineHeight);
   
    for (NSTextCheckingResult* result in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [result range];
        
        // Find emoji images by placeholder
        NSString *placeholder = [parsedOutput.string substringWithRange:matchRange];
        
        
        NSString *em = [NSString stringWithFormat:@"TKEmoji.bundle/%@.png",emojiPlistDic[placeholder]];
        
        UIImage *emojiImage = [UIImage imageNamed:em];
        
        // Resize Emoji Image
        UIGraphicsBeginImageContextWithOptions(emojiSize, NO, 0.0);
        [emojiImage drawInRect:CGRectMake(0, 0, emojiSize.width, emojiSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = resizedImage;
        
        // Replace placeholder with image
        NSAttributedString *rep = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        NSLog(@"%@",rep);
        
        [parsedOutput replaceCharactersInRange:matchRange withAttributedString:rep];
        
    }
    NSLog(@"%@",string);
    
    return [[NSAttributedString alloc]initWithAttributedString:parsedOutput];
    
}
+ (NSString *)removeEmojiAttributedString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color{
    if ([string isEqualToString:@""] || string == nil) {
        return nil;
    }
    
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName:color}];
    
    //图片格式[em_1]，正则表达式为\\[[a-z]+_[0-9]+\\]   代表1.png
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-z]+_[0-9]+\\]" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    NSMutableArray *emojiArray  = [NSMutableArray array];
    
    for (NSTextCheckingResult* result in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [result range];
        
        // Find emoji images by placeholder
        NSString *placeholder = [parsedOutput.string substringWithRange:matchRange];
        
        [emojiArray addObject:placeholder];
        
        
        
    }
    for (NSString *str in emojiArray) {
         string = [string stringByReplacingOccurrencesOfString:str withString:@""];
        
    }
   
    return string;
    
}




+ (NSInteger)getStringLengthWithString:(NSString *)string
{
    __block NSInteger stringLength = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     stringLength += 1;
                 }
                 else
                 {
                     stringLength += 1;
                 }
             }
             else
             {
                 stringLength += 1;
             }
         } else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3)
             {
                 stringLength += 1;
             }
             else
             {
                 stringLength += 1;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff)
             {
                 stringLength += 1;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 stringLength += 1;
             }
             else if (0x2934 <= hs && hs <= 0x2935)
             {
                 stringLength += 1;
             }
             else if (0x3297 <= hs && hs <= 0x3299)
             {
                 stringLength += 1;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
             {
                 stringLength += 1;
             }
             else
             {
                 stringLength += 1;
             }
         }
     }];
    
    return stringLength;
}

@end
