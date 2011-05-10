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

@implementation FormNinjaLoginViewController
@synthesize mainMenuViewController;


#pragma mark - View lifecycle


@synthesize usernameField, passwordField, statusLabel;

//git://github.com/Thotsudios/Form-Ninja.git


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.usernameField becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark - Instance Methods

- (IBAction) loginButtonAction{
    //Test account info
    //un:test pass:test
    NSLog(@"login (%@:%@)", [usernameField text], [passwordField text]);
    
    //Dismiss keyboard
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    //Prepare form
    NSURL *urlToSend = [[[NSURL alloc] initWithString: @"http://www.rilburskryler.net/mobile/login.php"] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
    [request setPostValue:self.usernameField.text forKey:@"username"];  
    [request setPostValue:self.passwordField.text forKey:@"password"];  
        
    //Send request
    request.delegate = self;
    [request startAsynchronous];  
}


//Called when user has been authenticated
- (void) userAuthenticated{
    NSLog(@"ACCEPTED");
    [self presentModalViewController:mainMenuViewController animated:YES];
}


//Called when user has failed authenticated
- (void) userAuthenticatedFailed:(NSString *)error{
    self.statusLabel.text = error;
}



#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"REQUEST FAIELD");
}


- (void)requestFinished:(ASIHTTPRequest *)request{	
    //Get intial dict from response string
	NSDictionary *jsonDict = [[request responseString] JSONValue];    
    NSString *userAccepted = [jsonDict objectForKey:@"accepted"]; //Get response

    if([userAccepted isEqualToString:@"True"]){
        [self userAuthenticated];
    }
    
    else{
        [self userAuthenticatedFailed:[jsonDict objectForKey:@"error"]];
    }
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
	[self setMainMenuViewController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.usernameField = nil;
    self.passwordField = nil;
    self.statusLabel = nil;
}


- (void)dealloc
{
    [usernameField release];
    [passwordField release];
    [statusLabel release];
	[mainMenuViewController release];
    [super dealloc];
}


@end
