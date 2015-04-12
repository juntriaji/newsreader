//
//  ColorUtil.h
//  POEMSIPAD
//
//  Created by Nunuk Basuki on 12/1/13.
//  Copyright (c) 2013 Mini OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

extern NSString *const greenColor;
extern NSString *const redColor;
extern NSString *const lightBlueColor;
extern NSString *const yellowColor;
extern NSString *const darkerGray;
extern NSString *const titleColor;
extern NSString *const titleColor2;
extern NSString *const tableRowColor;
extern NSString *const newsTitle;
extern NSString *const newsBody;

@interface ColorUtil : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)greenColor;
+ (UIColor *)redColor;
+ (UIColor *)lightBlueColor;
+ (UIColor *)yellowColor;
+ (UIColor *)darkerGray;
+ (UIColor *)titleColor;
+ (UIColor *)titleColor2;
+ (UIColor *)tableRowColor;
+ (UIColor *)newsTitle;
+ (UIColor *)newsBody;

@end
