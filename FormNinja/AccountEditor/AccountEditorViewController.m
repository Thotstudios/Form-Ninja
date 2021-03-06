//
//  AccountEditorViewController.m
//  FormNinja
//
//  Created by Chad Hatcher on 5/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "AccountEditorViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "AccountClass.h"
#import "Constants.h"
#import "CustomLoadAlertViewController.h"
#import "PopOverManager.h"


//Private methods
@interface AccountEditorViewController()
 
- (BOOL) isEmpty:(NSString *)text;
- (void) loadAccountInfo;

@end


@implementation AccountEditorViewController

@synthesize scroller;

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

@synthesize changePasswordButton, changePasswordConfirmButton, confirmButton, cancelButton;
@synthesize changePasswordView;

@synthesize securityQuestionView;
@synthesize securityQuestionTextField;
@synthesize securityAnswerTextField;

@synthesize loadAlert;
@synthesize type;
@synthesize statusLabel;


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
			}
		else	//	Account is being edited/updated
			{
			[securityQuestionView setHidden:YES];
			}
	} // end Security Question
	
    //Menu button
	UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction:)]; 
    self.navigationItem.rightBarButtonItem = menuButton;
    [menuButton release];
	
    //Add load alert view to window
    self.loadAlert.view.hidden = YES;
	[self.view addSubview:self.loadAlert.view];
	
    
    UIImage *blackSubmitImage=[UIImage imageNamed:@"submitGray.png"];
    [confirmButton setImage:blackSubmitImage forState:UIControlStateHighlighted];
    
    scroller.contentSize=CGSizeMake(768, 960);
}


-(void) viewDidDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[PopOverManager sharedManager] dismissCurrentPopoverController:YES]; //dismiss popover
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
	
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(keyboardWillShow:)
	 name:UIKeyboardWillShowNotification
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(keyboardWillHide:)
	 name:UIKeyboardWillHideNotification
	 object:nil];
    
    if ([self isEmpty:self.passwordChangeTextField.text] || [self isEmpty:self.passwordConfirmTextField.text]) {
		self.changePasswordConfirmButton.userInteractionEnabled = FALSE;
		self.changePasswordConfirmButton.alpha = .7;    
    }
    
    if (type == 0) {
        self.usernameTextField.userInteractionEnabled = TRUE;
        self.passwordTextField.userInteractionEnabled = TRUE;
        self.changePasswordButton.hidden = YES;
        self.confirmButton.userInteractionEnabled = FALSE;
		self.confirmButton.alpha = .7; 
    }
    
    else{
        self.usernameTextField.userInteractionEnabled = FALSE;
        self.passwordTextField.userInteractionEnabled = FALSE;
        self.emailAddressTextField.userInteractionEnabled = FALSE;
        self.changePasswordButton.hidden = NO;
    }
    
    [self loadAccountInfo];
}


- (void)viewWillDisappear:(BOOL)animated{
    [[PopOverManager sharedManager] dismissCurrentPopoverController:YES]; //dismiss popover
}

