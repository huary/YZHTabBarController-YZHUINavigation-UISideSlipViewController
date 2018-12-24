//
//  FirstViewController.m
//  YZHUINavigationController
//
//  Created by captain on 16/11/17.
//  Copyright (c) 2016年 yzh. All rights reserved.
//

#import "FirstViewController.h"
#import "YZHUINavigationController.h"
#import "SecondViewController.h"

@interface FirstViewController () <YZHUINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpChildView];
}

-(void)back:(id)sender
{
    
}

-(void)setUpChildView
{
//    self.navigationItem.title = @"首页";
//    
//    UILabel *label = [[UILabel alloc] init];
////    label.text=@"";
//    self.navigationItem.titleView = label;//[UIView new];
////    [self.navigationItem.titleView addSubview:[[UIView alloc] init]];
    
    self.title = @"首页";
    
    self.view.backgroundColor = WHITE_COLOR;
//    self.barViewStyle = UIBarViewStyleBlack;
    self.navigationBarViewBackgroundColor = ORANGE_COLOR;
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.navDelegate = self;
    
//    [self addNavigationItemViewLeftBackButtonItemWithTitle:@"返回" target:self action:@selector(back:)];
//    [self addNavigationItemViewLeftBackButtonItemWithTitle:@"左边" target:self action:@selector(back:)];
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:)    isReset:YES];

    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    [self addNavigationRightItemsWithImageNames:@[@"List",@"Device",@"DLNA"] target:self action:@selector(back:) isReset:YES];

    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundColor:RED_COLOR];
//    [btn setTitle:@"按钮的特殊设置" forState:UIControlStateNormal];
//    
//    [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:btn];
//    btn.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200]];
//
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:100]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSSTRING_FROM_CLASS(UITableViewCell)];
 
}

-(void)action:(id)sender
{
    NSLog(@"sender=%@",sender);
}


-(void)enterSecondVCAction:(id)sender
{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

#pragma mark YZHUINavigationControllerDelegate
-(UIViewController*)YZHUINavigationController:(YZHUINavigationController *)navigationController pushNextViewControllerForViewController:(UIViewController *)viewController
{
    if (viewController == self) {
        SecondViewController *secondVC = [[SecondViewController alloc] init];
        return secondVC;
    }
    return nil;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSSTRING_FROM_CLASS(UITableViewCell)];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.item+1];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
