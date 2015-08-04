//
//  AppDelegate.h
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FeedDBModel.h"
#import "HttpRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, HttpRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) FeedDBModel *feedDBModel;
@property (nonatomic) HttpRequest *requestFeed;

@property (nonatomic) NSDictionary *remoteNotifDict;

- (void)refreshFeed;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

