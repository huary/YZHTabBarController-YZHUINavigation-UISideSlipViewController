//
//  YZHUIGraphicsImage.m
//  YZHUIAlertViewDemo
//
//  Created by yuan on 2018/5/18.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "YZHUIGraphicsImage.h"

@implementation YZHUIGraphicsImageBeginInfo

-(instancetype)initWithGraphicsSize:(CGSize)graphicsSize opaque:(BOOL)opaque scale:(CGFloat)scale lineWidth:(CGFloat)lineWidth
{
    self = [super init];
    if (self) {
        self.scale = scale;
        self.opaque = opaque;
        self.lineWidth = lineWidth;
        self.graphicsSize = graphicsSize;
    }
    return self;
}

@end

@implementation YZHUIGraphicsImageContext

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.imageAlignment = NSGraphicsImageAlignmentLeft;
        self.ctx = NULL;
    }
    return self;
}

-(instancetype)initWithBeginBlock:(UIGraphicsImageBeginBlock)beginBlock runBlock:(UIGraphicsImageRunBlock)runBlock endPathBlock:(UIGraphicsImageEndPathBlock)endPathBlock
{
    self = [self init];
    if (self) {
        self.graphicsBeginBlock = beginBlock;
        self.graphicsRunBlock = runBlock;
        self.graphicsEndPathBlock = endPathBlock;
    }
    return self;
}

-(instancetype)initWithBeginBlock:(UIGraphicsImageBeginBlock)beginBlock runBlock:(UIGraphicsImageRunBlock)runBlock endPathBlock:(UIGraphicsImageEndPathBlock)endPathBlock completionBlock:(UIGraphicsImageCompletionBlock)completionBlock
{
    self = [self  initWithBeginBlock:beginBlock runBlock:runBlock endPathBlock:endPathBlock];
    if (self) {
        self.graphicsCompletionBlock = completionBlock;
    }
    return self;
}

-(UIImage*)createGraphicesImageWithStrokeColor:(UIColor*)strokeColor
{
    BOOL opaque = NO;
    CGFloat scale = 0;
    CGFloat lineWidth = 0.0;
    CGSize size = CGSizeZero;
    if (self.graphicsBeginBlock) {
        self.graphicsBeginBlock(self);
        YZHUIGraphicsImageBeginInfo *beginInfo = self.beginInfo;
        if (beginInfo) {
            scale = beginInfo.scale;
            opaque = beginInfo.opaque;
            lineWidth = beginInfo.lineWidth;
            if (beginInfo.graphicsSize.width > 0 && beginInfo.graphicsSize.height > 0) {
                size = beginInfo.graphicsSize;
            }
            else {
                beginInfo.graphicsSize = size;
            }
        }
        else {
            beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] initWithGraphicsSize:size opaque:opaque scale:scale lineWidth:lineWidth];
            self.beginInfo = beginInfo;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, lineWidth);
    if (strokeColor) {
        CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
    }
    
    self.ctx = ctx;
    if (self.graphicsRunBlock) {
        self.graphicsRunBlock(self);
    }
    
    CGContextStrokePath(ctx);
    
    if (self.graphicsEndPathBlock) {
        self.graphicsEndPathBlock(self);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (self.graphicsCompletionBlock) {
        self.graphicsCompletionBlock(self, image);
    }
    return image;
}

+(UIImage*)createCrossImageWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor transform:(CGAffineTransform)transform
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.lineWidth = lineWidth;
        context.beginInfo.graphicsSize = size;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        if (backgroundColor) {
            CGContextSetFillColorWithColor(context.ctx, backgroundColor.CGColor);
            CGContextFillRect(context.ctx, CGRectMake(0, 0, size.width, size.height));
        }
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(size.width/2, 0)];
        [path addLineToPoint:CGPointMake(size.width/2, size.height)];
        
        [path moveToPoint:CGPointMake(0, size.height/2)];
        [path addLineToPoint:CGPointMake(size.width, size.height/2)];
        
        [path applyTransform:transform];
        
        CGContextAddPath(context.ctx, path.CGPath);
        CGContextDrawPath(context.ctx, kCGPathStroke);
        
    } endPathBlock:nil];
    return [ctx createGraphicesImageWithStrokeColor:strokeColor];
}


