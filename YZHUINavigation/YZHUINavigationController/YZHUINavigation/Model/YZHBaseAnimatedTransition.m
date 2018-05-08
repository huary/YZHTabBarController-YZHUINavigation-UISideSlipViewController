//
//  YZHBaseAnimatedTransition.m
//  BaseDefaultUINavigationController
//
//  Created by captain on 16/11/10.
//  Copyright © 2016年 yzh. All rights reserved.
//

#import "YZHBaseAnimatedTransition.h"
#import "YZHDefaultAnimatedTransition.h"

@implementation YZHBaseAnimatedTransition

-(instancetype)initWithNavigation:(UINavigationController*)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation
{
    if (self = [super init]) {
        self.operation = operation;
        self.navigationController = (YZHUINavigationController*)navigationController;
    }
    return self;
}

+(instancetype)navigationController:(UINavigationController*)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation animatedTransitionStyle:(YZHNavigationAnimatedTransitionStyle)transitionStyle
{
    if (transitionStyle == YZHNavigationAnimatedTransitionStyleDefault) {
        return [[YZHDefaultAnimatedTransition alloc] initWithNavigation:navigationController animationControllerForOperation:operation];
    }
    return nil;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [NSException raise:@"YZHBaseAnimatedTransitionException" format:@"Sub class must override this method at %s %d",__FILE__,__LINE__];
    return 0.0;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [NSException raise:@"YZHBaseAnimatedTransitionException" format:@"Sub class must override this method at %s %d",__FILE__,__LINE__];
}

@end
