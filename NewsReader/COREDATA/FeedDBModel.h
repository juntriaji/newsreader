//
//  FeedDBModel.h
//  NewsReader
//
//  Created by Nunuk Basuki on 7/25/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FeedDBModel : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSString *entity;

- (void)bulkSaveData:(NSArray *)feeds;
- (NSArray*)getAll;
- (NSArray*)getCategory;
- (NSArray*)getByCat:(NSString*)catName;

@end
