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
- (void) loadAccountInfo;

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

@synthesize changePasswordButton, changePasswordConfirmButton, confirmButton;
@synthesize changePasswordView;

@synthesize securityQuestionView;
@synthesize securityQuestionTextField;
@synthesize securityAnswerTextField;

@synthesize loadAlert;
@synthesize type;


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
    
    [self loadAccountInfo];
    
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
    
    if (type == 0) {
        self.changePasswordButton.hidden = YES;
        self.confirmButton.userInteractionEnabled = FALSE;
		self.confirmButton.alpha = .7; 
    }
    
    else
        self.changePasswordButton.hidden = NO;
    
    [self loadAccountInfo];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



#pragma mark - Instance Methods

- (void) loadAccountInfo{
    //Get user account class
    self.account = [AccountClass sharedAccountClass];
    
    if(self.account.username == nil){ //if no username, there is no user info stored
        //clear fields
        self.usernameTextField.text = self.firstNameTextField.text = self.lastNameTextField.text = self.passwordTextField.text = self.passwordConfirmTextField.text = self.passwordChangeTextField.text = self.companyNameTextField.text = self.emailAddressTextField.text = self.phoneNumberTextField.text = self.zipCodeTextField.text = self.zipCodeExtTextField.text = nil;
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
}

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
    self.account.securityAnswer = @"test answer";
    self.account.securityQuestion = @"test?";
    
    [self.account save];
}

- (void) gotoMenu{
    [self removeAlertView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Called when user has been created
- (void) accountCreated{
    self.account.username = self.usernameTextField.text;
    self.account.passwordHash = self.passwordTextField.text;
    [self saveAccountInfoLocally]; //save locally
    
    // set login expiration
    NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
    int long_session = 1209600;	//	two weeks
    int short_session = 86400;	//	one day
    BOOL remember = [opt boolForKey:rememberUserKey]; 
    long loginExpiration = time(0) + (remember?long_session:short_session);
    [opt setInteger:loginExpiration forKey:loginExpirationKey];
    [opt synchronize];
    
    [self performSelector:@selector(gotoMenu) withObject:nil afterDelay:3];
}


- (void) validatePasswordChange:(NSString *) text withTextField:(UITextField *) textField{
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
}


//Called after every required text field has been edited
- (IBAction) textFieldDidChange{
    if (![self isEmpty:self.usernameTextField.text] && ![self isEmpty:self.passwordTextField.text ] 
             && ![self isEmpty:self.firstNameTextField.text] && ![self isEmpty:self.lastNameTextField.text] 
             && ![self isEmpty:self.emailAddressTextField.text ] && ![self isEmpty:self.zipCodeTextField.text]){
        self.confirmButton.userInteractionEnabled = TRUE;
		self.confirmButton.alpha = 1; 
    }
    
    else{
        self.confirmButton.userInteractionEnabled = FALSE;
		self.confirmButton.alpha = .7;   
    }
}


#pragma mark - Button Actions

- (IBAction)pressedConfirm:(id)sender {
    [self pushAlertView];
    [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:3];
    
    NSURL *urlToSend;
    ASIFormDataRequest *request;
    
    
    if(self.type == 0){ // Account is being registered
		// TODO: security question for new accounts
		// TODO: security answer for new accounts
        urlToSend = [[[NSURL alloc] initWithString: accountRegisterURL] autorelease];
        request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
        [request setPostValue:self.usernameTextField.text forKey:formUsername];
        [request setPostValue:self.passwordTextField.text forKey:formPassword];
        [request setPostValue:self.firstNameTextField.text forKey:formFirstName];
        [request setPostValue:self.lastNameTextField.text forKey:formLastName];
        [request setPostValue:self.emailAddressTextField.text forKey:formEmail];
        [request setPostValue:self.zipCodeTextField.text forKey:formZipCode];
        [request setPostValue:self.companyNameTextField.text forKey:formCompanyName];
        [request setPostValue:self.phoneNumberTextField.text forKey:formPhoneNumber];
        [request setPostValue:self.zipCodeExtTextField.text forKey:formZipCodeExt];
        [request setPostValue:@"test?" forKey:formSecretQuestion];
        [request setPostValue:@"test answer" forKey:formSecretAnswer];
    }
    
    else{
        //Save locally
        //Add validation later
        [self saveAccountInfoLocally];
        
        //Prepare form to save remotely 
        urlToSend = [[[NSURL alloc] initWithString: updateAccountURL] autorelease];
        request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
        [request setPostValue:self.account.username forKey:formUsername];
        [request setPostValue:self.account.firstName forKey:formFirstName];
        [request setPostValue:self.account.lastName forKey:formLastName];
        [request setPostValue:self.account.emailAddress forKey:formEmail];
        [request setPostValue:self.account.zipCode forKey:formZipCode];
        [request setPostValue:self.account.companyName forKey:formCompanyName];
        [request setPostValue:self.account.phoneNumber forKey:formPhoneNumber];
        [request setPostValue:self.account.zipCodeExt forKey:formZipCodeExt];
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
    //Prepare form to save remotely 
    NSURL *urlToSend = [[[NSURL alloc] initWithString: updateAccountURL] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];
    [request setPostValue:self.account.username forKey:formUsername];
    [request setPostValue:self.passwordConfirmTextField.text forKey:formPassword];
   
    [self pushAlertView];
    
    request.delegate = self;
    [request startAsynchronous];

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
    
    //Indicates a password change was successful
    if ([jsonDict objectForKey:@"passwordChanged"]) {
        self.passwordTextField.text = self.passwordConfirmTextField.text;
        self.account.passwordHash = self.passwordConfirmTextField.text;
        [self.account save];// save locally
    }
    
    else if(self.type == 0){
        self.loadAlert.alertLabel.text = @"Account Created";
        [self.loadAlert stopActivityIndicator];
        [self accountCreated];
        return;
    }
    
    [self removeAlertView];
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.passwordChangeTextField || textField == self.passwordConfirmTextField || textField == self.passwordTextField && self.type!=0) {
        [self validatePasswordChange:text withTextField:textField];
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
    [self setConfirmButton:nil];
	
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
	
    [confirmButton release];
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
