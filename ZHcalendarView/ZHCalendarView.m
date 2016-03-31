//
//  ZHCalendarView.m
//  FYCalendar
//
//  Created by 周海 on 16/3/30.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "ZHCalendarView.h"
#import "DateButton.h"
@interface ZHCalendarView ()
@property (nonatomic, strong) DateButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *daysArray;

@end
@implementation ZHCalendarView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.daysArray = [NSMutableArray arrayWithCapacity:42];
        self.failedDaysArr = [NSMutableArray array];
        [self setupNextAndLastMonthView];
    }
    return self;
}
#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}

- (void)setupNextAndLastMonthView {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"brn_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    leftBtn.tag = 1;
    leftBtn.frame = CGRectMake(10, 10, 20, 20);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    rightBtn.frame = CGRectMake(self.frame.size.width - 30, 10, 20, 20);
}
- (void)nextAndLastMonth:(UIButton *)button {
    if (button.tag == 1) {
        if (self.lastMonthBlock) {
            self.lastMonthBlock();
        }
    } else {
        if (self.nextMonthBlock) {
            self.nextMonthBlock();
        }
    }
}
- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = (self.frame.size.width / 7)/2.0;
    
    // 1.year month
    self.headlabel = [[UILabel alloc] init];
    self.headlabel.text     = [NSString stringWithFormat:@"%li年%li月",(long)[self year:date],(long)[self month:date]];
    NSLog(@"%@", self.headlabel.text);
    self.headlabel.font     = [UIFont systemFontOfSize:14];
    self.headlabel.frame           = CGRectMake(0, 0, self.frame.size.width, itemH);
    self.headlabel.textAlignment   = NSTextAlignmentCenter;
    self.headlabel.textColor = [UIColor orangeColor];
    [self addSubview: self.headlabel];
    
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    self.weekBg = [[UIView alloc] init];
    self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.headlabel.frame), self.frame.size.width, itemH);
    [self addSubview:self.weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor lightGrayColor];
        [self.weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * (itemH+10) + CGRectGetMaxY(self.weekBg.frame)+20;
        
        DateButton *dayButton = [[DateButton alloc] initWithFrame:CGRectMake(x, y, itemW, itemH)];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dayButton];
        [_daysArray addObject:dayButton];
        
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            dayButton.topLabel.text = [NSString stringWithFormat:@"%li", (long)day];
            
            //拼接年月日
            NSString *days = [NSString stringWithFormat:@"%li-%li-%li",(long)[self year:date],(long)[self month:date],(long)day];
            NSDateFormatter *date=[[NSDateFormatter alloc] init];
            [date setDateFormat:@"yyyy-MM-dd"];
            NSDate *beginday=[date dateFromString:days];
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [dateFormatter2 stringFromDate:beginday];
            
            dayButton.time = strDate;
            
            
            [self setBgColorInButton:self.nowMonthbeginDay nextBeginDay:self.lastMonthbeginDay dayButton:dayButton];
            
            [self setStyle_atherday:dayButton dayNmuArr:self.failedDaysArr];
        }
        dayButton.titleLabel.font = [UIFont systemFontOfSize:21];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if (i < todayIndex && i >= firstWeekday) {
            }else if(i ==  todayIndex){
                //                [self setStyle_Today:dayButton];//今天日期
            }
            
        }
        
    }
}
-(void)logDate:(DateButton *)dayBtn
{

    self.selectBtn.topLabel.backgroundColor = [UIColor clearColor];
    for(NSString *str2 in self.failedDaysArr) {
        if ([self.selectBtn.time isEqualToString:str2]) {
            self.selectBtn.topLabel.backgroundColor = [UIColor whiteColor];
        }
    }
    

    //获取上个月的结束时间
    NSString *nowendTime = [self endDay:self.nowMonthbeginDay];
    
    //获取这个月的结束时间
    NSString *lastendTime = [self endDay:self.lastMonthbeginDay];
    
    if ([self.selectBtn.time isEqualToString:nowendTime]
        ||[self.selectBtn.time isEqualToString:self.nowMonthbeginDay]
        ||[self.selectBtn.time isEqualToString:lastendTime]
        ||[self.selectBtn.time isEqualToString:self.lastMonthbeginDay]) {
        self.selectBtn.topLabel.backgroundColor = [UIColor colorWithRed:253/255.0 green:90/255.0 blue:114/255.0 alpha:1];
    }
    self.selectBtn = dayBtn;
    dayBtn.topLabel.backgroundColor = [UIColor greenColor];
    NSLog( @"点击的时间=== %@",dayBtn.time);
    
    
}
- (void)setStyle_atherday:(DateButton *)button dayNmuArr:(NSArray *)dayNum{
    NSString *str = button.time;
    for (NSString *num in dayNum) {
        if ([str isEqualToString:num]) {
            button.topLabel.backgroundColor = [UIColor whiteColor];
            
        }
    }
}
#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(DateButton *)btn
{
    btn.enabled = NO;
}
- (void)setBgColorInButton:(NSString *)nowbeginDay  nextBeginDay:(NSString *)time dayButton:(DateButton *)dateBut{
    //当前月的天数
    
    
    //开始时间距1970 多少天
    
    
    
    NSInteger nowbDay = [self intervalSinceNow1970:nowbeginDay];
    NSInteger nextDay = [self intervalSinceNow1970:time];
    NSInteger eDay = [self intervalSinceNow1970:dateBut.time];
    NSLog(@"距1970== %ld,%ld",nowbDay,eDay);
    
    NSInteger cha = eDay- nowbDay;
    if (cha <=27 && cha >=0) {
        if (cha == 0||cha ==27) {
            dateBut.topLabel.backgroundColor = [UIColor colorWithRed:253/255.0 green:90/255.0 blue:114/255.0 alpha:1];
            dateBut.topLabel.textColor = [UIColor whiteColor];
            if (cha == 0) {
                dateBut.bgImageView.image = [UIImage imageNamed:@"begin1"];
            } else if (cha ==27){
            
                 dateBut.bgImageView.image = [UIImage imageNamed:@"end1"];
            }
        } else{
        dateBut.backgroundColor = [UIColor colorWithRed:255/255.0 green:206/255.0 blue:212/255.0 alpha:1];
        }
        
    }
    NSInteger cha2 = eDay- nextDay;
    if (cha2 <=27 && cha2 >=0) {
        if (cha2 == 0||cha2 ==27) {
            dateBut.topLabel.backgroundColor = [UIColor colorWithRed:253/255.0 green:90/255.0 blue:114/255.0 alpha:1];
            dateBut.topLabel.textColor = [UIColor whiteColor];
            
            if (cha2 == 0) {
                dateBut.bgImageView.image = [UIImage imageNamed:@"begin1"];
            } else if (cha2 ==27){
                
                dateBut.bgImageView.image = [UIImage imageNamed:@"end1"];
            }
        }else{
            dateBut.backgroundColor = [UIColor colorWithRed:255/255.0 green:206/255.0 blue:212/255.0 alpha:1];
        }
    }
    
}

#pragma mark - 结束时间
- (NSString  *)endDay:(NSString *)beginDay{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginday=[date dateFromString:beginDay];
    NSTimeInterval  oneDay = 24*60*60*27;  //28天的长度
    
    NSDate *enday = [beginday dateByAddingTimeInterval:oneDay];
    
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter2 stringFromDate:enday];
    return strDate;
}

#pragma mark - 返回距1970多少天
- (NSInteger )intervalSinceNow1970: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970];
    
    return late/86400;
}
//一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


#pragma mark - date get: day-month-year
#pragma mark - 日
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

#pragma mark - 月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

#pragma mark - 年
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

@end
