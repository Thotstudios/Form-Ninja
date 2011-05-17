//
//  AccountEditorViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountEditorViewController.h"

#import "AccountClass.h"
#import "Constants.h"

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
    
    //Get user information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults dictionaryForKey:userInfo] == nil){
        //regrab info
    }
    
    //populate vc
    else{
        NSDictionary *userDict = [defaults dictionaryForKey:userInfo]; //get user info
        
        usernameTextField.text = [userDict objectForKey:userName];
        firstNameTextField.text = [userDict objectForKey:userFirstName];
        lastNameTextField.text = [userDict objectForKey:userLastName];
        passwordTextField.text = [userDict objectForKey:userPassword];
        companyNameTextField.text = [userDict objectForKey:userCompany];
        emailAddressTextField.text = [userDict objectForKey:userEmail];
        phoneNumberTextField.text = [userDict objectForKey:userPhoneNumber];
        zipCodeTextField.text = [userDict objectForKey:userZipCode];
        zipCodeExtTextField.text = [userDict objectForKey:zipCodeExtTextField];
    }
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
