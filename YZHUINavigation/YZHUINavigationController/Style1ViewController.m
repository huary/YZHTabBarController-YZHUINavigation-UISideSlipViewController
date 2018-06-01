//
//  Style1ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style1ViewController.h"
#import "YZHUINavigationController.h"
#import "Style1_2ViewController.h"
#import "AppDelegate.h"

@interface Style1ViewController () <YZHUINavigationControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

//tableView
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation Style1ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpChildView];
}

-(void)back:(id)sender
{
    Style1_2ViewController *style2VC = [[Style1_2ViewController alloc] init];
    [self.navigationController pushViewController:style2VC animated:YES];
}

-(void)setUpChildView
{
    self.view.backgroundColor = WHITE_COLOR;
    self.navigationBarBottomLineColor = nil;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.navigationBarViewBackgroundColor = CLEAR_COLOR;
    
    UIView *subView = [[UIView alloc] init];
    subView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    subView.frame = CGRectMake(100, 100, 150, 40);
    subView.backgroundColor = BLUE_COLOR;
    [self.view addSubview:subView];
    
//    self.navigationTitle = @"第一个";
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:) isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;
    
    CGFloat height = SAFE_HEIGHT;
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
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
        Style1_2ViewController *style2VC = [[Style1_2ViewController alloc] init];
        return style2VC;
    }
    return nil;
}

@end
