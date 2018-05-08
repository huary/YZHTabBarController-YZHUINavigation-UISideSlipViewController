//
//  YZHUIViewController.m
//  YZHUINavigationController
//
//  Created by captain on 16/11/17.
//  Copyright (c) 2016年 yzh. All rights reserved.
//

#import "YZHUIViewController.h"
#import "UINavigationItemView.h"
#import "YZHUINavigationController.h"
#import "YZHUIBarButtonItem.h"
#import "UIImage+TintColor.h"

@interface YZHUIViewController ()

@property (nonatomic, strong) UINavigationBarView *navigationBarView;
@property (nonatomic, strong) UINavigationItemView *navigationItemView;

@end

@implementation YZHUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initUIData];
    
    [self _setUpNavigationBarAndItemView];
}

-(void)_initUIData
{
    _popGestureEnabled = YES;
    _navigationItemViewAlpha = 1.0;
    _navigationBarViewBackgroundColor = [[UINavigationBar appearance] barTintColor];
}

-(void)_clearOldNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)_clearOldNavigationItemLeftBarButtonItem
{
    self.navigationItem.titleView = [[UIView alloc] init];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)_clearOldNavigationItemRightBarButtonItem
{
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)_setUpNavigationBarAndItemView
{
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
        if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle)) {
            [self _clearOldNavigationItemLeftBarButtonItem];
            [navigationController createNewNavigationItemViewForViewController:self];
            _layoutTopY = 0;
        }
        else if (barAndItemStyle == UINavigationControllerBarAndItemViewControllerBarItemStyle)
        {
            CGFloat w = self.view.bounds.size.width;
                        
            CGRect frame = CGRectMake(0, 0, w, STATUS_NAV_BAR_HEIGHT);
            self.navigationBarView = [[UINavigationBarView alloc] initWithFrame:frame];
//            self.navigationBarView.frame = frame;
            [self.view addSubview:self.navigationBarView];
            
            self.navigationItemView = [[UINavigationItemView alloc] init];
            self.navigationItemView.frame = self.navigationBarView.bounds;
            self.navigationItemView.backgroundColor = CLEAR_COLOR;
            [self.navigationBarView addSubview:self.navigationItemView];
            
            _layoutTopY = CGRectGetMaxY(frame);
        }
        else if (barAndItemStyle == UINavigationControllerBarAndItemViewControllerBarWithDefaultItemStyle)
        {
            CGFloat w = self.view.bounds.size.width;
            CGRect frame = CGRectMake(0, 0, w, STATUS_NAV_BAR_HEIGHT);
            self.navigationBarView = [[UINavigationBarView alloc] initWithFrame:frame];
            [self.view addSubview:self.navigationBarView];
            _layoutTopY = CGRectGetMaxY(frame);
        }
    }
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect frame = CGRectMake(SAFE_X, -STATUS_BAR_HEIGHT, SAFE_WIDTH, STATUS_NAV_BAR_HEIGHT);
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
        if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle)) {
            [navigationController resetNavigationBarAndItemViewFrame:frame];
        }
    }
    
    if (self.navigationBarView) {
        CGFloat width = self.view.bounds.size.width;
        frame = CGRectMake(0, 0, width, STATUS_NAV_BAR_HEIGHT);
        [self.view bringSubviewToFront:self.navigationBarView];
        self.navigationBarView.frame = frame;
    }
    _layoutTopY = CGRectGetMaxY(self.navigationBarView.frame);
    if (self.title) {
        self.title = self.title;
    }
}

-(void)setNavigationBarViewBackgroundColor:(UIColor *)navigationBarViewBackgroundColor
{
    _navigationBarViewBackgroundColor = navigationBarViewBackgroundColor;
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_BAR_STYLE(navigationController.navigationControllerBarAndItemStyle)) {
            self.navigationBarView.backgroundColor = navigationBarViewBackgroundColor;
        }
        else
        {
            navigationController.navigationBarViewBackgroundColor = navigationBarViewBackgroundColor;
        }
    }
    else
    {
        self.navigationController.navigationBar.barTintColor = navigationBarViewBackgroundColor;
    }
}

