//
//  YZTagList.m
//  Hobby
//
//  Created by yz on 16/8/14.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZTagList.h"



CGFloat const imageViewWH = 20;

@interface YZTagList ()
{
    NSMutableArray *_tagArray;
}

@property (nonatomic, strong) NSMutableDictionary *tags;
@property (nonatomic, strong) NSMutableArray *tagButtons;
/**
 *  需要移动的矩阵
 */
@property (nonatomic, assign) CGRect moveFinalRect;
@property (nonatomic, assign) CGPoint oriCenter;
@end

@implementation YZTagList
/*
 *获取所有的标签
 **/
- (NSMutableArray *)tagArray
{
    if (_tagArray == nil) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}
/*
 *
 **/
- (NSMutableArray *)tagButtons
{
    if (_tagButtons == nil) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (NSMutableDictionary *)tags
{
    if (_tags == nil) {
        _tags = [NSMutableDictionary dictionary];
    }
    return _tags;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setUpGapButton];
    }
    
    return self;
}

#pragma mark - 初始化
- (void)setup
{
    _tagMargin = 10;
    _tagColor = [UIColor redColor];
    _tagButtonMargin = 5;
    _tagCornerRadius = 5;
    _borderWidth = 0;
    //设置边框的颜色和标签的颜色一样
    _borderColor = _tagColor;
    //标签的间距
    _tagListCols = 4;
#pragma mark 放大标签的比例
    _scaleTagInSort = 1;
#pragma mark 需要标签自适应
    _isFitTagListH = YES;
    _tagFont = [UIFont systemFontOfSize:12];
    self.clipsToBounds = YES;
    
#pragma mark 标签的背景颜色
    _tagBackgroundImage = [UIImage imageNamed:@"checksetting_delete"];
    _tagBackgroundImage=  [_tagBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
#pragma mark 占位标签的背景颜色 上面的占位图
    _gapButtonBackgroundImage = [UIImage imageNamed:@"checksetting_rectangle"];
}

//设置占位图的图片的按钮大小
-(void)setUpGapButton
{
    if (!self.gapButton) {
        self.gapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    self.gapButton.frame = CGRectMake(_tagMargin, _tagMargin, 80, 25);
    [self.gapButton setBackgroundImage:_gapButtonBackgroundImage forState:UIControlStateNormal];
    [self addSubview:self.gapButton];
    
    
}
#pragma mark 更新占位图的位置
-(void)updateGapButtonFrame{
    CGRect frame = self.gapButton.frame;
    if (self.gapButton) {
        
        if (self.tagButtons.count > 0) {
            
            frame.origin.x = [self.tagButtons.lastObject frame].origin.x+[self.tagButtons.lastObject frame].size.width+_tagMargin;
            
            frame.origin.y = [self.tagButtons.lastObject frame].origin.y;
            
            CGFloat rightWidth = self.bounds.size.width - ([self.tagButtons.lastObject frame].origin.x+[self.tagButtons.lastObject frame].size.width+_tagMargin);
            //标签的数量多的时候  占位图的起始坐标向下
            if (rightWidth < frame.size.width) {
                frame.origin.x = _tagMargin;
                frame.origin.y = CGRectGetMaxY([self.tagButtons.lastObject frame])+_tagMargin;
            }
            
        }
        
    }
    self.gapButton.frame = frame;
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    if (self.tagButtons.count <= 0){
        frame.size.height = 50;
    }
    else
    {
        [self updateGapButtonFrame];
        //frame.size.height = CGRectGetMaxY([self.tagButtons.lastObject frame]) + _tagMargin;
        frame.size.height = CGRectGetMaxY([self.gapButton frame]) + _tagMargin;
        
    }
    
    self.frame = frame;

}

- (void)setScaleTagInSort:(CGFloat)scaleTagInSort
{
    if (_scaleTagInSort < 1) {
        @throw [NSException exceptionWithName:@"YZError" reason:@"(scaleTagInSort)缩放比例必须大于1" userInfo:nil];
    }
    _scaleTagInSort = scaleTagInSort;
}

- (CGFloat)tagListH
{
    
    if (self.tagButtons.count <= 0) return self.gapButton.frame.size.height+2*_tagMargin;
    [self updateGapButtonFrame];
    
    return CGRectGetMaxY(self.gapButton.frame) + _tagMargin;
}

#pragma mark - 操作标签方法
// 添加多个标签
- (void)addTags:(NSArray *)tagStrs
{
    if (self.frame.size.width == 0) {
        @throw [NSException exceptionWithName:@"YZError" reason:@"先设置标签列表的frame" userInfo:nil];
    }
    /*
     for (NSString *tagStr in tagStrs) {
     [self addTag:tagStr ];
     }
     */
}
// 添加标签
- (void)addTag:(NSString *)tagStr withID:(NSInteger)ID
{
    //Class tagClass = _tagClass?_tagClass : [YZTagButton class];
    
    // 创建标签按钮
    //UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    NSArray *result = [self.tagArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tagStr]];
    if (result.count != 0) {
        return;
    }
    YZTagButton *tagButton = [YZTagButton buttonWithType:UIButtonTypeCustom];
    
    tagButton.QSid = ID;
    
    tagButton.tag = self.tagButtons.count;
    [tagButton setTitle:tagStr forState:UIControlStateNormal];
    [tagButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [tagButton setBackgroundImage:_tagBackgroundImage forState:UIControlStateNormal];
    tagButton.titleLabel.font = _tagFont;
    [tagButton addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
    /*
     if (_isSort) {
     // 添加拖动手势
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
     [tagButton addGestureRecognizer:pan];
     }
     */
    [self addSubview:tagButton];
    
    // 保存到数组
    [self.tagButtons addObject:tagButton];
    
    // 保存到字典
    [self.tags setObject:tagButton forKey:tagStr];
    [self.tagArray addObject:tagStr];
    
    // 设置按钮的位置
    [self updateTagButtonFrame:tagButton.tag extreMargin:YES];
    
    // 更新自己的高度
    if (_isFitTagListH) {
        CGRect frame = self.frame;
        frame.size.height = self.tagListH;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = frame;
        }];
    }
}

// 点击标签
- (void)clickTag:(YZTagButton *)button
{
    
    if (_clickTagBlock) {
        _clickTagBlock(button);
    }
}

// 拖动标签   这个地方用不到
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取偏移量
    CGPoint transP = [pan translationInView:self];
    
    UIButton *tagButton = (UIButton *)pan.view;
    
    // 开始
    if (pan.state == UIGestureRecognizerStateBegan) {
        _oriCenter = tagButton.center;
        [UIView animateWithDuration:-.25 animations:^{
            tagButton.transform = CGAffineTransformMakeScale(_scaleTagInSort, _scaleTagInSort);
        }];
        [self addSubview:tagButton];
    }
    
    CGPoint center = tagButton.center;
    center.x += transP.x;
    center.y += transP.y;
    tagButton.center = center;
    
    
    
    // 改变
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        // 获取当前按钮中心点在哪个按钮上
        UIButton *otherButton = [self buttonCenterInButtons:tagButton];
        
        if (otherButton) { // 插入到当前按钮的位置
            // 获取插入的角标
            NSInteger i = otherButton.tag;
            
            // 获取当前角标
            NSInteger curI = tagButton.tag;
            
            _moveFinalRect = otherButton.frame;
            
            // 排序
            // 移除之前的按钮
            [self.tagButtons removeObject:tagButton];
            [self.tagButtons insertObject:tagButton atIndex:i];
            
            [self.tagArray removeObject:tagButton.currentTitle];
            [self.tagArray insertObject:tagButton.currentTitle atIndex:i];
            
            // 更新tag
            [self updateTag];
            
            if (curI > i) { // 往前插
                
                // 更新之后标签frame
                [UIView animateWithDuration:0.25 animations:^{
                    [self updateLaterTagButtonFrame:i + 1];
                }];
                
            } else { // 往后插
                
                // 更新之前标签frame
                [UIView animateWithDuration:0.25 animations:^{
                    [self updateBeforeTagButtonFrame:i];
                }];
            }
        }
        
    }
    
    // 结束
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.25 animations:^{
            tagButton.transform = CGAffineTransformIdentity;
            if (_moveFinalRect.size.width <= 0) {
                tagButton.center = _oriCenter;
            } else {
                tagButton.frame = _moveFinalRect;
            }
        } completion:^(BOOL finished) {
            _moveFinalRect = CGRectZero;
        }];
        
    }
    
    [pan setTranslation:CGPointZero inView:self];
}

