//
//  ViewController.h
//  MoreTagView
//
//  Created by Jolly on 2016/11/16.
//  Copyright © 2016年 longtugame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *projectDataArr;
@property (strong, nonatomic) NSMutableArray *constructionDataArr;
@end

