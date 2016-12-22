//
//  TagView.h
//  Tags
//
//  Created by Jolly on 2016/10/14.
//  Copyright © 2016年 longtugame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagButton.h"
@interface TagView : UIView


/**
 *  标签间距,和距离左，上间距,默认10
 */
@property (nonatomic, assign) CGFloat tagMargin;

/**
 *  标签颜色，默认红色
 */
@property (nonatomic, strong) UIColor *tagColor;

/**
 *  标签背景颜色
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;

/**
 *  标签背景图片
 */
@property (nonatomic, strong) UIImage *tagBackgroundImage;

/**
 *  标签字体，默认13
 */
@property (nonatomic, assign) UIFont *tagFont;
/**
 *  标签按钮内容间距，标签内容距离左上下右间距，默认5
 */
@property (nonatomic, assign) CGFloat tagButtonMargin;

/**
 *  标签列表的高度
 */
@property (nonatomic, assign) CGFloat tagListH;

/**
 *  边框宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 *  边框颜色
 */
@property (nonatomic, strong) UIColor *borderColor;


/**
 *  点击标签，执行Block
 */
@property (nonatomic, strong) void(^clickTagBlock)(TagButton *tag);


/******自定义标签尺寸******/
@property (nonatomic, assign) CGSize tagSize;

/******标签列表总列数 默认4列******/
/**
 *  标签间距会自动计算
 */
@property (nonatomic, assign) NSInteger tagListCols;


/**
 *  是否需要自定义tagList高度，默认为Yes
 */
@property (nonatomic, assign) BOOL isFitTagListH;



//添加按钮进行布局
- (void)addTags:(NSArray *)tagStrs;
//取消选中状态
- (void)cancelSelectedStateWithString:(NSString *)tagStr;
@end
