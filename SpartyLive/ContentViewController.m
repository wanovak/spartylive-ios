//
//  ContentViewController.m
//  SpartyLive
//
//  Created by Will on 10/2/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//
//  Uses code created by Nick Harris on 2/3/12
//  Copyright (c) 2012 Sepia Labs. All rights reserved.
//

#import "ContentViewController.h"

@implementation ContentViewController
@synthesize logoImageView;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)slideMenuButtonTouched
{
    [app_delegate showSideMenu];
}

@end
