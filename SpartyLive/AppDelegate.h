//
//  AppDelegate.h
//  SpartyLive
//
//  Created by Will on 10/2/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//
//  Uses code created by Nick Harris on 2/3/12
//  Copyright (c) 2012 Sepia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define app_delegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class ContentViewController, MenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ContentViewController *contentViewController;
@property (strong, nonatomic) MenuViewController *menuViewController;

- (void)showSideMenu;
- (void)hideSideMenu;

@end
