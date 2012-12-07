//
//  ClassDetailViewController.h
//  SpartyLive
//
//  Created by Will on 12/7/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface ClassDetailViewController : ContentViewController {
    NSMutableString* viewData;
    IBOutlet UILabel* updateText;
}

@property (nonatomic, strong) NSMutableString* viewData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSString*)data;
@property (nonatomic, retain) IBOutlet UILabel *updateText;

@end
