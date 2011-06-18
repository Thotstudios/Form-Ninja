//
//  SignatureElement.m
//  Dev
//
//  Created by Hackenslacker on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignatureElement.h"
#import "SignatureAlertView.h"
#import "LocationManager.h"

@implementation SignatureElement
@synthesize requestButton;
@synthesize confirmButton;
@synthesize imageView;
@synthesize gpsLabel;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
	[self setRequestButton:nil];
	[self setConfirmButton:nil];
	[self setImageView:nil];
	[self setGpsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[requestButton release];
	[confirmButton release];
	[imageView release];
	[gpsLabel release];
    [super dealloc];
}

#pragma mark - Methods

- (IBAction)reset
{
	[super reset];
	[dictionary setValue:@"Signature" forKey:elementTypeKey];
	[imageView setImage:nil];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	NSData *imageData = [dictionary valueForKey:elementSignatureImageKey];
	UIImage *image = [UIImage imageWithData:imageData];
	[imageView setImage:image];
}

-(void) success:(UIImage*) image
{
	[imageView setImage:image];

	NSData * imageData = UIImagePNGRepresentation(image);
	[dictionary setValue:imageData forKey:elementSignatureImageKey];
    
    
    //Get location info if possible
    if([[LocationManager locationManager] hasValidLocation])
		{
        NSString *coordinates = [NSString stringWithFormat:@"%f,%f", [LocationManager locationManager].latitude, [LocationManager locationManager].longitude];
        [dictionary setValue:coordinates forKey:elementCoordinatesKey]; //Set dict value
    }
	else
		{
		[dictionary setValue:@"N/A" forKey:elementCoordinatesKey];
		}
	[gpsLabel setText:[NSString stringWithFormat:@"GPS: %@", [dictionary objectForKey:elementCoordinatesKey]]];
}
-(void) failure
{
}

- (IBAction)requestSignature
{
	[SignatureAlertView showWithDelegate:self onSuccess:@selector(success:) onFailure:@selector(failure)];
	
}

- (IBAction)confirmSignature
{
}
@end







