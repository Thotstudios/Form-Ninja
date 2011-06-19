//
//  FormFinishViewController.m
//  FormNinja
//
//  Created by Ollin on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormFinishViewController.h"


@implementation FormFinishViewController
@synthesize delegate;
@synthesize locationManager;
@synthesize accuracyLabel;
@synthesize geoSign;
@synthesize lastLocation;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.locationManager=[[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.locationManager=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction) abortFinishButtonPressed
{
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction) confirmFinishButtonPressed
{
    
    if (geoSign.selectedSegmentIndex==0) {
        [[self delegate] formFinishConfirmedWithLocation:lastLocation];
    }
    else
        [[self delegate] formFinishConfirmedWithLocation:nil];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    lastLocation=newLocation;
    [self.accuracyLabel setText:[NSString stringWithFormat:@"+/- %f",newLocation.horizontalAccuracy]];
}

@end
