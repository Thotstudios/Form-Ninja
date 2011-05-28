//
//  SignatureElement.m
//  Dev
//
//  Created by Hackenslacker on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignatureElement.h"
#import "SignatureAlertView.h"

@implementation SignatureElement
@synthesize requestButton;
@synthesize confirmButton;
@synthesize imageView;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
	[self setRequestButton:nil];
	[self setConfirmButton:nil];
	[self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[requestButton release];
	[confirmButton release];
	[imageView release];
    [super dealloc];
}

#pragma mark - Methods

- (IBAction)reset
{
	[super reset];
	[dictionary setObject:@"Signature" forKey:@"type"];
	[imageView setImage:nil];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	
	NSData *imageData = [NSData dataWithData:[dictionary objectForKey:@"signature"]];
	UIImage *image = [UIImage imageWithData:imageData];
	[imageView setImage:image];
}

-(void) success:(UIImage*) image
{
	[imageView setImage:image];

	NSData * imageData = UIImagePNGRepresentation(image);
	[dictionary setObject:imageData forKey:@"signature"];
}
-(void) failure
{
}

- (IBAction)requestSignature
{
	[[[[SignatureAlertView alloc] initWithDelegate:self onSuccess:@selector(success:) onFailure:@selector(failure)] autorelease] show];
	
}

- (IBAction)confirmSignature
{
}
@end







