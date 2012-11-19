//
//  FeedViewController.m
//  SpartyLive
//
//  Created by Will on 11/4/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import "FeedViewController.h"
#import "application.h"
#import "JSONKit.h"

@implementation FeedViewController

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
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        [self.logoImageView setFrame:CGRectMake(self.logoImageView.frame.origin.x, self.logoImageView.frame.origin.y, 300, 300)];
    }
                     completion:^(BOOL finished){  }];
    
    
    // Send request to API
    NSString *urlAsString = APIURL @"/Feed/latest/";
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection
     sendAsynchronousRequest: urlRequest
     queue: [[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *reponse,
                         NSData *data,
                         NSError *error)
     {
         if([data length] > 0 && error == nil)
         {
             // Result successfully received
             NSString *jsonString = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
             NSLog(@"Here is what we got: %@", jsonString);
             NSDictionary *results = [jsonString objectFromJSONString];
             NSArray *resArr = [results objectForKey:@"data"];
             
             for(NSDictionary *record in resArr)
             {
                 UITableView *tableView;
                 UITableViewCell *cell = [tableView
                                          dequeueReusableCellWithIdentifier:@"FeedCell"];
                 
                 NSString *message = [record objectForKey:@"message"];
                 NSString *firstname = [record objectForKey:@"firstname"];
                 cell.textLabel.text = message;
                 cell.detailTextLabel.text = firstname;
                 NSLog(@"First name: %@", firstname);
             }
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil)
         {
             NSLog(@"Error = %@", error);
         }
     }];
      
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

@end
