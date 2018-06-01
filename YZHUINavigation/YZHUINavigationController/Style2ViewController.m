//
//  Style2ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style2ViewController.h"
#import "YZHUINavigationController.h"
#import "Style2_2ViewController.h"


@interface Style2ViewController () <YZHUINavigationControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

//tableView
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation Style2ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpChildView];
}

-(void)back:(id)sender
{

}

-(void)setUpChildView
{
    self.view.backgroundColor = WHITE_COLOR;
    
//    self.navigationTitle = @"第二个";
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:)    isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;

    
    //searchController
    self.tableView =[[UITableView alloc]initWithFrame:SCREEN_BOUNDS];
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
        Style2_2ViewController *style2VC = [[Style2_2ViewController alloc] init];
        return style2VC;
    }
    return nil;
}


@end
