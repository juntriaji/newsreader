//
//  FeedDB.h
//  NewsReader
//
//  Created by Nunuk Basuki on 7/25/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FeedDB : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * media;
@property (nonatomic, retain) NSString * contentEncoded;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * share_url;

@end
