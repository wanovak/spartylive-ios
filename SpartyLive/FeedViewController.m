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
@synthesize mTableView;
@synthesize feeds;
@synthesize responseData;

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
             
             [responseData appendData:data];
             self->feeds = [[NSMutableArray alloc] initWithArray:resArr];
             [self.mTableView reloadData];
         }
         else if ([data length] == 0 && error == nil)
         {
             [responseData setLength:0];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    //
    // @todo this is hacky... can't get member variable with correct context otherwise
    // side-effects: view must be interacted with before loading ends
    //
    self.mTableView = tableView;
    
    int count = self->feeds.count;
    
    if(count == 0)
    {
        return 15;
    }
    
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self->feeds count];
    
    if(nodeCount == 0 && indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:PlaceholderCellIdentifier];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.detailTextLabel.text = @"Loading...";
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(nodeCount > 0)
    {
    
        NSDictionary *dictionary = [self->feeds objectAtIndex:indexPath.row];
        NSString *message = [dictionary objectForKey:@"message"];
        NSString *firstname = [dictionary objectForKey:@"firstname"];
        NSString *lastname = [dictionary objectForKey:@"lastname"];
        NSString *thumbnail = [dictionary objectForKey:@"thumbnail"];
        NSURL *thumbURL = [NSURL URLWithString:thumbnail];
        NSLog(@"Cell first name: %d", indexPath.row);
    
        // Set up the cell...
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        cell.textLabel.text = [NSString	 stringWithFormat:@"%@", message];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
        cell.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:thumbURL]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// open a alert with an OK and cancel button
	//NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
	//[alert show];
	//[alert release];
    NSLog(@"Click event on feed");
}

@end
