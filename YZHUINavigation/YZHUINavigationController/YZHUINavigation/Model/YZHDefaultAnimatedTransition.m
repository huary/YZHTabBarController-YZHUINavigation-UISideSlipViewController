//
//  YZHDefaultAnimatedTransition.m
//  BaseDefaultUINavigationController
//
//  Created by captain on 16/11/10.
//  Copyright © 2016年 yzh. All rights reserved.
//

#import "YZHDefaultAnimatedTransition.h"
#import "UIViewController+NavigationBarAndItemView.h"
#import "YZHTabBarController.h"

static const CGFloat navigationItemViewAlphaPushChangeDurationWithTotalDurationRatio = 0.5;//0.2;
static const CGFloat navigationItemViewAlphaPopChangeDurationWithTotalDurationRatio = 0.5;//0.3;

@implementation YZHDefaultAnimatedTransition

-(void)printView:(UIView*)view withIndex:(NSInteger)index
{
    NSString *format = @"";
    for (int i = 0; i < index; ++i) {
        format = [NSString stringWithFormat:@"%@-",format];
    }
    NSLog(@"%@view=%@",format,view);
    for (UIView *subView in view.subviews) {
        [self printView:subView withIndex:index+1];
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    CGFloat duration = [self transitionDuration:transitionContext];
    
    CGFloat toViewTransitionX = CGRectGetWidth(containerView.bounds);
    CGFloat fromViewTransitionX = toViewTransitionX/3;
    
    UIColor *fromColor = [fromVC navigationBarViewBGColor];
    UIColor *toColor = [toVC navigationBarViewBGColor];
    
    CGFloat fromAlpha = [fromVC navigationItemViewAlpha];
    CGFloat toAlpha = [toVC navigationItemViewAlpha];
    
    UIColor *shadowColor = BLACK_COLOR;
    CGSize shadowOffset = CGSizeMake(-5, 0);
    CGFloat shadowOpacity = 0.4;
    CGFloat shadowRadius = 5;
    
    [containerView addSubview:toVC.view];
    if (self.operation == UINavigationControllerOperationPush) {
        toVC.view.layer.shadowColor = shadowColor.CGColor;
        toVC.view.layer.shadowOffset = shadowOffset;
        toVC.view.layer.shadowOpacity = shadowOpacity;
        toVC.view.layer.shadowRadius = shadowRadius;
        
        self.navigationController.view.userInteractionEnabled = NO;

        //1.指定最上面的NavigationItem
        [self.navigationController addNewNavigationItemViewForViewController:toVC];
        
        //2.设置NavigationBar的颜色
        self.navigationController.navigationBarViewBackgroundColor = fromColor;

        //3.指定不同ViewController上面NavigationItem的alpha值
        //根据VC属性navigationItemViewAlpha上面的alpha设置ItemView的alpha
        [self.navigationController setNavigationItemViewAlpha:fromAlpha minToHidden:NO forViewController:fromVC];
        //直接把需要push的itemView上面的alpha设置为0
        [self.navigationController setNavigationItemViewAlpha:0 minToHidden:NO forViewController:toVC];
        
        //4.指定不同ItemView的transform
        [self.navigationController setNavigationItemViewTransform:CGAffineTransformMakeTranslation(fromViewTransitionX, 0) forViewController:toVC];
        [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:fromVC];

        //5.设置ViewController上面View的transform
        toVC.view.transform = CGAffineTransformMakeTranslation(toViewTransitionX, 0);
        fromVC.view.transform = CGAffineTransformIdentity;

        if (self.navigationController.viewControllers.count == 2 && fromVC.tabBarController) {
            UITabBar *tabBar = fromVC.tabBarController.tabBar;
            if ([fromVC.tabBarController isKindOfClass:[YZHTabBarController class]]) {
                YZHTabBarController *tabBarVC = (YZHTabBarController*)fromVC.tabBarController;
                UIView *customView = [tabBarVC customTarBarView];
                [customView removeFromSuperview];
                CGRect frame = customView.frame;
                frame.origin = CGPointMake(0, fromVC.view.bounds.size.height -tabBar.bounds.size.height);
                customView.frame = frame;
                [fromVC.view addSubview:customView];
                tabBar.hidden = YES;
            }
        }
        
        [containerView bringSubviewToFront:toVC.view];
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             //1.变化NavigationBar上面的颜色
                             self.navigationController.navigationBarViewBackgroundColor = toColor;
                             
                             //2.变化不同ItemView的transform
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformMakeTranslation(-fromViewTransitionX, 0) forViewController:fromVC];
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:toVC];
                             
                             //3.变化ViewController上View的transform
                             toVC.view.transform = CGAffineTransformIdentity;
                             fromVC.view.transform = CGAffineTransformMakeTranslation(-fromViewTransitionX, 0);
                         }
                         completion:^(BOOL finished) {
                             self.navigationController.view.userInteractionEnabled = YES;

                             //1.指定变化完成后的NavigationItemView的Transform
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:fromVC];
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:toVC];
                             
                             //2.指定ViewController的View的transform
                             fromVC.view.transform = CGAffineTransformIdentity;
                             toVC.view.transform = CGAffineTransformIdentity;
                             
                             //3.检查是否完成push还是取消
                             BOOL canceled = [transitionContext transitionWasCancelled];
                             [transitionContext completeTransition:!canceled];
                             if (canceled) {
                                 //取消
                                 //1.移除添加的NavigationItem
                                 [self.navigationController removeNavigationItemViewForViewController:toVC];
                                 
                                 //2.还原navigationBar上面的颜色
                                 self.navigationController.navigationBarViewBackgroundColor = fromColor;

                                 if (fromVC.tabBarController) {
                                     UITabBar *tabBar = fromVC.tabBarController.tabBar;
                                     if ([fromVC.tabBarController isKindOfClass:[YZHTabBarController class]]) {
                                         YZHTabBarController *tabBarVC = (YZHTabBarController*)fromVC.tabBarController;
                                         UIView *customView = [tabBarVC customTarBarView];
                                         CGRect frame = customView.frame;
                                         frame.origin = CGPointMake(0, 0);
                                         customView.frame = frame;
                                         [tabBar addSubview:customView];
                                         tabBar.hidden = NO;
                                     }
                                     
                                 }
                             }
                         }];
        
        CGFloat diff = duration * navigationItemViewAlphaPushChangeDurationWithTotalDurationRatio;
        [UIView animateWithDuration:diff delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.navigationController setNavigationItemViewAlpha:0 minToHidden:NO forViewController:fromVC];
        } completion:^(BOOL finished) {
            BOOL canceled = [transitionContext transitionWasCancelled];
            if (canceled) {
                [self.navigationController removeNavigationItemViewForViewController:toVC];
                [self.navigationController setNavigationItemViewAlpha:fromAlpha minToHidden:NO forViewController:fromVC];
            }
        }];

        [UIView animateWithDuration:duration-diff delay:diff options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.navigationController setNavigationItemViewAlpha:toAlpha minToHidden:NO forViewController:toVC];
        } completion:^(BOOL finished) {
            BOOL canceled = [transitionContext transitionWasCancelled];
            if (canceled) {
                [self.navigationController removeNavigationItemViewForViewController:toVC];
                [self.navigationController setNavigationItemViewAlpha:fromAlpha minToHidden:NO forViewController:fromVC];
            }
        }];
    }
    else
    {
        fromVC.view.layer.shadowColor = shadowColor.CGColor;
        fromVC.view.layer.shadowOffset = shadowOffset;
        fromVC.view.layer.shadowOpacity = shadowOpacity;
        fromVC.view.layer.shadowRadius = shadowRadius;
        
        self.navigationController.view.userInteractionEnabled = NO;

        if (self.navigationController.viewControllers.count == 1 && fromVC.tabBarController) {
            UITabBar *tabBar = fromVC.tabBarController.tabBar;
            
            if ([fromVC.tabBarController isKindOfClass:[YZHTabBarController class]]) {
                YZHTabBarController *tabBarVC = (YZHTabBarController*)fromVC.tabBarController;
                UIView *customView = [tabBarVC customTarBarView];
                [customView removeFromSuperview];
                CGRect frame = customView.frame;
                
                CGFloat h = tabBar.bounds.size.height;
                CGFloat x = 0;
                CGFloat y = toVC.view.bounds.size.height - h;
                CGFloat w = tabBar.bounds.size.width;
                frame = CGRectMake(x, y, w, h);
                customView.frame = frame;
                [toVC.view addSubview:customView];
                tabBar.hidden = YES;
            }
        }
        
        [containerView bringSubviewToFront:fromVC.view];
        
        //1.设置NavigationBar的颜色
        self.navigationController.navigationBarViewBackgroundColor = fromColor;

        //2.指定不同ViewController上面NavigationItem的alpha值
        //根据VC属性navigationItemViewAlpha上面的alpha设置ItemView的alpha
        [self.navigationController setNavigationItemViewAlpha:fromAlpha minToHidden:NO forViewController:fromVC];
        [self.navigationController setNavigationItemViewAlpha:0 minToHidden:NO forViewController:toVC];
        
        //3.指定不同ItemView的transform
        [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:fromVC];
        [self.navigationController setNavigationItemViewTransform:CGAffineTransformMakeTranslation(-fromViewTransitionX, 0) forViewController:toVC];

        //4.指定不同ItemView的transform
        toVC.view.transform = CGAffineTransformMakeTranslation(-fromViewTransitionX, 0);
        fromVC.view.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             //1.变化NavigationBar上面的颜色
                             self.navigationController.navigationBarViewBackgroundColor = toColor;
                             
                             //3.变化不同ItemView的transform
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformMakeTranslation(fromViewTransitionX, 0) forViewController:fromVC];
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:toVC];
                             
                             //4.变化ViewController上View的transform
                             toVC.view.transform = CGAffineTransformIdentity;
                             fromVC.view.transform = CGAffineTransformMakeTranslation(toViewTransitionX, 0);
                         }
                         completion:^(BOOL finished) {
                             self.navigationController.view.userInteractionEnabled = YES;
                             
                             //1.指定变化完成后的NavigationItemView的Transform
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:fromVC];
                             [self.navigationController setNavigationItemViewTransform:CGAffineTransformIdentity forViewController:toVC];
                             
                             //2.指定ViewController的View的transform
                             fromVC.view.transform = CGAffineTransformIdentity;
                             toVC.view.transform = CGAffineTransformIdentity;

                             //3.检查是否完成pop还是取消
                             BOOL canceled = [transitionContext transitionWasCancelled];
                             [transitionContext completeTransition:!canceled];
                             if (canceled) {
                                 //取消
                                 //1.还原navigationBar上面的颜色
                                 self.navigationController.navigationBarViewBackgroundColor = fromColor;
                             }
                             else
                             {
                                 //完成
                                 [self.navigationController removeNavigationItemViewForViewController:fromVC];
                                 
                                 if (self.navigationController.viewControllers.count == 1 && toVC.tabBarController) {
                                     UITabBar *tabBar = toVC.tabBarController.tabBar;
                                     if ([toVC.tabBarController isKindOfClass:[YZHTabBarController class]]) {
                                         YZHTabBarController *tabBarVC = (YZHTabBarController*)toVC.tabBarController;
                                         UIView *customView = [tabBarVC customTarBarView];
                                         [customView removeFromSuperview];
                                         CGRect frame = customView.frame;
                                         frame = CGRectMake(0, 0, tabBar.bounds.size.width, tabBar.bounds.size.height);
                                         customView.frame = frame;
                                         [tabBar addSubview:customView];
                                         tabBar.hidden = NO;
                                     }
                                 }
                             }
                         }];
        
        CGFloat diff = duration * navigationItemViewAlphaPopChangeDurationWithTotalDurationRatio;
        [UIView animateWithDuration:diff delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.navigationController setNavigationItemViewAlpha:0 minToHidden:NO forViewController:fromVC];
        } completion:^(BOOL finished) {
            BOOL canceled = [transitionContext transitionWasCancelled];
            if (canceled) {
                [self.navigationController setNavigationItemViewAlpha:fromAlpha minToHidden:NO forViewController:fromVC];
                [self.navigationController setNavigationItemViewAlpha:0 minToHidden:NO forViewController:toVC];
            }
        }];
        
        [UIView animateWithDuration:duration-diff delay:diff options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.navigationController setNavigationItemViewAlpha:toAlpha minToHidden:NO forViewController:toVC];
        } completion:^(BOOL finished) {
            BOOL canceled = [transitionContext transitionWasCancelled];
            if (canceled) {
                [self.navigationController setNavigationItemViewAlpha:fromAlpha minToHidden:NO forViewController:fromVC];
                [self.navigationController setNavigationItemViewAlpha:0 minToHidden:NO forViewController:toVC];
            }
        }];
    }
}

@end
