//
//  SigTestView.m
//  FormNinja
//
//  Created by Hackenslacker on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SigTestView.h"

#import "SignatureAlertView.h"

@implementation SigTestView
@synthesize signatureView;

@synthesize resultImageHalfSize;
@synthesize resultImageFullSize;


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
	[signatureView release];
	[resultImageHalfSize release];
	[resultImageFullSize release];
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
	[self setSignatureView:nil];
	[self setResultImageHalfSize:nil];
	[self setResultImageFullSize:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)setResultImage
{
	[resultImageHalfSize setImage:[signatureView image]];
	[resultImageFullSize setImage:[signatureView image]];
}

- (IBAction)clearSignature
{
	[signatureView clearSignature];
	[self setResultImage];
}

-(void) setSignature:(UIImage*)image
{
	[resultImageHalfSize setImage:image];
	[resultImageFullSize setImage:image];
}

// Signature Alert View Stuff (3 functions):
- (IBAction)getSignature
{
	[[[[SignatureAlertView alloc] initWithDelegate:self onSuccess:@selector(success:) onFailure:@selector(failure)] autorelease] show];
}
-(void) failure
{
	NSLog(@"Form not signed.");
}
-(void) success:(UIImage*)image
{
	if(image)
		{
		[resultImageFullSize setImage:image];
		[resultImageHalfSize setImage:image];
		
		}
	else
		[self failure];
}

@end
