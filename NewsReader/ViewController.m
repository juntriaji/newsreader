//
//  ViewController.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "ViewController.h"
#import "FeedURL.h"

#import "FeedData.h"
#import "ViewControllerCell.h"
#import "WebViewController.h"
#import "EditFeed.h"
#import "ODRefreshControl.h"
#import "ColorUtil.h"
#import "FeedDBModel.h"
#import "FeedDB.h"
#import "AppDelegate.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ViewControllerCellDelegate>

@property (nonatomic) IBOutlet UIView *viewHeader;

@property (nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic) NSArray *feeds;
@property (nonatomic) UIStoryboard *storyBoard;
@property (nonatomic) WebViewController *webViewVC;
@property (nonatomic) EditFeed *editFeed;
@property (nonatomic) ODRefreshControl *refreshControl;
@property (nonatomic) FeedDBModel *feedDBModel;
@property (nonatomic) AppDelegate *appDelegate;
//@property (nonatomic)

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        //NSLog(@"here");
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    _feedDBModel = [[FeedDBModel alloc] init];
    
    _myTableView.sectionIndexColor = [UIColor whiteColor];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    
    _storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    _webViewVC = [_storyBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    _webViewVC.view.hidden = YES;
 
    [self.view addSubview:_webViewVC.view];
    
    _editFeed = [_storyBoard instantiateViewControllerWithIdentifier:@"EditFeed"];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_myTableView];
    [_refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    
    [_viewHeader setBackgroundColor:[ColorUtil colorFromHexString:@"#1293c9"]];
    
    [self addChildViewController:_webViewVC];
    
    _tellFriend = [[TellAFriendController alloc] init];
    _tellFriend.view.backgroundColor = [UIColor whiteColor];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        _popOver = [[UIPopoverController alloc] initWithContentViewController:_tellFriend];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPostID:) name:@"PostID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openTheBrowser) name:@"PostIDInactive" object:nil];
    

}



- (void)didRotate:(NSNotification *)notification
{
    
    //_refreshControl = [[ODRefreshControl alloc] initInScrollView:_myTableView];
    //[_refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [_myTableView reloadData];
}

- (void)refreshAction:(id)sender
{
    [_appDelegate refreshFeed];
    [self getCategory];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStop:) userInfo:nil repeats:NO];
}

- (void)timerStop:(id)sender
{
    [_refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_appDelegate refreshFeed];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    [self getCategory];
    _webViewVC.view.frame = self.view.frame;
    [_myTableView reloadData];
    
    // test
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerTest:) userInfo:nil repeats:NO];

}


- (void)timerTest:(NSTimer*)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //test
    _appDelegate.remoteNotifDict = @{@"aps": @{@"alert" : @"this is the Title"}, @"post_id" : @"170"};
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PostIDInactive" object:self userInfo:_appDelegate.remoteNotifDict] ;
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PostID" object:self userInfo:_appDelegate.remoteNotifDict] ;
    
}


- (void)getPostID:(NSNotification*)sender
{

    // @"Workers' Party News"
    NSDictionary *dict = [sender userInfo];
    NSString *title = [[dict valueForKey:@"aps"] valueForKey:@"alert"];
    if([dict valueForKey:@"post_id"] != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Workers' Party News" message:title delegate:self cancelButtonTitle:@"Read" otherButtonTitles:@"Skip", nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Workers' Party News" message:title delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag = 2;
        [alert show];
        
    }
    
}

- (void)openTheBrowser
{
    FeedDB *db = [_feedDBModel getByPostID:[_appDelegate.remoteNotifDict valueForKey:@"post_id"]];
    
    if(db == nil)
    {
        [_appDelegate refreshFeed];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGetPostID) userInfo:nil repeats:NO];
    }
    else
    {
        [self showwebView:db];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
        {
            if(buttonIndex == 0)
                [self openTheBrowser];
            break;
        }
        default:
            break;
    }
}


