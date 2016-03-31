//
//  ViewController.m
//  ZHCalendarViewTest
//
//  Created by 周海 on 16/3/31.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import "ViewController.h"
#import "ZHCalendarView.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ViewController ()
@property (strong, nonatomic) ZHCalendarView *calendarView;
@property (nonatomic, strong) NSDate *date;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.date = [NSDate date];
    
    [self setupCalendarView];
}

- (void)setupCalendarView {
    self.calendarView = [[ZHCalendarView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    [self.calendarView.failedDaysArr  addObject:@"2016-03-15"];
    [self.calendarView.failedDaysArr  addObject:@"2016-03-20"];
    self.calendarView.nowMonthbeginDay = @"2016-03-08";
    self.calendarView.lastMonthbeginDay = @"";
    
    
    
    [self.view addSubview:self.calendarView];
    self.calendarView.date = [NSDate date];
    
    WS(weakSelf)
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

#pragma mark 下一个月
- (void)setupNextMonth {
    [self.calendarView removeFromSuperview];
    self.calendarView = [[ZHCalendarView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    self.calendarView.nowMonthbeginDay = @"2016-03-08";
    self.calendarView.lastMonthbeginDay = @"2016-04-07";
    [self.view addSubview:self.calendarView];
    
    
    self.date = [self.calendarView nextMonth:self.date];
    [self.calendarView createCalendarViewWith:self.date];
    
    WS(weakSelf)
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

#pragma mark上一个月
- (void)setupLastMonth {
    [self.calendarView removeFromSuperview];
    self.calendarView = [[ZHCalendarView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    [self.view addSubview:self.calendarView];
    [self.calendarView.failedDaysArr  addObject:@"2016-03-15"];
    [self.calendarView.failedDaysArr  addObject:@"2016-03-20"];
    self.calendarView.nowMonthbeginDay = @"2016-03-08";
    self.calendarView.lastMonthbeginDay = @"";
    self.date = [self.calendarView lastMonth:self.date];
    [self.calendarView createCalendarViewWith:self.date];
    
    WS(weakSelf)
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
}
@end
