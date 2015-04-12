//
//  ColorUtil.m
//  POEMSIPAD
//
//  Created by Nunuk Basuki on 12/1/13.
//  Copyright (c) 2013 Mini OSX. All rights reserved.
//

#import "ColorUtil.h"

NSString *const greenColor = @"#007700";
NSString *const redColor = @"#C00000";
NSString *const lightBlueColor = @"#00B0F0";
NSString *const yellowColor = @"#f07f09";
NSString *const darkerGray = @"#333333";
NSString *const titleColor = @"#000000";
NSString *const titleColor2 = @"#4A452A";
NSString *const tableRowColor = @"#330000";
NSString *const newsTitle = @"#4F81BD";
NSString *const newsBody = @"#BFBFBF";
//#4F81BD
@implementation ColorUtil


#pragma mark - Color From Hex credit goes to Dave DeLong

+ (UIColor*) colorFromHexString:(NSString *)hexString {
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

+ (UIColor*)greenColor{
    return  [self colorFromHexString:greenColor];
}

+ (UIColor*)redColor{
    return  [self colorFromHexString:redColor];
}

+ (UIColor *)lightBlueColor{
    return  [self colorFromHexString:lightBlueColor];
}

+ (UIColor *)yellowColor{
    return  [self colorFromHexString:yellowColor];
}

+ (UIColor *)darkerGray{
    return  [self colorFromHexString:darkerGray];
}

+ (UIColor *)titleColor{
    return  [self colorFromHexString:titleColor];
}

+ (UIColor *)titleColor2{
    return  [self colorFromHexString:titleColor2];
}

+ (UIColor *)tableRowColor{
    return  [[UIColor darkGrayColor] colorWithAlphaComponent:0.15];
}

+ (UIColor *)newsTitle{
    return [self colorFromHexString:newsTitle];
}

+ (UIColor *)newsBody{
    return [self colorFromHexString:newsBody];
}



@end
