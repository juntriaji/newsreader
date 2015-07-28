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
#import "FeedCategoryPref.h"

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
    NSArray *cat = [dict allKeys];
    [self saveCategoryPref:cat];
    return cat;
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

#pragma mark -  Category Pref

- (NSArray*)getAllCatPref
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return recordSet;
    
}

- (NSArray*)getAllCatPrefActive
{
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"enabled == 1"];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *arrMut = [NSMutableArray array];
    [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedCategoryPref *fDB = (FeedCategoryPref*)obj;
        [arrMut addObject:fDB.categoryName];
        
    }];

    return arrMut;
    
}

- (void)saveCategoryPref:(NSArray*)catExisting
{
    //NSLog(@"iki %@", catExisting);
    [catExisting enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(![self isExistsCategoryName:obj])
        {
            [self insertNewCategory:obj];
        }
    }];
    
    [self deleteIfCatNoLongerExists:catExisting];
}

- (void)insertNewCategory:(NSString*)catName
{
    NSError *error = nil;
    FeedCategoryPref *feedCAtPref = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"FeedCategoryPref" inManagedObjectContext:_managedObjectContext];
    feedCAtPref.categoryName = catName;
    feedCAtPref.enabled = @1;
    
    if(![_managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
        
}

- (void)updateCatPref:(NSString*)catName value:(NSNumber*)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@", catName];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedCategoryPref *feedCatPref = (FeedCategoryPref*)obj;
        feedCatPref.enabled = value;
        feedCatPref.categoryName = feedCatPref.categoryName;
    }];
    
    if(![_managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
    
}

- (void)deleteIfCatNoLongerExists:(NSArray*)catNames
{

    //NSArray *currenCat = [self getAllCatPref];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_managedObjectContext];
    fetchRequest.entity = entity;
    //fetchRequest.predicate = predicate;
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];

    [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedCategoryPref *pref = (FeedCategoryPref*)obj;
        if([catNames indexOfObject:pref.categoryName] == NSNotFound)
        {
            [_managedObjectContext deleteObject:obj];
        }
    }];
    
    
    if(![_managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
    
}


- (BOOL)isExistsCategoryName:(NSString*)catName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@", catName];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"== %@", recordSet);
    if(recordSet.count > 0)
        return YES;
    
    return NO;
}


@end
