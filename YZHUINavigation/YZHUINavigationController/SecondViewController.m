//
//  SecondViewController.m
//  YZHUINavigationController
//
//  Created by captain on 16/11/17.
//  Copyright (c) 2016年 yzh. All rights reserved.
//

#import "SecondViewController.h"
#import "YZHUINavigationController.h"
#import "UINavigationPopScrollView.h"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIPanGestureRecognizer *popPan;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, assign) BOOL isIn;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildView];
}

-(void)back:(id)sender
{
    NSLog(@"sender=%@",sender);
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    self.title = @"其次";
//    [self addNavigationItemViewLeftBackButtonItemWithTitle:@"返回" target:self action:@selector(back:)];
//}

-(void)setUpChildView
{
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"其次";
//    self.barViewStyle = UIBarViewStyleDefault;
    self.navigationBarViewBackgroundColor = PURPLE_COLOR;
    
    [self addNavigationFirstLeftBackItemWithTitle:@"返回" target:self action:@selector(back:)];
    [self addNavigationRightItemsWithTitles:@[@"世界"] target:self action:@selector(back:) isReset:YES];

//    [self addNavigationItemViewLeftButtonItemsWithTitle:@[@"自定义",@"好东西",@"值得拥有"] target:self action:@selector(back:) isReset:YES];
    
//    [self addNavigationItemViewLeftBackButtonItemWithTitle:@"返回" target:self action:@selector(back:)];

//    [self addNavigationItemViewLeftButtonItemsWithTitle:@[@"自定义",@"选择"] target:self action:@selector(back:) isReset:NO];

//    [self addNavigationItemViewRightButtonItemsWithTitle:@[@"右边1",@"右边2",@"右边3"] target:self action:@selector(back:) isReset:NO];
    
//    [self addNavigationItemViewRightButtonItemsWithImage:@[@"List",@"Device",@"DLNA"] target:self action:@selector(rightAction:) isReset:YES];
    
//    [self addNavigationItemViewLeftButtonItemsWithImage:@[@"List",@"Device",@"DLNA"] target:self action:@selector(back:) isReset:YES];
    [self addNavigationRightItemsWithImageNames:@[@"Device",@"List"] target:self action:@selector(back:) isReset:YES];
    
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [self.view addSubview:tableView];
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSSTRING_FROM_CLASS(UITableViewCell)];
    
//    UIScrollView *scrollView = [[UIScreenEdgePanNotEffectScrollView alloc] initWithFrame:SCREEN_BOUNDS];
//    UIView *flagView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    flagView.backgroundColor = ORANGE_COLOR;
//    [scrollView addSubview:flagView];
    
    UIScrollView *scrollView = [[UINavigationPopScrollView alloc] initWithFrame:SCREEN_BOUNDS];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.backgroundColor = RED_COLOR;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 28*SCREEN_HEIGHT);
    
    self.scrollView = scrollView;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
//    UIView *newView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:newView];
//    _gestureView = newView;
    
//    self.popPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopAction:)];
//    self.popPan.delegate = self;
//    self.popPan.cancelsTouchesInView = NO;
//    [newView addGestureRecognizer:self.popPan];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollview=%@",scrollView.panGestureRecognizer);
//    NSLog(@"content.x=%f",scrollView.contentOffset.x);
//    if (scrollView.contentOffset.x == 0 /*&& (self.isIn || scrollView.isDragging == YES)*/) {
//        if (_gestureView == nil) {
//            UIView *newView = [[UIView alloc] initWithFrame:self.view.bounds];
//            newView.backgroundColor = YELLOW_COLOR;
//            newView.alpha=0.6;
//            newView.userInteractionEnabled = NO;
//            [self.view addSubview:newView];
//            _gestureView = newView;
//        }
//    }
//    else
//    {
//        if (_gestureView) {
//            [_gestureView removeFromSuperview];
//        }
//    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isIn = YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isIn = YES;
}

//-(void)handlePopAction:(UIScreenEdgePanGestureRecognizer*)sender
//{
//    CGFloat tx = [sender translationInView:self.gestureView].x;
//    CGFloat percent = tx / CGRectGetWidth(self.gestureView.frame);
//    CGFloat vx = [sender velocityInView:self.gestureView].x;
//    
//    CGPoint lx = [sender locationInView:self.gestureView];
//    
//        NSLog(@"tx=%f,percent=%f,vx=%f,(%f,%f)",tx,percent,lx.x,lx.y);
//
//    CGPoint offPoint = [sender translationInView:self.gestureView];
//    CGPoint oldPoint = self.scrollView.contentOffset;
//    CGPoint newPoint = CGPointMake(-offPoint.x, -offPoint.y);
////    percent = MAX(percent, 0);
//    
//    if (sender.state == UIGestureRecognizerStateBegan) {
////        self.isInteractive = YES;
////        [self popViewControllerAnimated:YES];
//        
//    }else if (sender.state == UIGestureRecognizerStateChanged) {
////        [self.transition updateInteractiveTransition:percent];
//        self.scrollView.contentOffset = newPoint;
//    }else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
////        if (vx < 0 || percent < minPercentChangeViewController) {//
////            [self.transition cancelInteractiveTransition];
////        }else{
////            [self.transition finishInteractiveTransition];
////        }
////        self.isInteractive = NO;
//        self.scrollView.contentOffset = newPoint;
//    }
//}

//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
//{
//    if (panGestureRecognizer == self.popPan) {
//        return YES;
//    }
//    return NO;
//}

-(void)rightAction:(id)sender
{
    NSLog(@"sender.tag=%@",sender);
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
    cell.backgroundColor = ORANGE_COLOR;
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.item+1];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
