//
//  ClassDetailViewController.m
//  SpartyLive
//
//  Created by Will on 12/7/12.
//  Copyright (c) 2012 SpartyLive LLC. All rights reserved.
//

#import "JSONKit.h"
#import "ClassDetailViewController.h"

@implementation ClassDetailViewController
@synthesize updateText;
@synthesize viewData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSString*)data;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.viewData = data;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    updateText.text = @"Loading...";
    [self getJsonFromUrl:viewData];
}

- (void)viewDidUnload
{
    [self setUpdateText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)getJsonFromUrl:(NSString *)urlAsString {
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData: oResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"Here is what we got: %@", jsonString);
    NSDictionary *results = [jsonString objectFromJSONString];
    
    NSDictionary *resArr = [results objectForKey:@"data"];
    NSArray *resArrDesc = [resArr objectForKey:@"description"];
    NSMutableString *text = [NSMutableString string];
    for(int i = 0; i < [resArrDesc count]; i++) {
        [text appendString:[resArrDesc objectAtIndex:i]];
        [text appendString:@"\r\n\r\n"];
    }
    updateText.text = text;
    
}

@end
