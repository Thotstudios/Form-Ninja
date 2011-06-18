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







