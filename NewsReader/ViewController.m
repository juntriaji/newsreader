//
//  ViewController.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "ViewController.h"
#import "FeedModel.h"
#import "FeedURL.h"

#import "FeedData.h"
#import "ViewControllerCell.h"
#import "WebViewController.h"
#import "EditFeed.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ViewControllerCellDelegate>

@property (nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic) NSArray *feeds;
@property (nonatomic) UIStoryboard *storyBoard;
@property (nonatomic) WebViewController *webViewVC;
@property (nonatomic) EditFeed *editFeed;
@property (nonatomic) FeedModel *feedModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _feedModel = [[FeedModel alloc] init];
    


    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parsingComplete:) name:@"ParsingComplete" object:nil];
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
    
}


- (void)didRotate:(NSNotification *)notification
{
    [_myTableView reloadData];
    //[_webViewVC.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    _feeds = [_feedModel getAllActive];
    _webViewVC.view.frame = _myTableView.frame;
    [_myTableView reloadData];
    
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
    FeedURL *feedUrl = [_feeds objectAtIndex:indexPath.section];
    cell.delegate = self;
    cell.feedURL = feedUrl;
    [cell reloadMyCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,30)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,0,300,30)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    FeedURL *feed = [_feeds objectAtIndex:section];
    tempLabel.text = feed.feedTitle;
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

- (void)getRSSFeedURL:(NSString *)strURL
{
    [self.view bringSubviewToFront:_webViewVC.view];
    [_webViewVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]]];
}

@end
