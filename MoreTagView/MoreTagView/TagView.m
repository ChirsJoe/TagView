//
//  TagView.m
//  Tags
//
//  Created by Jolly on 2016/10/14.
//  Copyright © 2016年 longtugame. All rights reserved.
//

#import "TagView.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface TagView ()
@property (nonatomic, strong) NSMutableDictionary *buttonsDictionary;
@property (nonatomic, strong) NSMutableArray *tagButtons;

@property (nonatomic,strong) NSMutableArray *selectedArray;
@end
@implementation TagView



- (NSMutableArray *)tagButtons
{
    if (_tagButtons == nil) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}
-(NSMutableDictionary *)buttonsDictionary
{
    if (!_buttonsDictionary) {
        _buttonsDictionary = [NSMutableDictionary dictionary];
    }
    return _buttonsDictionary;
}

-(NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}


- (CGFloat)tagListH
{
    if (self.tagButtons.count <= 0) return 0;
    return CGRectGetMaxY([self.tagButtons.lastObject frame]) + _tagMargin;
}

-(void)layoutSubviews{
    CGRect frame = self.frame;
    if (self.tagButtons.count <= 0){
        frame.size.height = 30;
    }
    else
    {
        frame.size.height = CGRectGetMaxY([self.tagButtons.lastObject frame]) + _tagMargin;
    }
    
    self.frame = frame;
    
}
#pragma mark - 初始化
- (void)setup
{
    _tagMargin = 10;
    _tagColor = [UIColor redColor];
    _tagButtonMargin = 5;
    _borderWidth = 0;
    _borderColor = _tagColor;
    _isFitTagListH = YES;
    _tagListCols = 4;
    _tagFont = [UIFont systemFontOfSize:12];
    self.clipsToBounds = YES;
}

#pragma mark - 操作标签方法
// 添加多个标签
- (void)addTags:(NSArray *)tagStrs
{
    if (self.frame.size.width == 0) {
        @throw [NSException exceptionWithName:@"YZError" reason:@"先设置标签列表的frame" userInfo:nil];
    }
//    for (QueryCheckModel *model in tagStrs) {
//        [self setUpViewWithString:model.name withId:model.CheckId];
//    }
    
     for (NSString *tagStr in tagStrs) {
     [self setUpViewWithString:tagStr];
     }
    
}


-(void)setUpViewWithString:(NSString *)string{
    
    
    
    [self updateTagStates];
    NSArray *keys = [self.buttonsDictionary allKeys];
    NSArray *result = [keys filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", string]];
    if (result.count != 0) {
        return;
    }
    TagButton *button = [TagButton buttonWithType:UIButtonTypeCustom];
    
    //button.QSid = ID;
    button.tag = self.tagButtons.count;
    [button setTitle:string forState:UIControlStateNormal];
    
    button.isSelected = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self.tagButtons addObject:button];
    [self.buttonsDictionary setObject:button forKey:string];
    // 更新tag
    [self updateTag];
    
    
    [self updateTagButtonFrame:button.tag extreMargin:YES];
    // 保存到字典
    //[self.tags setObject:tagButton forKey:tagStr];
    //[self.tagArray addObject:tagStr];
    // 设置按钮的位置
    
    
    // 更新自己的高度
    if (_isFitTagListH) {
        CGRect frame = self.frame;
        frame.size.height = self.tagListH;
        [UIView animateWithDuration:0.25 animations:^{
            //self.frame = frame;
        }];
    }
    
}

-(void)updateTagStates
{
    if (self.selectedArray.count > 0) {
        for (NSString *string in self.selectedArray) {
            TagButton *button = self.buttonsDictionary[string];
            button.selected = YES;
        }
        
    }
}

// 更新标签
- (void)updateTag
{
    NSInteger count = self.tagButtons.count;
    for (int i = 0; i < count; i++) {
        UIButton *tagButton = self.tagButtons[i];
        tagButton.tag = i;
    }
}
- (void)updateTagButtonFrame:(NSInteger)i extreMargin:(BOOL)extreMargin{
    NSInteger preTag = i - 1;
    TagButton *preButton ;
    if (preTag >= 0) {
        preButton = self.tagButtons[preTag];
    }
    
    TagButton *currentButton = self.tagButtons[i];
    
    if (_tagSize.width == 0) { // 没有设置标签尺寸
        // 自适应标签尺寸
        // 设置标签按钮frame（自适应）
        [self setupTagButtonCustomFrame:currentButton preButton:preButton extreMargin:extreMargin];
    } else { // 按规律排布
        // 计算标签按钮frame（regular）
        [self setupTagButtonRegularFrame:currentButton];
    }
    
}
- (void)setupTagButtonRegularFrame:(TagButton *)tagButton{
    // 获取角标
    NSInteger i = tagButton.tag;
    NSInteger col = i % _tagListCols;
    NSInteger row = i / _tagListCols;
    CGFloat btnW = _tagSize.width;
    CGFloat btnH = _tagSize.height;
    NSInteger margin = (self.bounds.size.width - _tagListCols * btnW - 2 * _tagMargin) / (_tagListCols - 1);
    CGFloat btnX = _tagMargin + col * (btnW + margin);;
    CGFloat btnY = _tagMargin + row * (btnH + margin);
    tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}
// 设置标签按钮frame（自适应）
- (void)setupTagButtonCustomFrame:(TagButton *)tagButton preButton:(TagButton *)preButton extreMargin:(BOOL)extreMargin{
    // 等于上一个按钮的最大X + 间距
    CGFloat btnX = CGRectGetMaxX(preButton.frame) + _tagMargin;
    
    // 等于上一个按钮的Y值,如果没有就是标签间距
    CGFloat btnY = preButton? preButton.frame.origin.y : _tagMargin;
    // 获取按钮宽度
    CGFloat titleW = [tagButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    CGFloat titleH = [tagButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
    CGFloat btnW = extreMargin?titleW + 2 * _tagButtonMargin : tagButton.bounds.size.width ;
    // 获取按钮高度
    CGFloat btnH = extreMargin? titleH + 2 * _tagButtonMargin:tagButton.bounds.size.height;
    
    // 判断当前按钮是否足够显示
    CGFloat rightWidth = self.bounds.size.width -10 - btnX;
    if (rightWidth < btnW) {
        // 不够显示，显示到下一行
        btnX = _tagMargin;
        btnY = CGRectGetMaxY(preButton.frame) + _tagMargin;
    }
    
    tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH*ScreenW/320);
    
    
    
}
// 点击标签
- (void)buttonClick:(TagButton *)button
{
    if (!button.isSelected) {
        [self.selectedArray addObject:button.titleLabel.text];
    }
    else
    {
        [self.selectedArray removeObject:button.titleLabel.text];
    }
    if (_clickTagBlock) {
        _clickTagBlock(button);
    }
}


//通过点击上部视图来取消下部视图按钮的选中状态
- (void)cancelSelectedStateWithString:(NSString *)tagStr{
    [self.selectedArray removeObject:tagStr];
    TagButton *button = self.buttonsDictionary[tagStr];
    button.isSelected = !button.isSelected;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
