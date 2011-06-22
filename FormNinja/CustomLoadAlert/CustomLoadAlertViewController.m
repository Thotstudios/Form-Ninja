    //
//  CustomLoadAlertViewController.m
//  iPlace HD
//
//  Created by Paul Salazar on 2/27/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "CustomLoadAlertViewController.h"


@implementation CustomLoadAlertViewController


@synthesize alertLabel;
@synthesize activityIndicator;


#pragma mark -
#pragma mark View Lifecycle

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}



#pragma mark -
#pragma mark CustomAlertViewController Methods

- (void) startActivityIndicator{
	[self.activityIndicator startAnimating];
}


- (void) stopActivityIndicator{
	[self.activityIndicator stopAnimating];
}



#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];

	[activityIndicator stopAnimating];
	self.activityIndicator = nil;
	self.alertLabel = nil;
}


- (void)dealloc {
	[alertLabel release];
	[activityIndicator release];
    
    [super dealloc];
}


@end
