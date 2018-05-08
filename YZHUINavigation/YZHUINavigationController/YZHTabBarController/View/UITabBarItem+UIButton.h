//
//  UITabBarItem+UIButton.h
//  jszs
//
//  Created by yuan on 2018/3/2.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NSButtonImageTitleStyle)
{
    NSButtonImageTitleStyleVertical      = 0,
    NSButtonImageTitleStyleHorizontal    = 1,
};

struct CGRange {
    CGFloat offset;
    CGFloat length;
};
typedef struct CG_BOXABLE CGRange CGRange;

CG_INLINE CGRange
CGRangeMake(CGFloat offset, CGFloat length)
{
    CGRange R; R.offset = offset; R.length = length; return R;
}

CG_INLINE bool
CGRangeEqualToRange(CGRange r1, CGRange r2)
{
    return r1.offset == r2.offset && r1.length == r2.length;
}

CG_INLINE bool
CGRangeEqualToZero(CGRange r)
{
    return r.offset <= 0.00001 && r.length <= 0.00001;
}


@interface UITabBarItem (UIButton)

@property (nonatomic, assign) NSButtonImageTitleStyle buttonStyle;

@property (nonatomic, assign) CGSize buttonItemSize;

@property (nonatomic, assign) CGRange imageRange;
@property (nonatomic, assign) CGRange titleRange;

//@property (nonatomic, strong) UIFont *titleTextFont;
//@property (nonatomic, strong) UIColor *titleNormalColor;
//@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;


@end
