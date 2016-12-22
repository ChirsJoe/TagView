//
//  CustomTagsTableViewCell.m
//  YunOs
//
//  Created by Jolly on 2016/10/17.
//  Copyright © 2016年 BruchChou. All rights reserved.
//

#import "CustomTagsTableViewCell.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@implementation CustomTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpLineView];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setUpLineView{
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 1, self.frame.size.height)];
    }    
    _leftLineView.backgroundColor = [UIColor colorWithRed:188/255.0 green:228/255.0 blue:255/255.0 alpha:1.0];
    [self.contentView addSubview:_leftLineView];
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc]initWithFrame:CGRectMake(ScreenW-11, 0, 1, self.frame.size.height)];
    }
    
    _rightLineView.backgroundColor = [UIColor colorWithRed:188/255.0 green:228/255.0 blue:255/255.0 alpha:1.0];
    [self.contentView addSubview:_rightLineView];
}

-(void)setRowHeight:(float)rowHeight
{
    CGRect rect1 = _leftLineView.frame;
    CGRect rect2 = _rightLineView.frame;
    if (_rowHeight != rowHeight) {
        rect1.size.height = rowHeight;
        rect2.size.height = rowHeight;
    }
    _leftLineView.frame = rect1;
    _rightLineView.frame = rect2;
}

- (void)setTagView:(TagView *)tagView
{
    if (_tagView != tagView) {
        _tagView = tagView;
    }
    [self.contentView addSubview:tagView];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