- (void)timerGetPostID
{
    FeedDB *db = [_feedDBModel getByPostID:[_appDelegate.remoteNotifDict valueForKey:@"post_id"]];
    if(db != nil)
        [self showwebView:db];
    else
        [[[UIAlertView alloc] initWithTitle:@"Workers' Party News" message:@"Error, can not fetch the content." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)buttonAction:(UIButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            [UIView transitionWithView:_webViewVC.view duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                _webViewVC.view.hidden = YES;
                            } completion:nil];

            break;
        }
        case 2:
        {
            if(_webViewVC.view.hidden == NO)
            {
                [_webViewVC.webView reload];
            }
            else
            {
                [_myTableView reloadData];
            }
            break;
        }
        case 3:
        {
            [self presentViewController:_editFeed animated:YES completion:nil];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - HTTP REq DElegate
//- (void)getRSSFeedData:(NSArray *)datas
//{
//    NSLog(@"%@", datas);
//    [_feedDBModel bulkSaveData:datas];
//    
//    [self getCategory];
//    
//}


- (void)getCategory
{
    [_feedDBModel getCategory];
    _feeds = [_feedDBModel getAllCatPrefActive];
    if(_feeds.count == 0)
    {
        //NSLog(@"triger timer");
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCategory) userInfo:nil repeats:NO];
    }
    [_myTableView reloadData];
}

#pragma mark - TableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _feeds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewControllerCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = (ViewControllerCell*)[[[NSBundle mainBundle] loadNibNamed:@"ViewControllerCell" owner:self options:nil] firstObject];
        //cell = [[UITableViewCell alloc] init];
    }
    //FeedURL *feedUrl = [_feeds objectAtIndex:indexPath.section];
    cell.delegate = self;
    cell.myCat = [_feeds objectAtIndex:indexPath.section];
    [cell reloadMyCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,30)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,0,300,30)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor blackColor]; //here you can change the text color of header.
    //FeedURL *feed = [_feeds objectAtIndex:section];
    tempLabel.text = [_feeds objectAtIndex:section];
    [tempView addSubview:tempLabel];
    
    return tempView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)showwebView:(FeedDB*)fData
{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy, hh:mm a"];
    NSString *finaly = [df stringFromDate:fData.pubDate];
    //NSLog(@"== %@ => %@ => %@", item.labelTitle.text, finaly, fData.pubDate);
    
    NSMutableString *mutStr = [NSMutableString stringWithString:@""];
    
    NSString *css = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"style" ofType: @"css"] usedEncoding:nil error:nil];
    [mutStr appendString:@"<html><head><style>"];
    [mutStr appendString:css];
    [mutStr appendString:@"</style><body>"];
    [mutStr appendString:[NSString stringWithFormat:@"<h3>%@</h3><strong>Posted on %@</strong><br>", fData.title, finaly]];
    [mutStr appendString:fData.contentEncoded];
    [mutStr appendString:@"</body></html>"];
    
    NSString *link = fData.share_url == nil ? fData.link : fData.share_url;
    
    [self.view bringSubviewToFront:_webViewVC.view];
    _webViewVC.arrData = @[fData.title, link];
    [UIView transitionWithView:self.view
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _webViewVC.view.hidden = NO;
                    } completion:^(BOOL finished) {
                        [_webViewVC.webView loadHTMLString:mutStr baseURL:[[NSURL alloc] init]];
                    }];

    
}

- (void)getRSSFeedURL:(NSString *)strURL additionData:(NSArray*)arrData
{
    //NSLog(@"%@ %@", arrData, strURL);
    [self.view bringSubviewToFront:_webViewVC.view];
    _webViewVC.arrData = arrData;
    [UIView transitionWithView:self.view
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _webViewVC.view.hidden = NO;
                    } completion:^(BOOL finished) {
                        //[_webViewVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]]];
                        
                        [_webViewVC.webView loadHTMLString:strURL baseURL:[[NSURL alloc] init]];
                    }];

}

@end