-(void)setNavigationBarBottomLineColor:(UIColor *)navigationBarBottomLineColor
{
    _navigationBarBottomLineColor = navigationBarBottomLineColor;
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_BAR_STYLE(navigationController.navigationControllerBarAndItemStyle)) {
            self.navigationBarView.bottomLine.backgroundColor = navigationBarBottomLineColor;
        }
        else
        {
            navigationController.navigationBarBottomLineColor = navigationBarBottomLineColor;
        }
    }
    else
    {
        if (navigationBarBottomLineColor) {
            UIImage *image = [[UIImage new] createImageWithSize:CGSizeMake(self.navigationController.navigationBar.bounds.size.width, SINGLE_LINE_WIDTH) tintColor:navigationBarBottomLineColor];
            [self.navigationController.navigationBar setShadowImage:image];
        }
        else {
            [self.navigationController.navigationBar setShadowImage:nil];
        }
    }
}

-(void)setBarViewStyle:(UIBarViewStyle)barViewStyle
{
    _barViewStyle = barViewStyle;
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_BAR_STYLE(navigationController.navigationControllerBarAndItemStyle)) {
            self.navigationBarView.style = barViewStyle;
        }
        else
        {
            navigationController.barViewStyle = barViewStyle;
        }
    }
}

-(void)setTitle:(NSString *)title
{
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
        if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle)) {
            [navigationController setNavigationItemTitle:title forViewController:self];
        }
        else if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle))
        {
            [self.navigationItemView setTitle:title];
        }
        else
        {
            self.navigationItem.titleView = nil;
            super.title = title;
        }
    }
    else
    {
        super.title = title;
    }
//    super.title = title;
}

-(void)setNavigationBarViewAlpha:(CGFloat)navigationBarViewAlpha
{
    _navigationBarViewAlpha = navigationBarViewAlpha;
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_BAR_STYLE(navigationController.navigationControllerBarAndItemStyle)) {
            self.navigationBarView.alpha = navigationBarViewAlpha;
            if (navigationBarViewAlpha <= MIN_ALPHA_TO_HIDDEN) {
                self.navigationBarView.hidden = YES;
                _layoutTopY = 0;
            }
            else {
                self.navigationBarView.hidden = NO;
                _layoutTopY = CGRectGetMaxY(self.navigationBarView.frame);
            }
        }
        else
        {
            navigationController.navigationBarViewAlpha = navigationBarViewAlpha;
            _layoutTopY = 0;
        }
    }
    else
    {
        self.navigationController.navigationBar.alpha = navigationBarViewAlpha;
        if (navigationBarViewAlpha <= MIN_ALPHA_TO_HIDDEN) {
            self.navigationController.navigationBar.hidden = YES;
        }
        else {
            self.navigationController.navigationBar.hidden = NO;
        }
        _layoutTopY = 0;
    }
}

-(void)setNavigationItemViewAlpha:(CGFloat)navigationItemViewAlpha
{
    _navigationItemViewAlpha = navigationItemViewAlpha;
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
        if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle)) {
            [navigationController setNavigationItemViewAlpha:navigationItemViewAlpha minToHidden:YES forViewController:self];
        }
        else if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle))
        {
            self.navigationItemView.alpha = navigationItemViewAlpha;
            if (navigationItemViewAlpha <= MIN_ALPHA_TO_HIDDEN) {
                self.navigationItemView.hidden = YES;
            }
            else {
                self.navigationItemView.hidden = NO;
            }
        }
        else
        {
        }
    }
}

-(void)setTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)titleTextAttributes
{
    _titleTextAttributes = titleTextAttributes;
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
        if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle)) {
            [navigationController setNavigationItemTitleTextAttributes:titleTextAttributes forViewController:self];
        }
        else if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle))
        {
            self.navigationItemView.titleTextAttributes = titleTextAttributes;
        }
        else
        {
            
        }
    }
}

