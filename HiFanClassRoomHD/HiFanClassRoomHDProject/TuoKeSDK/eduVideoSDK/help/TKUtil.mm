//
//  TKUtil.m
//  emmnew
//
//  Created by mac on 14-3-27.
//
//

#import "TKUtil.h"
#import "TKMacro.h"
#import "TKGTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#include <netdb.h>
#include <arpa/inet.h>
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <mach/mach.h>
#import <sys/sysctl.h>

#define kChosenDigestLength        CC_SHA1_DIGEST_LENGTH

#define DESKEY @"Gd0^9f@KoAQOXFPZQ^H&fURo"

static TKUtil *instace;
@interface TKUtil()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end
@implementation TKUtil
+ (instancetype)shareInstance
{
    @synchronized(self)
    {
        if (!instace) {
            instace = [[TKUtil alloc] init];
        }
    }
    return instace;
}

/*
 
 typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
 UIRectCornerTopLeft     = 1 << 0,//左上角
 UIRectCornerTopRight    = 1 << 1,//右上角
 UIRectCornerBottomLeft  = 1 << 2,//左下角
 UIRectCornerBottomRight = 1 << 3,//右下角
 UIRectCornerAllCorners  = ~0UL   //全部
 };
 
 //创建圆角边框(UIRectCornerBottomLeft | UIRectCornerBottomRight)
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.button.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
 
 CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
 maskLayer.frame = self.button.bounds;
 maskLayer.path = maskPath.CGPath;
 self.button.layer.mask = maskLayer;
 
 
 */
+(UIView *)setCornerForView:(UIView * )aView {
    //创建圆角边框(UIRectCornerBottomLeft | UIRectCornerBottomRight)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:UIRectCornerAllCorners   cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.shadowColor = RGBACOLOR(0, 0, 0, 1.0).CGColor;
    maskLayer.shadowOffset = CGSizeMake(-2, -3);
    maskLayer.shadowOpacity = 1;
    maskLayer.shadowRadius = 5;
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    aView.layer.mask = maskLayer;
    return aView;
    
}


+ (NSString*)fullPath:(NSString*)shortPath
{
    static NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:shortPath];
}


+ (NSString*)GetDicString:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return @"";
    }
    
    NSString *str = [dic objectForKey:key];
    
    if (!str || ![str isKindOfClass:[NSString class]])
    {
        str = @"";
    }
    
    return str;
}

