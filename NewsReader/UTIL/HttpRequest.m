//
//  HttpRequest.m
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import "HttpRequest.h"
#import "FeedData.h"


dispatch_queue_t backgroundQueue;

@interface HttpRequest()

@property (nonatomic) id currentElement;
@property (nonatomic) NSMutableString *currentElementData;

@end


@implementation HttpRequest

-(id)init
{
    self = [super init];
    if(self){
        //default Init
        backgroundQueue = dispatch_queue_create("dispatch.name.req", 0);
        _feedArr = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Private Method
- (void)getRSSFeed:(NSString*)strURL
{
    NSURL *url = [[NSURL alloc] initWithString:strURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    dispatch_async(backgroundQueue, ^{
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if(connectionError == nil && data.length > 0)
            {
                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                parser.shouldProcessNamespaces = NO;
                parser.shouldResolveExternalEntities = NO;
                parser.shouldReportNamespacePrefixes = NO;
                parser.delegate = self;
                if ([parser parse]) {
                    [_delegate getRSSFeedData:[NSArray arrayWithArray:_feedArr]];
                }
                
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"ParsingComplete"
                 object:nil];

                
            }
            else
            {
                NSLog(@"ERROR CONNECTION: %@", [connectionError localizedDescription]);
                
            }
            
        }];
    });
    
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"item"]) {
        FeedData *fData = [[FeedData alloc] init];
        [_feedArr addObject:fData];

        _currentElement = fData;
        return;
        
    }
    
    //BBC & CNN
    if([elementName isEqualToString:@"media:thumbnail"])
    {
        FeedData *fData = (FeedData*)_currentElement;
        fData.media = [[attributeDict valueForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
//    if([elementName isEqualToString:@"content:encoded"])
//    {
//        FeedData *fData = (FeedData*)_currentElement;
//        NSLog(@"%@", attributeDict);
//        //fData.media = [[attributeDict valueForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    }
    // CNN
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (_currentElementData == nil) {
        self.currentElementData = [[NSMutableString alloc] init];
    }
    
    [_currentElementData appendString:string];
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if(![elementName isEqualToString:@"description"])
    {
        SEL selectorName = NSSelectorFromString(elementName);
        
        if ([_currentElement respondsToSelector:selectorName]) {
            [_currentElement setValue:_currentElementData forKey:elementName];
        }
        
        if([elementName isEqualToString:@"content:encoded"])
        {
            FeedData *fData = (FeedData*)_currentElement;
            fData.contentEncoded =  _currentElementData;
        }
        //NSLog(@"%@", elementName);
    }
    
    _currentElementData = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *info = [NSString stringWithFormat:
                      @"Error %li, Description: %@, Line: %li, Column: %li",
                      (long)[parseError code],
                      [[parser parserError] localizedDescription],
                      (long)[parser lineNumber],
                      (long)[parser columnNumber]];
    
    NSLog(@"RSS Feed Parse Error: %@", info);
}

@end


