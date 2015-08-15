//
//  TellAFriendController.m
//  POEMSIPAD
//
//  Created by Mini OSX on 9/16/13.
//  Copyright (c) 2013 Mini OSX. All rights reserved.
//

#import "TellAFriendController.h"
#import <AddressBook/AddressBook.h>
#import "GraphUtil.h"
#import "ColorUtil.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface TellAFriendController ()

@property (nonatomic) UITapGestureRecognizer *tap;

@end

@implementation TellAFriendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tell a friend.";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [_tap setNumberOfTapsRequired:1];
    _tap.cancelsTouchesInView = NO;

    self.preferredContentSize = self.view.frame.size;
//    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//    content.contentURL = [NSURL
//                          URLWithString:@"https://www.facebook.com/FacebookDevelopers"];
//    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
//    button.shareContent = content;
//    [self.view addSubview:button];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            // Remove the recognizer first so it's view.window is valid.
            [self.view.window removeGestureRecognizer:sender];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark - Mail Composer Init

- (void)displayMailComposer:(NSString*)strTitle strUrl:(NSString*)strUrl
{
    NSLog(@"display composer");
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Workers' Party News"];
    NSMutableString *mutString = [NSMutableString stringWithString:strTitle];
    [mutString appendString:@". Read more at "];
    [mutString appendString:strUrl];
    [mailComposer setMessageBody:mutString isHTML:NO];
    mailComposer.modalTransitionStyle  = UIModalTransitionStyleCrossDissolve;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        
        [self presentViewController:mailComposer animated:YES completion:^{
            [mailComposer.view.window addGestureRecognizer:_tap];
        }];
    }else{
        [self.parentViewController.parentViewController presentViewController:mailComposer animated:YES completion:^{
            [mailComposer.view.window addGestureRecognizer:_tap];
        }];
    }
    
    
}

#pragma mark - SMS Composer Init
- (void)displaySMSComposer
{
    MFMessageComposeViewController *smsComposer = [[MFMessageComposeViewController alloc] init];
    smsComposer.messageComposeDelegate = self;
    //[smsComposer setBody:[_appDelegate.configDefault valueForKey:@"tellFriendString"]];
    smsComposer.modalTransitionStyle  = UIModalTransitionStyleCrossDissolve;
    smsComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:smsComposer animated:YES completion:^{
        [smsComposer.view.window addGestureRecognizer:_tap];
    }];
}

#pragma mark - Display AddressBook

- (void)displayAddressBook
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.modalTransitionStyle  = UIModalTransitionStyleCrossDissolve;
    picker.modalPresentationStyle = UIModalPresentationFormSheet;
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{
        [picker.view.window addGestureRecognizer:_tap];
    }];
}

#pragma mark - Tap Action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Your device not configured to perform this action." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];

    UITouch *touch = [touches anyObject];
    if([[self.view viewWithTag:touch.view.tag] isKindOfClass:[UIImageView class]])
    {
        UIImageView *imgView = (UIImageView*)[self.view viewWithTag:touch.view.tag];
        [UIView animateWithDuration:0.3
                         animations:^{
                             imgView.backgroundColor = [ColorUtil lightBlueColor];
                             imgView.backgroundColor = [UIColor clearColor];
                         }];
    }
    
    switch (touch.view.tag) {
        case 1:
        {
            [self displayAddressBook];
            break;
        }
        case 2:
        {
            if([MFMailComposeViewController canSendMail])
                
                [self displayMailComposer:_stringTitle strUrl:_stringUrl];
            
            else
                [alert show];
            break;
        }
        case 3:
        {
            if([MFMessageComposeViewController canSendText])
                [self displaySMSComposer];
            else
                [alert show];
            break;
        }
        case 4:
        {
            //[self sendViaService:SLServiceTypeFacebook stringTitle:_stringTitle stringURL:_stringUrl];
            
            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL
                                  URLWithString:_stringUrl];
            content.contentTitle = _stringTitle;
            
            [FBSDKShareDialog showFromViewController:self
                                         withContent:content
                                            delegate:nil];
            break;
        }
        case 5:
        {
            [self sendViaService:SLServiceTypeTwitter stringTitle:_stringTitle stringURL:_stringUrl];
            break;
        }
            
        default:
        {
            break;
        }
    }

}

#pragma mark - Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	switch (result)
	{
		case MFMailComposeResultCancelled:
			alert.message = @"Mail sending canceled";
			break;
		case MFMailComposeResultSaved:
			alert.message = @"Mail saved";
			break;
		case MFMailComposeResultSent:
			alert.message = @"Mail sent";
			break;
		case MFMailComposeResultFailed:
			alert.message = @"Mail sending failed";
			break;
		default:
			alert.message = @"Mail not sent";
			break;
	}
    [controller.view.window removeGestureRecognizer:_tap];
    [alert show];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    /*
     MessageComposeResultCancelled,
     MessageComposeResultSent,
     MessageComposeResultFailed

     */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            alert.message = @"Message Canceled.";
            break;
        }
        case MessageComposeResultSent:
        {
            alert.message = @"Message Sent.";
            break;
        }
        case MessageComposeResultFailed:
        {
            alert.message = @"Send Message Failed.";
            break;
        }
        default:
            alert.message = @"Send Message Failed.";
            break;
    }
    [controller.view.window removeGestureRecognizer:_tap];
    [alert show];
}

#pragma mark - AddressBok Delegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self displayPerson:person];
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker.view.window removeGestureRecognizer:_tap];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    [self callContact:phone];
    CFRelease(phoneNumbers);
}

- (void)callContact:(NSString*)phoneNumber
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"INFO:" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
}
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self dismissViewControllerAnimated:YES completion:nil];
    //self.view.hidden = YES;
    
}


#pragma mark - SocialComposeController

- (void)sendViaService:(NSString*)serviceType stringTitle:(NSString*)strTitle stringURL:(NSString*)strURL
{
    if([SLComposeViewController isAvailableForServiceType:serviceType])
    {
        SLComposeViewController *socialComposeController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        NSMutableString *mutString = [NSMutableString stringWithString:@"Workers' Party News\n\n"];
        [mutString appendString:strTitle];
        [mutString appendString:@". Read more at "];
        [mutString appendString:strURL];

        [socialComposeController setInitialText:mutString];
                
        [socialComposeController addURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [self presentViewController:socialComposeController animated:YES completion:nil];
    }
    else
        [[[UIAlertView alloc] initWithTitle:@"INFO" message:@"Your device can't use this feature. Install appropriate apps." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}




@end