+ (int)GetDicInt:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    
    if (![dic objectForKey:key])
    {
        return 0;
    }
    
    if ([[dic objectForKey:key] isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    
    return [[dic objectForKey:key] intValue];
}

+ (void)setLeft:(UIView*)v To:(CGFloat)x {
    CGRect frame = v.frame;
    frame.origin.x = x;
    v.frame = frame;
}

+ (void)setTop:(UIView*)v To:(CGFloat)y {
    CGRect frame = v.frame;
    frame.origin.y = y;
    v.frame = frame;
}

+ (void)setRight:(UIView*)v To:(CGFloat)right {
    CGRect frame = v.frame;
    frame.origin.x = right - frame.size.width;
    v.frame = frame;
}

+ (void)setBottom:(UIView*)v To:(CGFloat)bottom {
    CGRect frame = v.frame;
    frame.origin.y = bottom - frame.size.height;
    v.frame = frame;
}

+ (void)setWidth:(UIView*)v To:(CGFloat)width {
    CGRect frame = v.frame;
    frame.size.width = width;
    v.frame = frame;
}

+ (void)setHeight:(UIView*)v To:(CGFloat)height {
    CGRect frame = v.frame;
    frame.size.height = height;
    v.frame = frame;
}
+ (void)setCenter:(UIView*)v ToFrame:(CGRect )frame{
    v.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
    
}
#pragma mark 加解密

//http://blog.csdn.net/justinjing0612/article/details/8482689
//先base64解码，在3des解码
+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    //
    
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        //plainText = [GTMBase64 decodeBase64String:plainText];
        NSData *tData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        NSData *EncryptData = [TKGTMBase64 TK_webSafeDecodeData:tData];
        plainTextBufferSize = [EncryptData length];
        
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        
    }
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    //http://stackoverflow.com/questions/13415672/assigning-to-uint8-t-aka-unsigned-char-from-incompatible-type-void
    bufferPtr =  static_cast<uint8_t *> (malloc( bufferPtrSize * sizeof(uint8_t)));
    // bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    
    NSString *result;
    //解密
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [TKGTMBase64 TK_stringByEncodingData:myData];
    }
    
    return result;
}
//weiyi://start?param=ENCRYPT&timestamp=xxxxx(unix 时间戳)
//
+(NSMutableDictionary *)decodeUrl:(NSString *)aDecodeUrl{
    NSMutableDictionary *tResultDic = [[NSMutableDictionary  alloc]initWithCapacity:10];
    
    NSArray *tUrlArray = [aDecodeUrl componentsSeparatedByString:@"?"];
    //[tUrlArray objectAtIndex:1] ->param=ENCRYPT&timestamp=xxxxx(unix 时间戳)
    NSArray *tParamArray = [[tUrlArray objectAtIndex:1] componentsSeparatedByString:@"&"];
    if ([tParamArray count]>1) {
        for (NSString *aTempString in tParamArray) {
            NSArray *tParamOrTimestapArray = [aTempString componentsSeparatedByString:@"="];
            [tResultDic  setObject:[tParamOrTimestapArray objectAtIndex:1]  forKey:[tParamOrTimestapArray objectAtIndex:0]];
        }
    }
    
    
    return tResultDic;
}
// @"ip=192.168|port=80|meetingid=132444942|nickname=xue|headurl=http://192.168.0.5/t.jpg|thirdID=100|password=1234
+(NSMutableDictionary *)decodeParam:(NSString *)aParamString{
    
    NSMutableDictionary *tResultDic = [[NSMutableDictionary  alloc]initWithCapacity:10];
    //NSString * aURLString = @"ip=192.168|port=80|meetingid=132444942|nickname=xue|headurl=http://192.168.0.5/t.jpg|thirdID=100|password=1234";
    NSArray *tUrlArray = [aParamString componentsSeparatedByString:@"&"];
    if ([tUrlArray count]>1) {
        /*
         stringByAddingPercentEscapesUsingEncoding(只对 `#%^{}[]|\"<> 加空格共14个字符编码，不包括”&?”等符号),
         URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
         URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
         URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
         URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
         URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
         URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
         
         */
        //stringByRemovingPercentEncoding
        for (NSString *aTempString in tUrlArray) {
            NSArray *tParagramArray = [aTempString componentsSeparatedByString:@"="];
            [tResultDic  setObject:[tParagramArray objectAtIndex:1]  forKey:[tParagramArray objectAtIndex:0]];
        }
    }
    
    return tResultDic;
}

+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Light" size:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}


+(BOOL)getIsMedia:(NSString*)filetype{
    BOOL tIsMedia = false;
    if ([filetype isEqualToString:@"mp3"]
        || [filetype isEqualToString:@"mp4"]
        || [filetype isEqualToString:@"webm"]
        || [filetype isEqualToString:@"ogg"]
        || [filetype isEqualToString:@"wav"]) {
        tIsMedia = true;
    }
    return tIsMedia;
    
}
+(BOOL)isVideo:(NSString *)filetype{
    BOOL tIsVideo = false;
    if ([filetype isEqualToString:@"mp4"] || [filetype isEqualToString:@"webm"]) {
        tIsVideo = true;
    }
    return tIsVideo;
}