-(CGRect)_getNavigationItemFrameForImageSize:(CGSize)imageSize graphicsSize:(CGSize*)graphicsSize
{
    if (imageSize.width == 0 || imageSize.height == 0) {
        return CGRectMake(0, 0, 0, 0);
    }
    CGFloat itemHeight = NAV_ITEM_HEIGH;
    CGFloat itemWidth = itemHeight * NAV_IMAGE_ITEM_WIDTH_WITH_HEIGHT_RATIO;
    
    CGFloat imageRatio = imageSize.width/imageSize.height;
    CGFloat imageHeigth = itemHeight * NAVIGATION_ITEM_IMAGE_HEIGHT_WITH_NAVIGATION_BAR_HEIGHT_RATIO;
    CGFloat imageWidth = imageHeigth * imageRatio;
    
    itemWidth = MAX(itemWidth, imageWidth);
    
    if (graphicsSize) {
        *graphicsSize = CGSizeMake(itemWidth, itemHeight);
    }
    
    return CGRectMake((itemWidth - imageWidth)/2, (itemHeight - imageHeigth)/2, imageWidth, imageHeigth);
}

-(UIImage*)_createGraphicesImage:(YZHUIGraphicsImageContext*)graphicsContext strokeColor:(UIColor*)strokeColor
{
    YZHUIGraphicsImageBeginInfo *beginInfo = graphicsContext.beginInfo;
    if (beginInfo && beginInfo.graphicsSize.width <= 0 && beginInfo.graphicsSize.height <= 0) {
        beginInfo.graphicsSize = CGSizeMake(NAV_BAR_HEIGHT, NAV_BAR_HEIGHT);
    }
    return [graphicsContext createGraphicesImageWithStrokeColor:strokeColor];
//    BOOL opaque = NO;
//    CGFloat scale = 0;
//    CGFloat lineWidth = 2.0;
//    CGSize size = CGSizeMake(NAV_BAR_HEIGHT, NAV_BAR_HEIGHT);
//    if (graphicsContext && graphicsContext.graphicsBeginBlock) {
//        graphicsContext.graphicsBeginBlock(graphicsContext);
//        YZHUIGraphicsImageBeginInfo *beginInfo = graphicsContext.beginInfo;
//        if (beginInfo) {
//            scale = beginInfo.scale;
//            opaque = beginInfo.opaque;
//            lineWidth = beginInfo.lineWidth;
//            if (beginInfo.graphicsSize.width > 0 && beginInfo.graphicsSize.height > 0) {
//                size = beginInfo.graphicsSize;
//            }
//            else {
//                beginInfo.graphicsSize = size;
//            }
//        }
//        else {
//            beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] initWithGraphicsSize:size opaque:opaque scale:scale lineWidth:lineWidth];
//            graphicsContext.beginInfo = beginInfo;
//        }
//    }
//
//    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, lineWidth);
//    if (strokeColor) {
//        CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
//    }
//
//    graphicsContext.ctx = ctx;
//    if (graphicsContext.graphicsRunBlock) {
//        graphicsContext.graphicsRunBlock(graphicsContext);
//    }
//
//    CGContextStrokePath(ctx);
//
//    if (graphicsContext.graphicsEndPathBlock) {
//        graphicsContext.graphicsEndPathBlock(graphicsContext);
//    }
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    if (graphicsContext.graphicsCompletionBlock) {
//        graphicsContext.graphicsCompletionBlock(graphicsContext, image);
//    }
//    return image;
}

-(UIImage*)_createLeftBackImageForColor:(UIColor*)color width:(CGFloat)width
{
    width = MAX(15, width);
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.lineWidth = 2.5;
        context.beginInfo.graphicsSize = CGSizeMake(width, NAV_BAR_HEIGHT);
        context.imageAlignment = NSGraphicsImageAlignmentLeft;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        
        CGSize size = context.beginInfo.graphicsSize;
        CGFloat height = size.height * NAVIGATION_ITEM_LEFT_BACK_HEIGHT_WITH_NAVIGATION_BAR_HEIGHT_RATIO;//0.55;
        CGFloat width = height/2;
        CGFloat startY = (size.height - height)/2;
        CGFloat endY = size.height - startY;
        
        CGFloat remX = size.width - width;
        CGFloat shiftX = 0;
        if (context.imageAlignment == NSGraphicsImageAlignmentLeft) {
            shiftX += 0;
        }
        else if (context.imageAlignment == NSGraphicsImageAlignmentCenter) {
            shiftX += remX/2;
        }
        else if (context.imageAlignment == NSGraphicsImageAlignmentRight) {
            shiftX += remX;
        }
        CGFloat lineWidth = context.beginInfo.lineWidth;
        
        CGContextMoveToPoint(context.ctx, shiftX + width, startY + lineWidth/2);
        CGContextAddLineToPoint(context.ctx, shiftX + lineWidth/2, (startY + endY)/2);
        CGContextAddLineToPoint(context.ctx, shiftX + width, endY - lineWidth/2);
        
        CGContextSetStrokeColorWithColor(context.ctx, color.CGColor);
    } endPathBlock:nil];
    UIImage *image =[self _createGraphicesImage:ctx strokeColor:nil];
    return image;
}

