//
//  AppDelegate.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>
#import "ColorUtil.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@property (nonatomic) NSString *pathPlist;
@property (nonatomic) NSDictionary *dictPlist;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self defaultFeeds];
    
    [ParseCrashReporting enable];
    
    
    [Parse setApplicationId:@"Ejn1u9YxslHL3fqndhEPV7BPcpMvY3o9BAoMPJhJ"
                  clientKey:@"oMw04chHGQvyPumdhF2D9IZV5c8twHSGZzVCNvbz"];
    
    [self registerToAPNs];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    

    _pathPlist = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"Pref.plist"];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager isWritableFileAtPath:_pathPlist])
    {
        _dictPlist = [NSDictionary dictionaryWithContentsOfFile:_pathPlist];
    }
    
    //return [[FBSDKApplicationDelegate sharedInstance] application:application
    //                                didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
    
}

// FACEBOOK

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //return [[FBSDKApplicationDelegate sharedInstance] application:application
    //                                                      openURL:url
    //                                            sourceApplication:sourceApplication
    //                                                   annotation:annotation
    //        ];
    
    return YES;
}



// APN Register

- (void)registerToAPNs
{
    //NSLog(@"register");
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0)
        UIUserNotificationSettings *notifSet = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge| UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notifSet];
    
#else
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    //NSLog(@"token %@", deviceToken);
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    _remoteNotifDict = userInfo;
//    if(_dictPlist != nil && [[_dictPlist valueForKey:@"PushNotification"] isEqual:@1])
//    {
    
        //save captured post id into persistence
    
        NSString *postId = [userInfo objectForKey:@"postId"];

        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
        [preferences setObject:postId forKey:@"postId"];
    
    
        if(application.applicationState == UIApplicationStateInactive) {
            
            //NSLog(@"Inactive");
            
            //Show the view with the content of the push
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostIDInactive" object:self userInfo:userInfo] ;

            
            
        } else if (application.applicationState == UIApplicationStateBackground) {
            
            //NSLog(@"Background");
            
            //Refresh the local model
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostIDInactive" object:self userInfo:userInfo] ;

            
            
        } else {
            
            //NSLog(@"Active");
            
            //Show an in-app banner
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostID" object:self userInfo:userInfo] ;
        }
//    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[NSNotificationCenter defaultCenter] postNotificationName:@"PostID" object:self userInfo:userInfo]
    //[FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "kecepit.NewsReader" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewsReader" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NewsReader.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Custom calls

- (void)defaultFeeds
{
    _requestFeed = [[HttpRequest alloc] init];
    _requestFeed.delegate = self;
    _feedDBModel = [[FeedDBModel alloc] init];

}

- (void)refreshFeed
{
    [_requestFeed getRSSFeed:@"http://news.wp.sg/?feed=rss2"];
    
}
#pragma mark - HTTP REq DElegate
- (void)getRSSFeedData:(NSArray *)datas
{
    [_feedDBModel bulkSaveData:datas];
}

@end
