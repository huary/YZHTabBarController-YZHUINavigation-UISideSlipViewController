//
//  Style5ViewController.m
//  YZHUINavigationController
//
//  Created by yuan on 2018/4/27.
//  Copyright © 2018年 dlodlo. All rights reserved.
//

#import "Style5ViewController.h"
#import "YZHUINavigationController.h"
#import "Style5_2ViewController.h"

@interface Style5ViewController () <YZHUINavigationControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchController *searchController;

//tableView
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation Style5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildView];
}

-(void)back:(id)sender
{
    Style5_2ViewController *style2VC = [[Style5_2ViewController alloc] init];
    [self.navigationController pushViewController:style2VC animated:YES];
}

-(void)setUpChildView
{
    self.view.backgroundColor = WHITE_COLOR;
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:)    isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;
    
    CGFloat x = 0;
    CGFloat y = self.layoutTopY;
    CGFloat w = self.contentViewSize.width;
    CGFloat h = self.contentViewSize.height - y - SAFE_TAB_BAR_HEIGHT;
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSSTRING_FROM_CLASS(UITableViewCell)];
    [self.contentView addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.barTintColor = LIGHT_GRAY_COLOR;
    self.searchController.searchBar.placeholder = @"请输入关键字搜索";
    
    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    //    self.searchController.obscuresBackgroundDuringPresentation = NO;
    
    //点击搜索的时候,是否隐藏导航栏
    //    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    CGRect frame = self.searchController.searchBar.frame;
//    frame.size.height = NAV_BAR_HEIGHT;
//    self.searchController.searchBar.frame = frame;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    self.definesPresentationContext=YES;
}
-(void)_updateTableViewHeader
{
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - UISearchControllerDelegate代理

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self _updateTableViewHeader];
    NSLog(@"%s",__FUNCTION__);
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"%s",__FUNCTION__);
}

//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSSTRING_FROM_CLASS(UITableViewCell) forIndexPath:indexPath];
    cell.textLabel.text = NEW_STRING_WITH_FORMAT(@"%ld",indexPath.row);
    return cell;
}

#pragma mark YZHUINavigationControllerDelegate
-(UIViewController*)YZHUINavigationController:(YZHUINavigationController *)navigationController pushNextViewControllerForViewController:(UIViewController *)viewController
{
    if (viewController == self) {
        Style5_2ViewController *style2VC = [[Style5_2ViewController alloc] init];
        return style2VC;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
