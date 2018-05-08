//
//  Style5_2ViewController.m
//  YZHUINavigationController
//
//  Created by yuan on 2018/4/28.
//  Copyright © 2018年 dlodlo. All rights reserved.
//

#import "Style5_2ViewController.h"

@interface Style5_2ViewController ()

@end

@implementation Style5_2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildView];
    
}

-(void)back:(id)sender
{
    NSLog(@"sender=%@",sender);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpChildView
{
    self.title = @"样式5-2";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((SCREEN_WIDTH-150)/2, 100, 150, 40);
    btn.backgroundColor = RAND_COLOR;
    [btn setTitle:@"test" forState:UIControlStateNormal];
    //    [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.4 blue:0.5 alpha:1.0];
    self.navigationBarViewBackgroundColor = [UIColor colorWithRed:0.3 green:0.7 blue:0.4 alpha:0.8];
    
    [self addNavigationFirstLeftBackItemWithTitle:@"返回" target:self action:@selector(back:)];
    
    [self addNavigationRightItemsWithImageNames:@[@"List",@"Device",@"DLNA"] target:self action:@selector(back:) isReset:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
