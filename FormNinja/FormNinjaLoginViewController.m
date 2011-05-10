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

@implementation FormNinjaLoginViewController
@synthesize mainMenuViewController;


#pragma mark - View lifecycle


@synthesize usernameField, passwordField;

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
    NSLog(@"login (%@:%@)", [usernameField text], [passwordField text]);
    NSURL *urlToSend = [[[NSURL alloc] initWithString: @"http://www.rilburskryler.net/mobile/login.php"] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
    [request setPostValue:self.usernameField.text forKey:@"username"];  
    [request setPostValue:self.passwordField.text forKey:@"password"];  
    
    [request startSynchronous];  
    NSError *error = [request error];  
    if (!error) {  
        NSString *response = [request responseString];
        NSLog(@"repsonse %@", response);
    }
    
    /*
    NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"repsonse %@", response);
    }*/

	//[self presentModalViewController:mainMenuViewController animated:YES];
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
}


- (void)dealloc
{
    [usernameField release];
    [passwordField release];
	[mainMenuViewController release];
    [super dealloc];
}


@end
