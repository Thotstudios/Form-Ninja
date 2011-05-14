//
//  AccountEditorViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountEditorViewController.h"

#import "AccountClass.h"

@implementation AccountEditorViewController

@synthesize account;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize passwordChangeTextField;
@synthesize passwordConfirmTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize emailAddressTextField;
@synthesize companyNameTextField;
@synthesize phoneNumberTextField;
// security question
// security answer
@synthesize zipCodeTextField;
@synthesize zipCodeExtTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setAccount:nil];
    }
    return self;
}

- (void)dealloc
{
	[account release];
	[usernameTextField release];
	[passwordTextField release];
	[passwordChangeTextField release];
	[passwordConfirmTextField release];
	[firstNameTextField release];
	[lastNameTextField release];
	[emailAddressTextField release];
	[companyNameTextField release];
	[phoneNumberTextField release];
	// security question
	// security answer
	[zipCodeTextField release];
	[zipCodeExtTextField release];
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
	[self setUsernameTextField:nil];
	[self setPasswordTextField:nil];
	[self setPasswordChangeTextField:nil];
	[self setPasswordConfirmTextField:nil];
	[self setFirstNameTextField:nil];
	[self setLastNameTextField:nil];
	[self setEmailAddressTextField:nil];
	[self setCompanyNameTextField:nil];
	[self setPhoneNumberTextField:nil];
	// security question
	// security answer
	[self setZipCodeTextField:nil];
	[self setZipCodeExtTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
- (IBAction)pressedConfirm:(id)sender {
}

- (IBAction)pressedCancel:(id)sender {
}
@end
