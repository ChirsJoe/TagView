//
//  ViewController.m
//  MoreTagView
//
//  Created by Jolly on 2016/11/16.
//  Copyright © 2016年 longtugame. All rights reserved.
//

#import "ViewController.h"
#import "TagView.h"
#import "YZTagList.h"
#import "YZHobbyCell.h"
#import "CustomTagsTableViewCell.h"
#import "FooterView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

static NSString * const hobbyCell = @"hobbyCell";
static NSString * const customTagsCell = @"CustomTagsCell";

@interface ViewController ()
{
    float ROW_HEIGHT;
    NSArray *titleArray;
    
    
    BOOL tagViewIsSelected;
}
/**
 *  记录选择工程类型的标签名，即第1区的标签名
 */
@property (strong, nonatomic) NSMutableArray *selectedTopTags;
@property (strong, nonatomic) NSMutableArray *selectedTopID;
/**
 *  记录施工类型的标签，即第2区的标签名
 */
@property (strong, nonatomic) NSMutableArray *selectedBottomTags;
@property (strong, nonatomic) NSMutableArray *selectedBottomID;

/**
 *  用来记录点击更多按钮，BOOL数组，在添加数据时创建，见setData中方法
 */
@property (strong, nonatomic) NSMutableArray *showMoreArray;
/**
 *  用来记录选择的tag，以便点击上面已选工程标签进行删除
 */
@property (strong, nonatomic) NSMutableDictionary *selectedDictionary;
/**
 *  用来记录在表格上面展示的cell上的TagView
 */
@property (strong, nonatomic) NSMutableDictionary *tagViewDictionary;
@property (nonatomic, strong) YZTagList *tagList;
@property (nonatomic, strong) TagView *tagView;
@end

@implementation ViewController
-(NSMutableArray *)selectedTopTags{
    if (!_selectedTopTags) {
        _selectedTopTags = [NSMutableArray array];
    }
    return _selectedTopTags;
}
-(NSMutableArray *)selectedBottomTags{
    if (!_selectedBottomTags) {
        _selectedBottomTags = [NSMutableArray array];
    }
    return _selectedBottomTags;
}

-(NSMutableArray *)selectedTopID
{
    if (!_selectedTopID) {
        _selectedTopID = [NSMutableArray array];
    }
    return _selectedTopID;
}
-(NSMutableArray *)selectedBottomID
{
    if (!_selectedBottomID) {
        _selectedBottomID = [NSMutableArray array];
    }
    return _selectedBottomID;
}
-(NSMutableDictionary *)selectedDictionary{
    if (!_selectedDictionary) {
        _selectedDictionary = [NSMutableDictionary dictionary];
    }
    return _selectedDictionary;
}
-(NSMutableDictionary *)tagViewDictionary
{
    if (!_tagViewDictionary) {
        _tagViewDictionary = [NSMutableDictionary dictionary];
    }
    return _tagViewDictionary;
}

-(NSMutableArray *)showMoreArray
{
    if (!_showMoreArray) {
        _showMoreArray = [NSMutableArray array];
    }
    return _showMoreArray;
}

- (YZTagList *)tagList
{
    if (_tagList == nil) {
        _tagList = [[YZTagList alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 50)];
        _tagList.tagFont = [UIFont systemFontOfSize:12];
        __weak typeof(self) weakSelf = self;
        _tagList.clickTagBlock = ^(YZTagButton *tag){
            [weakSelf clickTag:tag];
        };
    }
    return _tagList;
}



