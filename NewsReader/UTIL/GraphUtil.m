//
//  GraphUtil.m
//  POEMSIPAD
//
//  Created by Mini OSX on 6/18/13.
//  Copyright (c) 2013 Mini OSX. All rights reserved.
//

#import "GraphUtil.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h> 

@implementation GraphUtil

+ (NSAttributedString*)setAttributtedText:(NSArray*)textArray colorArray:(NSArray*)colors delimiter:(NSString*)delimiter
{
    NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] init];
    for(NSUInteger i = 0; i < textArray.count ; i++)
    {
        if(i == textArray.count -1) delimiter = @"";
        
        NSString *str = [NSString stringWithFormat:@"%@%@", [textArray objectAtIndex:i], delimiter];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[colors objectAtIndex:i] range:NSMakeRange(0, str.length)];
        
        [retval appendAttributedString:attributedString];
    }
    
    return retval;
}

+ (void)createBorders:(UIView*)view color:(UIColor*)color
{
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = 6.0;
    view.layer.borderColor = [color CGColor];
}

+ (void)createBordersWithCorderRadius:(UIView*)view color:(UIColor*)color radius:(CGFloat)radius
{
    view.clipsToBounds = YES;
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = radius;
    view.layer.borderColor = [color CGColor];
}

+ (void)createBorderBottom:(UIView*)view
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.bounds = view.bounds;
    bottomBorder.masksToBounds = YES;
    bottomBorder.needsDisplayOnBoundsChange = YES;
    bottomBorder.frame = CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1);
    bottomBorder.backgroundColor = [[UIColor darkGrayColor] CGColor];
    
    [view.layer addSublayer:bottomBorder];
}

+ (UIImage*)buttonGrey
{
    return [[UIImage imageNamed:@"btn_grey_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
}

+ (UIImage*)buttonGreyBig
{
    return [[UIImage imageNamed:@"btn_gray_22x40.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 20, 5)];
}

+ (UIImage*)buttonDarkGreyBig
{
    return [[UIImage imageNamed:@"btn_darkgray_22x40.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
}

+ (UIImage*)buttonDarkGrey
{
    return [[UIImage imageNamed:@"btn_darkgray_22x30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
}

+ (UIImage*)buttonRed
{
    return [[UIImage imageNamed:@"btn_red_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
}

+ (UIImage*)buttonBlue
{
    return [[UIImage imageNamed:@"btn_blue_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

+ (UIImage*)buttonRed64
{
    return [[UIImage imageNamed:@"btn_red_64.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
}


+ (UIImage*)buttonGreen
{
    return [[UIImage imageNamed:@"btn_green_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
}

+ (UIImage*)buttonSelectGrey
{
    return [[UIImage imageNamed:@"btn_select_grey_30.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 27)];
}

+ (void)setButtonGreySelect:(UIButton*)button
{
    [button setBackgroundImage:[self buttonSelectGrey] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 25);
}

+ (void)setButtonGrey:(UIButton*)button
{
    [button setBackgroundImage:[self buttonGrey] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

+ (void)setButtonRed64:(UIButton*)button
{
    [button setBackgroundImage:[self buttonRed64] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

+ (void)setButtonGreyBig:(UIButton*)button
{
    [button setBackgroundImage:[self buttonGreyBig] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

+ (void)setButtonDarkGreyBig:(UIButton*)button
{
    [button setBackgroundImage:[self buttonDarkGreyBig] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

+ (void)setButtonDarkGrey:(UIButton*)button
{
    [button setBackgroundImage:[self buttonDarkGrey] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

+ (void)setButtonRed:(UIButton*)button
{
    [button setBackgroundImage:[self buttonRed] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

+ (void)setButtonBlue:(UIButton*)button
{
    [button setBackgroundImage:[self buttonBlue] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

+ (void)setButtonGreen:(UIButton*)button
{
    [button setBackgroundImage:[self buttonGreen] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}


#pragma mark - Bid/Ask button
+ (void)setBidAskButton:(UIButton*)button upDown:(u_int8_t)upDown
{
    UIImage *btnImage;
    if(upDown == 0)
        btnImage = [[UIImage imageNamed:@"price_down.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    else if(upDown == 1)
        btnImage = [[UIImage imageNamed:@"price_up.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    else
        btnImage = [[UIImage imageNamed:@"price_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 1);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    if([button.titleLabel.text isEqualToString:@"-"])
    {
        [button setUserInteractionEnabled:NO];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [button setUserInteractionEnabled:YES];
        [button setBackgroundImage:btnImage forState:UIControlStateNormal];
    }
}

#pragma mark - Color From Hex credit goes to Dave DeLong

+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSAttributedString*)searchStringAndHiligthIt:(NSString*)stringSource searchForText:(NSString*)searchText backgroundColor:(UIColor*)backgroundColor
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:stringSource];
    
    NSRange searchRange = NSMakeRange(0,stringSource.length);
    NSRange foundRange;
    while (searchRange.location < stringSource.length) {
        searchRange.length = stringSource.length-searchRange.location;
        foundRange = [stringSource rangeOfString:searchText options:NSCaseInsensitiveSearch range:searchRange];
        if (foundRange.location != NSNotFound) {
            // found an occurrence of the substring! do stuff here
            [string addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:foundRange];
            searchRange.location = foundRange.location+1;//foundRange.length;
        } else {
            // no more substring to find
            break;
        }
    }
    
    return string;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




@end
