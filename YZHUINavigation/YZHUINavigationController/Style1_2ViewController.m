//
//  Style1_2ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style1_2ViewController.h"
#import "UINavigationPopScrollView.h"

//#import "UITableViewTest.h"
#import "UIScrollView+UIPanGestureRecognizers.h"

@interface Style1_2ViewController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@end

@implementation Style1_2ViewController

-(void)viewDidLoad
{
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
    self.title = @"样式1-2";
    
    self.view.backgroundColor = RED_COLOR;
    self.navigationBarViewBackgroundColor = PURPLE_COLOR;
    
    [self addNavigationFirstLeftBackItemWithTitle:@"Style1" target:self action:@selector(back:)];
    
    [self addNavigationRightItemsWithImageNames:@[@"List",@"Device",@"DLNA"] target:self action:@selector(back:) isReset:YES];
//    [self addNavigationRightItemsWithTitles:@[@"1",@"2",@"3"] target:self action:@selector(back:) isReset:YES];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = SCREEN_BOUNDS;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
//    tableView.bounces = NO;
   // tableView.delaysContentTouches = NO;
   // tableView.canCancelContentTouches = NO;
    //tableView.panGestureRecognizer.delegate = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSSTRING_FROM_CLASS(UITableViewCell)];
}


#pragma mark UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSSTRING_FROM_CLASS(UITableViewCell)];
    
    
    //UINavigationPopScrollView *scrollView = [[UINavigationPopScrollView alloc] init];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 800);
    scrollView.bounces = NO;
    UIView *subView = [[UIView alloc] init];
    subView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 2, 800);
    subView.backgroundColor = RAND_COLOR;
    [scrollView addSubview:subView];
    [cell.contentView addSubview:scrollView];
    
    CGFloat offsetX = 800-200;
    
    //scrollView.bounces = NO;
    __block BOOL shouldRecognizeSimultaneously = NO;
    UIPanGestureRecognizersShouldRecognizeSimultaneouslyBlock panRecognizersBlock = ^(UIScrollView *scrollView,UIGestureRecognizer *first, UIGestureRecognizer *second)
    {
        //NSLog(@"1.y=%f,state=%ld",scrollView.contentOffset.y,first.state);
        
        CGPoint point = CGPointZero;
        if (first.view == scrollView && [first isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)first;
            point = [pan translationInView:scrollView];
        }
        
        //NSLog(@"pt=(%f,%f)",point.x,point.y);
        
        if (fabs(point.x) > fabs(point.y)) {
            if (scrollView.contentOffset.x <= 0) {
                shouldRecognizeSimultaneously = YES;
                return YES;
            }
        }
        else
        {
            if (scrollView.contentOffset.y < 0 || (scrollView.contentOffset.y == 0 && point.y > 0)) {
                shouldRecognizeSimultaneously = YES;
                return YES;
            }
            
            if (scrollView.contentOffset.y > offsetX || (scrollView.contentOffset.y == offsetX && point.y < 0)) {
                shouldRecognizeSimultaneously = YES;
                return YES;
            }
        }
        
        shouldRecognizeSimultaneously = NO;
        return NO;
        
    };
    
//    [scrollView setUIPanGestureRecognizersEnabled:YES withShouldRecognizesBlock:panRecognizersBlock];
    [scrollView setUIPanGestureRecognizersEnabled:YES whitPanGestureRecognizerShouldBeginBlock:nil panGestureRecognizersShouldRecognizeSimultaneouslyBlock:panRecognizersBlock];
    
    UIPanGestureRecognizersShouldRecognizeSimultaneouslyBlock tableViewPanRecognizersBlock = ^(UIScrollView *scrollViewT,UIGestureRecognizer *first, UIGestureRecognizer *second)
    {
        return shouldRecognizeSimultaneously;
    };
    
//    [tableView setUIPanGestureRecognizersEnabled:YES withShouldRecognizesBlock:tableViewPanRecognizersBlock];
    
    [tableView setUIPanGestureRecognizersEnabled:YES whitPanGestureRecognizerShouldBeginBlock:nil panGestureRecognizersShouldRecognizeSimultaneouslyBlock:tableViewPanRecognizersBlock];

    return cell;
}

@end
