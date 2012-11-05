//
//  MenuViewController.m
//  SpartyLive
//
//  Created by Will on 10/2/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//
//  Uses code created by Nick Harris on 2/3/12
//  Copyright (c) 2012 Sepia Labs. All rights reserved.
//

#import "MenuViewController.h"
#import "FeedViewController.h"
#import "CheckinViewController.h"

@implementation MenuViewController
@synthesize screenShotImageView, screenShotImage, tapGesture, panGesture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a UITapGestureRecognizer to detect when the screenshot recieves a single tap 
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapScreenShot:)];
    [screenShotImageView addGestureRecognizer:tapGesture];
    
    // Create a UIPanGestureRecognizer to detect when the screenshot is touched and dragged
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMoveAround:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [screenShotImageView addGestureRecognizer:panGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Remove the gesture recognizers
    [self.screenShotImageView removeGestureRecognizer:self.tapGesture];
    [self.screenShotImageView removeGestureRecognizer:self.panGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // When the menu view appears, it will create the illusion that the other view has slide to the side
    [screenShotImageView setImage:self.screenShotImage];
    [screenShotImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    // Now we'll animate it across to the right over 0.2 seconds with an Ease In and Out curve
    // - this uses blocks to do the animation. Inside the block the frame of the UIImageView has its
    // - x value changed to where it will end up with the animation is complete.
    // - this animation doesn't require any action when completed so the block is left empty
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [screenShotImageView setFrame:CGRectMake(265, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
                     completion:^(BOOL finished){  }];
}

- (void)slideThenHide
{
    // - This animates the screenshot back to the left before telling the app delegate to swap out the MenuViewController
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [screenShotImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
                     completion:^(BOOL finished){ [app_delegate hideSideMenu]; }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showFeedViewController
{
    // This sets the currentViewController on the app_delegate to the expanding view controller
    // - then slides the screenshot back over
    [app_delegate setContentViewController:[[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil]];
    [self slideThenHide];
}

- (IBAction)showCheckinController
{
    // This sets the currentViewController on the app_delegate to the expanding view controller
    // - then slides the screenshot back over
    [app_delegate setContentViewController:[[CheckinViewController alloc] initWithNibName:@"CheckinViewController" bundle:nil]];
    [self slideThenHide];
}

- (void)singleTapScreenShot:(UITapGestureRecognizer *)gestureRecognizer 
{
    // On a single tap of the screenshot, assume the user is done viewing the menu
    // - and call the slideThenHide function
    [self slideThenHide];
}


/* The following is from http://blog.shoguniphicus.com/2011/06/15/working-with-uigesturerecognizers-uipangesturerecognizer-uipinchgesturerecognizer/ */

- (void)panGestureMoveAround:(UIPanGestureRecognizer *)gesture;
{
    UIView *piece = [gesture view];
    [self adjustAnchorPointForGestureRecognizer:gesture];
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y)];
        [gesture setTranslation:CGPointZero inView:[piece superview]];
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded)
        [self slideThenHide];
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

@end
