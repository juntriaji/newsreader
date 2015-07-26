//
//  FeedCategoryPref.h
//  NewsReader
//
//  Created by Nunuk Basuki on 7/26/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FeedCategoryPref : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * enabled;

@end
