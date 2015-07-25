//
//  FeedData.h
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedData : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *media;
@property (nonatomic) NSString *contentEncoded;
@property (nonatomic) NSString *category;

@end
