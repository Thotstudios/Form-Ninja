//
//  FormGeoSignature.m
//  FormNinja
//
//  Created by Hackenslacker on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormGeoSignatureElement.h"
#import "GPSMapViewController.h"


@implementation FormGeoSignatureElement

@synthesize mapButton;

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
    [mapButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) check{
    if(![self.dictionary objectForKey:elementCoordinatesKey] || [[self.dictionary objectForKey:elementCoordinatesKey] isEqualToString:@"N/A"]){
        self.mapButton.hidden = TRUE;
    }
    
    else
        self.mapButton.hidden = FALSE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(check) withObject:nil afterDelay:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mapButton = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setFinished
{
    [self.dictionary setValue:@"yes" forKey:@"finished"];
}

- (IBAction) viewSigButtonAction{    NSLog(@"%@",dictionary);
    
    GPSMapViewController *gpsVS = [[GPSMapViewController alloc] 
                                   initWithNibName:@"GPSMapViewController" 
                                   bundle:nil];
    
    NSString *coordinates = [dictionary objectForKey:elementCoordinatesKey];
    gpsVS.sigCoordinates = coordinates;
    
    [self.delegate presentModalViewController:gpsVS animated:YES];
    
    [gpsVS release];
    
}

@end
