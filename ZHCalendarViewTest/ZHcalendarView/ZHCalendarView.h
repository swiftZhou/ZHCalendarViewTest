//
//  ZHCalendarView.h
//  FYCalendar
//
//  Created by 周海 on 16/3/30.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHCalendarView : UIView
@property (nonatomic, strong) NSMutableArray *failedDaysArr;// 未执行方案的日期数组
@property (nonatomic, assign) NSString *nowMonthbeginDay;//这个月的开始时间
@property (nonatomic, assign) NSString *lastMonthbeginDay;//上个月的开始时间

@property (nonatomic, strong) NSDate *date;
//年月label
@property (nonatomic, strong) UILabel *headlabel;

//weekView
@property (nonatomic, strong) UIView *weekBg;

@property (nonatomic, copy) void(^nextMonthBlock)();
@property (nonatomic, copy) void(^lastMonthBlock)();

- (void)createCalendarViewWith:(NSDate *)date;
/**
 *  nextMonth
 *
 *  @param date nil = 当前日期的下一个月
 */

- (NSDate *)nextMonth:(NSDate *)date;

/**
 *  lastMonth
 *
 *  @param date nil -> 当前日期的上一个月
 */
- (NSDate *)lastMonth:(NSDate *)date;
@end
