//
//  GraphUtil.h
//  POEMSIPAD
//
//  Created by Mini OSX on 6/18/13.
//  Copyright (c) 2013 Mini OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GraphUtil : NSObject

+ (NSAttributedString*)setAttributtedText:(NSArray*)textArray colorArray:(NSArray*)colors delimiter:(NSString*)delimiter;

+ (void)createBorders:(UIView*)view color:(UIColor*)color;
+ (void)createBordersWithCorderRadius:(UIView*)view color:(UIColor*)color radius:(CGFloat)radius;
+ (void)createBorderBottom:(UIView*)view;
+ (void)createBordersWithCorderRadius:(UIView*)view color:(UIColor*)color radius:(CGFloat)radius withBorderSize:(CGFloat)borderSize;


#pragma mark - Color From Hex credit goes to Dave DeLong
+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (NSAttributedString*)searchStringAndHiligthIt:(NSString*)stringSource searchForText:(NSString*)searchText backgroundColor:(UIColor*)backgroundColor;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (void)createButtonShadow:(UIButton*)button withBgColor:(UIColor*)bgcolor withBorderColor:(UIColor*)bordercolor;
+ (void)createCornerRadius:(UIView*)view radius:(CGSize)radius rectCorner:(UIRectCorner)rectCorner;

@end
