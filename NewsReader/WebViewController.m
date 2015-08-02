//
//  WebViewController.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "WebViewController.h"
#import "ColorUtil.h"
#import "TellAFriendController.h"
#import "ViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet UIView *viewHeader;
@property (nonatomic) TellAFriendController *tellFriend;
@property (nonatomic) UIPopoverController *popOver;
@property (nonatomic) IBOutlet UIButton *buttonShare;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:_activityIndicator];
    [self.view bringSubviewToFront:_activityIndicator];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    [_viewHeader setBackgroundColor:[ColorUtil colorFromHexString:@"#1293c9"]];
    
    _tellFriend = [[TellAFriendController alloc] init];
    _tellFriend.view.hidden = YES;
    [self.view addSubview:_tellFriend.view];
    [self addChildViewController:_tellFriend];
    
}


- (void)didRotate:(id)sender
{
    _activityIndicator.center = self.view.center;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonAcction:(UIButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            if (_tellFriend.view.hidden)
            {
                [UIView transitionWithView:self.view
                                  duration:0.3f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.view.hidden = YES;
                                } completion:^(BOOL finished) {
                                    [_webView loadHTMLString:@"" baseURL:[[NSURL alloc] init]];
                                }];
            }
            {
                _tellFriend.view.hidden = YES;
            }
            
            break;
        }
        case 2:
        {
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                ViewController *vwc = (ViewController*)self.parentViewController;
                vwc.tellFriend.stringTitle = [_arrData objectAtIndex:0];
                vwc.tellFriend.stringUrl = [_arrData objectAtIndex:1];

                [vwc.popOver presentPopoverFromRect:_buttonShare.frame inView:vwc.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
            }
            else
            {
                _tellFriend.stringTitle = [_arrData objectAtIndex:0];
                _tellFriend.stringUrl = [_arrData objectAtIndex:1];
                _tellFriend.view.frame = _webView.frame;
                [UIView transitionWithView:self.view
                                  duration:0.3f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    _tellFriend.view.hidden = NO;
                                    [self.view bringSubviewToFront:_tellFriend.view];
                                } completion:nil];
            }
            
            break;
        }
        default:
            break;
    }

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
}

@end
