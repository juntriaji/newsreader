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

+ (UIImage*)buttonGrey;
+ (UIImage*)buttonRed;
+ (UIImage*)buttonGreen;
+ (UIImage*)buttonSelectGrey;
+ (void)setButtonGrey:(UIButton*)button;
+ (void)setButtonRed:(UIButton*)button;
+ (void)setButtonGreen:(UIButton*)button;
+ (void)setButtonGreySelect:(UIButton*)button;
+ (void)setButtonRed64:(UIButton*)button;
+ (UIImage*)buttonGreyBig;
+ (UIImage*)buttonDarkGreyBig;
+ (void)setButtonGreyBig:(UIButton*)button;
+ (void)setButtonDarkGreyBig:(UIButton*)button;
+ (void)setButtonDarkGrey:(UIButton*)button;
+ (void)setButtonBlue:(UIButton*)button;

#pragma mark - Bid/Ask Button
+ (void)setBidAskButton:(UIButton*)button upDown:(u_int8_t)upDown;

#pragma mark - Color From Hex credit goes to Dave DeLong
+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (NSAttributedString*)searchStringAndHiligthIt:(NSString*)stringSource searchForText:(NSString*)searchText backgroundColor:(UIColor*)backgroundColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
