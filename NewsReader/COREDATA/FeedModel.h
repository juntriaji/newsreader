//
//  FeedModel.h
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FeedModel : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSString *entity;

- (BOOL)checkIfExist:(NSString*)strURL;
- (NSArray*)getAll;
- (void)bulkSaveData:(NSArray *)feeds;
- (void)saveAll:(NSArray*)feedArray;
- (NSArray*)getAllActive;

@end