-(UIImage*)_createNavigationItemImageForImage:(UIImage*)image
{
    if (!image) {
        return nil;
    }
    CGSize graphicsSize;
    CGRect frame = [self _getNavigationItemFrameForImageSize:image.size graphicsSize:&graphicsSize];
    YZHUIGraphicsImageContext *ctx = [[YZHUIGraphicsImageContext alloc] initWithBeginBlock:^(YZHUIGraphicsImageContext *context) {
        context.beginInfo = [[YZHUIGraphicsImageBeginInfo alloc] init];
        context.beginInfo.graphicsSize = graphicsSize;
    } runBlock:^(YZHUIGraphicsImageContext *context) {
        [image drawInRect:frame];
    } endPathBlock:nil];
    UIImage *newImage =[self _createGraphicesImage:ctx strokeColor:nil];
    return newImage;
}

-(UIImage*)_createNavigationItemImageForView:(UIView*)view
{
//    NSLog(@"size=%@",NSStringFromCGSize(view.bounds.size));
    CGSize viewSize = view.bounds.size;
    if (CGSizeEqualToSize(viewSize, CGSizeZero)) {
        [view sizeToFit];
        viewSize = view.bounds.size;
    }
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, SCREEN_SCALE);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIButton*)_createButtonItemWithImage:(UIImage*)image title:(NSString*)title color:(UIColor*)color target:(id)target action:(SEL)selector
{
    UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonItem.userInteractionEnabled = YES;
    buttonItem.backgroundColor = CLEAR_COLOR;
    if (image) {
        [buttonItem setImage:image forState:UIControlStateNormal];
        [buttonItem setImage:image forState:UIControlStateHighlighted];
        [buttonItem setImage:image forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    if (IS_AVAILABLE_NSSTRNG(title)) {
        [buttonItem setTitle:title forState:UIControlStateNormal];
        [buttonItem setTitleColor:color forState:UIControlStateNormal];
//        buttonItem.titleLabel.backgroundColor = PURPLE_COLOR;
    }
    [buttonItem sizeToFit];
//    buttonItem.imageView.backgroundColor = RED_COLOR;
    
    [buttonItem.titleLabel sizeToFit];
    CGRect frame = buttonItem.titleLabel.frame;
    frame.origin.x = (buttonItem.bounds.size.width-buttonItem.titleLabel.bounds.size.width)/2;
    if (image) {
        frame.origin.x = CGRectGetMaxX(buttonItem.imageView.frame);
    }
    frame.origin.y = (buttonItem.bounds.size.height - buttonItem.titleLabel.bounds.size.height)/2;
    buttonItem.titleLabel.frame = frame;
    
//    buttonItem.backgroundColor = RED_COLOR;
    
    [buttonItem addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return buttonItem;
}

-(UIButton*)_createButtonItemWithGraphicsImageContext:(YZHUIGraphicsImageContext*)graphicsImageContext title:(NSString*)title target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    UIImage *image = [self _createGraphicesImage:graphicsImageContext strokeColor:color];
    UIButton *buttonItem = [self _createButtonItemWithImage:image title:title color:color target:target action:selector];
    return buttonItem;
}

-(UIButton*)_createLeftBackButtonItemWithImageName:(NSString*)imageName title:(NSString*)title target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    UIImage *image = nil;
    if (IS_AVAILABLE_NSSTRNG(imageName)) {
        image = [self _createNavigationItemImageForImage:[UIImage imageNamed:imageName]];
    }
    else {
        if (IS_AVAILABLE_NSSTRNG(title)) {
            image = [self _createLeftBackImageForColor:color width:0];
        }
        else {
            image = [self _createLeftBackImageForColor:color width:40];
        }
    }
    UIButton *buttonItem = [self _createButtonItemWithImage:image title:title color:color target:target action:selector];
    return buttonItem;
}

-(NSMutableArray*)_createNavigationButtonItemsWithTitles:(NSArray*)titles target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    NSMutableArray *navigationButtonItems = [NSMutableArray array];
    
    for (NSString *title in titles) {
        UIButton *btn = [self _createButtonItemWithImage:nil title:title color:color target:target action:selector];
        [navigationButtonItems addObject:btn];
    }
    return navigationButtonItems;
}