// 看下当前按钮中心点在哪个按钮上
- (UIButton *)buttonCenterInButtons:(UIButton *)curButton
{
    for (UIButton *button in self.tagButtons) {
        if (curButton == button) continue;
        if (CGRectContainsPoint(button.frame, curButton.center)) {
            return button;
        }
    }
    return nil;
}

// 删除标签
- (void)deleteTag:(NSString *)tagStr
{
    // 获取对应的标题按钮
    YZTagButton *button = self.tags[tagStr];
    
    // 移除数组
    [self.tagButtons removeObject:button];
    
    // 移除字典
    [self.tags removeObjectForKey:tagStr];
    
    // 移除数组
    [self.tagArray removeObject:tagStr];
    
    // 更新tag
    [self updateTag];
    
    // 更新后面按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateLaterTagButtonFrame:button.tag];
    }];
    
    if (button.tag == 0) {
        CGRect frame = self.gapButton.frame;
        frame.origin.x = self.frame.origin.x;
        [UIView animateWithDuration:0.25 animations:^{
            self.gapButton.frame = frame;
        }];
    }
    // 移除按钮
    [button removeFromSuperview];
    // 更新自己的frame
    if (_isFitTagListH) {
        CGRect frame = self.frame;
        frame.size.height = self.tagListH;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = frame;
        }];
    }
    
}

