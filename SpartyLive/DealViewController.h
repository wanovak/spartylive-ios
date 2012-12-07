//
//  DealViewController.h
//  SpartyLive
//
//  Created by Will on 11/4/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import "ContentViewController.h"

@interface DealViewController : ContentViewController <UITableViewDelegate,
    UITableViewDataSource> {
    IBOutlet UITableView* mTableView;
    NSMutableArray *deals;
    NSMutableData *responseData;
}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray* deals;
@property (nonatomic, strong) NSMutableData* responseData;

- (void)getJsonFromUrl:(NSString*)urlAsString;

@end
