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


@interface ViewControllerCell() <UIScrollViewDelegate, HttpRequestDelegate, ItemViewDeleagate>

@property (nonatomic) HttpRequest *request;

@end

@implementation ViewControllerCell

- (void)awakeFromNib {
    // Initialization code
    /*
    NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.poems.co.id/image/patterns/%@.png", [arr objectAtIndex:0]]];
    
    [self downloadImageWithURL:urlImage completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            CGRect frame = cell.imageVw.frame;
            frame.size.height = image.size.height;
            frame.size.width  = image.size.width;
            frame.origin.y = (cell.contentView.frame.size.height - image.size.height)/ 2;
            cell.imageVw.frame = frame;
            cell.imageVw.image = image;
        }
    }];
     */
    _request = [[HttpRequest alloc] init];
    _request.delegate = self;
    
    //[_request getRSSFeed:_feedURL.feedURL];
    
}


- (void)getRSSFeedData:(NSArray *)datas
{
    
    _arrData = [NSArray arrayWithArray:datas];
    [datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        FeedData *fData = (FeedData*)obj;
        ItemView *item = (ItemView*)[[[NSBundle mainBundle] loadNibNamed:@"ItemView" owner:self options:nil] firstObject];
        item.frame = CGRectMake(item.frame.size.width * idx, 0, item.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:item];
        
        [self downloadImageWithURL:[NSURL URLWithString:fData.media] completionBlock:^(BOOL succeeded, UIImage *image) {
            item.imgView.image = image;
        }];
        
        item.labelTitle.text = [fData.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        item.urlTarget = [fData.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        item.delegate = self;

        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), _scrollView.frame.size.height);
    }];

}

- (void)reloadMyCell
{
    [_request getRSSFeed:_feedURL.feedURL];

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

- (void)getURLTarget:(NSString *)strURL
{
    [_delegate getRSSFeedURL:strURL];
}

@end
