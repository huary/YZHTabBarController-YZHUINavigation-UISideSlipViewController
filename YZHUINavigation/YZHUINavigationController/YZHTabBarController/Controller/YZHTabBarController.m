//
//  YZHTabBarController.m
//  YZHTabBarControllerDemo
//
//  Created by captain on 17/2/7.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import "YZHTabBarController.h"
#import "UITabBarView.h"
#import "UIViewController+UITabBarButton.h"

NSString *const YZHTabBarItemTitleNormalColorKey = TYPE_STR(YZHTabBarItemTitleNormalColorKey);
NSString *const YZHTabBarItemTitleSelectedColorKey = TYPE_STR(YZHTabBarItemTitleSelectedColorKey);
NSString *const YZHTabBarItemTitleTextFontKey = TYPE_STR(YZHTabBarItemTitleTextFontKey);
NSString *const YZHTabBarItemSelectedBackgroundColorKey = TYPE_STR(YZHTabBarItemSelectedBackgroundColorKey);
NSString *const YZHTabBarItemHighlightedBackgroundColorKey = TYPE_STR(YZHTabBarItemHighlightedBackgroundColorKey);

@interface YZHTabBarController () <UITabBarViewDelegate>

@property (nonatomic, strong) UITabBarView *tabBarView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, UIViewController*> *indexChildVC;

@end

static YZHTabBarController *shareTabBarController_s = NULL;

@implementation YZHTabBarController

-(instancetype)init
{
    self = [super init];
    if (self) {
        shareTabBarController_s = self;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        shareTabBarController_s = self;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        shareTabBarController_s = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupTabBar];
}

+(YZHTabBarController*)shareTabBarController
{
    return shareTabBarController_s;
}

-(UIView*)customTarBarView
{
    return self.tabBarView;
}

-(NSMutableDictionary<NSNumber*, UIViewController*>*)indexChildVC
{
    if (_indexChildVC == nil) {
        _indexChildVC = [NSMutableDictionary dictionary];
    }
    return _indexChildVC;
}

-(void)_setupTabBar
{
    UITabBarView *tabBarView = [[UITabBarView alloc] init];
    tabBarView.delegate  = self;
    tabBarView.frame = self.tabBar.bounds;
    tabBarView.backgroundColor = WHITE_COLOR;
    
    [self _hiddenTabBarSubView];
    
    [self.tabBar addSubview:tabBarView];
    self.tabBarView = tabBarView;
}

-(void)_hiddenTabBarSubView
{
    for (UIView *subView in self.tabBar.subviews) {
        if (![subView isKindOfClass:[UITabBarView class]]) {
            subView.hidden = YES;
        }
    }
}

#pragma mark UITabBarViewDelegate

-(BOOL)tabBarView:(UITabBarView *)tabBarView didSelectFrom:(NSInteger)from to:(NSInteger)to
{
    BOOL shouldSelect = YES;
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarController:shouldSelectFrom:to:)]) {
        shouldSelect = [self.tabBarDelegate tabBarController:self shouldSelectFrom:from to:to];
    }
    if (shouldSelect) {
        self.selectedIndex = to;
    }
    return shouldSelect;
}

#pragma mark end

-(void)doSelectTo:(NSInteger)toIndex
{
    [self.tabBarView doSelectTo:toIndex];
}

-(void)_addChildVC:(UIViewController*)viewController atIndex:(NSInteger)index
{
    if (viewController == nil) {
        return;
    }
    [self addChildViewController:viewController];
    [self.indexChildVC setObject:viewController forKey:@(index)];
}

-(NSInteger)_getChildVCIndexAtIndex:(NSInteger)index
{
    NSInteger childVCIndex = index;
    for (NSInteger i = 0; i < index; ++i) {
        if (![self.indexChildVC objectForKey:@(i)]) {
            --childVCIndex;
        }
    }
    return childVCIndex;

}

-(void)_updateChildVC:(UIViewController*)viewController atIndex:(NSInteger)index
{
    if (viewController == nil) {
        return;
    }
    
    NSInteger childVCIndex = [self _getChildVCIndexAtIndex:index];
    if ([self.indexChildVC objectForKey:@(index)]) {
        if (childVCIndex < 0 || childVCIndex >= self.viewControllers.count) {
            return;
        }
        
        NSMutableArray *childVCArray = [self.viewControllers mutableCopy];
        childVCArray[childVCIndex] = viewController;
        self.viewControllers = childVCArray;
        [self.indexChildVC setObject:viewController forKey:@(index)];
    }
    else {
        if (childVCIndex >= self.viewControllers.count) {
            [self _addChildVC:viewController atIndex:index];
        }
        else {
            NSMutableArray *childVCArray = [self.viewControllers mutableCopy];
            [childVCArray insertObject:viewController atIndex:childVCIndex];
            self.viewControllers = childVCArray;
            [self.indexChildVC setObject:viewController forKey:@(index)];
        }
    }
    
}

