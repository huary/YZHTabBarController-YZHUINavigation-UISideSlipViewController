//
//  UITabBarView.m
//  YZHTabBarControllerDemo
//
//  Created by captain on 17/2/7.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import "UITabBarView.h"
#import "UITabBarButton.h"
#import "UITabBarItem+UIButton.h"

#define CUSTOM_VIEW_TAG         (111)

@interface UITabBarView ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) UITabBarButton *lastSelectedBtn;

@property (nonatomic, strong) CALayer *lineLayer;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation UITabBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self _setupChildView];
    }
    return self;
}

-(void)_setupChildView
{
    self.lineLayer = [[CALayer alloc] init];
    
    self.lineLayer.frame = CGRectMake(0, -SINGLE_LINE_WIDTH, self.bounds.size.width, SINGLE_LINE_WIDTH);
    self.lineLayer.backgroundColor = RGBA_F(0, 0, 0, 0.3).CGColor;
    [self.layer addSublayer:self.lineLayer];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.bounces = NO;
    scrollView.backgroundColor = CLEAR_COLOR;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.layer.masksToBounds = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.scrollContent = NO;
}

-(NSMutableArray*)items
{
    if (_items == nil) {
        _items =  [NSMutableArray array];
    }
    return _items;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.lineLayer.frame = CGRectMake(0, -SINGLE_LINE_WIDTH, self.bounds.size.width, SINGLE_LINE_WIDTH);
    [self _updateLayout];
}

-(void)_updateLayout
{
    if (self.items.count <= 0) {
        return;
    }
    if (self.tabBarViewStyle == UITabBarViewStyleHorizontal) {
        CGFloat btnW = self.frame.size.width / self.items.count;
        CGFloat btnH = self.frame.size.height;
        CGFloat btnX = 0;
        
        for (int i = 0; i < self.items.count; ++i) {
            UITabBarButton *btn = self.items[i];
            btn.tag = i;
            CGFloat w = btnW;
            CGFloat h = btnH;
            CGFloat maxW = self.frame.size.width - btnX;
            if (self.scrollContent) {
                maxW = CGFLOAT_MAX;
            }
            if (btn.tabBarItem.buttonItemSize.width > 0 && btn.tabBarItem.buttonItemSize.width <= maxW) {
                w = btn.tabBarItem.buttonItemSize.width;
            }
            if (btn.tabBarItem.buttonItemSize.height > 0 && btn.tabBarItem.buttonItemSize.height <= btnH) {
                h = btn.tabBarItem.buttonItemSize.height;
            }
            btn.frame = CGRectMake(btnX, (btnH - h)/2, w, h);
            btn.tabBarItem = btn.tabBarItem;
            btnX += w;
        }
        self.scrollView.contentSize = CGSizeMake(btnX, btnH);
    }
    else {
        CGFloat btnW = self.frame.size.width;
        CGFloat btnH = self.frame.size.height  / self.items.count;
        CGFloat btnY = 0;
        
        for (int i = 0; i < self.items.count; ++i) {
            UITabBarButton *btn = self.items[i];
            btn.tag = i;
            CGFloat w = btnW;
            CGFloat h = btnH;
            CGFloat maxH = self.frame.size.height - btnY;
            if (self.scrollContent) {
                maxH = CGFLOAT_MAX;
            }
            if (btn.tabBarItem.buttonItemSize.width > 0 && btn.tabBarItem.buttonItemSize.width <= btnW) {
                w = btn.tabBarItem.buttonItemSize.width;
            }
            if (btn.tabBarItem.buttonItemSize.height > 0 && btn.tabBarItem.buttonItemSize.height <= maxH) {
                h = btn.tabBarItem.buttonItemSize.height;
            }
            btn.frame = CGRectMake((btnW - w)/2, btnY, w, h);
            btn.tabBarItem = btn.tabBarItem;
            btnY += h;
        }
        self.scrollView.contentSize = CGSizeMake(btnW, btnY);
    }
    self.scrollView.frame = self.bounds;
}

-(UITabBarButton*)addTabBarItem:(UITabBarItem *)tabBarItem
{
    UITabBarButton *btn = [[UITabBarButton alloc] init];
    btn.tabBarItem = tabBarItem;
    btn.tabBarView = self;
    
    [btn addTarget:self action:@selector(_tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.items addObject:btn];
    
    [self.scrollView addSubview:btn];
    if (self.items.count == 1) {
        [self _tabBarClick:btn];
    }
    return btn;
}

-(UITabBarButton*)resetTabBarItem:(UITabBarItem *)tabBarItem atIndex:(NSInteger)index
{
    if (index < 0 || index >= self.items.count) {
        return nil;
    }
    UITabBarButton *btn = self.items[index];
    btn.tabBarItem = tabBarItem;
    [self _removeCustomViewAtView:btn];
    [self _updateLayout];
    return btn;
}

-(void)_removeCustomViewAtView:(UIView*)view
{
    UIView *old = [view viewWithTag:CUSTOM_VIEW_TAG];
    [old removeFromSuperview];
}

-(void)addTabBarWithCustomView:(UIView*)customView
{
    if (customView == nil) {
        return;
    }
    UITabBarButton *btn = [self addTabBarItem:nil];
    customView.tag = CUSTOM_VIEW_TAG;
    customView.userInteractionEnabled = NO;
    [btn addSubview:customView];
}

-(void)resetTabBarWithCustomView:(UIView*)customView atIndex:(NSInteger)index
{
    if (index < 0 || index >= self.items.count) {
        return ;
    }
    if (customView == nil) {
        return;
    }
    UITabBarButton *btn = self.items[index];
    [self _removeCustomViewAtView:btn];
    customView.tag = CUSTOM_VIEW_TAG;
    customView.userInteractionEnabled = NO;
    [btn addSubview:customView];
}

-(void)_tabBarClick:(UITabBarButton*)selectedBtn
{
    BOOL shouldSelect = YES;
    if ([self.delegate respondsToSelector:@selector(tabBarView:didSelectFrom:to:)]) {
        shouldSelect = [self.delegate tabBarView:self didSelectFrom:self.lastSelectedBtn.tag to:selectedBtn.tag];
    }
    if (shouldSelect) {
        self.lastSelectedBtn.selected = NO;
        selectedBtn.selected = YES;
        self.lastSelectedBtn = selectedBtn;
    }
}

-(void)doSelectTo:(NSInteger)to
{
    if (to < 0 || to >= self.items.count) {
        return;
    }
    UITabBarButton *btn = [self.items objectAtIndex:to];
    if (btn == nil) {
        return;
    }
    [self _tabBarClick:btn];
}

-(NSInteger)currentIndex
{
    return self.items.count;
//    if (IS_AVAILABLE_NSSET_OBJ(self.items)) {
//        return self.items.count - 1;
//    }
//    return 0;
}
@end
