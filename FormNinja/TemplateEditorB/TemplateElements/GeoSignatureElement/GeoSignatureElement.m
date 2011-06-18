//
//  GeoSignatureElement.m
//  FormNinja
//
//  Created by Hackenslacker on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoSignatureElement.h"

#import "LocationManager.h"

@implementation GeoSignatureElement
@synthesize gpsLabel;
@synthesize gpsSwitch;

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
	[gpsLabel release];
    [gpsSwitch release];
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
	[self setGpsLabel:nil];
    [self setGpsSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Instance Methods

-(void) fixGpsLabel
{
	[gpsLabel setText:[NSString stringWithFormat:@"GPS: %@", [dictionary objectForKey:elementCoordinatesKey]]];
}

#pragma mark - Inherited Methods

-(IBAction) reset
{
	[super reset];
	[dictionary setValue:@"GeoSignature" forKey:elementTypeKey];
	[dictionary setValue:[NSNumber numberWithBool:YES] forKey:elementCoordinatesEnabledKey];
	[dictionary setValue:@"N/A" forKey:elementCoordinatesKey];
	[dictionary setValue:nil forKey:elementCoordinatesAccuracyKey];
	[self fixGpsLabel];
	[gpsSwitch setOn:YES];
}
-(void) setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	[self fixGpsLabel];
	[gpsSwitch setOn:[[dictionary valueForKey:elementCoordinatesEnabledKey] boolValue] animated:YES];
}
-(void) success:(UIImage*) image
{
	[super success:image];
    
    //Get location info if possible
    if([[LocationManager locationManager] hasValidLocation])
		{
        NSString *coordinates = [NSString stringWithFormat:@"%f,%f", [LocationManager locationManager].latitude, [LocationManager locationManager].longitude];
        [dictionary setValue:coordinates forKey:elementCoordinatesKey]; //Set dict value
		}
	else
		{
		[dictionary setValue:@"N/A" forKey:elementCoordinatesKey];
		[dictionary setValue:nil forKey:elementCoordinatesAccuracyKey];
		}
	[self fixGpsLabel];
}
- (IBAction)toggleAllowGps
{
	[dictionary setValue:[NSNumber numberWithBool:[gpsSwitch isOn]] forKey:elementCoordinatesEnabledKey];
	if(![gpsSwitch isOn])
		{
		[dictionary setValue:@"N/A" forKey:elementCoordinatesKey];
		[dictionary setValue:nil forKey:elementCoordinatesAccuracyKey];
		[self fixGpsLabel];
		}
}
@end
