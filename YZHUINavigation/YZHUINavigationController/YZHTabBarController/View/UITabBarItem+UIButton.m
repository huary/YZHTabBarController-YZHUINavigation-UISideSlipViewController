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
    objc_setAssociatedObject(self, @selector(buttonType), @(buttonStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSButtonImageTitleStyle)buttonStyle
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
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

//-(void)setTitleTextFont:(UIFont *)titleTextFont
//{
//    objc_setAssociatedObject(self, @selector(titleTextFont), titleTextFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(UIFont*)titleTextFont
//{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//-(void)setTitleNormalColor:(UIColor *)titleNormalColor
//{
//    objc_setAssociatedObject(self, @selector(titleNormalColor), titleNormalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(UIColor*)titleNormalColor
//{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//-(void)setTitleSelectedColor:(UIColor *)titleSelectedColor
//{
//    objc_setAssociatedObject(self, @selector(titleSelectedColor), titleSelectedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(UIColor*)titleSelectedColor
//{
//    return objc_getAssociatedObject(self, _cmd);
//}

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
