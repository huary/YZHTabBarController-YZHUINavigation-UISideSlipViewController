//
//  UITabBarItem+UIButton.m
//  jszs
//
//  Created by yuan on 2018/3/2.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "UITabBarItem+UIButton.h"
#import <objc/runtime.h>

@implementation UITabBarItem (UIButton)

//@property (nonatomic, assign) NSButtonImageTitleStyle buttonStyle;
//
//@property (nonatomic, assign) CGSize buttonItemSize;
//
//@property (nonatomic, assign) CGFloat imageViewStartRatio;
//@property (nonatomic, assign) CGFloat imageViewOffsetRatio;
//
//@property (nonatomic, assign) CGFloat titleLabelStartRatio;
//@property (nonatomic, assign) CGFloat titleLabelOffsetRatio;

-(void)setButtonStyle:(NSButtonImageTitleStyle)buttonStyle
{
    objc_setAssociatedObject(self, @selector(buttonStyle), @(buttonStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSButtonImageTitleStyle)buttonStyle
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

-(void)setButtonItemOrigin:(CGPoint)buttonItemOrigin
{
    objc_setAssociatedObject(self, @selector(buttonItemOrigin), [NSValue valueWithCGPoint:buttonItemOrigin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGPoint)buttonItemOrigin
{
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

-(void)setButtonItemSize:(CGSize)buttonItemSize
{
    objc_setAssociatedObject(self, @selector(buttonItemSize), [NSValue valueWithCGSize:buttonItemSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGSize)buttonItemSize
{
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

-(void)setImageRange:(CGRange)imageRange
{
    NSValue *value = [NSValue valueWithBytes:&imageRange objCType:@encode(CGRange)];
    objc_setAssociatedObject(self, @selector(imageRange), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRange)imageRange
{
    CGRange r = CGRangeMake(0, 0);
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if (SYSTEMVERSION_NUMBER < 11.0) {
        [value getValue:&r];
    }
    else {
        [value getValue:&r size:sizeof(r)];
    }
    return r;
}

-(void)setTitleRange:(CGRange)titleRange
{
    NSValue *value = [NSValue valueWithBytes:&titleRange objCType:@encode(CGRange)];
    objc_setAssociatedObject(self, @selector(titleRange), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRange)titleRange
{
    CGRange r = CGRangeMake(0, 0);
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if (SYSTEMVERSION_NUMBER < 11.0) {
        [value getValue:&r];
    }
    else {
        [value getValue:&r size:sizeof(r)];
    }
    return r;
}

-(void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    objc_setAssociatedObject(self, @selector(normalBackgroundColor), normalBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor*)normalBackgroundColor
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    objc_setAssociatedObject(self, @selector(selectedBackgroundColor), selectedBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor*)selectedBackgroundColor
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    objc_setAssociatedObject(self, @selector(highlightedBackgroundColor), highlightedBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor*)highlightedBackgroundColor
{
    return objc_getAssociatedObject(self, _cmd);
}


@end
