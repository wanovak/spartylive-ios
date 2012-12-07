//
//  ClassViewController.h
//  SpartyLive
//
//  Created by Will on 11/30/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import "ContentViewController.h"
#import "ClassDetailViewController.h"

@interface ClassViewController : ContentViewController <UITableViewDelegate,
UITableViewDataSource> {
    IBOutlet UITableView* mTableView;
    NSMutableArray *feeds;
    NSMutableData *responseData;
    NSString *name;
    int state;
}

//@property (nonatomic, retain) UITableView* mTableView;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray* feeds;
@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, assign) int state;

- (IBAction)showDetail:(NSString*)url;
- (void)getJsonFromUrl:(NSString*)urlAsString;

@end
