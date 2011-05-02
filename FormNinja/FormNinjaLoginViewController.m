//
//  FormNinjaViewController.m
//  FormNinja
//
//  Created by Ollin on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormNinjaLoginViewController.h"

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
	
	[self presentModalViewController:mainMenuViewController animated:YES];
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
