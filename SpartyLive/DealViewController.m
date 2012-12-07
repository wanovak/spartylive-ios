//
//  DealViewController.m
//  SpartyLive
//
//  Created by Will on 11/4/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import "DealViewController.h"
#import "application.h"
#import "JSONKit.h"

@implementation DealViewController
@synthesize mTableView;
@dynamic deals;
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
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.logoImageView.alpha = 0;
    }
                     completion:^(BOOL finished){  }];
    
    // Send request to API
    NSString *urlAsString = APIURL @"/deals/latest/";
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
    
    int count = self->deals.count;
    
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
    int nodeCount = [self->deals count];
    
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
        NSDictionary *dictionary = [self->deals objectAtIndex:indexPath.row];
        // Set up the cell...
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        

            NSString *company = [dictionary objectForKey:@"company"];
            NSString *description = [dictionary objectForKey:@"description"];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", description];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", company];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
             
             NSDictionary *resDic = [results objectForKey:@"data"];
             NSArray *resArr = [resDic objectForKey:@"deal"];
             //NSLog(@"%@", [resArr class]);
             
             [responseData appendData:data];
             self->deals = [[NSMutableArray alloc] initWithArray:resArr];

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


@end
