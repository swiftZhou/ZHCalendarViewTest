//
//  DateButton.m
//  FYCalendar
//
//  Created by 周海 on 16/3/30.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "DateButton.h"

@implementation DateButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.bgImageView];
        
        self.topLabel =  [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height - (self.frame.size.height/2.0), 0, self.frame.size.height, self.frame.size.height)];
        self.topLabel.layer.cornerRadius = self.frame.size.height / 2;
        self.topLabel.layer.masksToBounds = YES;
        self.topLabel.userInteractionEnabled = NO;
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.topLabel];
        
    }
    
    return self;
}
@end
