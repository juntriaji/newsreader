//
//  ItemView.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "ItemView.h"
#import "ColorUtil.h"

@implementation ItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBegin:)];
    [self addGestureRecognizer:reg];
}

- (void)tapBegin:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];//[ColorUtil colorFromHexString:@"#1293c9"];
    }];

    [_delegate getURLTarget:_urlTarget];
}

@end
