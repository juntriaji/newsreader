//
//  TellAFriendController.h
//  POEMSIPAD
//
//  Created by Mini OSX on 9/16/13.
//  Copyright (c) 2013 Mini OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
#import <Social/Social.h>



@interface TellAFriendController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic) AppDelegate *appDelegate;

@property (nonatomic) NSString *stringTitle;
@property (nonatomic) NSString *stringUrl;


@end
