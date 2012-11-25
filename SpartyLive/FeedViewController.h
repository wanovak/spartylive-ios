//
//  FeedViewController.h
//  SpartyLive
//
//  Created by Will on 11/4/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import "ContentViewController.h"

@interface FeedViewController : ContentViewController <UITableViewDelegate,
UITableViewDataSource> {
    IBOutlet UITableView* mTableView;
    NSArray *feeds;
    NSMutableData *responseData;
    NSString *name;
}

@property (nonatomic, retain) UITableView* mTableView;
@property (nonatomic, strong) NSArray* feeds;
@property (nonatomic, strong) NSMutableData* responseData;

@end
