//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Bootstrap)

-(void)bootstrapStyle{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    //[self.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize]];
}

-(void)defaultStyle{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)primaryStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:51/255.0 green:119/255.0 blue:172/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)successStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:76/255.0 green:174/255.0 blue:76/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:69/255.0 green:164/255.0 blue:84/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)infoStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)warningStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:162/255.0 blue:54/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:237/255.0 green:155/255.0 blue:67/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)dangerStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:217/255.0 green:83/255.0 blue:79/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:63/255.0 blue:58/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:210/255.0 green:48/255.0 blue:51/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)yellowStyle
{
    [self bootstrapStyle];
    self.layer.borderWidth = 0;
    self.backgroundColor = [UIColor colorWithRed:1.0 green:192/255.0 blue:2/255.0 alpha:1];
    //self.layer.borderColor = [[UIColor colorWithRed:1.0 green:192/255.0 blue:2/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:248/255.0 green:181/255.0 blue:0.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)cyanStyle
{
    [self bootstrapStyle];
    self.layer.borderWidth = 0;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:190/255.0 blue:212/255.0 alpha:1];
    //self.layer.borderColor = [[UIColor colorWithRed:0.0 green:190/255.0 blue:222/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0.0 green:176/255.0 blue:196/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)greenStyle
{
    [self bootstrapStyle];
    self.layer.borderWidth = 0;
    self.backgroundColor = [UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1];
    //self.layer.borderColor = [[UIColor colorWithRed:16/255.0 green:188/255.0 blue:156/255.0 alpha:1] CGColor];
    [self setTitleColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1] forState:UIControlStateDisabled];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:82/255.0 green:209/255.0 blue:184/255.0 alpha:1]] forState:UIControlStateDisabled];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:25/255.0 green:178/255.0 blue:148/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)blueStyle
{
    [self bootstrapStyle];
    self.layer.borderWidth = 0;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:234/255.0 alpha:1];
    //self.layer.borderColor = [[UIColor colorWithRed:16/255.0 green:188/255.0 blue:156/255.0 alpha:1] CGColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:135/255.0 green:211/255.0 blue:242/255.0 alpha:1]] forState:UIControlStateDisabled];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0/255.0 green:170/255.0 blue:224/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)redStyle
{
    [self bootstrapStyle];
    self.layer.borderWidth = 0;
    self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
    //self.layer.borderColor = [[UIColor colorWithRed:16/255.0 green:188/255.0 blue:156/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:200/255.0 green:0.0 blue:0.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)whiteSquareStyle
{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)lightStyle
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
}


- (UIImage *)buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
