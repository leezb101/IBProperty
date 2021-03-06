//
//  UIView+ORIBProperty.m
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/8.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import "UIView+ORIBProperty.h"
#import "ORIBProperty.h"
#import "NSObject+ORIBProperty.h"
#import "UIImageView+ORIBProperty.h"


static const NSString *ib_gradientStartColorKey = @"ib_gradientStartColorKey";

static const NSString *ib_gradientEndColorKey = @"ib_gradientEndColorKey";

static const NSString *ib_gradientLayerKey = @"ib_gradientLayerKey";


@interface UIImage (IBYYImage)

- (UIImage *)ib_addCornerRadius:(CGFloat)radius andSize:(CGSize)size;

@end

@implementation UIImage (IBYYImage)

- (UIImage *)ib_addCornerRadius:(CGFloat)radius andSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end


@implementation UIView (ORIBProperty)

#pragma mark -- border

- (void)setIb_borderWidth:(CGFloat)ib_borderWidth {
    if (ib_borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = ib_borderWidth;
}

- (CGFloat)ib_borderWidth {
    return self.layer.borderWidth;
}

- (void)setIb_borderColor:(UIColor *)ib_borderColor {
    self.layer.borderColor = ib_borderColor.CGColor;
}

- (UIColor *)ib_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark -- ib_cornerRadius

- (void)setIb_cornerRadius:(CGFloat)ib_cornerRadius {
    
    if (ib_cornerRadius == 0) {
        return;
    }
    
    self.layer.cornerRadius = ib_cornerRadius;

    
    if (ib_cornerRadius == 0) {
        return;
    }
    
    self.layer.cornerRadius = ib_cornerRadius;
    
    if ([self isKindOfClass:[UIImageView class]]) {
        
        UIImageView *imageView = (UIImageView *)self;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self ib_methodExchangeWithSelector:@selector(setImage:) toSelector:@selector(ib_setImage:)];
        });
        
        
        if (imageView.image) {
            imageView.image = imageView.image;
        }
        IB_WEAKIFY(self);
        
        [self aspect_hookSelector:@selector(setBounds:) withOptions:AspectPositionAfter usingBlock:^(){
            
            IB_STRONGIFY(self);
            
            if ([self isKindOfClass:[UIImageView class]]) {
                UIImageView *imageview = (UIImageView *)self;
                imageview.image = imageview.image;
            }
        } error:nil];
        
    }
    
    if ([self isKindOfClass:[UILabel class]]) {
        self.layer.masksToBounds = YES;
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        if (button.currentImage || button.currentBackgroundImage) {
            self.layer.masksToBounds = YES;
        }
    }
    
    if (@available(iOS 8.0, *)) {
        if ([self isKindOfClass:[UIVisualEffectView class]]) {
            self.layer.masksToBounds = YES;
        }
    }
    
    return;
}

- (CGFloat)ib_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setIb_cornerCircle:(BOOL)ib_cornerCircle {

    if (ib_cornerCircle == YES) {
        
        self.ib_cornerRadius = self.bounds.size.height / 2.0f;
        
        IB_WEAKIFY(self);

        [self aspect_hookSelector:@selector(setBounds:) withOptions:AspectPositionAfter usingBlock:^(){

            IB_STRONGIFY(self);

            self.ib_cornerRadius = self.bounds.size.height / 2.0f;

        } error:nil];
    }
    
}

- (BOOL)ib_cornerCircle {
    return self.layer.cornerRadius == self.bounds.size.height / 2.0f;
}

- (void)ib_setImage:(UIImage *)image {
    
    UIImage *aImage = image;
    
    if (!self.layer.masksToBounds && self.ib_cornerRadius > 0) {
        
        CGSize size = self.bounds.size;
        if (size.width == 0 || size.height == 0) {
            size = image.size;
        }
        aImage = [image ib_addCornerRadius:self.layer.cornerRadius andSize:self.bounds.size];

        aImage = aImage == nil ? image : aImage;
    }
    [self ib_setImage:aImage];
}

#pragma mark -- shadow

- (void)setIb_shadowColor:(UIColor *)ib_shadowColor {
    self.layer.shadowColor = ib_shadowColor.CGColor;
}

- (UIColor *)ib_shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setIb_shadowOffset:(CGSize)ib_shadowOffset {
    self.layer.shadowOffset = ib_shadowOffset;
}

- (CGSize)ib_shadowOffset {
    return self.layer.shadowOffset;
}

- (void)setIb_shadowOpacity:(CGFloat)ib_shadowOpacity {
    self.layer.shadowOpacity = ib_shadowOpacity;
}

- (CGFloat)ib_shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setIb_shadowRadius:(CGFloat)ib_shadowRadius {
    self.layer.shadowRadius = ib_shadowRadius;
}

- (CGFloat)ib_shadowRadius {
    return self.layer.shadowRadius;
}

#pragma mark -- gradient

- (void)setIb_gradientStartColor:(UIColor *)ib_gradientStartColor {
    [self ib_setAssociateValue:ib_gradientStartColor withKey:&ib_gradientStartColorKey];
    [self _ib_addGradient];
}

- (void)setIb_gradientEndColor:(UIColor *)ib_gradientEndColor {
    [self ib_setAssociateValue:ib_gradientEndColor withKey:&ib_gradientEndColorKey];
    [self _ib_addGradient];
}

- (UIColor *)ib_gradientEndColor {
    return [self ib_getAssociatedValueForKey:&ib_gradientEndColorKey];
}

- (UIColor *)ib_gradientStartColor {
    return [self ib_getAssociatedValueForKey:&ib_gradientStartColorKey];
}

- (void)_ib_addGradient {
    
    CAGradientLayer *gradientLayer = [self ib_getAssociatedValueForKey:&ib_gradientLayerKey];
    
    if (!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
        
        gradientLayer.frame = self.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.locations = @[@(0.0f), @(1.0f)];
        gradientLayer.zPosition = -100;
        [self.layer addSublayer:gradientLayer];
        
        [self ib_setAssociateValue:gradientLayer withKey:@"gradientLayer"];
        
        IB_WEAKIFY(self);
        [self aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^{
            IB_STRONGIFY(self);
            gradientLayer.frame = self.bounds;
            gradientLayer.cornerRadius = self.layer.cornerRadius;
        } error:nil];
        
    }
    gradientLayer.colors = [self _ib_getCGColors];
}

- (NSArray *)_ib_getCGColors {
    if (self.ib_gradientStartColor && self.ib_gradientEndColor) {
        return @[(__bridge id)self.ib_gradientStartColor.CGColor, (__bridge id)self.ib_gradientEndColor.CGColor];
    }
    
    if (self.ib_gradientStartColor) {
        return @[[self _ib_getCGColorWithColor:self.ib_gradientStartColor alpha:0.3], [self _ib_getCGColorWithColor:self.ib_gradientStartColor alpha:0.1]];
    }
    
    if (self.ib_gradientEndColor) {
        return @[[self _ib_getCGColorWithColor:self.ib_gradientEndColor alpha:0.1], [self _ib_getCGColorWithColor:self.ib_gradientEndColor alpha:0.3]];
    }
    
    return nil;
}

- (id)_ib_getCGColorWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    
    CGFloat red = 0.0, green = 0.0, blue = 0, al = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&al];
    return  (__bridge id)[UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
}


@end