//为每个cell添加标签视图，即TagView
- (TagView *)addHistoryViewTagsWithIndex:(NSIndexPath *)indexPath{
    TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, ROW_HEIGHT)];
    
    [self.tagViewDictionary setObject:tagView forKey:[NSString stringWithFormat:@"第%ld区的TagView",(long)indexPath.section]];
    tagView.tagColor = [UIColor whiteColor];
    tagView.tagFont = [UIFont systemFontOfSize:12];
    //tagView.backgroundColor = [UIColor redColor];
    tagView.tag = indexPath.section + 10000;
    if (self.projectDataArr.count >  0) {
        
        [tagView addTags:self.projectDataArr[indexPath.section-1]];
        
        __weak typeof(self) weakSelf = self;
        
        tagView.clickTagBlock = ^(TagButton *tag){
            [weakSelf buttonClick:tag];
        };
        
    }
    return tagView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    ROW_HEIGHT = 113*ScreenW/320;
    
    
    
    
    [self initTableView];
    [self setData];
}
#pragma mark - 数据源  作假数据的时候用到的
- (void)setData {
    //需要几个区就向self.projectDataArr中添加几个数组
    self.projectDataArr = [NSMutableArray arrayWithArray:@[@[@"房建工程", @"市政工程", @"绿化工程", @"铁路工程",@"路桥工程", @"神马工程",@"11工程", @"22工程", @"33工程",@"44工程", @"55工程", @"66工程",@"77工程", @"88工程", @"99工程"],@[@"施工总承包", @"桩基工程", @"幕墙工程", @"水电安装工程",@"装修装饰工程", @"防雾施工",@"防水施工", @"222施工", @"332施工",@"443施工", @"555施工", @"666施工",@"777施工", @"888施工", @"999施工"],@[@"工业建筑", @"民用建筑", @"商用建筑", @"农用建筑",@"公共建筑", @"小三建筑",@"南通建筑", @"巢湖建筑", @"苏州一建",@"合肥一建", @"苏州二建", @"苏州四建",@"苏州五建", @"江苏一建", @"南京建筑"]]];
    //设置区头数据，有几个区就添加几个内容
    titleArray = @[@"已选工程标签",@"工程类型",@"施工类型",@"建筑类型"];
    //根据数据源数组的个数来记录区分区尾更多按钮的状态（几个区就有几项内容），默认全为NO
    for(int i = 0 ; i < self.projectDataArr.count ; i++){
        [self.showMoreArray addObject:@(NO)];
    }
    
    
    [self.tableView reloadData];
}



