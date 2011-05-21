//
//  SigTestView.m
//  FormNinja
//
//  Created by Hackenslacker on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SigTestView.h"

@implementation SigTestView
@synthesize signatureViewController;

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
	[signatureViewController release];
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
	[self setSignatureViewController:nil];
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
	[resultImageHalfSize setImage:[signatureViewController image]];
	[resultImageFullSize setImage:[signatureViewController image]];
}

- (IBAction)clearSignature
{
	[signatureViewController clearSignature];
}
@end