-(NSMutableArray*)_createNavigationButtonItemsWithImageNames:(NSArray *)imageNames target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    NSMutableArray *navigationButtonItems = [NSMutableArray array];

    for (NSString *imageName in imageNames) {
        UIImage *oldImage = [UIImage imageNamed:imageName];
        UIImage *image = [self _createNavigationItemImageForImage:oldImage];
        UIButton *btn = [self _createButtonItemWithImage:image title:nil color:color target:target action:selector];
        [navigationButtonItems addObject:btn];
    }
    return navigationButtonItems;
}

-(NSMutableArray*)_createNavigationButtonItemsWithImages:(NSArray<UIImage*> *)images target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    NSMutableArray *navigationButtonItems = [NSMutableArray array];
    
    for (UIImage *image in images) {
        UIImage *newImg = [self _createNavigationItemImageForImage:image];
        UIButton *btn = [self _createButtonItemWithImage:newImg title:nil color:color target:target action:selector];
        [navigationButtonItems addObject:btn];
    }
    return navigationButtonItems;
}

-(NSMutableArray*)_createNavigationButtonItemsWithViews:(NSArray<UIView*>*)views target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    NSMutableArray *navigationButtonItems = [NSMutableArray array];
    
    for (UIView *view in views) {
        UIImage *viewImg = [self _createNavigationItemImageForView:view];
        UIImage *image = [self _createNavigationItemImageForImage:viewImg];
        UIButton *btn = [self _createButtonItemWithImage:image title:nil color:color target:target action:selector];
        [navigationButtonItems addObject:btn];
    }
    return navigationButtonItems;
}

-(NSMutableArray*)_createNavigationButtonItemsWithImageNames:(NSArray *)imageNames titles:(NSArray *)titles target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    NSMutableArray *navigationButtonItems = [NSMutableArray array];
    
    NSInteger cnt = MAX(imageNames.count, titles.count);
    
    for (NSInteger i = 0; i < cnt; ++i) {
        UIImage *image = nil;
        NSString *title = nil;
        if (i < imageNames.count) {
            NSString *imageName = [imageNames objectAtIndex:i];
            UIImage *oldImage = [UIImage imageNamed:imageName];
            image = [self _createNavigationItemImageForImage:oldImage];
        }
        
        if (i < titles.count) {
            title = [titles objectAtIndex:i];
        }
        UIButton *btn = [self _createButtonItemWithImage:image title:title color:color target:target action:selector];
        [navigationButtonItems addObject:btn];
    }
    return navigationButtonItems;
}

-(NSMutableArray*)_createNavigationButtonItemsWithImages:(NSArray *)images titles:(NSArray *)titles target:(id)target action:(SEL)selector
{
    UIColor *color = [[UINavigationBar appearance] tintColor];
    NSMutableArray *navigationButtonItems = [NSMutableArray array];
    
    NSInteger cnt = MAX(images.count, titles.count);
    
    for (NSInteger i = 0; i < cnt; ++i) {
        UIImage *image = nil;
        NSString *title = nil;
        if (i < images.count) {
            UIImage *oldImage = [images objectAtIndex:i];
            image = [self _createNavigationItemImageForImage:oldImage];
        }
        
        if (i < titles.count) {
            title = [titles objectAtIndex:i];
        }
        UIButton *btn = [self _createButtonItemWithImage:image title:title color:color target:target action:selector];
        [navigationButtonItems addObject:btn];
    }
    return navigationButtonItems;
}


