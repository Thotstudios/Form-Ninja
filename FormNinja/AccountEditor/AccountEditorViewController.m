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


//Private methods
@interface AccountEditorViewController()
 
- (BOOL) isEmpty:(NSString *)text;

@end


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
@synthesize zipCodeTextField;
@synthesize zipCodeExtTextField;

@synthesize changePasswordButton, changePasswordConfirmButton;
@synthesize changePasswordView;

@synthesize securityQuestionView;
@synthesize securityQuestionTextField;
@synthesize securityAnswerTextField;

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
        passwordTextField.text = self.account.passwordHash; // TODO: should not be shown
        companyNameTextField.text = self.account.companyName;
        emailAddressTextField.text = self.account.emailAddress;
        phoneNumberTextField.text = self.account.phoneNumber;
        zipCodeTextField.text = self.account.zipCode;
        zipCodeExtTextField.text = self.account.zipCodeExt;
		if(1) // account is being created/registered
			{
			// TODO: security question for new accounts
			// TODO: security answer for new accounts
			}
    }
	
    // Security Question view should hide or not:
	{
		// Do we allow users to view or edit their security details on iPad?
		// I think not; th point of the feature is account recovery. -Chad
		if(1)	// Account is being created/registered
			{
			[securityQuestionView setHidden:NO];
			// TODO: Do hide Change Password button for making new accounts
			// [changePasswordButton setHidden:YES];
			}
		else	//	Account is being edited/updated
			{
			[securityQuestionView setHidden:YES];
			// TODO: Don't hide Change Password button for existing accounts
			// [changePasswordButton setHidden:NO];
			}
	} // end Security Question
	
	
    //Add load alert view to window
    self.loadAlert.view.hidden = YES;
	[self.view addSubview:self.loadAlert.view];
	
}


- (void)viewWillAppear:(BOOL)animated{
    if ([self isEmpty:self.passwordChangeTextField.text] || [self isEmpty:self.passwordConfirmTextField.text]) {
		self.changePasswordConfirmButton.userInteractionEnabled = FALSE;
		self.changePasswordConfirmButton.alpha = .7;    
    }
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


//Checks for empty text
- (BOOL) isEmpty:(NSString *) text{
	if([text length] == 0 || [text isEqualToString:@" "] || 
	   ([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)){
        return TRUE;
	}
    
    else
        return FALSE;
}

- (void) saveAccountInfoLocally{
    self.account.lastName = self.lastNameTextField.text;
    self.account.firstName = self.firstNameTextField.text;
    self.account.emailAddress = self.emailAddressTextField.text;
    self.account.zipCode = self.zipCodeTextField.text;
    self.account.companyName = self.companyNameTextField.text;
    self.account.phoneNumber = self.phoneNumberTextField.text;
    self.account.zipCodeExt = self.zipCodeExtTextField.text;
    
    [self.account save];
}


- (IBAction)pressedConfirm:(id)sender {
    [self pushAlertView];
    [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:3];
    
    //Save locally
    //Add validation later
    [self saveAccountInfoLocally];
    
	if(1) // Account is being created/registered
		{
		// TODO: security question for new accounts
		// TODO: security answer for new accounts
		}
    
    //Prepare form to save remotely 
    NSURL *urlToSend = [[[NSURL alloc] initWithString: updateAccountURL] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
    [request setPostValue:self.account.username forKey:formUsername];
    [request setPostValue:self.account.firstName forKey:formFirstName];
    [request setPostValue:self.account.lastName forKey:formLastName];
    [request setPostValue:self.account.emailAddress forKey:formEmail];
    [request setPostValue:self.account.zipCode forKey:formZipCode];
    [request setPostValue:self.account.companyName forKey:formCompanyName];
    [request setPostValue:self.account.phoneNumber forKey:formPhoneNumber];
    [request setPostValue:self.account.zipCodeExt forKey:formZipCodeExt];
	if(1) // Account is being created/registered
		{
		// TODO: security question for new accounts
		// TODO: security answer for new accounts
		}
	
    //Send request
    request.delegate = self;
    [request startAsynchronous];  
    
}

- (IBAction)pressedCancel:(id)sender
{
	// TODO: repopulate fields (currently done in ViewDidLoad)
	// TODO: refactor that. -Chad
}

- (IBAction)changePasswordEnable
{
	[changePasswordButton setHidden:YES];
	[changePasswordView setHidden:NO];
}

- (IBAction)changePasswordCancel
{
	[changePasswordButton setHidden:NO];
	[changePasswordView setHidden:YES];
	// TODO: clear field text
}

- (IBAction)changePasswordConfirm
{
	// TODO: change password in database
    self.account.passwordHash = self.passwordChangeTextField.text;
    [self.account save]; //save locally
	
	// then hide the fields:
	[self changePasswordCancel];
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


#pragma mark - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([self isEmpty:text]) {
        self.changePasswordConfirmButton.userInteractionEnabled = FALSE;
        self.changePasswordConfirmButton.alpha = .7; 
    }
    
    else if ((textField == self.passwordChangeTextField && [text isEqualToString:self.passwordConfirmTextField.text]) || 
        (textField == self.passwordConfirmTextField && [text isEqualToString:self.passwordChangeTextField.text]) ||
             (textField == self.passwordTextField && [text isEqualToString:self.account.passwordHash])){
        self.changePasswordConfirmButton.userInteractionEnabled = TRUE;
        self.changePasswordConfirmButton.alpha = 1; 
    }
    
    else{
        self.changePasswordConfirmButton.userInteractionEnabled = FALSE;
        self.changePasswordConfirmButton.alpha = .7; 
    }
        
    return TRUE;
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
	[self setZipCodeTextField:nil];
	[self setZipCodeExtTextField:nil];
	
    [self setChangePasswordButton:nil];
    [self setChangePasswordConfirmButton:nil];
	[self setChangePasswordView:nil];
	
    [self setSecurityQuestionView:nil];
    [self setSecurityQuestionTextField:nil];
    [self setSecurityAnswerTextField:nil];
	
    self.loadAlert = nil;
	
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
	[zipCodeTextField release];
	[zipCodeExtTextField release];
	
    [changePasswordButton release];
    [changePasswordConfirmButton release];
	[changePasswordView release];
	
    [securityQuestionView release];
    [securityQuestionTextField release];
    [securityAnswerTextField release];
	
    [loadAlert release];
	
    [super dealloc];
}

@end
