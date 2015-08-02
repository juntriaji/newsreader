//
//  ViewControllerCell.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "ViewControllerCell.h"
#import "ItemView.h"
#import "FeedData.h"
#import "HttpRequest.h"
#import "FeedDBModel.h"
#import "FeedDB.h"


@interface ViewControllerCell() <UIScrollViewDelegate, HttpRequestDelegate, ItemViewDeleagate>

@property (nonatomic) HttpRequest *request;
@property (nonatomic) FeedDBModel *feedDBModel;

@end


@implementation ViewControllerCell

- (void)awakeFromNib {
//    _request = [[HttpRequest alloc] init];
//    _request.delegate = self;
    //NSLog(@"%lu", (unsigned long)_scrollView.subviews.count);
    
    _feedDBModel = [[FeedDBModel alloc] init];
}


- (void)getRSSFeedData:(NSArray *)datas
{
    _arrData = [NSArray arrayWithArray:datas];
    //NSLog(@"%@", _arrData);
    [_arrData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        FeedDB *fData = (FeedDB*)obj;
        //NSLog(@"%@", fData.contentEncoded);
        
        ItemView *item = (ItemView*)[[[NSBundle mainBundle] loadNibNamed:@"ItemView" owner:self options:nil] firstObject];
        item.frame = CGRectMake(item.frame.size.width * idx, 0, item.frame.size.width, _scrollView.frame.size.height);
        item.hidden = YES;
        [_scrollView addSubview:item];
        
        
        [self downloadImageWithURL:[NSURL URLWithString:fData.media] completionBlock:^(BOOL succeeded, UIImage *image) {
            item.imgView.image = image;
            [UIView transitionWithView:item
                              duration:0.6
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                item.hidden = NO;
                            } completion:nil];
        }];
        
        item.labelTitle.text = [fData.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE, dd MM yyyy HH:mm:ss ZZZ"];//Wed, 29 Jul 2015 17:37:12 +0000
        NSDate *date = [df dateFromString:fData.pubDate];
        [df setDateFormat:@"dd MMM yyyy, hh:mm a"];
        NSString *finaly = [df stringFromDate:date];
        //NSLog(@"== %@ => %@ => %@", item.labelTitle.text, finaly, fData.pubDate);
        
        NSMutableString *mutStr = [NSMutableString stringWithString:@""];
        
        NSString *css = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"style" ofType: @"css"] usedEncoding:nil error:nil];
        [mutStr appendString:@"<html><head><style>"];
        [mutStr appendString:css];
        [mutStr appendString:@"</style><body>"];
        [mutStr appendString:[NSString stringWithFormat:@"<h3>%@</h3><strong>Posted on %@</strong><br>", item.labelTitle.text, finaly]];
        [mutStr appendString:fData.contentEncoded];
        [mutStr appendString:@"</body></html>"];
        item.urlTarget = mutStr;
        item.link = fData.share_url == nil ? fData.link : fData.share_url;
        item.delegate = self;
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), _scrollView.frame.size.height);
        
    }];
    //NSLog(@"%lu", (unsigned long) _scrollView.subviews.count);

}

- (void)reloadMyCell
{
    //[_request getRSSFeed:_feedURL.feedURL];
    NSArray *data = [_feedDBModel getByCat:_myCat];
    [self getRSSFeedData:data];

}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getURLTarget:(NSString *)strURL additionData:(NSArray *)arrData
{
    [_delegate getRSSFeedURL:strURL additionData:arrData];
}

@end
