//
//  HF_HomeUnGradedHeaderCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/26.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnGradedHeaderCell.h"

@interface HF_HomeUnGradedHeaderCell()
@property (nonatomic,strong) BaseScrollHeaderView *headerView;
@end


@implementation HF_HomeUnGradedHeaderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.height.mas_equalTo(106);
    }];
    
    @weakify(self);
    [[self.headerView.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.gonglueBtnBlock) {
             self.gonglueBtnBlock();
         }
     }];
    
}


//MARK:懒加载
-(BaseScrollHeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [[BaseScrollHeaderView alloc] init];
        self.headerView.titleLabel.text = [self getTheTimeBucket];
        if ([[self getTheTimeBucket] isEqualToString:@"上午好"]) {
            self.headerView.navBigLabel.text = @"Good Morning";
        } else if ([[self getTheTimeBucket] isEqualToString:@"下午好"]) {
            self.headerView.navBigLabel.text = @"Good Afternoon";
        } else if ([[self getTheTimeBucket] isEqualToString:@"晚上好"]) {
            self.headerView.navBigLabel.text = @"Good Evening";
        }
        [self.headerView.rightButton setTitle:@"课程攻略" forState:UIControlStateNormal];
        [self.headerView.rightButton setImage:UIIMAGE_FROM_NAME(@"攻略1") forState:UIControlStateNormal];
    }
    return _headerView;
}


//获取时间段
-(NSString *)getTheTimeBucket {
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:[self getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:12]] == NSOrderedAscending) {
        return @"上午好"; //good morning
    } else if ([currentDate compare:[self getCustomDateWithHour:12]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:18]] == NSOrderedAscending) {
        return @"下午好"; //good afternoon
    } else {
        return @"晚上好"; //good evening
    }
}

//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate *destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

@end
