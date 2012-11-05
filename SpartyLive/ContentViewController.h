//
//  ContentViewController.h
//  SpartyLive
//
//  Created by Will on 10/2/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//
//  Uses code created by Nick Harris on 2/3/12
//  Copyright (c) 2012 Sepia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (strong, atomic) IBOutlet UIImageView *logoImageView;

- (IBAction)slideMenuButtonTouched;

@end