+(NSString *)docmentOrMediaImage:(NSString*)aType{
    NSString *tString = @"icon_user";
    if ([aType isEqualToString:@"whiteboard"]) {
        tString = @"icon_empty";
        
    }else if ([aType isEqualToString:@"xls"]||[aType isEqualToString:@"xlsx"]||[aType isEqualToString:@"xlt"]||[aType isEqualToString:@"xlsm"]){
        tString = @"icon_excel";
    }else if ([aType isEqualToString:@"jpg"]|| [aType isEqualToString:@"jpeg"]||[aType isEqualToString:@"png"] ||[aType isEqualToString:@"gif"] || [aType isEqualToString:@"bmp"]){
        tString = @"icon_images";
    }
    else if ([aType isEqualToString:@"ppt"] || [aType isEqualToString:@"pptx"] || [aType isEqualToString:@"pps"]){
        tString = @"icon_ppt";
    }
    else if ([aType isEqualToString:@"docx"]|| [aType isEqualToString:@"doc"]){
        tString = @"icon_word";
    }
    else if ([aType isEqualToString:@"txt"]){
        tString = @"icon_text_pad";
    }
    else if ([aType isEqualToString:@"pdf"]){
        tString = @"icon_pdf";
    }
    else if ([aType isEqualToString:@"mp3"]){
        tString = @"icon_mp3";
    }
    else if ([aType isEqualToString:@"mp4"]){
        tString = @"icon_mp4";
    } else if ([aType isEqualToString:@"zip"]){
        tString = @"icon_h5";
    }
    return tString;
    
    
}

+(NSString *)timestampToFormatString:(NSTimeInterval)ts {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]];
    return strDate;
}

+(NSString *)currentTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

+(NSString *)currentTimeToSeconds{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}

+(NSString *) md5HexDigest:(NSString *)aString{
    const char *original_str = [aString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

+ (void)showMessage:(NSString *)message {
    NSArray *array = [UIApplication sharedApplication].windows;
    int count = (int)array.count;
    [TKRCGlobalConfig HUDShowMessage:message addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
}
+ (void)showClassEndMessage:(NSString *)message {
    NSArray *array = [UIApplication sharedApplication].windows;
    int count = (int)array.count;
    [TKPromptMessage HUDShowMessage:message addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:4];
}
+(NSInteger)numberBit:(NSInteger)aNumber{
    int sum=0;
    
    while(aNumber){
        sum++;
        aNumber/=10;
    }
    return sum;
}
+(BOOL)isEnglishLanguage{
    /*
     en-CN,
     zh-Hans-CN,
     en
     
     zh-Hans-CN,
     en-CN,
     
     */
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog ( @"----%@" , currentLanguage); //打印结果： en 用获取到的当前语言，和支持的语言做字符串对比，就可以知道是那种语言了。
    if([currentLanguage isEqualToString:@"en-CN"]) { return YES; }
    return NO;
}
+(NSString*)absolutefileUrl:(NSString*)fileUrl webIp:(NSString*)webIp webPort:(NSString*)webPort{
    
    NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",sHttp,webIp,webPort,fileUrl];
    NSString *tdeletePathExtension = tUrl.stringByDeletingPathExtension;
    NSString *tNewURLString = [NSString stringWithFormat:@"%@-1.%@",tdeletePathExtension,tUrl.pathExtension];
    NSArray *tArray          = [tNewURLString componentsSeparatedByString:@"/"];
    if ([tArray count]<4) {
        return @"";
    }
    NSString *tNewURLString2 = [NSString stringWithFormat:@"%@//%@/%@/%@",[tArray objectAtIndex:0],[tArray objectAtIndex:1],[tArray objectAtIndex:2],[tArray objectAtIndex:3]];
    return tNewURLString2;
}

+(NSString *)dictionaryToJSONString:(NSDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

#pragma mark 检测语言
+(NSString*)getCurrentLanguage {
    NSArray *language = [NSLocale preferredLanguages];
    if ([language objectAtIndex:0]) {
        NSString *currentLanguage = [language objectAtIndex:0];
        if ([currentLanguage length] >= 7 && [[currentLanguage substringToIndex:7] isEqualToString:@"zh-Hans"]) {
            return @"ch";
        }
        
        if ([currentLanguage length] >= 7 && [[currentLanguage substringToIndex:7] isEqualToString:@"zh-Hant"]) {
            return @"tw";
        }
        
        if ([currentLanguage length] >= 3 && [[currentLanguage substringToIndex:3] isEqualToString:@"en-"]) {
            return @"en";
        }
    }
    
    return @"ch";
}

+(BOOL)isSimplifiedChinese {
    if ([[TKUtil getCurrentLanguage] isEqualToString:@"ch"]) {
        return YES;
    } else {
        return NO;
    }
}

//https://www.theiphonewiki.com/wiki/Models
//2014年10月17日iPad Air 2、iPad mini 3 iPhone6 iPad mini 2
+(bool)deviceisConform{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];//获得设备类型 iPad4,4
    
    NSArray *tParagramArray = [platform componentsSeparatedByString:@","];
    if ([tParagramArray count]<2) {
        return false;
    }
    
    // 运行app的时候，给一个提示：当前的设备配置较低，课堂不能完美运行
    // 点击按钮“知道了”关闭
    NSString *platString = [tParagramArray objectAtIndex:0]; //ipad 4
    NSString *tPlatVersion = [tParagramArray objectAtIndex:1];//4
    
    NSArray *tIPhoneArray = [platString componentsSeparatedByString:@"iPhone"];
    NSArray *tIPadArray   = [platString componentsSeparatedByString:@"iPad"];
    if ([tIPhoneArray count]==2) {
        /*
         3 iphone
         iPhone 6
         iPhone7,2
         iPhone 6 Plus
         iPhone7,1
         */
        
        NSString *tIPhoneVersion = [tIPhoneArray objectAtIndex:1];
        bool isConformPhone      = [tIPhoneVersion intValue]>6?true:false;
        return isConformPhone;
    }
    if ([tIPadArray count]==2) {
        
        //支持多路
        /**  iPad
         iPad Air 2
         iPad Pro (12.9-inch) iPad Pro (9.7-inch)
         iPad (5th generation)
         iPad Pro (12.9-inch, 2nd generation)
         iPad Pro (10.5-inch)
         iPad (6th generation)
         */

        /**  iPad mini
         iPad mini 3,
         iPad mini 4
         */
        //仅支持2路
        /**
         iPad mini
         iPad mini 2
         iPad Air
         iPad (4th generation)
         iPad (3rd generation)
         */
        NSString *tIPadVersion = [tIPadArray objectAtIndex:1];
        bool isConformIPad = [tIPadVersion intValue]>4?true:false;
        if (isConformIPad) {
            return isConformIPad;
        }
        //iPad mini 2
        //iPad4,4
        //iPad mini 3
        //iPad4,7 iPad4,8 iPad4,9
        if ([tIPadVersion intValue] == 4) {
            isConformIPad = [tPlatVersion intValue]>6?true:false;
        }
        return isConformIPad;
        
    }
    return false;
}

+(BOOL)isDomain:(NSString *)host {
    const char *hostN= [host UTF8String];
    in_addr_t rt = inet_addr(hostN);
    if (rt == INADDR_NONE) {
        return YES;
    } else {
        return NO;
    }
}
+(NSString *)getTKVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        
        return true;
        
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            
            return true;
            
        } else {
            
            return false;
            
        }
        
    }
    
}

