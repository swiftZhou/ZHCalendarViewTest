//
//  DateButton.h
//  FYCalendar
//
//  Created by 周海 on 16/3/30.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateButton : UIButton
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, copy) NSString *time;
@end