-(void) keyboardWillShow:(id)selector
{//264, 352
	UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
	if(orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight)
        [scroller setFrame:CGRectMake(scroller.frame.origin.x, scroller.frame.origin.y, scroller.frame.size.width, scroller.frame.size.height-352)];
    else
        [scroller setFrame:CGRectMake(scroller.frame.origin.x, scroller.frame.origin.y, scroller.frame.size.width, scroller.frame.size.height-264)];
    
}
-(void) keyboardWillHide:(id)selector
{
	UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
	if(orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight)
        [scroller setFrame:CGRectMake(scroller.frame.origin.x, scroller.frame.origin.y, scroller.frame.size.width, scroller.frame.size.height+352)];
    else
        [scroller setFrame:CGRectMake(scroller.frame.origin.x, scroller.frame.origin.y, scroller.frame.size.width, scroller.frame.size.height+264)];
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
    
    if ([self.account.userID isEqualToString:@"-1"]){
        self.confirmButton.userInteractionEnabled = FALSE;
        return;
    }
    
    else if(self.account.username == nil){ //if no username, there is no user info stored
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


- (void) handleRegistrationResponse:(NSDictionary *) jsonDict{
    NSString *registered = [jsonDict objectForKey:formRegistrationAccepted];
    
    if ([registered isEqualToString:formTrue]){
        self.loadAlert.alertLabel.text = @"Account Created";
        
        //Set user id
        self.account.userID = [jsonDict objectForKey:userIDNumber];
        
        [self.loadAlert stopActivityIndicator];
        [self accountCreated];
        return;
    }
    
    else{
        self.statusLabel.text = [jsonDict objectForKey:formError];
        [self removeAlertView];
    }
}


- (void) handlePasswordChangeResponse:(NSDictionary *) jsonDict{
    NSString *passwordChanged = [jsonDict objectForKey:formPasswordChangeAccepted];
    
    if ([passwordChanged isEqualToString:formTrue]) { //Sucessful change
        self.passwordTextField.text = self.passwordConfirmTextField.text; //Change field to new pw
        self.account.passwordHash = self.passwordConfirmTextField.text;
        [self.account save];// save locally
        self.loadAlert.alertLabel.text = @"Password Changed";
        [self.loadAlert stopActivityIndicator];
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:3];
    }
    
    else{
        self.statusLabel.text = [jsonDict objectForKey:formError];
        [self removeAlertView];
    }
}

#pragma mark - Button Actions

- (IBAction)pressedConfirm:(id)sender {
    [self.view endEditing:YES]; //dismiss keyboard
    [self pushAlertView];
    
    NSURL *urlToSend;
    ASIFormDataRequest *request;
    
    
    if(self.type == 0){ // Account is being registered
		// TODO: security question for new accounts
		// TODO: security answer for new accounts
        self.loadAlert.alertLabel.text = @"Registering Account";
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
        self.loadAlert.alertLabel.text = @"Saving Account Information";

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
    [self.view endEditing:YES]; //dismiss keyboard
    [self loadAccountInfo]; //reload info
}

- (IBAction)changePasswordEnable
{
	[changePasswordButton setHidden:YES];
	[changePasswordView setHidden:NO];
}

- (IBAction)changePasswordCancel
{
    [self.view endEditing:YES]; //dismiss keyboard
    //clear change password text
    self.passwordChangeTextField.text = nil;
    self.passwordConfirmTextField.text = nil;
    
	[changePasswordButton setHidden:NO];
	[changePasswordView setHidden:YES];
}

- (IBAction)changePasswordConfirm
{
    [self.view endEditing:YES]; //dismiss keyboard

    //Prepare form to save remotely 
    NSURL *urlToSend = [[[NSURL alloc] initWithString: updateAccountURL] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];
    [request setPostValue:self.account.username forKey:formUsername];
    [request setPostValue:self.passwordConfirmTextField.text forKey:formPassword];
   
    self.loadAlert.alertLabel.text = @"Changing Password";
    [self pushAlertView];
    
    request.delegate = self;
    [request startAsynchronous];

	// then hide the fields:
	[self changePasswordCancel];
}


- (void) menuButtonAction:(id) sender{
    [[PopOverManager sharedManager] createMenuPopOver:accountProfileMenu fromButton:sender];
}




#pragma mark - ASIHTTPRequest Delegate Methods

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (self.type == 1){ //Inform user of saved information even when remoting data has failed
        self.loadAlert.alertLabel.text = @"Information Saved";
        [self.loadAlert.activityIndicator stopAnimating];
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:3];
        return;
    }
    
    [self removeAlertView];
    self.statusLabel.text = @"Error connecting to server";
}


- (void)requestFinished:(ASIHTTPRequest *)request
{	
    //Get intial dict from response string
	NSDictionary *jsonDict = [[request responseString] JSONValue]; 
    NSLog(@"%@", jsonDict);
    
    //Indicates a password change was successful
    if ([jsonDict objectForKey:formPasswordChangeAccepted]) {
        [self handlePasswordChangeResponse:jsonDict];
    }
    
    else if(self.type == 0){
        [self handleRegistrationResponse:jsonDict];
    }
    
    else if (self.type == 1){
        self.loadAlert.alertLabel.text = @"Information Saved";
        [self.loadAlert.activityIndicator stopAnimating];
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:3];
    }
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
    self.statusLabel = nil;
	
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
    
    [statusLabel release];
	
    [loadAlert release];
	
    [super dealloc];
}

@end
