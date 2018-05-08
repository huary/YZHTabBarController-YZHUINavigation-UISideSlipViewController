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

@interface Style5ViewController () <YZHUINavigationControllerDelegate>

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
    
//    self.navigationBarViewBackgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.4 alpha:1.0];
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:)    isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;
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
