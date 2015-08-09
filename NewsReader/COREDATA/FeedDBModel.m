//
//  FeedDBModel.m
//  NewsReader
//
//  Created by Nunuk Basuki on 7/25/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "FeedDBModel.h"
#import "FeedDB.h"
#import "FeedData.h"
#import "FeedCategoryPref.h"
#import "AppDelegate.h"

@interface FeedDBModel()

@property (nonatomic) AppDelegate *appDelegate;

@end

@implementation FeedDBModel

-(id)init
{
    self = [super init];
    if(self)
    {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = _appDelegate.managedObjectContext;
        [_managedObjectContext setUndoManager:nil];
        _entity = @"FeedDB";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(compareData:) name:@"DeleteDB" object:self];
    }
    return self;
}

- (BOOL)checkFeedDBExist:(NSString*)stringURL
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", stringURL];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(recordSet.count == 0)
    {
        return NO;
    }
    return YES;
    
}


- (void)bulkSaveData:(NSArray *)feeds
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Deleting
    
    NSError *error = nil;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE, dd MM yyyy HH:mm:ss ZZZ"];//Wed, 29 Jul 2015 17:37:12 +0000
    
    NSMutableArray *arrayMut = [NSMutableArray array];
    
    [feeds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // save
        FeedData *fData = (FeedData*)obj;
        
        NSString *link = [fData.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [arrayMut addObject:link];
        
        if([self checkFeedDBExist:link] == NO)
        {
        
            FeedDB *feedDB = [NSEntityDescription
                              insertNewObjectForEntityForName:_entity
                              inManagedObjectContext:_managedObjectContext];
            feedDB.link = [fData.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            feedDB.title = [fData.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            feedDB.media = [fData.media stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            feedDB.contentEncoded = [fData.contentEncoded stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            feedDB.category = [fData.category stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSDate *date = [df dateFromString:[fData.pubDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
            feedDB.pubDate = date;
            feedDB.share_url = [fData.share_url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDB" object:self userInfo:@{@"feeds": arrayMut}];
    
    if(![_managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }

}

- (void)compareData:(NSNotification*)notif
{
    NSArray *feeds = [[notif userInfo] valueForKey:@"feeds"];
    NSArray *existingData = [self getAll];
    
    [existingData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        FeedDB *feedDB = (FeedDB*) obj;
        
        if([feeds indexOfObject:feedDB.link] == NSNotFound)
        {
            [self deleteNoExistOnFeed:feedDB.link];
        }
        
    }];
}

- (void)deleteNoExistOnFeed:(NSString*)stringURL
{
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", stringURL];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"pubDate" ascending:NO];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    fetchRequest.sortDescriptors = @[sort];
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
                                              inManagedObjectContext:_appDelegate.managedObjectContext];
    NSSortDescriptor *decriptors = [NSSortDescriptor sortDescriptorWithKey:@"categoryName" ascending:YES];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = @[decriptors];
    
    NSArray *recordSet = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return recordSet;
    
}

- (NSArray*)getAllCatPrefActive
{
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"enabled == 1"];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_appDelegate.managedObjectContext];
    NSSortDescriptor *decriptors = [NSSortDescriptor sortDescriptorWithKey:@"categoryName" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    fetchRequest.sortDescriptors = @[decriptors];
    
    NSArray *recordSet = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
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
                                     insertNewObjectForEntityForName:@"FeedCategoryPref" inManagedObjectContext:_appDelegate.managedObjectContext];
    feedCAtPref.categoryName = catName;
    feedCAtPref.enabled = @1;
    
    if(![_appDelegate.managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
        
}

- (void)updateCatPref:(NSString*)catName value:(NSNumber*)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@", catName];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_appDelegate.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
    NSArray *recordSet = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedCategoryPref *feedCatPref = (FeedCategoryPref*)obj;
        feedCatPref.enabled = value;
        feedCatPref.categoryName = feedCatPref.categoryName;
    }];
    
    if(![_appDelegate.managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
    
}

- (void)deleteIfCatNoLongerExists:(NSArray*)catNames
{

    //NSArray *currenCat = [self getAllCatPref];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_appDelegate.managedObjectContext];
    fetchRequest.entity = entity;
    //fetchRequest.predicate = predicate;
    NSArray *recordSet = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedCategoryPref *pref = (FeedCategoryPref*)obj;
        if([catNames indexOfObject:pref.categoryName] == NSNotFound)
        {
            [_appDelegate.managedObjectContext deleteObject:obj];
        }
    }];
    
    
    if(![_appDelegate.managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
    
}


- (BOOL)isExistsCategoryName:(NSString*)catName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@", catName];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedCategoryPref"
                                              inManagedObjectContext:_appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *recordSet = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"== %@", recordSet);
    if(recordSet.count > 0)
        return YES;
    
    return NO;
}

- (FeedDB*)getByPostID:(NSString*)postID
{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link CONTAINS[cd] %@", postID];
    // http://news.wp.sg/?p=
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", [NSString stringWithFormat:@"http://news.wp.sg/?p=%@", postID]];

    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    FeedDB __block *retFeed;
    int __block length = 255;
    [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedDB *feedDB = (FeedDB*)obj;
        if(feedDB.link.length < length)
        {
            retFeed = feedDB;
            length = (int) feedDB.link.length;
        }
    }];
    
    return retFeed;
    
}

@end
