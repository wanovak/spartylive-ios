//
//  ClassViewController.m
//  SpartyLive
//
//  Created by Will on 11/30/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassDetailViewController.h"
#import "application.h"
#import "JSONKit.h"

@implementation ClassViewController
@synthesize mTableView;
@dynamic feeds;
@synthesize responseData;
@dynamic state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Set the state to initial
        state = 0;
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
    NSString *urlAsString = APIURL @"/classes/listings/";
    [self getJsonFromUrl:urlAsString];
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
    //mTableView = tableView;
    
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
        // Set up the cell...
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        
        if(self->state == 0)
        {
            NSString *course = [dictionary objectForKey:@"name"];
            NSLog(@"Cell first name: %d", indexPath.row);
    
            cell.textLabel.text = [NSString	 stringWithFormat:@"%@", course];
        }
        else if(self->state == 1)
        {
            NSString *subject = [dictionary objectForKey:@"subject"];
            NSString *course = [dictionary objectForKey:@"course"];
            NSString *title = [dictionary objectForKey:@"title"];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", subject, course];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", title];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // debug
    NSLog(@"running didSelectRowAtIndexPath");
    
    if(state == 0)
    {
        // set the state
        state = 1;
        NSLog(@"state: %d", state);
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *celltext = [NSString stringWithFormat:@"/classes/subjects/?subject=%@&type=unkeyed", cell.text];
        NSString *api = APIURL;
        NSString *class = [api stringByAppendingString:celltext];
        [self getJsonFromUrl:class];
    }
    else if(state == 1)
    {
        // set the state
        state = 2;
        NSLog(@"state: %d", state);
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *celltext = [NSString stringWithFormat:@"%@", cell.text];
                             
        NSArray *tokens = [celltext componentsSeparatedByString: @" "];
        NSString *subject = [tokens objectAtIndex:0];
        NSString *course = [tokens objectAtIndex:1];
        
        NSString *req = [NSString stringWithFormat:@"/classes/detail/?subject=%@&course=%@", subject, course];
        NSString *api = APIURL;
        NSString *detail = [api stringByAppendingString:req];
        [self showDetail:detail];
    }
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
	//[alert show];
	//[alert release];
    //NSLog(@"Click event on class");
}

- (void)getJsonFromUrl:(NSString *)urlAsString {
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
             //NSLog(@"Here is what we got: %@", jsonString);
             NSDictionary *results = [jsonString objectFromJSONString];
             
                 NSArray *resArr = [results objectForKey:@"data"];
                 //NSLog(@"%@", [resArr class]);
             
                 [responseData appendData:data];
                 if([self->feeds count]) {
                     [self->feeds removeAllObjects];
                     [self->feeds addObjectsFromArray:resArr];
                 }
                 else {
                     self->feeds = [[NSMutableArray alloc] initWithArray:resArr];
                 }
                 [self.mTableView reloadData];

         }
         else if ([data length] == 0 && error == nil)
         {
             [self.responseData setLength:0];
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil)
         {
             NSLog(@"Error = %@", error);
         }
     }];
}

- (IBAction)showDetail:(NSString *)url {
    
    [app_delegate setContentViewController:[[ClassDetailViewController alloc] initWithNibName:@"ClassDetailViewController" bundle:nil data:url]];
    [app_delegate hideSideMenu];
}

@end
