//
//  GPSMapViewController.m
//  FormNinja
//
//  Created by Paul Salazar on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GPSMapViewController.h"


@implementation GPSMapViewController

@synthesize webView, activityView, sigCoordinates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    webView.delegate = nil;
    [webView release];
    [activityView release];
    [sigCoordinates release];
    
    [super dealloc];
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
    NSArray *coordArray = [self.sigCoordinates componentsSeparatedByString:@","];
    NSLog(@"%@", coordArray);
    
    NSString *urlAddress = [NSString stringWithFormat:@"http://maps.google.com/?q=%@", self.sigCoordinates];
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
    
    [self.activityView startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.activityView = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


-(IBAction) closeButtonAction{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark UIWebViewDelegate Methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityView stopAnimating];

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Unable to load location"
                          message: @"Please check your network or 3g connection"
                          delegate: self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityView stopAnimating];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissModalViewControllerAnimated:YES];
}
@end
