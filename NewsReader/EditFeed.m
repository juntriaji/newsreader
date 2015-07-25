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
@property (nonatomic) NSArray *sectionTable;
@property (nonatomic) NSArray *contentTable;

@end

@implementation EditFeed

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _feedModel = [[FeedModel alloc] init];
    
    [_buttonOK setBackgroundImage:[GraphUtil imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [GraphUtil createButtonShadow:_buttonOK withBgColor:[UIColor redColor] withBorderColor:[UIColor clearColor]];
    
    _sectionTable = @[@"Push Notification", @"News"];
    _contentTable = @[
                      @[
                      @[@"Push Notification", @"Push Notification is On"],
                        @[@"Sound", @"Push Notification Sound is Enabled"],
                      @[@"Vibrate", @"Vibrate on Push Notifications is Enabled"]],
                      @[
                          @[@"Category Preferences",@"Change preferred Categories to be displayed"]]
                      
                      ];
    NSLog(@"%@", _contentTable);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    
    //_feedUrl = [NSMutableArray arrayWithArray:[_feedModel getAll]];
    
    [_myTableView reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTable.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_contentTable objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,30)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,0,300,30)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor blackColor]; //here you can change the text color of header.
    //FeedURL *feed = [_feeds objectAtIndex:section];
    tempLabel.text = [_sectionTable objectAtIndex:section];
    [tempView addSubview:tempLabel];
    
    return tempView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EditFeedCell" owner:self options:nil] firstObject];
    }
    //NSLog(@"-- %li", indexPath.section);
    NSArray *feed = [_contentTable objectAtIndex:indexPath.section];
    //NSLog(@"%@", feed);
    cell.labelTitleFeed.text = [[feed objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.labelURLFeed.text = [[feed objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.buttonActive.selected = !cell.buttonActive.selected;
    
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
