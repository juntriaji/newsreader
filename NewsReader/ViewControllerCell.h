//
//  ViewControllerCell.h
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedURL.h"

@protocol ViewControllerCellDelegate <NSObject>

- (void)getRSSFeedURL:(NSString*)strURL;

@end

@interface ViewControllerCell : UITableViewCell

@property (nonatomic) id <ViewControllerCellDelegate> delegate;
@property (nonatomic) FeedURL *feedURL;
@property (nonatomic) NSArray *arrData;
@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSString *myCat;

- (void)reloadMyCell;

@end
