//
//  FeedURL.h
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FeedURL : NSManagedObject

@property (nonatomic, retain) NSString * feedTitle;
@property (nonatomic, retain) NSString * feedURL;
@property (nonatomic, retain) NSString * active;

@end