-(void)resetTagListWithArray:(NSMutableArray *)array{
    
    for (int i = 0; i < array.count; i++) {
        NSString *tagStr = array[i];
        // 获取对应的标题按钮
        YZTagButton *button = self.tags[tagStr];
        [button removeFromSuperview];
    }
    // 移除数组
    [self.tagButtons removeAllObjects];
    // 移除字典
    [self.tags removeAllObjects];
    // 移除数组
    [self.tagArray removeAllObjects];
    
    self.gapButton.frame = CGRectMake(_tagMargin, _tagMargin, 80, 30);
    CGRect frame = self.frame;
    frame.size.height = self.tagListH;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = frame;
    }];
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

// 更新之前按钮
- (void)updateBeforeTagButtonFrame:(NSInteger)beforeI
{
    for (int i = 0; i < beforeI; i++) {
        // 更新按钮
        [self updateTagButtonFrame:i extreMargin:NO];
    }
}

// 更新以后按钮
- (void)updateLaterTagButtonFrame:(NSInteger)laterI
{
    NSInteger count = self.tagButtons.count;
    
    for (NSInteger i = laterI; i < count; i++) {
        // 更新按钮
        [self updateTagButtonFrame:i extreMargin:NO];
    }
}

- (void)updateTagButtonFrame:(NSInteger)i extreMargin:(BOOL)extreMargin
{
    // 获取上一个按钮
    NSInteger preI = i - 1;
    
    // 定义上一个按钮
    UIButton *preButton;
    
    // 过滤上一个角标
    if (preI >= 0) {
        preButton = self.tagButtons[preI];
    }
    
    
    // 获取当前按钮
    YZTagButton *tagButton = self.tagButtons[i];
    // 判断是否设置标签的尺寸
    if (_tagSize.width == 0) { // 没有设置标签尺寸
        // 自适应标签尺寸
        // 设置标签按钮frame（自适应）
        [self setupTagButtonCustomFrame:tagButton preButton:preButton extreMargin:extreMargin];
    } else { // 按规律排布
        // 计算标签按钮frame（regular）
        [self setupTagButtonRegularFrame:tagButton];
    }
    
    
}

// 计算标签按钮frame（按规律排布）
- (void)setupTagButtonRegularFrame:(UIButton *)tagButton
{
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
- (void)setupTagButtonCustomFrame:(UIButton *)tagButton preButton:(UIButton *)preButton extreMargin:(BOOL)extreMargin
{
    // 等于上一个按钮的最大X + 间距
    CGFloat btnX = CGRectGetMaxX(preButton.frame) + _tagMargin;
    
    // 等于上一个按钮的Y值,如果没有就是标签间距
    CGFloat btnY = preButton? preButton.frame.origin.y : _tagMargin;
    
    // 获取按钮宽度
    CGFloat titleW = [tagButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    CGFloat titleH = [tagButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
    CGFloat btnW = extreMargin?titleW + 2 * _tagButtonMargin : tagButton.bounds.size.width ;
    if (_tagDeleteimage && extreMargin == YES) {
        //btnW += imageViewWH;
        btnW += _tagButtonMargin;
    }
    
    // 获取按钮高度
    CGFloat btnH = extreMargin? titleH + 2 * _tagButtonMargin:tagButton.bounds.size.height;
    if (_tagDeleteimage && extreMargin == YES) {
        CGFloat height = imageViewWH > titleH ? imageViewWH : titleH;
        btnH = height + 2 * _tagButtonMargin;
    }
    
    // 判断当前按钮是否足够显示
    CGFloat rightWidth = self.bounds.size.width -10 - btnX;
    
    if (rightWidth < btnW) {
        // 不够显示，显示到下一行
        btnX = _tagMargin;
        btnY = CGRectGetMaxY(preButton.frame) + _tagMargin;
    }
    
    tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
}

@end
