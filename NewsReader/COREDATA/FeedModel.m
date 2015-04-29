//
//  FeedModel.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "FeedModel.h"
#import "AppDelegate.h"
#import "FeedURL.h"

@implementation FeedModel

-(id)init
{
    self = [super init];
    if(self)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
        [_managedObjectContext setUndoManager:nil];
        _entity = @"FeedURL";
    }
    return self;
}

- (BOOL)checkIfExist:(NSString*)strURL
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedURL=%@", strURL];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(recordSet.count > 0) return YES;
    return NO;
}

-(NSArray*)getAllActive
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active=%@", @"1"];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return recordSet;
    
}

-(NSArray*)getAll
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return recordSet;
    
}

- (void)bulkSaveData:(NSArray *)feeds
{
    NSError *error = nil;
    [feeds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(![self checkIfExist:[obj objectAtIndex:1]])
        {
            FeedURL *feedURL = [NSEntityDescription
                                    insertNewObjectForEntityForName:_entity
                                    inManagedObjectContext:_managedObjectContext];
            feedURL.feedTitle = [obj objectAtIndex:0];
            feedURL.feedURL = [obj objectAtIndex:1];
            feedURL.active = [obj objectAtIndex:2];
        }
        
    }];
    
    if(![_managedObjectContext save:&error]){
        NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
    }
    
}


-(void)saveAll:(NSArray*)feedArray
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entity
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *recordSet = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(recordSet.count == feedArray.count)
    {
        [recordSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            FeedURL *fromDB = (FeedURL*)obj;
            FeedURL *fromUI = (FeedURL*)[feedArray objectAtIndex:idx];
            
            fromDB = fromUI; //<=== why this is dead store?
            
            
        }];
        
        
        if(![_managedObjectContext save:&error]){
            NSLog(@"Whoops error ndeng...%@", error.localizedDescription);
        }
    }
    
}



@end
