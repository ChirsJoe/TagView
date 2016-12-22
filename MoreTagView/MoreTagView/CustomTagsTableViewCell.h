//
//  CustomTagsTableViewCell.h
//  YunOs
//
//  Created by Jolly on 2016/10/17.
//  Copyright © 2016年 BruchChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagView.h"
@interface CustomTagsTableViewCell : UITableViewCell

@property (nonatomic,assign)float rowHeight;
@property (nonatomic,strong)UIView *leftLineView;
@property (nonatomic,strong)UIView *rightLineView;
@property(nonatomic,strong)TagView *tagView;



@end