//创建关闭的符号：x
+(UIImage*)createCrossImageWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    CGFloat s = sqrt(2);
    
    CGAffineTransform tr = CGAffineTransformMakeRotation(M_PI_4);
    CGAffineTransform ts = CGAffineTransformMakeScale(s, s);
    CGAffineTransform tt = CGAffineTransformMakeTranslation(size.width/2, -size.height/2);
    CGAffineTransform  transform = CGAffineTransformConcat(tr, ts);
    transform = CGAffineTransformConcat(transform, tt);
    return [YZHUIGraphicsImageContext createCrossImageWithSize:size lineWidth:lineWidth backgroundColor:backgroundColor strokeColor:strokeColor transform:transform];
    
//    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
//        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
//        context.beginInfo.lineWidth = lineWidth;
//        context.beginInfo.graphicsSize = size;
//    } runBlock:^(YZHUIGraphicsImageContext *context) {
//        if (backgroundColor) {
//            CGContextSetFillColorWithColor(context.ctx, backgroundColor.CGColor);
//            CGContextFillRect(context.ctx, CGRectMake(0, 0, size.width, size.height));
//        }
//        CGContextMoveToPoint(context.ctx, 0, 0);
//        CGContextAddLineToPoint(context.ctx, size.width, size.height);
//        CGContextMoveToPoint(context.ctx, size.width, 0);
//        CGContextAddLineToPoint(context.ctx, 0, size.height);
//    } endPathBlock:nil];
//    return [ctx createGraphicesImageWithStrokeColor:strokeColor];
}

//创建返回的符号：<
+(UIImage*)createBackImageWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.lineWidth = lineWidth;
        context.beginInfo.graphicsSize = size;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        if (backgroundColor) {
            CGContextSetFillColorWithColor(context.ctx, backgroundColor.CGColor);
            CGContextFillRect(context.ctx, CGRectMake(0, 0, size.width, size.height));
        }
        CGFloat width = context.beginInfo.graphicsSize.width;
        CGFloat height = context.beginInfo.graphicsSize.height;
        NSLog(@"width=%f,height=%f",width,height);
        CGFloat lineWidth = context.beginInfo.lineWidth;
        CGContextMoveToPoint(context.ctx, width - lineWidth/2, lineWidth/2);
        CGContextAddLineToPoint(context.ctx, lineWidth/2, height/2);
        CGContextAddLineToPoint(context.ctx, width - lineWidth/2, height - lineWidth/2);
    } endPathBlock:nil];
    return [ctx createGraphicesImageWithStrokeColor:strokeColor];
}

//创建前进的符号：>
+(UIImage*)createForwardImageWithSize:(CGSize)size lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.lineWidth = lineWidth;
        context.beginInfo.graphicsSize = size;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        CGFloat width = context.beginInfo.graphicsSize.width;
        CGFloat height = context.beginInfo.graphicsSize.height;
        if (backgroundColor) {
            CGContextSetFillColorWithColor(context.ctx, backgroundColor.CGColor);
            CGContextFillRect(context.ctx, CGRectMake(0, 0, width, height));
        }
        NSLog(@"width=%f,height=%f",width,height);
        CGFloat lineWidth = context.beginInfo.lineWidth;
        CGContextMoveToPoint(context.ctx, lineWidth/2, lineWidth/2);
        CGContextAddLineToPoint(context.ctx, width - lineWidth/2, height/2);
        CGContextAddLineToPoint(context.ctx, lineWidth/2, height - lineWidth/2);
    } endPathBlock:nil];
    return [ctx createGraphicesImageWithStrokeColor:strokeColor];
}