- (void)initTableView{
    // 注册兴趣cell
    [self.tableView registerClass:[YZHobbyCell class] forCellReuseIdentifier:hobbyCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.projectDataArr.count+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YZHobbyCell *cell = [tableView dequeueReusableCellWithIdentifier:hobbyCell];
        
        return cell;
    }
    
    CustomTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customTagsCell];
    if (!cell) {
        cell = [[CustomTagsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customTagsCell];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (self.selectedTopTags.count <= 0 && _tagList.tagListH < 50) {
            return 45;
        }
        return _tagList.tagListH;
    }
    
    if (![self.showMoreArray[indexPath.section-1] boolValue]) {
        return ROW_HEIGHT;
    }
    else
    {
        if (self.tagViewDictionary.count > 0) {
            NSString *key = [NSString stringWithFormat:@"第%ld区的TagView",(long)indexPath.section];
            
            TagView *view = (TagView *)self.tagViewDictionary[key];
            
            if (view.tagListH < ROW_HEIGHT) {
                return ROW_HEIGHT;
            }
            else
            {
                return view.tagListH;
            }
        }
        return ROW_HEIGHT;
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YZHobbyCell *hobbyCell = (YZHobbyCell *)cell;
        hobbyCell.tagList = self.tagList;
        hobbyCell.selectionStyle = 0;
    }
    else {
        CustomTagsTableViewCell *tagCell =(CustomTagsTableViewCell *)cell;
        if (!tagCell.tagView) {
            tagCell.tagView = [self addHistoryViewTagsWithIndex:indexPath];
        }
        
        CGFloat height = ![self.showMoreArray[indexPath.section-1] boolValue] ? ROW_HEIGHT :tagCell.tagView.tagListH;
        if (height<ROW_HEIGHT) {
            height =ROW_HEIGHT;
        }
        tagCell.rowHeight = height;
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section==0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
        [self.view addSubview:headerView];
        UILabel *groupLab= [[UILabel alloc] initWithFrame:CGRectMake(20, 6, self.view.bounds.size.width-40, 18)];
        groupLab.text =titleArray[0];
        groupLab.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:groupLab];
        return headerView;
    }
    else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 46)];
        [self.view addSubview:headerView];
        UIView *intView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 46 )];
        intView.backgroundColor = [UIColor colorWithRed:188/255.0 green:228/255.0 blue:255/255.0 alpha:1];
        [headerView addSubview:intView];
        
        UILabel *groupLab= [[UILabel alloc] initWithFrame:CGRectMake(10, 13, ScreenW-40, 21)];
        groupLab.text = titleArray[section];
        groupLab.font = [UIFont systemFontOfSize:15];
        [intView addSubview:groupLab];
        return headerView;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 0) {
        FooterView  *footerView = [[FooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        
        
        //用区名给设置标签还有更多标签设置tag值用于区分
        footerView.settingButton.tag =section +1000;
        footerView.moreButton.tag = section +100;
        
        [footerView.settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *string = [self.showMoreArray[section-1] boolValue] ? @"收起":@"更多";
        [footerView.moreButton setTitle:string forState:UIControlStateNormal];
        return footerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 40;
}

#pragma mark 设置&更多按钮绑定事件
-(void)settingButtonClick:(UIButton *)button
{
    
}
-(void)moreButtonClick:(UIButton *)button
{
    [self showMoreContentWithButton:button];
}

-(void)showMoreContentWithButton:(UIButton *)button{
    
    NSInteger tag = button.tag-101;
    
    
    [self reloadSectionWithIndex:(int)button.tag-100];
    
    
    BOOL is = ![self.showMoreArray[tag] boolValue];
    
    [self.showMoreArray replaceObjectAtIndex:tag withObject:@(is)];
    
}


-(void)reloadSectionWithIndex:(int)index{
    if (index == 0) {
        NSIndexSet *indexSex = [NSIndexSet indexSetWithIndex:index];
        [self.tableView reloadSections:indexSex withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    [self.tableView reloadData];

}


#pragma mark 按钮点击事件
-(void)buttonClick:(TagButton*)button
{
    TagView *tagView = (TagView *)button.superview;
    
    NSString *tagString = button.titleLabel.text;
    NSInteger tagID = button.QSid;
    if (!button.isSelected) {
        
        [self.selectedDictionary setObject:tagView forKey:tagString];
        
        //添加选择数据
        if (tagView.tag == 10001) {
            [self.selectedTopTags addObject:tagString];
            //如果需要存储ID，启用
            //[self.selectedTopID addObject:@(tagID)];
        }
        else if(tagView.tag == 10002)
        {
            [self.selectedBottomTags addObject:tagString];
            
            //[self.selectedBottomID addObject:@(tagID)];
        }
        
        // 添加标签
        [self.tagList addTag:tagString withID:tagID];
        
    }else {
        [self.selectedDictionary removeObjectForKey:tagString];
        //删除选择数据
        if (tagView.tag == 10001) {
            [self.selectedTopTags removeObject:tagString];
            
            //[self.selectedTopID removeObject:@(tagID)];
        }
        else if(tagView.tag == 10002)
        {
            [self.selectedBottomTags removeObject:tagString];
            
            //[self.selectedBottomID addObject:@(tagID)];
        }
        // 删除标签
        [self.tagList deleteTag:tagString];
    }
    [self reloadSectionWithIndex:0];
    
    button.isSelected = !button.isSelected;
}
//点击上部视图的标签删除下部视图的标签
- (void)clickTag:(YZTagButton *)tag
{
    TagView *tagView = (TagView *)[self.selectedDictionary objectForKey:tag.currentTitle];
    
    // 删除标签
    [self.tagList deleteTag:tag.currentTitle];
    
    [tagView cancelSelectedStateWithString:tag.currentTitle];
    ////删除选择数据
    if (tagView.tag == 10001) {
        [self.selectedTopTags removeObject:tag.currentTitle];
        
        //[self.selectedTopID removeObject:@(tag.QSid)];
    }
    else if(tagView.tag == 10002)
    {
        [self.selectedBottomTags removeObject:tag.currentTitle];
        
        //[self.selectedBottomID removeObject:@(tag.QSid)];
    }
    
    
    [self reloadSectionWithIndex:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
