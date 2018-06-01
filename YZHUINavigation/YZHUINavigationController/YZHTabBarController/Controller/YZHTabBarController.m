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


/**************************************************************************
 *NSItemChildVCInfo
 **************************************************************************/
@interface NSItemChildVCInfo : NSObject

/** item的Index，这个是在TabBarView上面的Index */
@property (nonatomic, assign) NSInteger itemIndex;

/** childVCIndex,这个是在TabBarController上面的Index*/
@property (nonatomic, assign) NSInteger childVCIndex;

/** ChildVC */
@property (nonatomic, weak) UIViewController *childVC;

@end

@implementation NSItemChildVCInfo
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self _setupDefaultValue];
    }
    return self;
}

-(instancetype)initWithItemIndex:(NSInteger)itemIndex childVC:(UIViewController*)childVC
{
    self = [super init];
    if (self) {
        [self _setupDefaultValue];
        self.itemIndex = itemIndex;
        self.childVC = childVC;
    }
    return self;
}

-(void)_setupDefaultValue
{
    self.childVCIndex = -1;
}
@end


/**************************************************************************
 *YZHTabBarController
 **************************************************************************/

@interface YZHTabBarController () <UITabBarViewDelegate>

@property (nonatomic, strong) UITabBarView *tabBarView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, NSItemChildVCInfo*> *itemChildVCInfo;

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

-(NSMutableDictionary<NSNumber*, NSItemChildVCInfo*>*)itemChildVCInfo
{
    if (_itemChildVCInfo == nil) {
        _itemChildVCInfo = [NSMutableDictionary dictionary];
    }
    return _itemChildVCInfo;
}

-(void)_setupTabBar
{
    UITabBarView *tabBarView = [[UITabBarView alloc] init];
    tabBarView.delegate  = self;
    tabBarView.frame = self.tabBar.bounds;
//    NSLog(@"frame=%@,safe=%f",NSStringFromCGRect(tabBarView.frame),SAFE_BOTTOM);
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
        NSItemChildVCInfo *childVCInfo = [self.itemChildVCInfo objectForKey:@(to)];
        NSInteger childVCIndex = childVCInfo.childVCIndex;
        if (childVCInfo && childVCIndex >= 0 && childVCIndex < self.childViewControllers.count) {
//            NSLog(@"to=%ld,childVCIndex=%ld",to,childVCIndex);
            self.selectedIndex = childVCIndex;
        }
    }
    return shouldSelect;
}

-(void)tabBarView:(UITabBarView *)tabBarView doubleClickAtIndex:(NSInteger)index
{
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarController:doubleClickAtIndex:)]) {
        [self.tabBarDelegate tabBarController:self doubleClickAtIndex:index];
    }
}

#pragma mark end

-(void)doSelectTo:(NSInteger)toIndex
{
    [self.tabBarView doSelectTo:toIndex];
}

-(void)_addChildVC:(UIViewController*)viewController atItemIndex:(NSInteger)itemIndex
{
    NSItemChildVCInfo *itemChildVCInfo = [[NSItemChildVCInfo alloc] initWithItemIndex:itemIndex childVC:viewController];
    [self.itemChildVCInfo setObject:itemChildVCInfo forKey:@(itemIndex)];
    if (viewController == nil) {
        return;
    }
    [self addChildViewController:viewController];
    itemChildVCInfo.childVCIndex = self.viewControllers.count - 1;
}

-(NSInteger)_getChildVCIndexAtItemIndex:(NSInteger)itemIndex
{
    NSItemChildVCInfo *childVCInfo = [self.itemChildVCInfo objectForKey:@(itemIndex)];
    if (childVCInfo.childVC) {
        return childVCInfo.childVCIndex;
    }
    return -1;
}

-(void)_updateChildVC:(UIViewController*)viewController atItemIndex:(NSInteger)itemIndex
{
    NSItemChildVCInfo *childVCInfo = [self.itemChildVCInfo objectForKey:@(itemIndex)];
    if (childVCInfo == nil) {
        return;
    }
    NSInteger findIndex = -1;
    NSMutableArray *VCS = [self.viewControllers mutableCopy];
    if (childVCInfo.childVC) {
        //重新再来求一遍childVCIndex
        findIndex = [self.viewControllers indexOfObject:childVCInfo.childVC];
    }
    else {
        __block NSInteger findIndex = -1;
        [self.itemChildVCInfo enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSItemChildVCInfo * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key integerValue] < itemIndex) {
                findIndex = MAX(findIndex, obj.childVCIndex);
            }
        }];
        findIndex += 1;
        if (findIndex < 0 || findIndex >= VCS.count) {
            [self.itemChildVCInfo removeObjectForKey:@(itemIndex)];
            return;
        }
    }
    if (viewController) {
        VCS[findIndex] = viewController;
    }
    else {
        [VCS removeObjectAtIndex:findIndex];
        findIndex = -1;
    }
    self.viewControllers = VCS;
    childVCInfo.childVCIndex = findIndex;
    childVCInfo.childVC = viewController;
}

-(void)_removeChildVCAtItemIndex:(NSInteger)itemIndex
{
    NSItemChildVCInfo *childVCInfo = [self.itemChildVCInfo objectForKey:@(itemIndex)];
    if (!childVCInfo) {
        return;
    }
    NSMutableArray *VCS = [self.viewControllers mutableCopy];
    UIViewController *childVC = childVCInfo.childVC;
    childVC.title = nil;
    childVC.tabBarItem.title = nil;
    childVC.tabBarItem.image = nil;
    childVC.tabBarItem.selectedImage = nil;
    [VCS removeObject:childVC];
    self.viewControllers= VCS;
    [self.itemChildVCInfo removeObjectForKey:@(itemIndex)];
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
    [self _addChildVC:nav atItemIndex:index];
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
        NSInteger itemIndex = [self.tabBarView currentIndex];
        [self _addChildVC:nav atItemIndex:itemIndex];
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
    self.itemChildVCInfo = nil;
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
    [self _updateChildVC:nav atItemIndex:index];
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
        [self _updateChildVC:nav atItemIndex:index];
    }
    else {
        [self _removeChildVCAtItemIndex:index];
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
    self.tabBarView.frame = self.tabBar.bounds;
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
