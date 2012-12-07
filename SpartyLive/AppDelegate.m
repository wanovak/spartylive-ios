//
//  AppDelegate.m
//  SpartyLive
//
//  Created by Will on 10/2/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//
//  Uses code created by Nick Harris on 2/3/12
//  Copyright (c) 2012 Sepia Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentViewController.h"
#import "FeedViewController.h"
#import "DealViewController.h"
#import "MenuViewController.h"
#import "ClassViewController.h"
#import "ClassDetailViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize contentViewController;
@synthesize menuViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create contentViewController
    self.contentViewController = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    
    // Create menuViewController
    self.menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    
    // Set the rootViewController to the contentViewController
    self.window.rootViewController = self.contentViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)showSideMenu
{    
    // Before swaping the views, we'll take a "screenshot" of the current view
    // - by rendering its CALayer into the an ImageContext then saving that off to a UIImage
    CGSize viewSize = self.contentViewController.view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
    [self.contentViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Pass this image off to the MenuViewController then swap it in as the rootViewController
    self.menuViewController.screenShotImage = image;
    self.window.rootViewController = self.menuViewController;
}

-(void)hideSideMenu
{
    // All animation takes place elsewhere. When this gets called just swap the contentViewController in
    self.window.rootViewController = self.contentViewController;
}

@end