-(void)_removeChildVCAtIndex:(NSInteger)index
{
    NSInteger childVCIndex = [self _getChildVCIndexAtIndex:index];
    if (childVCIndex < 0 || childVCIndex >= self.viewControllers.count) {
        return;
    }
    NSMutableArray *childVCArray = [self.viewControllers mutableCopy];
    UIViewController *childVC = [childVCArray objectAtIndex:childVCIndex];
    childVC.title = nil;
    childVC.tabBarItem.title = nil;
    childVC.tabBarItem.image = nil;
    childVC.tabBarItem.selectedImage = nil;
    [childVCArray removeObjectAtIndex:childVCIndex];
    self.viewControllers = childVCArray;
    [self.indexChildVC removeObjectForKey:@(index)];
}

-(void)setupChildViewController:(UIViewController *)childVC
                      withTitle:(NSString *)title
                          image:(UIImage *)image
                  selectedImage:(UIImage *)selectedImage
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
{
    if (childVC == nil) {
        return;
    }
    childVC.title = title;
    childVC.tabBarItem.image = image;
    childVC.tabBarItem.selectedImage = selectedImage;
    YZHUINavigationController *nav = [[YZHUINavigationController alloc] initWithRootViewController:childVC navigationControllerBarAndItemStyle:barAndItemStyle];
    NSInteger index = [self.tabBarView currentIndex];
    [self _addChildVC:nav atIndex:index];
    UITabBarButton *button = [self.tabBarView addTabBarItem:childVC.tabBarItem];
    childVC.tabBarButton = button;
}

-(void)setupChildViewController:(UIViewController*)childVC
                      withTitle:(NSString*)title
                      imageName:(NSString*)imageName
              selectedImageName:(NSString*)selectedImageName
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *selectImage = [UIImage imageNamed:selectedImageName];
    [self setupChildViewController:childVC withTitle:title image:image selectedImage:selectImage navigationControllerBarAndItemStyle:barAndItemStyle];
}

-(void)setupChildViewController:(UIViewController *)childVC
                 customItemView:(UIView*)customItemView
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
{
    if (customItemView == nil) {
        return;
    }
    if (childVC) {
        YZHUINavigationController *nav = [[YZHUINavigationController alloc] initWithRootViewController:childVC navigationControllerBarAndItemStyle:barAndItemStyle];
        NSInteger index = [self.tabBarView currentIndex];
        [self _addChildVC:nav atIndex:index];
    }
    [self.tabBarView addTabBarWithCustomView:customItemView];
}

-(void)clear
{
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = nil;
        obj.tabBarItem.title = nil;
        obj.tabBarItem.image = nil;
        obj.tabBarItem.selectedImage = nil;
        [obj removeFromParentViewController];
        obj.tabBarButton = nil;
    }];
    [self.tabBarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.indexChildVC = nil;
}

-(void)resetChildViewController:(UIViewController*)childVC
                        withTitle:(NSString*)title
                            image:(UIImage*)image
                    selectedImage:(UIImage*)selectedImage
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
                          atIndex:(NSInteger)index
{
//    if (index < 0 || index >= self.viewControllers.count) {
//        return;
//    }
    if (childVC == nil) {
        return;
    }
    childVC.title = title;
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = image;
    childVC.tabBarItem.selectedImage = selectedImage;
    YZHUINavigationController *nav = [[YZHUINavigationController alloc] initWithRootViewController:childVC navigationControllerBarAndItemStyle:barAndItemStyle];
    [self _updateChildVC:nav atIndex:index];
    [self.tabBarView resetTabBarItem:childVC.tabBarItem atIndex:index];
}

-(void)resetChildViewController:(UIViewController*)childVC
                      withTitle:(NSString*)title
                      imageName:(NSString*)imageName
              selectedImageName:(NSString*)selectedImageName
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
                        atIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *selectImage = [UIImage imageNamed:selectedImageName];
    [self resetChildViewController:childVC withTitle:title image:image selectedImage:selectImage navigationControllerBarAndItemStyle:barAndItemStyle atIndex:index];
}

-(void)resetChildViewController:(UIViewController *)childVC
                 customItemView:(UIView*)customItemView
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
                        atIndex:(NSInteger)index
{
//    if (index < 0 || index >= self.viewControllers.count) {
//        return;
//    }
    if (childVC) {
        YZHUINavigationController *nav = [[YZHUINavigationController alloc] initWithRootViewController:childVC navigationControllerBarAndItemStyle:barAndItemStyle];
        [self _updateChildVC:nav atIndex:index];
    }
    else {
        [self _removeChildVCAtIndex:index];
    }
    [self.tabBarView resetTabBarWithCustomView:customItemView atIndex:index];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIControl class]]) {
            [obj removeFromSuperview];
        }
    }];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self _hiddenTabBarSubView];
    CGSize size = self.tabBar.bounds.size;
    self.tabBarView.frame = CGRectMake(0, 0, size.width, TAB_BAR_HEIGHT);
    self.tabBarView.backgroundColor = WHITE_COLOR;
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [child removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