-(void)_addNavigationItemWithButton:(UIButton*)button isReset:(BOOL)reset left:(BOOL)left
{
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
        if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle)) {
            if (left) {
                [self _clearOldNavigationItemLeftBarButtonItem];
                [navigationController addNavigationItemViewLeftButtonItems:@[button] isReset:reset forViewController:self];
            }
            else {
                [navigationController addNavigationItemViewRightButtonItems:@[button] isReset:reset forViewController:self];
            }
            return;
        }
        else if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle))
        {
            if (left) {
                [self _clearOldNavigationItemLeftBarButtonItem];
                [self.navigationItemView setLeftButtonItems:@[button] isReset:reset];
            }
            else {
                [self.navigationItemView setRightButtonItems:@[button] isReset:reset];
            }
            return;
        }
    }
    if (left) {
        if (self.title == nil) {
            [self _clearOldNavigationItemLeftBarButtonItem];
        }
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

-(void)_addNavigationItemWithButtons:(NSArray<UIButton*>*)buttons isReset:(BOOL)reset left:(BOOL)left
{
//    if (buttons == nil) {
//        return;
//    }
    
    if ([self.navigationController isKindOfClass:[YZHUINavigationController class]]) {
        YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
        UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
        if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle)) {
            if (left) {
                [navigationController addNavigationItemViewLeftButtonItems:buttons isReset:reset forViewController:self];
            }
            else {
                [navigationController addNavigationItemViewRightButtonItems:buttons isReset:reset forViewController:self];
            }
            return;
        }
        else if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_ITEM_STYLE(barAndItemStyle))
        {
            if (left) {
                [self.navigationItemView setLeftButtonItems:buttons isReset:reset];
            }
            else {
                [self.navigationItemView setRightButtonItems:buttons isReset:reset];
            }
            return;
        }
    }
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = SYSTEM_NAVIGATION_ITEM_VIEW_SUBVIEWS_ITEM_SPACE;
    
    NSMutableArray *systemItems = [NSMutableArray array];
    if (!reset) {
        if (left) {
            systemItems = [self.navigationItem.leftBarButtonItems mutableCopy];
        }
        else {
            systemItems = [self.navigationItem.rightBarButtonItems mutableCopy];

        }
        if (systemItems == nil) {
            systemItems = [NSMutableArray array];
        }
    }
    
    __block NSInteger tag = 0;
    [systemItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.customView && obj.customView.tag > 0) {
            tag = MAX(tag, obj.customView.tag);
        }
    }];
    
    for (UIButton *buttonItem in buttons) {
        buttonItem.tag = ++tag;
        [systemItems addObject:[[UIBarButtonItem alloc] initWithCustomView:buttonItem]];
        [systemItems addObject:space];
    }
    if (left) {
        self.navigationItem.leftBarButtonItems = systemItems;
    }
    else {
        self.navigationItem.rightBarButtonItems = systemItems;
    }
}

//这个带<剪头的返回按钮
-(UIButton *)addNavigationFirstLeftBackItemWithTitle:(NSString*)title target:(id)target action:(SEL)selector
{
    UIButton *leftButtonItem = [self _createLeftBackButtonItemWithImageName:nil title:title target:target action:selector];
    [self _addNavigationItemWithButton:leftButtonItem isReset:YES left:YES];
    return leftButtonItem;
}

-(UIButton *)addNavigationFirstLeftItemWithImageName:(NSString*)imageName title:(NSString*)title target:(id)target action:(SEL)selector
{
    UIButton *leftBtn = [self addNavigationLeftItemWithImageName:imageName title:title target:target action:selector isReset:YES];
    return leftBtn;
}

-(UIButton *)addNavigationLeftItemWithImageName:(NSString*)imageName title:(NSString*)title target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [self addNavigationLeftItemWithImage:image title:title target:target action:selector isReset:reset];
}

-(UIButton *)addNavigationLeftItemWithImage:(UIImage*)image title:(NSString*)title target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    image = [self _createNavigationItemImageForImage:image];
    UIButton *leftButtonItem = [self _createButtonItemWithImage:image title:title color:[[UINavigationBar appearance] tintColor] target:target action:selector];
    [self _addNavigationItemWithButton:leftButtonItem isReset:reset left:YES];
    return leftButtonItem;
}

