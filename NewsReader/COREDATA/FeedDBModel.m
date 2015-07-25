//
//  FeedDBModel.m
//  NewsReader
//
//  Created by Nunuk Basuki on 7/25/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "FeedDBModel.h"
#import "AppDelegate.h"
#import "FeedDB.h"
#import "FeedData.h"

@implementation FeedDBModel

-(id)init
{
    self = [super init];
    if(self)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
        [_managedObjectContext setUndoManager:nil];
        _entity = @"FeedDB";
    }
    return self;
}

- (void)bulkSaveData:(NSArray *)feeds
{
    [self emptyDBFeed];
    NSError *error = nil;
    [feeds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // save
        FeedData *fData = (FeedData*)obj;
        FeedDB *feedDB = [NSEntityDescription
                            insertNewObjectForEntityForName:_entity
                            inManagedObjectContext:_managedObjectContext];
        feedDB.link = [fData.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        feedDB.title = [fData.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        feedDB.media = [fData.media stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        feedDB.contentEncoded = [fData.contentEncoded stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        feedDB.category = [fData.category stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    }];
    
    if(![_managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
    
}

- (void)emptyDBFeed
{
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_managedObjectContext deleteObject:obj];
    }];

    if(![_managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
    
}

- (NSArray*)getCategory
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *getAll = [self getAll];
    [getAll enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedDB *fDB = (FeedDB*)obj;
        [dict setValue:fDB.category forKey:fDB.category];
    }];
    
    return [dict allKeys];
}


- (NSArray*)getAll
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category != %@", @"Uncategorized"];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return recordSet;
    
}

- (NSArray*)getByCat:(NSString*)catName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", catName];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return recordSet;
    
}


@end
