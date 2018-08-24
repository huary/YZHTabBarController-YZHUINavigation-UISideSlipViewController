//
//  UITabBarView.m
//  YZHTabBarControllerDemo
//
//  Created by captain on 17/2/7.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <objc/runtime.h>
#import "UITabBarView.h"
#import "UITabBarButton.h"
#import "UITabBarItem+UIButton.h"
#import "UIView+UIGestureRecognizer.h"

static const NSInteger customViewTag_s = 111;

typedef NS_ENUM(NSInteger, NSTabBarButtonType)
{
    //创建的TabBar按顺序加入到TabBarView中的
    NSTabBarButtonTypeDefault       = 0,
    //自定义Layout
    NSTabBarButtonTypeCustomLayout  = 1,
    //创建单个的TabBar
    NSTabBarButtonTypeSingle        = 2,
};

/**************************************************************************
 *UITabBarButton (TabBarButtonType)
 **************************************************************************/
@interface UITabBarButton (TabBarButtonType)
@property (nonatomic, assign) NSTabBarButtonType tabBarButtonType;
@property (nonatomic, copy) TabBarEventActionBlock eventActionBlock;
@end

@implementation UITabBarButton (TabBarButtonType)

-(void)setTabBarButtonType:(NSTabBarButtonType)tabBarButtonType
{
    objc_setAssociatedObject(self, @selector(tabBarButtonType), @(tabBarButtonType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTabBarButtonType)tabBarButtonType
{
    return (NSTabBarButtonType)[objc_getAssociatedObject(self, _cmd) integerValue];
}

-(void)setEventActionBlock:(TabBarEventActionBlock)eventActionBlock
{
    objc_setAssociatedObject(self, @selector(eventActionBlock), eventActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(TabBarEventActionBlock)eventActionBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

@end




/**************************************************************************
 *UITabBarView
 **************************************************************************/
@interface UITabBarView ()

@property (nonatomic, strong) NSMutableArray *items;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *singleTabBarItems;

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

-(NSMutableArray*)singleTabBarItems
{
    if (_singleTabBarItems == nil) {
        _singleTabBarItems = [NSMutableArray array];
    }
    return _singleTabBarItems;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.lineLayer.frame = CGRectMake(0, -SINGLE_LINE_WIDTH, self.bounds.size.width, SINGLE_LINE_WIDTH);
    [self _updateLayout];
}

-(void)_updateLayout
{
    if (self.items.count <= 0 && self.singleTabBarItems.count <= 0) {
        return;
    }
    __block NSInteger defaultItemCnt = 0;
    __block NSInteger customLayoutCnt = 0;
    [self.items enumerateObjectsUsingBlock:^(UITabBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tabBarButtonType == NSTabBarButtonTypeDefault) {
            ++defaultItemCnt;
        }
        else if (obj.tabBarButtonType == NSTabBarButtonTypeCustomLayout) {
            ++customLayoutCnt;
        }
    }];
    
    if (self.tabBarViewStyle == UITabBarViewStyleHorizontal) {
        CGFloat btnW = defaultItemCnt > 0 ? (self.frame.size.width / defaultItemCnt) : 0;
        CGFloat btnH = self.frame.size.height;
        if (self.tabBarViewUseFor == UITabBarViewUseForTabBar) {
            btnH = self.frame.size.height - SAFE_BOTTOM;
        }
        CGFloat btnX = 0;
        
        for (int i = 0; i < self.items.count; ++i) {
            UITabBarButton *btn = self.items[i];
            btn.tag = i;
            if (btn.tabBarButtonType == NSTabBarButtonTypeDefault) {
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
            }
            else {
                btn.frame = CGRectMake( btn.tabBarItem.buttonItemOrigin.x,  btn.tabBarItem.buttonItemOrigin.y, btn.tabBarItem.buttonItemSize.width, btn.tabBarItem.buttonItemSize.height);
            }
            btnX = CGRectGetMaxX(btn.frame);
            btn.tabBarItem = btn.tabBarItem;
        }
        self.scrollView.contentSize = CGSizeMake(btnX, btnH);
    }
    else {
        CGFloat btnW = self.frame.size.width;
        CGFloat btnH = defaultItemCnt > 0 ? (self.frame.size.height  / defaultItemCnt) : 0;
        CGFloat btnY = 0;
        
        for (int i = 0; i < self.items.count; ++i) {
            UITabBarButton *btn = self.items[i];
            btn.tag = i;
            if (btn.tabBarButtonType == NSTabBarButtonTypeDefault) {
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
            }
            else {
                btn.frame = CGRectMake( btn.tabBarItem.buttonItemOrigin.x,  btn.tabBarItem.buttonItemOrigin.y, btn.tabBarItem.buttonItemSize.width, btn.tabBarItem.buttonItemSize.height);
            }
            btnY = CGRectGetMaxY(btn.frame);
            btn.tabBarItem = btn.tabBarItem;
        }
        self.scrollView.contentSize = CGSizeMake(btnW, btnY);
    }
    self.scrollView.frame = self.bounds;
    
    [self.singleTabBarItems enumerateObjectsUsingBlock:^(UITabBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tabBarItem = obj.tabBarItem;
    }];
}

-(void)_addGestureAtButton:(UITabBarButton*)button
{
    WEAK_SELF(weakSelf);
    [button addDoubleTapGestureRecognizerBlock:^(UIGestureRecognizer *gesture) {
        [weakSelf _tapAction:gesture];
    }];
}

-(void)_tapAction:(UIGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(tabBarView:doubleClickAtIndex:)]) {
        [self.delegate tabBarView:self doubleClickAtIndex:gesture.view.tag];
    }
}

-(UITabBarButton*)addTabBarItem:(UITabBarItem *)tabBarItem
{
    return [self _createTabBarItem:tabBarItem tabBarItemType:NSTabBarButtonTypeDefault forControlEvents:UIControlEventTouchUpInside actionBlock:nil];
}

-(UITabBarButton*)addCustomLayoutTabBarItem:(UITabBarItem *)tabBarItem
{
    return [self _createTabBarItem:tabBarItem tabBarItemType:NSTabBarButtonTypeCustomLayout forControlEvents:UIControlEventTouchUpInside actionBlock:nil];
}

-(UITabBarButton*)createSingleTabBarItem:(UITabBarItem *)tabBarItem forControlEvents:(UIControlEvents)controlEvents actionBlock:(TabBarEventActionBlock)actionBlock
{
    return [self _createTabBarItem:tabBarItem tabBarItemType:NSTabBarButtonTypeSingle forControlEvents:controlEvents actionBlock:actionBlock];
}

-(UITabBarButton*)_createTabBarItem:(UITabBarItem *)tabBarItem tabBarItemType:(NSTabBarButtonType)tabBarButtonType forControlEvents:(UIControlEvents)controlEvents actionBlock:(TabBarEventActionBlock)actionBlock
{
    UITabBarButton *btn = [[UITabBarButton alloc] init];
    btn.tabBarItem = tabBarItem;
    btn.tabBarButtonType = tabBarButtonType;
    [btn addTarget:self action:@selector(_tabBarClick:) forControlEvents:controlEvents];
    if (tabBarButtonType == NSTabBarButtonTypeDefault || tabBarButtonType == NSTabBarButtonTypeCustomLayout)
    {
        [self _addGestureAtButton:btn];
        btn.tabBarView = self;
        [self.items addObject:btn];
        [self.scrollView addSubview:btn];
        if (self.items.count == 1) {
            [self _tabBarClick:btn];
        }
    }
    else {
        btn.eventActionBlock = actionBlock;
        [self.singleTabBarItems addObject:btn];
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
    UIView *old = [view viewWithTag:customViewTag_s];
    [old removeFromSuperview];
}

-(void)addTabBarWithCustomView:(UIView*)customView
{
    if (customView == nil) {
        return;
    }
    UITabBarButton *btn = [self addTabBarItem:nil];
    customView.tag = customViewTag_s;
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
    customView.tag = customViewTag_s;
    customView.userInteractionEnabled = NO;
    [btn addSubview:customView];
}

-(void)addCustomLayoutTabBarWithCustomView:(UIView *)customView
{
    CGSize size = customView.frame.size;
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.buttonItemOrigin = customView.frame.origin;
    tabBarItem.buttonItemSize = size;
    UITabBarButton *btn = [self addCustomLayoutTabBarItem:tabBarItem];
    customView.tag = customViewTag_s;
    customView.userInteractionEnabled = NO;
    customView.frame = CGRectMake(0, 0, size.width, size.height);
    [btn addSubview:customView];
}

-(void)_tabBarClick:(UITabBarButton*)selectedBtn
{
    if (selectedBtn.tabBarButtonType == NSTabBarButtonTypeDefault || selectedBtn.tabBarButtonType == NSTabBarButtonTypeCustomLayout) {
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
    else {
        if (selectedBtn.eventActionBlock) {
            selectedBtn.eventActionBlock(selectedBtn);
        }
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
}
@end
