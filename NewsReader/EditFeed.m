//
//  EditFeed.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/12/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "EditFeed.h"
#import "FeedDBModel.h"
#import "FeedCategoryPref.h"
#import "FeedURL.h"
#import "EditFeedCell.h"
#import "GraphUtil.h"
#import "AppDelegate.h"

@interface EditFeed ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic) IBOutlet UIButton *buttonOK;
@property (nonatomic) FeedDBModel *feedDBModel;
@property (nonatomic) NSMutableArray *feedUrl;
@property (nonatomic) NSArray *sectionTable;
@property (nonatomic) NSMutableArray *contentTable;

@property (nonatomic) NSMutableDictionary *dictPlist;
@property (nonatomic) NSString *pathPlist;

@end

@implementation EditFeed

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _feedDBModel = [[FeedDBModel alloc] init];
    
    [GraphUtil createBordersWithCorderRadius:_buttonOK color:[UIColor whiteColor] radius:5];
    
    
    _sectionTable = @[@"Push Notification", @"News"];
    NSArray *tmpArr = @[
                      @[
                      @[@"Push Setting", @"Push Notification is On"]],
                      @[
                          @[@"Category Preferences",@"Change preferred Categories to be displayed"]
                          ]
                      
                      ];
    
    _contentTable = [NSMutableArray arrayWithArray:tmpArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //
    _pathPlist = [[_appDelegate applicationDocumentsDirectory].path stringByAppendingPathComponent:@"Pref.plist"];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager isWritableFileAtPath:_pathPlist])
    {
        _dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_pathPlist];
    }
    else
    {
        _dictPlist = [NSMutableDictionary dictionary];
    }

    NSArray *catPref = [_feedDBModel getAllCatPref];
    NSMutableArray *tmpArr = [NSMutableArray array];
    [catPref enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FeedCategoryPref *pref = (FeedCategoryPref*)obj;
        NSArray *val = @[pref.categoryName, [pref.enabled stringValue]];
        [tmpArr addObject:val];
    }];
    [_contentTable replaceObjectAtIndex:1 withObject:tmpArr];
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
    NSArray *feed = [_contentTable objectAtIndex:indexPath.section];
    
    if(indexPath.section == 0)
    {
        //cell.buttonActive.selected = !cell.buttonActive.selected;
        
        if(indexPath.row == 0)
        {
            //NSLog(@"%@", _dictPlist);
            
            if([_dictPlist valueForKey:@"PushNotification"] != nil)
                cell.buttonActive.selected = [[_dictPlist valueForKey:@"PushNotification"] isEqual:@1] ? YES : NO;
            else
                cell.buttonActive.selected = YES;
            cell.labelTitleFeed.text = @"Push Setting";
            cell.labelURLFeed.text = cell.buttonActive.selected ? @"Push Notification is On" : @"Push Notification is Off";
        }
        
    }
    else{
        
        cell.labelTitleFeed.text = [[feed objectAtIndex:indexPath.row] objectAtIndex:0];
        NSString *enabled =[[feed objectAtIndex:indexPath.row] objectAtIndex:1];
        if([enabled isEqualToString:@"1"])

        {
            cell.labelURLFeed.text = @"Enabled";
        }
        else
        {
            cell.labelURLFeed.text = @"Disabled";
        }
        cell.buttonActive.selected = [enabled isEqualToString:@"1"] ? YES : NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedURL *feed = [_feedUrl objectAtIndex:indexPath.row];
    feed.active = [feed.active isEqualToString:@"1"] || feed.active == nil ? @"0" : @"1";
    [_feedUrl replaceObjectAtIndex:indexPath.row withObject:feed];
    
    EditFeedCell *cell = (EditFeedCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.buttonActive.selected = ! cell.buttonActive.selected;
    
    if(indexPath.section == 1)
    {
        
        if(cell.buttonActive.selected)
        {
            cell.labelURLFeed.text = @"Enabled";
            [_feedDBModel updateCatPref:cell.labelTitleFeed.text value:@1];
        }
        else
        {
            cell.labelURLFeed.text = @"Disabled";
            [_feedDBModel updateCatPref:cell.labelTitleFeed.text value:@0];
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            cell.labelURLFeed.text = cell.buttonActive.selected ? @"Push Notification is On" : @"Push Notification is Off";
            [_dictPlist setValue:[NSNumber numberWithBool:cell.buttonActive.selected] forKey:@"PushNotification"];
            
        }
        
        [_dictPlist writeToFile:_pathPlist atomically:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *selection = [[UIView alloc] init];
    selection.backgroundColor = [UIColor colorWithRed:43.0/255.0f green:81.0/255.0f blue:154.0/255.0f alpha:0.4];
    cell.selectedBackgroundView = selection;
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)buttonAction:(UIButton*)sender
{
    //[_feedModel saveAll:[NSArray arrayWithArray:_feedUrl]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
