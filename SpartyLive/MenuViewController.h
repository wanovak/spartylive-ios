//
//  MenuViewController.h
//  SpartyLive
//
//  Created by Will on 10/2/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//
//  Uses code created by Nick Harris on 2/3/12
//  Copyright (c) 2012 Sepia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *screenShotImageView;
@property (strong, nonatomic) UIImage *screenShotImage;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

- (IBAction)showFeedViewController;
- (IBAction)showCheckinController;

- (void)slideThenHide;
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer ;

@end
