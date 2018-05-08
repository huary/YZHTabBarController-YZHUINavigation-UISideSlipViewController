//
//  YZHUIGraphicsImageModel.m
//  jszs
//
//  Created by yuan on 2018/3/22.
//  Copyright © 2018年 yuan. All rights reserved.
//

#import "YZHUIGraphicsImageModel.h"

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

@end