+(UIImage*)_createArrowImageWithType:(NSArrowPointingType)type size:(CGSize)size basePointShitPoint:(CGPoint)basePointShift topPointShift:(CGFloat)topPointShift lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    CGFloat basePointHShift = basePointShift.x;
    CGFloat basePointVShift = basePointShift.y;
    
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.lineWidth = lineWidth;
        context.beginInfo.graphicsSize = size;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        CGFloat width = context.beginInfo.graphicsSize.width;
        CGFloat height = context.beginInfo.graphicsSize.height;
        if (backgroundColor) {
            CGContextSetFillColorWithColor(context.ctx, backgroundColor.CGColor);
            CGContextFillRect(context.ctx, CGRectMake(0, 0, width, height));
        }
        if (type == NSArrowPointingTypeUp) {
            CGContextMoveToPoint(context.ctx, basePointHShift, height - basePointVShift);
            CGContextAddLineToPoint(context.ctx, width/2, topPointShift);
            CGContextAddLineToPoint(context.ctx, width - basePointHShift, height - basePointVShift);
        }
        else if (type == NSArrowPointingTypeLeft) {
            CGContextMoveToPoint(context.ctx, width - basePointVShift, basePointHShift);
            CGContextAddLineToPoint(context.ctx, topPointShift, height/2);
            CGContextAddLineToPoint(context.ctx, width - basePointVShift, height - basePointHShift);
        }
        else if (type == NSArrowPointingTypeDown) {
            CGContextMoveToPoint(context.ctx, basePointHShift, basePointVShift);
            CGContextAddLineToPoint(context.ctx, width/2, height - topPointShift);
            CGContextAddLineToPoint(context.ctx, width - basePointHShift, basePointVShift);
        }
        else if (type == NSArrowPointingTypeRight) {
            CGContextMoveToPoint(context.ctx, basePointVShift, basePointHShift);
            CGContextAddLineToPoint(context.ctx, width - topPointShift, height/2);
            CGContextAddLineToPoint(context.ctx, basePointVShift, height - basePointHShift);
        }
    } endPathBlock:nil];
    return [ctx createGraphicesImageWithStrokeColor:strokeColor];
}

/*
 *创建的符号：< > v ^这样一个等腰三角形的两边
 *arrowAngle为顶角大小
 *baseWidth为底边的宽度
 */
+(UIImage*)createArrowImageWithType:(NSArrowPointingType)type arrowAngle:(CGFloat)angle baseWidth:(CGFloat)baseWidth lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor
{
    if (type < NSArrowPointingTypeUp || type > NSArrowPointingTypeRight || angle >= M_PI || angle == 0) {
        return nil;
    }
    
    CGFloat halfArrowAngle = angle/2;
    
    CGFloat baseHeight = baseWidth/(2 * tan(halfArrowAngle));
    
    CGFloat basePointHShift = lineWidth * cos(halfArrowAngle)/2;
    CGFloat basePointVShift = lineWidth * sin(halfArrowAngle)/2;
    CGFloat topPointVShift = lineWidth / (2 * sin(halfArrowAngle));
    
    CGFloat w = baseWidth;
    CGFloat h = baseHeight + topPointVShift;
    
    CGSize size = CGSizeZero;
    if (type == NSArrowPointingTypeUp || type == NSArrowPointingTypeDown) {
        size = CGSizeMake(w, h);
    }
    else if (type == NSArrowPointingTypeLeft || type == NSArrowPointingTypeRight) {
        size = CGSizeMake(h, w);
    }
    
    return [YZHUIGraphicsImageContext _createArrowImageWithType:type size:size basePointShitPoint:CGPointMake(basePointHShift, basePointVShift) topPointShift:topPointVShift lineWidth:lineWidth backgroundColor:backgroundColor strokeColor:strokeColor];
}

/*创建的符号：< > v ^这样一个等腰三角形的两边
 *arrowAngle为顶角大小
 *baseHeight底边上的高
 */
