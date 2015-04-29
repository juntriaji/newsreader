//
//  EditFeed.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/12/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "EditFeed.h"
#import "FeedModel.h"
#import "FeedURL.h"
#import "EditFeedCell.h"
#import "GraphUtil.h"

@interface EditFeed ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic) IBOutlet UIButton *buttonOK;
@property (nonatomic) FeedModel *feedModel;
@property (nonatomic) NSMutableArray *feedUrl;

@end

@implementation EditFeed

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _feedModel = [[FeedModel alloc] init];
    
    [_buttonOK setBackgroundImage:[GraphUtil imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [GraphUtil createButtonShadow:_buttonOK withBgColor:[UIColor redColor] withBorderColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    
    _feedUrl = [NSMutableArray arrayWithArray:[_feedModel getAll]];
    
    [_myTableView reloadData];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feedUrl.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EditFeedCell" owner:self options:nil] firstObject];
    }
    FeedURL *feed = [_feedUrl objectAtIndex:indexPath.row];
    cell.labelTitleFeed.text = [feed.feedTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.labelURLFeed.text = [feed.feedURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.buttonActive.selected = [feed.active isEqualToString:@"1"] || feed.active == nil ? YES : NO;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedURL *feed = [_feedUrl objectAtIndex:indexPath.row];
    feed.active = [feed.active isEqualToString:@"1"] || feed.active == nil ? @"0" : @"1";
    [_feedUrl replaceObjectAtIndex:indexPath.row withObject:feed];
    
    EditFeedCell *cell = (EditFeedCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.buttonActive.selected = ! cell.buttonActive.selected;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *selection = [[UIView alloc] init];
    selection.backgroundColor = [UIColor colorWithRed:43.0/255.0f green:81.0/255.0f blue:154.0/255.0f alpha:0.4];
    cell.selectedBackgroundView = selection;
}

- (IBAction)buttonAction:(UIButton*)sender
{
    [_feedModel saveAll:[NSArray arrayWithArray:_feedUrl]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