-(NSArray<UIButton*> *)addNavigationFirstLeftBackItemsWithTitles:(NSArray<NSString*> *)titles target:(id)target action:(SEL)selector
{
//    if (!IS_AVAILABLE_NSSET_OBJ(titles)) {
//        return nil;
//    }
    NSMutableArray *leftButtonItems = [NSMutableArray array];
    UIButton *leftBackButton = [self _createLeftBackButtonItemWithImageName:nil title:[titles firstObject] target:target action:selector];
    [leftButtonItems addObject:leftBackButton];
    
    if (titles.count > 1) {
        NSArray *sub = [titles subarrayWithRange:NSMakeRange(1, titles.count - 1)];
        NSMutableArray *leftButtonItemsTmp = [self _createNavigationButtonItemsWithImageNames:nil titles:sub target:target action:selector];
        [leftButtonItems addObjectsFromArray:leftButtonItemsTmp];
    }
    [self _addNavigationItemWithButtons:leftButtonItems isReset:YES left:YES];
    
    return leftButtonItems;
}

-(NSArray<UIButton*> *)addNavigationFirstLeftBackItemsWithImageNames:(NSArray<NSString*> *)imageNames target:(id)target action:(SEL)selector
{
    NSMutableArray *leftButtonItems = [NSMutableArray array];
    UIButton *leftBackButton = [self _createLeftBackButtonItemWithImageName:nil title:nil target:target action:selector];
    [leftButtonItems addObject:leftBackButton];
    
    if (imageNames.count > 0) {
        NSMutableArray *leftButtonItemsTmp = [self _createNavigationButtonItemsWithImageNames:imageNames target:target action:selector];
        [leftButtonItems addObjectsFromArray:leftButtonItemsTmp];
    }
    [self _addNavigationItemWithButtons:leftButtonItems isReset:YES left:YES];
    
    return leftButtonItems;
}

-(NSArray<UIButton*> *)addNavigationFirstLeftBackItemsWithImage:(NSArray<UIImage*> *)images target:(id)target action:(SEL)selector
{
    NSMutableArray *leftButtonItems = [NSMutableArray array];
    UIButton *leftBackButton = [self _createLeftBackButtonItemWithImageName:nil title:nil target:target action:selector];
    [leftButtonItems addObject:leftBackButton];
    if (images.count > 0) {
        NSMutableArray *leftButtonItemsTmp = [self _createNavigationButtonItemsWithImages:images target:target action:selector];
        [leftButtonItems addObjectsFromArray:leftButtonItemsTmp];
    }
    [self _addNavigationItemWithButtons:leftButtonItems isReset:YES left:YES];
    return leftButtonItems;
}

-(NSArray<UIButton*> *)addNavigationLeftItemsWithTitles:(NSArray<NSString*> *)titles target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
//    if (!IS_AVAILABLE_NSSET_OBJ(titles)) {
//        return nil;
//    }
    NSMutableArray *leftButtonItems = [self _createNavigationButtonItemsWithTitles:titles target:target action:selector];
    [self _addNavigationItemWithButtons:leftButtonItems isReset:reset left:YES];
    return leftButtonItems;
}

-(NSArray<UIButton*> *)addNavigationLeftItemsWithImageNames:(NSArray<NSString*> *)imageNames target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
//    if (!IS_AVAILABLE_NSSET_OBJ(imageNames)) {
//        return nil;
//    }
    NSMutableArray *leftButtonItems = [self _createNavigationButtonItemsWithImageNames:imageNames target:target action:selector];
    [self _addNavigationItemWithButtons:leftButtonItems isReset:reset left:YES];
    return leftButtonItems;
}

-(NSArray<UIButton*> *)addNavigationLeftItemsWithImages:(NSArray<UIImage*> *)images target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
//    if (!IS_AVAILABLE_NSSET_OBJ(images)) {
//        return nil;
//    }
    NSMutableArray *leftButtonItems = [self _createNavigationButtonItemsWithImages:images target:target action:selector];
    [self _addNavigationItemWithButtons:leftButtonItems isReset:reset left:YES];
    return leftButtonItems;
}

