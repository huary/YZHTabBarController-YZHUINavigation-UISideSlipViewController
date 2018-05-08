//
//  UINavigationItemView.h
//  BaseDefaultUINavigationController
//
//  Created by captain on 16/11/10.
//  Copyright (c) 2016年 yzh. All rights reserved.

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSAttributedStringKey const NSTitleAttributesTextName;

@interface UINavigationItemView : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) CGAffineTransform t;

@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;

-(void)setLeftButtonItems:(NSArray*)leftButtonItems isReset:(BOOL)reset;
-(void)setRightButtonItems:(NSArray *)rightButtonItems isReset:(BOOL)reset;
@end
