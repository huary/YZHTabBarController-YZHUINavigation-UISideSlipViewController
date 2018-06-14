//
//  Style4ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style4ViewController.h"
#import "YZHUINavigationController.h"
#import "Style4_2ViewController.h"

@interface Style4ViewController () <YZHUINavigationControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

//tableView
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation Style4ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpChildView];
}

-(void)back:(id)sender
{
    Style4_2ViewController *style2VC = [[Style4_2ViewController alloc] init];
    [self.navigationController pushViewController:style2VC animated:YES];
}

-(void)setUpChildView
{
    self.view.backgroundColor = WHITE_COLOR;
    
    
//    self.navigationBarViewBackgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.4 alpha:1.0];
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:)  isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;
    
    
//    return;
    //searchController
    CGFloat x = 0;
    CGFloat y = self.layoutTopY;
    CGFloat w = SAFE_WIDTH;
    CGFloat h = SAFE_HEIGHT - NAV_BAR_HEIGHT - SAFE_TAB_BAR_HEIGHT;
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.tableView.backgroundColor = RED_COLOR;

//    self.navigationTitle = @"自定义";

    [self.view addSubview:self.tableView];
    
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
    
    CGRect frame = self.searchController.searchBar.frame;
    frame.size.height = NAV_BAR_HEIGHT;
    self.searchController.searchBar.frame = frame;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    self.definesPresentationContext=YES;
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
    NSLog(@"%s",__FUNCTION__);
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"%s",__FUNCTION__);
}

//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}


#pragma mark YZHUINavigationControllerDelegate
-(UIViewController*)YZHUINavigationController:(YZHUINavigationController *)navigationController pushNextViewControllerForViewController:(UIViewController *)viewController
{
    if (viewController == self) {
        Style4_2ViewController *style2VC = [[Style4_2ViewController alloc] init];
        return style2VC;
    }
    return nil;
}

@end
