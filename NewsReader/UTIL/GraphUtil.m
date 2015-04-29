//
//  GraphUtil.m
//  POEMSIPAD
//
//  Created by Mini OSX on 6/18/13.
//  Copyright (c) 2013 Mini OSX. All rights reserved.
//

#import "GraphUtil.h"
#import <QuartzCore/QuartzCore.h>

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

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (void)createBordersWithCorderRadius:(UIView*)view color:(UIColor*)color radius:(CGFloat)radius withBorderSize:(CGFloat)borderSize
{
    view.clipsToBounds = YES;
    view.layer.borderWidth = borderSize;
    view.layer.cornerRadius = radius;
    view.layer.borderColor = [color CGColor];
}


+ (void)createButtonShadow:(UIButton*)button withBgColor:(UIColor*)bgcolor withBorderColor:(UIColor*)bordercolor
{
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[GraphUtil imageWithColor:bgcolor] forState:UIControlStateNormal];
    [GraphUtil createBordersWithCorderRadius:button color:bordercolor radius:5.0f withBorderSize:1.5f];
    button.layer.masksToBounds = NO;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.9;
    button.layer.shadowOffset = CGSizeMake(0.0, 3.0);

}

+ (void)createCornerRadius:(UIView*)view radius:(CGSize)radius rectCorner:(UIRectCorner)rectCorner
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:rectCorner
                                           cornerRadii:CGSizeMake(radius.height, radius.width)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}



@end
