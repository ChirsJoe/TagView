//
//  FooterView.m
//  YunOs
//
//  Created by Jolly on 2016/10/17.
//  Copyright © 2016年 BruchChou. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpViewsWithFrame:frame];
    }
    return self;
}
-(void)setUpViewsWithFrame:(CGRect)frame{
    
    
    
    UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 1, frame.size.height)];
    [self addSubview:leftLineView];
    UIView *rightLineView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-11, 0, 1, frame.size.height)];
    [self addSubview:rightLineView];
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(10, frame.size.height -1, frame.size.width-21, 1)];
    [self addSubview:bottomLineView];
    
    leftLineView.backgroundColor = [UIColor colorWithRed:188/255.0 green:228/255.0 blue:255/255.0 alpha:1.0];
    rightLineView.backgroundColor = [UIColor colorWithRed:188/255.0 green:228/255.0 blue:255/255.0 alpha:1.0];
    bottomLineView.backgroundColor = [UIColor colorWithRed:188/255.0 green:228/255.0 blue:255/255.0 alpha:1.0];
    
    if (!self.settingButton) {
        self.settingButton  = [UIButton buttonWithType:UIButtonTypeSystem];
        self.settingButton.backgroundColor = [UIColor clearColor];
    }
    self.settingButton.frame = CGRectMake(10, 0, 50, frame.size.height);
    [self.settingButton setTitle:@"设置" forState:UIControlStateNormal];
    
    [self addSubview:self.settingButton];
    
    if (!self.moreButton) {
        self.moreButton  = [UIButton buttonWithType:UIButtonTypeSystem];
        self.moreButton.backgroundColor = [UIColor clearColor];
    }
    self.moreButton.frame = CGRectMake(frame.size.width-61, 0, 50, frame.size.height);
    [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    
    [self addSubview:self.moreButton];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