-(void)addNavigationLeftItemsWithCustomView:(NSArray<UIView*> *)leftItems target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    if (!IS_AVAILABLE_NSSET_OBJ(leftItems)) {
        return;
    }
    NSMutableArray *leftButtonItems = [self _createNavigationButtonItemsWithViews:leftItems target:target action:selector];
    [self _addNavigationItemWithButtons:leftButtonItems isReset:reset left:YES];
}

//添加（Image,title）这样的按钮
-(NSArray<UIButton*> *)addNavigationLeftItemsWithImageNames:(NSArray<NSString*> *)imageNames titles:(NSArray<NSString*> *)titles target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    NSMutableArray *leftButtonItems = [self _createNavigationButtonItemsWithImageNames:imageNames titles:titles target:target action:selector];
    [self _addNavigationItemWithButtons:leftButtonItems isReset:reset left:YES];
    return leftButtonItems;
}

//添加（Image,title）这样的按钮
-(NSArray<UIButton*> *)addNavigationLeftItemsWithImages:(NSArray<UIImage*> *)images titles:(NSArray<NSString*> *)titles target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    NSMutableArray *leftButtonItems = [self _createNavigationButtonItemsWithImages:images titles:titles target:target action:selector];
    [self _addNavigationItemWithButtons:leftButtonItems isReset:reset left:YES];
    return leftButtonItems;
}

//添加（Image,title）这样的按钮
-(UIButton *)addNavigationLeftItemWithGraphicsImageContext:(YZHUIGraphicsImageContext*)graphicsImageContext title:(NSString*)title target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    UIButton *leftBtn = [self _createButtonItemWithGraphicsImageContext:graphicsImageContext title:title target:target action:selector];
    [self _addNavigationItemWithButton:leftBtn isReset:reset left:YES];
    return leftBtn;
}

//right
-(NSArray<UIButton*> *)addNavigationRightItemsWithTitles:(NSArray<NSString*> *)titles target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
//    if (!IS_AVAILABLE_NSSET_OBJ(titles)) {
//        return nil;
//    }
    
    NSMutableArray *rightButtonItems = [self _createNavigationButtonItemsWithTitles:titles target:target action:selector];
    [self _addNavigationItemWithButtons:rightButtonItems isReset:reset left:NO];
    return rightButtonItems;
}

-(NSArray<UIButton*> *)addNavigationRightItemsWithImageNames:(NSArray<NSString*> *)imageNames target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
//    if (!IS_AVAILABLE_NSSET_OBJ(imageNames)) {
//        return nil;
//    }
    
    NSMutableArray *rightButtonItems = [self _createNavigationButtonItemsWithImageNames:imageNames target:target action:selector];
    [self _addNavigationItemWithButtons:rightButtonItems isReset:reset left:NO];
    return rightButtonItems;
}

-(NSArray<UIButton*> *)addNavigationRightItemsWithImages:(NSArray<UIImage*> *)images target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    NSMutableArray *rightButtonItems = [self _createNavigationButtonItemsWithImages:images target:target action:selector];
    [self _addNavigationItemWithButtons:rightButtonItems isReset:reset left:NO];
    return rightButtonItems;
}

-(void)addNavigationRightItemsWithCustomView:(NSArray<UIView*> *)rightItems target:(id)target action:(SEL)selector isReset:(BOOL)reset
{
    NSMutableArray *rightButtonItems = [self _createNavigationButtonItemsWithViews:rightItems target:target action:selector];
    [self _addNavigationItemWithButtons:rightButtonItems isReset:reset left:NO];
}

-(void)addNavigationBarCustomView:(UIView*)customView
{
    YZHUINavigationController *navigationController = (YZHUINavigationController*)self.navigationController;
    UINavigationControllerBarAndItemStyle barAndItemStyle = navigationController.navigationControllerBarAndItemStyle;
    if (IS_CUSTOM_GLOBAL_UINAVIGATIONCONTROLLER_BAR_STYLE(barAndItemStyle)) {
        [navigationController addNavigationBarCustomView:customView];
    }
    else if (IS_CUSTOM_VIEWCONTROLLER_UINAVIGATIONCONTROLLER_BAR_STYLE(barAndItemStyle))
    {
        if (self.navigationBarView && customView) {
            [self.navigationBarView addSubview:customView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