+(NSString*)optString:(NSDictionary*)dic Key:(NSObject*)key
{
    id value = [dic objectForKey:key];
    if (value)
    {
        if ([value isKindOfClass:[NSString class]])
            return value;
        else
            return [NSString stringWithFormat:@"%@", value];
    }
    
    return nil;
}
+(NSInteger)getIntegerValueFromDic:(NSDictionary*)dic Key:(NSObject*)key
{
    id value = [dic objectForKey:key];
    if (value && ([value isKindOfClass:[NSNumber class]]
                  || [value isKindOfClass:[NSString class]])) {
        return [value integerValue];
    }
    
    return 0;
}
+(BOOL)getBOOValueFromDic:(NSDictionary*)dic Key:(NSObject*)key
{
    id value = [dic objectForKey:key];
    if (value && ([value isKindOfClass:[NSNumber class]]
                  || [value isKindOfClass:[NSString class]])) {
        return [value boolValue];
    }
    
    return NO;
}
+(id)getValueFromDic:(NSDictionary*)dic Key:(NSObject*)key Class:(Class)cls
{
    id value = [dic objectForKey:key];
    if (value && [value isKindOfClass:cls]) {
        return value;
    }
    
    return nil;
}
+(int)getCurrentFontSize:(CGSize)size  withString:(NSString *)string{
    CGSize maxSize=size;
    int currentFontSize=12;
    NSString *str=string;
    CGSize requiredSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
    if(requiredSize.height<=maxSize.height)
    {
        while (requiredSize.height<=maxSize.height&&requiredSize.width<maxSize.width) {
            currentFontSize++;
            requiredSize=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
        }
    }else
    {
        while (requiredSize.height>maxSize.height||requiredSize.width>maxSize.width) {
            currentFontSize--;
            requiredSize=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
        }
        requiredSize=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
    }
    return currentFontSize;
}
- (void)playVoiceWithFileURL:(NSString *)fileUrl
{
    if (!_player) {
        [self createPlayerWithURL:fileUrl];
    } else
    {
        [self deletePlayer];
        [self createPlayerWithURL:fileUrl];
    }
}

