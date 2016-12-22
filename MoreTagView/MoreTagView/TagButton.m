//
//  TagButton.m
//  Tags
//
//  Created by Jolly on 2016/10/17.
//  Copyright © 2016年 longtugame. All rights reserved.
//

#import "TagButton.h"

@implementation TagButton

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.layer.borderWidth = 1;
    
}
-(void)setQSid:(NSInteger)QSid{
    if (_QSid!=QSid) {
        _QSid =QSid;
    }
}
-(void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
    }
    if (isSelected) {
        
        self.backgroundColor = [UIColor colorWithRed:252/255.0 green:254/255.0 blue:203/255.0 alpha:1.0];
        [self setTitleColor:[UIColor colorWithRed:249/255.0 green:121/255.0 blue:56/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
