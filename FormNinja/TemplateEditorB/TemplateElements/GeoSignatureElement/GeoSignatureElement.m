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
	if([[dictionary valueForKey:elementCoordinatesAccuracyKey] length])
	[gpsLabel setText:[NSString stringWithFormat:GPS_COORD_AND_ACC_FORMAT,
					   [dictionary objectForKey:elementCoordinatesKey],
					   [dictionary valueForKey:elementCoordinatesAccuracyKey]]];
	else
		[gpsLabel setText:@"Include GPS"];
}

#pragma mark - Inherited Methods

-(IBAction) reset
{
	[super reset];
	[dictionary setValue:@"GeoSignature" forKey:elementTypeKey];
	[dictionary setValue:[NSNumber numberWithBool:YES] forKey:elementCoordinatesEnabledKey];
	[dictionary setValue:@"N/A" forKey:elementCoordinatesKey];
	[dictionary setValue:@"" forKey:elementCoordinatesAccuracyKey];
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
    
    LocationManager *locationManager = [LocationManager locationManager];
    if([locationManager hasValidLocation]  && [gpsSwitch isOn])
		{
        NSString *coordinates = [NSString stringWithFormat:GPS_COORDINATES_FORMAT, locationManager.latitude, locationManager.longitude];
        [dictionary setValue:coordinates forKey:elementCoordinatesKey];
		NSString * accuracy = [NSString stringWithFormat:GPS_ACCURACY_FORMAT, [locationManager getAccuracy]];
        [dictionary setValue:accuracy forKey:elementCoordinatesAccuracyKey];
		}
	else
		{
		[dictionary setValue:@"N/A" forKey:elementCoordinatesKey];
		[dictionary setValue:@"" forKey:elementCoordinatesAccuracyKey];
		}
	[self fixGpsLabel];
}
- (IBAction)toggleAllowGps
{
	[dictionary setValue:[NSNumber numberWithBool:[gpsSwitch isOn]] forKey:elementCoordinatesEnabledKey];
	if(![gpsSwitch isOn])
		{
		[dictionary setValue:@"N/A" forKey:elementCoordinatesKey];
		[dictionary setValue:@"" forKey:elementCoordinatesAccuracyKey];
		[self fixGpsLabel];
		}
}

@end
