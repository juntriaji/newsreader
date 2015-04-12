//
//  ItemView.h
//  NewsReader
//
//  Created by Nunuk Basuki on 4/11/15.
//  Copyright (c) 2015 Nunuk Basuki. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemViewDeleagate <NSObject>

- (void)getURLTarget:(NSString*)strURL;

@end

@interface ItemView : UIView

@property (nonatomic) id <ItemViewDeleagate> delegate;
@property (nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic) IBOutlet UILabel *labelTitle;
@property (nonatomic) NSString *urlTarget;

@end
