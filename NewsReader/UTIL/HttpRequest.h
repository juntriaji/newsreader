//
//  HttpRequest.h
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpRequestDelegate <NSObject>

- (void)getRSSFeedData:(NSArray*)datas;

@end

@interface HttpRequest : NSObject <NSXMLParserDelegate>

@property (nonatomic) id <HttpRequestDelegate> delegate;
@property (nonatomic) NSMutableArray *feedArr;


- (void)getRSSFeed:(NSString*)strURL;

@end