+(UIImage*)createArrowImageWithType:(NSArrowPointingType)type arrowAngle:(CGFloat)angle baseHeight:(CGFloat)baseHeight lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor
{
    if (type < NSArrowPointingTypeUp || type > NSArrowPointingTypeRight || angle >= M_PI || angle == 0) {
        return nil;
    }
    
    CGFloat halfArrowAngle = angle/2;
    CGFloat baseWidth = 2 * baseHeight * tan(halfArrowAngle);
    return [YZHUIGraphicsImageContext createArrowImageWithType:type arrowAngle:angle baseWidth:baseWidth lineWidth:lineWidth backgroundColor:backgroundColor strokeColor:strokeColor];
    return nil;
}

/*
 *创建的符号：< > v ^这样一个等腰三角形的两边
 *为三角形形成的大小，这个形成三角形底边的高度要稍微大点
 */
+(UIImage*)createArrowImageWithType:(NSArrowPointingType)type size:(CGSize)size lineWidth:(CGFloat)lineWidth backgroundColor:(UIColor*)backgroundColor strokeColor:(UIColor*)strokeColor
{
    if (CGSizeEqualToSize(size, CGSizeZero) || type < NSArrowPointingTypeUp || type > NSArrowPointingTypeRight) {
        return nil;
    }
    
    CGFloat baseWidth = size.width;
    CGFloat baseHeight = size.height;
    if (type == NSArrowPointingTypeLeft || type == NSArrowPointingTypeRight) {
        baseWidth = size.height;
        baseHeight = size.width;
    }
    CGFloat atanValue = baseWidth/(2 * baseHeight);
    CGFloat arrowAngle = 2 * atan(atanValue);
    return [YZHUIGraphicsImageContext createArrowImageWithType:type arrowAngle:arrowAngle baseWidth:size.width lineWidth:lineWidth backgroundColor:backgroundColor strokeColor:strokeColor];
}

//创建带圆角的图片
+(UIImage*)createImageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor backgroundColor:(UIColor*)backgroundColor
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.lineWidth = borderWidth;
        context.beginInfo.graphicsSize = size;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        CGFloat width = context.beginInfo.graphicsSize.width;
        CGFloat height = context.beginInfo.graphicsSize.height;
        if (backgroundColor) {
            CGContextSetFillColorWithColor(context.ctx, backgroundColor.CGColor);
        }
        CGRect rect = CGRectMake(0, 0, width, height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        [path closePath];
//        [path fill];
        CGContextAddPath(context.ctx, path.CGPath);
        CGContextDrawPath(context.ctx, kCGPathFill);
        
        CGFloat minWH = MIN(width, height);
        if (borderWidth > 0 && borderColor && borderWidth < minWH) {
            rect = CGRectInset(rect, borderWidth/2, borderWidth/2);
            UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            [borderPath closePath];
            CGContextAddPath(context.ctx, borderPath.CGPath);
            CGContextDrawPath(context.ctx, kCGPathStroke);
        }
    } endPathBlock:nil];
    return [ctx createGraphicesImageWithStrokeColor:borderColor];
}


+(UIImage*)createBorderStrokeImageWithSize:(CGSize)size byRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor backgroundColor:(UIColor*)backgroundColor
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.lineWidth = borderWidth;
        context.beginInfo.graphicsSize = size;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        CGFloat width = context.beginInfo.graphicsSize.width;
        CGFloat height = context.beginInfo.graphicsSize.height;
        CGRect rect = CGRectMake(0, 0, width, height);
        if (backgroundColor) {
            CGContextSetFillColorWithColor(context.ctx, backgroundColor.CGColor);
            CGContextFillRect(context.ctx, rect);
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        [path closePath];
        CGContextAddPath(context.ctx, path.CGPath);
        CGContextDrawPath(context.ctx, kCGPathStroke);        
    } endPathBlock:nil];
    return [ctx createGraphicesImageWithStrokeColor:borderColor];
}
@end
