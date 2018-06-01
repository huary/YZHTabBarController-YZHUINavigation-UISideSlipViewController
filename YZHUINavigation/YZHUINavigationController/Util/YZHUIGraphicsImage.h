//
//  YZHUIGraphicsImage.h
//  YZHUIAlertViewDemo
//
//  Created by yuan on 2018/5/18.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NSGraphicsImageAlignment)
{
    NSGraphicsImageAlignmentLeft        = 0,
    NSGraphicsImageAlignmentCenter      = 1,
    NSGraphicsImageAlignmentRight       = 2,
};

@class YZHUIGraphicsImageContext;

//这个是可以addpath的block
typedef void(^UIGraphicsImageRunBlock)(YZHUIGraphicsImageContext *context);
//这个是通过beginblock获取YZHUIGraphicsImageBeginInfo中的需要的信息
typedef void(^UIGraphicsImageBeginBlock)(YZHUIGraphicsImageContext *context);
//这个如strokepath，fillpath所需要的操作。
typedef void(^UIGraphicsImageEndPathBlock)(YZHUIGraphicsImageContext *context);
//这个UIGraphicsEndImageContext后返回image的操作
typedef void(^UIGraphicsImageCompletionBlock)(YZHUIGraphicsImageContext *context, UIImage *image);


@interface YZHUIGraphicsImageBeginInfo : NSObject

@property (nonatomic, assign) BOOL opaque;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGSize graphicsSize;
@property (nonatomic, assign) CGFloat lineWidth;

-(instancetype)initWithGraphicsSize:(CGSize)graphicsSize opaque:(BOOL)opaque scale:(CGFloat)scale lineWidth:(CGFloat)lineWidth;

@end

@interface YZHUIGraphicsImageContext : NSObject

//这个ctx只会在graphicsBeginBlock后面才会有值的情况
@property (nonatomic, assign) CGContextRef ctx;
//默认为left
@property (nonatomic, assign) NSGraphicsImageAlignment imageAlignment;
/*
 *beginInfo就是开始UIGraphicsBeginImageContextWithOptions所需要的信息和笔画粗细，
 *可以UIGraphicsImageBeginBlock中再来设置，也可以初始化的时候设置好
 */
@property (nonatomic, strong) YZHUIGraphicsImageBeginInfo *beginInfo;


@property (nonatomic, copy) UIGraphicsImageRunBlock graphicsRunBlock;
@property (nonatomic, copy) UIGraphicsImageBeginBlock graphicsBeginBlock;
@property (nonatomic, copy) UIGraphicsImageEndPathBlock graphicsEndPathBlock;
@property (nonatomic, copy) UIGraphicsImageCompletionBlock graphicsCompletionBlock;

-(instancetype)initWithBeginBlock:(UIGraphicsImageBeginBlock)beginBlock runBlock:(UIGraphicsImageRunBlock)runBlock endPathBlock:(UIGraphicsImageEndPathBlock)endPathBlock;

-(instancetype)initWithBeginBlock:(UIGraphicsImageBeginBlock)beginBlock runBlock:(UIGraphicsImageRunBlock)runBlock endPathBlock:(UIGraphicsImageEndPathBlock)endPathBlock completionBlock:(UIGraphicsImageCompletionBlock)completionBlock;

-(UIImage*)createGraphicesImageWithStrokeColor:(UIColor*)strokeColor;
@end
