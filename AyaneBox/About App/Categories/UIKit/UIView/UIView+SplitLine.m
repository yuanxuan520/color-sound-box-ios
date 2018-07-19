//
//  UIView+SplitLine.m
//  SellHouseManager
//
//  Created by 文俊 on 2016/11/17.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "UIView+SplitLine.h"

@implementation UIView (SplitLine)

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        
//        SEL originalSelector = @selector(drawRect:);
//        SEL swizzledSelector = @selector(my_drawRect:);
//        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}

- (void)my_drawRect:(CGRect)rect
{
    if (self.borderType != 0) {
        CGContextRef cx=UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(cx, 1.0f);//这里设置的是1, 但实际反映出是0.5的效果, 要的就是这种感觉. ~原因我知道.
        CGContextSetAllowsAntialiasing(cx, NO);
        CGContextMoveToPoint(cx, 0.0f,0.0f);//左上边
        //顶部的线
        if ([self hasBorderWithType:ZDBorderTypeTop])
        {
            CGContextAddLineToPoint(cx, rect.size.width, 0.0f);
        }else {
            CGContextMoveToPoint(cx, rect.size.width, 0.0f);
        }
        
        //右侧的线
        if ([self hasBorderWithType:ZDBorderTypeRight])
        {
            CGContextAddLineToPoint(cx, rect.size.width, rect.size.height);
        }else {
            CGContextMoveToPoint(cx, rect.size.width, rect.size.height);
        }
        
        //底部的线
        if ([self hasBorderWithType:ZDBorderTypeBottom])
        {
            CGContextAddLineToPoint(cx, 0.0f, rect.size.height);
        }else {
            CGContextMoveToPoint(cx, 0.0f, rect.size.height);
        }
        
        //左侧的线
        if ([self hasBorderWithType:ZDBorderTypeLeft])
        {
            CGContextAddLineToPoint(cx, 0.0f,0.0f);
        }else {
            CGContextMoveToPoint(cx, 0.0f,0.0f);
        }
        
        [self.borderColor setStroke];
        CGContextDrawPath(cx, kCGPathStroke);
    }
}

- (BOOL)hasBorderWithType:(ZDBorderType)aType
{
    return (self.borderType & aType) != 0;
}


- (ZDBorderType)borderType {
    return [objc_getAssociatedObject(self, @selector(setBorderType:)) intValue];
}

- (void)setBorderType:(ZDBorderType)borderType {
    objc_setAssociatedObject(self, @selector(setBorderType:), @(borderType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
    [self my_drawRect:self.frame];
}

- (UIColor *)borderColor {
    UIColor *color = objc_getAssociatedObject(self, @selector(setBorderColor:));
    if (!color) {
        color = kSplitLineColor;
    }
    return color;
}

- (void)setBorderColor:(UIColor *)borderColor {
    objc_setAssociatedObject(self, @selector(setBorderColor:), borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

@end
