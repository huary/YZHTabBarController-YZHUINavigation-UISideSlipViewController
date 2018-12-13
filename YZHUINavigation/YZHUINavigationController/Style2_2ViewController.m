//
//  Style2_2ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style2_2ViewController.h"

#import "UIScrollView+UIPanGestureRecognizers.h"

@implementation Style2_2ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpChildView];
    
    [self test2];
}

-(void)back:(id)sender
{
    NSLog(@"sender=%@",sender);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpChildView
{
    self.title = @"样式2-2";
    
    self.view.backgroundColor = PURPLE_COLOR;
    self.navigationBarViewBackgroundColor = RED_COLOR;
    
    [self addNavigationFirstLeftBackItemWithTitle:@"返回Style2" target:self action:@selector(back:)];
    
    [self addNavigationRightItemsWithImageNames:@[@"List",@"Device",@"DLNA"] target:self action:@selector(back:) isReset:YES];
}

-(void)test2
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGFloat y = STATUS_NAV_BAR_HEIGHT+50;
    scrollView.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT- y- TAB_BAR_HEIGHT - 50);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, scrollView.bounds.size.height);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    UIScrollView *sub1 = [[UIScrollView alloc] init];
    sub1.frame = CGRectMake(0, 0, SCREEN_WIDTH, scrollView.bounds.size.height);
//    sub1.bounces = NO;
    sub1.backgroundColor = GREEN_COLOR;
    sub1.contentSize = CGSizeMake(SCREEN_WIDTH, scrollView.bounds.size.height);
    [scrollView addSubview:sub1];
    
//    UIScrollView *sub2 = [[UIScrollView alloc] init];
//    sub2.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView.bounds.size.height);
//    sub2.contentSize = CGSizeMake(SCREEN_WIDTH * 2, scrollView.bounds.size.height);
//    sub2.backgroundColor = YELLOW_COLOR;
//    [scrollView addSubview:sub2];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView.bounds.size.height);
    webView.opaque = NO;
    webView.backgroundColor = CLEAR_COLOR;
    webView.scrollView.frame = webView.bounds;
    
    webView.scrollView.contentInset = UIEdgeInsetsZero;
    webView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*1.5, scrollView.bounds.size.height);
//    webView.backgroundColor = BLACK_COLOR;
    webView.scrollView.backgroundColor = ORANGE_COLOR;
    [scrollView addSubview:webView];
    
//    [scrollView setUIPanGestureRecognizersEnabled:YES withShouldRecognizesBlock:^BOOL(UIScrollView *scrollView, UIGestureRecognizer *first, UIGestureRecognizer *second) {
//        if (scrollView.contentOffset.x <= 0) {
//            scrollView.contentOffset = CGPointMake(0, 0);
//            return YES;
//        }
//        return NO;
//    }];
    
    [scrollView setUIPanGestureRecognizersEnabled:YES whitPanGestureRecognizerShouldBeginBlock:^BOOL(UIScrollView *scrollView, UIGestureRecognizer *gestureRecognizer) {
        
        CGPoint point = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:gestureRecognizer.view];
        NSLog(@"contentOffset=(%f,%f),point=%(%f,%f)",scrollView.contentOffset.x,scrollView.contentOffset.y,point.x,point.y);
        if (scrollView.contentOffset.x <= 0 && point.x > 0) {
            return NO;
        }
        return YES;
    } panGestureRecognizersShouldRecognizeSimultaneouslyBlock:nil];
}

@end