- (void)createPlayerWithURL:(NSString *)url
{
    NSURL *sourceMovieUrl = [NSURL fileURLWithPath:url];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    //    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    //    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [_player setVolume:1];
    [_player play];
    
    
}

- (void)deletePlayer
{
    if (_player) {
        if (_player.status == AVPlayerStatusReadyToPlay) {
            [_player pause];
        }
        _player = nil;
        _playerItem = nil;
    }
}
- (void)dealloc
{
    [self deletePlayer];
}
+(NSString *)getCurrentDateTime{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    
    //字符串的转化并且拼接
    NSString *yearstr=[NSString stringWithFormat:@"%ld-",(long)year];
    NSString *monthstr=[NSString stringWithFormat:@"%ld-",(long)month];
    NSString *daystr=[NSString stringWithFormat:@"%ld_",(long)day];
    NSString *hourstr=[NSString stringWithFormat:@"%ld_",(long)hour];
    NSString *minutestr=[NSString stringWithFormat:@"%ld_",(long)minute];
    NSString *secondstr=[NSString stringWithFormat:@"%ld",(long)second];
    //字符串开始拼接
    NSString *allstr=[yearstr stringByAppendingString:monthstr];
    NSString *allstr1=[allstr stringByAppendingString:daystr];
    NSString *allstr2=[allstr1 stringByAppendingString:hourstr];
    NSString *allstr3=[allstr2 stringByAppendingString:minutestr];
    NSString *DateTime=[allstr3 stringByAppendingString:secondstr];
    return DateTime;
}

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
    
}

+(NSString *)getCurrentHoursAndMinutes:(NSString *)time{
    
    NSTimeInterval t=[time doubleValue];
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:t];
    
    NSLog(@"date:%@",[detaildate description]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *strDate = [dateFormatter stringFromDate:detaildate];
    
    return strDate;
    
}

+(NSTimeInterval)getNowTimeTimestamp{
    
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    
    return [datenow timeIntervalSince1970];
    
}
+ (id) processDictionaryIsNSNull:(id)obj{
    const NSString *blank = @"";
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dt = [(NSMutableDictionary*)obj mutableCopy];
        for(NSString *key in [dt allKeys]) {
            id object = [dt objectForKey:key];
            if([object isKindOfClass:[NSNull class]]) {
                [dt setObject:blank
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSString class]]){
                NSString *strobj = (NSString*)object;
                if ([strobj isEqualToString:@"<null>"]) {
                    [dt setObject:blank
                           forKey:key];
                }
            }
            else if ([object isKindOfClass:[NSArray class]]){
                NSArray *da = (NSArray*)object;
                da = [self processDictionaryIsNSNull:da];
                [dt setObject:da
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSDictionary class]]){
                NSDictionary *ddc = (NSDictionary*)object;
                ddc = [self processDictionaryIsNSNull:object];
                [dt setObject:ddc forKey:key];
            }
        }
        return [dt copy];
    }else{
        return nil;
    }
}


+ (float)GetCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    if (thread_count > 0)
    stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return 0;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}
+ (CGFloat)GetCurrentTaskUsedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    if(kernReturn != KERN_SUCCESS) {
        return 0;
    }
    
    
    CGFloat memory =taskInfo.resident_size / 1024.0 / 1024.0;
    return memory;
}

@end