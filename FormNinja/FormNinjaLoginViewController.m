//
//  FormNinjaViewController.m
//  FormNinja
//
//  Created by Ollin on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormNinjaLoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "CustomLoadAlertViewController.h"


#define LOGIN 1 //0 skips login screen

//private methods
@interface FormNinjaLoginViewController()
- (void) userAuthenticated;
@end


@implementation FormNinjaLoginViewController
@synthesize rememberSwitch;
//@synthesize mainMenuViewController;


#pragma mark - View lifecycle


@synthesize usernameField, passwordField, statusLabel, loginButton;
@synthesize loadAlert;

//git://github.com/Thotsudios/Form-Ninja.git


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add load alert view to window
    self.loadAlert.view.hidden = YES;
	[self.view addSubview:self.loadAlert.view];
}


- (void) viewDidAppear:(BOOL)animated
{
    if (!LOGIN)
		{
        [self userAuthenticated];
		}
    
    //Make sure the title text field is not empty before enabling save button when view appears
	if([self.usernameField.text length] == 0 || [self.usernameField.text isEqualToString:@" "] || 
	   ([[self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)){
        //Disable save button
        self.loginButton.userInteractionEnabled = FALSE;
        self.loginButton.alpha = .7; 
        [self.usernameField becomeFirstResponder];
	}
	
	NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
	BOOL remember = [opt boolForKey:@"remember user"]; // MAGIC: stay_logged_in_key
	[rememberSwitch setOn:remember];
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
    self.loadAlert.view.hidden = FALSE;
	[self.loadAlert startActivityIndicator];
}


//Removes alert view
- (void) removeAlertView
{
	[self.loadAlert stopActivityIndicator];
    self.loadAlert.view.hidden = TRUE;	
}


- (void) gotoMenu{
    [self removeAlertView];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)rememberSwitchAction:(UISwitch*)sender
{
	BOOL remember = [sender isOn];
	
	
	NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
	[opt setBool:remember forKey:@"remember user"]; // MAGIC: stay_logged_in_key
	[opt synchronize];
	
	//[opt boolForKey:@"remember user"]; // MAGIC: stay_logged_in_key
}

- (IBAction) loginButtonAction
{
    //Test account info
    //un:test pass:test
    NSLog(@"login (%@:%@)", [usernameField text], [passwordField text]);
    
    //Dismiss keyboard
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
	
    //Push alert view
    self.loadAlert.alertLabel.text = @"Logging in";
    [self pushAlertView];
    
    //Prepare form
    NSURL *urlToSend = [[[NSURL alloc] initWithString: @"http://www.rilburskryler.net/mobile/login.php"] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
    [request setPostValue:self.usernameField.text forKey:@"username"];  
    [request setPostValue:self.passwordField.text forKey:@"password"];  
	
    //Send request
    request.delegate = self;
    [request startAsynchronous];  
}


- (void) getUserInfo{
    //Prepare form
    NSURL *urlToSend = [[[NSURL alloc] initWithString: @"http://www.rilburskryler.net/mobile/userinfo.php"] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
    [request setPostValue:self.usernameField.text forKey:@"username"];  
    [request setPostValue:self.passwordField.text forKey:@"password"];  
	
    //Send request
    request.delegate = self;
    [request startAsynchronous];  
}


//Called when user has been authenticated
- (void) userAuthenticated
{
    NSUserDefaults *opt = [NSUserDefaults standardUserDefaults];

	
	{ // set login expiration
		NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
		int long_session = 1209600;	//	two weeks
		int short_session = 86400;	//	one day
		BOOL remember = [opt boolForKey:@"remember user"]; // MAGIC
		long loginExpiration = time(0) + (remember?long_session:short_session);
		[opt setInteger:loginExpiration forKey:@"login expiration"];
		[opt synchronize];
	} // end set login expiration
	
    /*
    if([opt stringForKey:@"username"] == nil){
        self.loadAlert.alertLabel.text = @"Fetching account information";
        [self getUserInfo];
    }
    
    else*/
    [self performSelector:@selector(gotoMenu) withObject:nil afterDelay:3];
}


//Called when user has failed authenticated
- (void) userAuthenticatedFailed:(NSString *)error
{
    [self removeAlertView];
    self.statusLabel.text = error;
}



#pragma mark - ASIHTTPRequest Delegate Methods

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self removeAlertView];
    self.statusLabel.text = @"Error connecting to server";
}


- (void)requestFinished:(ASIHTTPRequest *)request
{	
    //Get intial dict from response string
	NSDictionary *jsonDict = [[request responseString] JSONValue]; 
    NSLog(@"%@", jsonDict);
    NSString *userAccepted = [jsonDict objectForKey:@"accepted"]; //Get response
    
    if([userAccepted isEqualToString:@"True"]){
        self.loadAlert.alertLabel.text = @"Login successful";
        [self.loadAlert stopActivityIndicator];
        
        //If there is no user information stored locally, store it
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults dictionaryForKey:@"userInformation"] == nil){
            NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
            [userDict setObject:self.usernameField.text forKey:@"username"];
            [userDict setObject:self.passwordField.text forKey:@"password"];
            [userDict setObject:@"thot" forKey:@"company"];
            [userDict setObject:[jsonDict objectForKey:@"email"] forKey:@"email"];
            [userDict setObject:[jsonDict objectForKey:@"firstName"] forKey:@"firstName"];
            [userDict setObject:[jsonDict objectForKey:@"lastName"] forKey:@"lastName"];
            [userDict setObject:@"55949" forKey:@"phoneNumber"];
            [userDict setObject:[jsonDict objectForKey:@"zipCode"] forKey:@"zipCode"];
            [userDict setObject:@"456" forKey:@"zipeCodeExt"];
            
            [defaults setObject:userDict forKey:@"userInformation"];
            [defaults synchronize];
        }
        
        [self performSelector:@selector(userAuthenticated) withObject:nil afterDelay:3];
    }
    
    else{
        self.loadAlert.alertLabel.text = @"Login failed";
        [self.loadAlert stopActivityIndicator];
        [self performSelector:@selector(userAuthenticatedFailed:) withObject:[jsonDict objectForKey:@"error"] afterDelay:3];
    }
}



#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *otherText;
    
    if (textField == self.usernameField)
		{
        otherText = self.passwordField.text;
		}
    
    else
        otherText = self.usernameField.text;
	
	//Make sure both fields have text before allowing attempted login
	if(([text length] == 0 || [text isEqualToString:@" "] || 
		([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)) ||
       ([otherText length] == 0 || [otherText isEqualToString:@" "] || 
        ([[otherText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)))
		{
        //Disable save button
        self.loginButton.userInteractionEnabled = FALSE;
        self.loginButton.alpha = .7; 
		}
	
	else
		{
        //Enable save button
        self.loginButton.userInteractionEnabled = TRUE;
        self.loginButton.alpha = 1;  	
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
	//[self setMainMenuViewController:nil];
	[self setRememberSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.usernameField = nil;
    self.passwordField = nil;
    self.statusLabel = nil;
    self.loadAlert = nil;
    self.loginButton = nil;
}


- (void)dealloc
{
    [usernameField release];
    [passwordField release];
    [statusLabel release];
	//[mainMenuViewController release];
    [loadAlert release];
    [loginButton release];
    
	[rememberSwitch release];
    [super dealloc];
}


@end
