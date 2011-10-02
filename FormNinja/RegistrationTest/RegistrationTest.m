//
//  RegistrationTest.m
//  FormNinja
//
//  Created by Hackenslacker on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegistrationTest.h"
#import "WebServiceLink.h"

@implementation RegistrationTest
@synthesize regMessage;
@synthesize loginMessage;
@synthesize resultTextView;
@synthesize usernameField, passwordField;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - View Controls

-(IBAction) fauxRegistrationPressed
{   
    /*
    id regger=[WebServiceLink registerUserWithDelegate:self andUserName:@"Rilbur" andPassword:@"Rilbur" andFName:@"Fname" andLName:@"lname" andEmail:@"email@email.com" andZip:@"93245" andZipExt:@"2423" andPhoneNumber:@"5596818113" andCompany:@"thotstudios" andSecurityQuestion:@"quest" andSecurityAnswer:@"tion"];
    self.registration=regger;*/
    self.regMessage=[RegistrationMessage registerNewUserWithUserName:@"Rilbur" andPassword:@"Rilbur" andFName:@"Fname" andLName:@"lname" andEmail:@"email@email.com" andZip:@"93245" andZipExt:@"2423" andPhoneNumber:@"5596818113" andCompany:@"thotstudios" andSecurityQuestion:@"quest" andSecurityAnswer:@"answer" andDelegate:self];
    [resultTextView setText:@"Sending request..."];
}

-(IBAction) loginPressed
{
    //id log=[WebServiceLink loginWithUserName:[usernameField text] andPassword:[passwordField text] withDelegate:self];
    //self.logger=log;
    [[WebServiceMessageQueue sharedInstance] clearQueue];
    //[self fauxRegistrationPressed];
    loginMessage=[LoginMessage loginWithUsername:[self.usernameField text] andPassword:[self.passwordField text] withDelegate:self];
    
}

#pragma mark - Web Service Delegates

//Registration delegate functions
-(void)registrationSuccessful
{
    NSLog(@"Registration successful!");
}

-(void)registrationFailedWithError:(NSError *) error
{
    NSLog(@"Registration failed: %@", [error description]);
}

//Login Delegate FUnctions
-(void)loginSuccessful
{
    NSLog(@"Login successful!");
}
-(void)loginFailedWithError:(NSError *)error
{
    NSLog(@"login failed :( ");
}

//message delegate functions
-(void)messageError:(NSError *)messageError
{
    NSLog(@"Message failure: %@", [messageError description]);
}

@end
