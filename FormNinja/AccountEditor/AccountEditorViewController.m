//
//  AccountEditorViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountEditorViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "AccountClass.h"
#import "Constants.h"
#import "CustomLoadAlertViewController.h"

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
@synthesize changePasswordView;
@synthesize loadAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setAccount:nil];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Get user account class
    self.account = [AccountClass sharedAccountClass];
    
    if(self.account.username == nil){ //if no username, there is no user info stored
        //regrab info
    }
    
    //else populate vc
    else{        
        usernameTextField.text = self.account.username;
        firstNameTextField.text = self.account.firstName;
        lastNameTextField.text = self.account.lastName;
        passwordTextField.text = self.account.passwordHash;
        companyNameTextField.text = self.account.companyName;
        emailAddressTextField.text = self.account.emailAddress;
        phoneNumberTextField.text = self.account.phoneNumber;
        zipCodeTextField.text = self.account.zipCode;
        zipCodeExtTextField.text = self.account.zipCodeExt;
    }
    
    //Add load alert view to window
    self.loadAlert.view.hidden = YES;
	[self.view addSubview:self.loadAlert.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



#pragma mark - Instance Methods

//Pushes alert view
- (void) pushAlertView
{
    self.navigationItem.hidesBackButton = TRUE;
    self.loadAlert.view.hidden = FALSE;
	[self.loadAlert startActivityIndicator];
}


//Removes alert view
- (void) removeAlertView
{
    self.navigationItem.hidesBackButton = FALSE;
	[self.loadAlert stopActivityIndicator];
    self.loadAlert.view.hidden = TRUE;	
}


- (IBAction)pressedConfirm:(id)sender {
    [self pushAlertView];
    [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:3];
    
    //Save locally
    self.account.lastName = self.lastNameTextField.text;
    self.account.firstName = self.firstNameTextField.text;
    self.account.emailAddress = self.emailAddressTextField.text;
    self.account.zipCode = self.zipCodeTextField.text;
    [self.account save];
    
    //Prepare form to save remotely 
    NSURL *urlToSend = [[[NSURL alloc] initWithString: updateAccountURL] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
    [request setPostValue:self.account.username forKey:formUsername];
    [request setPostValue:self.account.firstName forKey:formFirstName];
    [request setPostValue:self.account.lastName forKey:formLastName];
    [request setPostValue:self.account.emailAddress forKey:formEmail];
    [request setPostValue:self.account.zipCode forKey:formZipCode];

	
    //Send request
    request.delegate = self;
    [request startAsynchronous];  
    
}

- (IBAction)pressedCancel:(id)sender {
}



#pragma mark - ASIHTTPRequest Delegate Methods

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self removeAlertView];
    //self.statusLabel.text = @"Error connecting to server";
}


- (void)requestFinished:(ASIHTTPRequest *)request
{	
    //Get intial dict from response string
	NSDictionary *jsonDict = [[request responseString] JSONValue]; 
    NSLog(@"%@", jsonDict);
    [self removeAlertView];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    self.loadAlert = nil;
	[self setChangePasswordView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    [loadAlert release];
	[changePasswordView release];
    [super dealloc];
}

@end
