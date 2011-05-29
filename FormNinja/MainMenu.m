//
//  MainMenu.m
//  FormNinja
//
//  Created by Hackenslacker on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "Constants.h"
#import "AccountClass.h"
#import "AccountEditorViewController.h"

@interface MainMenu ()
-(void) updateLoginExpirationLabel;
@end

@implementation MainMenu

@synthesize loginExpirationLabel;
@synthesize versionLabel;

@synthesize loginViewController;
@synthesize formManagerViewController;
@synthesize templateManagerViewContoller;
@synthesize groupManagerViewController;
@synthesize accountEditor;

// TODO: temporary
@synthesize templateEditorViewController;
@synthesize temporaryFormEditorViewController;
//

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
	[loginExpirationLabel release];
	
	[loginViewController release];
	[formManagerViewController release];
	[templateManagerViewContoller release];
	[groupManagerViewController release];
	[accountEditor release];
	
	// TODO: Temporary
	[templateEditorViewController release];
    [temporaryFormEditorViewController release];
	//
	
    [versionLabel release];
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
-(void) viewDidAppear:(BOOL)animated
{
	[self updateLoginExpirationLabel];
	[self.versionLabel setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (void)viewDidUnload
{
	[self setLoginExpirationLabel:nil];
	
	[self setLoginViewController:nil];
	[self setFormManagerViewController:nil];
	[self setTemplateManagerViewContoller:nil];
	[self setGroupManagerViewController:nil];
	[self setAccountEditor:nil];
	
	[self setTemplateEditorViewController:nil];
    [self setTemporaryFormEditorViewController:nil];
	
    [self setVersionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



#pragma mark - Interface Actions
-(void) updateLoginExpirationLabel
{
	NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
	long loginExpiration = [opt integerForKey:loginExpirationKey];
	if(loginExpiration < time(0))
		{
		if(1) // TODO: has_internet_access
			[self.navigationController pushViewController:loginViewController animated:YES];
		// else
		// extend expiration
		}
	
	long count = loginExpiration - time(0);
	NSString * units = @"second";
	
	// Divide out the units (as float), and round up:
	if(count > 60) // seconds
		{
		count = 0.50 + count / 60.;
		units = @"minute";
		if(count > 60) // minutes
			{
			count = 0.50 + count / 60.;
			units = @"hour";
			if(count > 24) // hours
				{
				count = 0.50 + count / 24.;
				units = @"day";
				if(count > 7) // days
					{
					count = 0.50 + count / 7.;
					units = @"week";
					}
				}
			}
		}
	
	// make the units plural:
	if(count > 1) units = [units stringByAppendingString:@"s"];
	
	// set the message
	if(count > 0)
		[loginExpirationLabel setText:[NSString stringWithFormat:@"Login expires in %i %@", count, units]];
	else
		[loginExpirationLabel setText:[NSString stringWithFormat:@"Login expired."]];
}

#pragma mark - Push View Controllers

- (IBAction)pushFormManagerViewController
{
	[self.navigationController pushViewController:formManagerViewController animated:YES];
}

- (IBAction)pushTemplateManagerViewController
{
	[self.navigationController pushViewController:templateManagerViewContoller animated:YES];
}

- (IBAction)pushGroupManagerViewController
{
	[self.navigationController pushViewController:groupManagerViewController animated:YES];
}

- (IBAction)pushAccountEditorViewController
{
    ((AccountEditorViewController *)accountEditor).type = 1;
	[self.navigationController pushViewController:accountEditor animated:YES];
}

- (IBAction)logout
{
	NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
	[opt setInteger:0 forKey:loginExpirationKey];
	[opt synchronize];
	
	[AccountClass invalidateAccountInformation];

	[self.navigationController pushViewController:loginViewController animated:YES];
}

#pragma mark - Temporary Methods

- (IBAction)buttonPressedTemplateEditor:(id)sender
{
	[self.navigationController pushViewController:templateEditorViewController animated:YES];
}
- (IBAction)pressedTemporaryFormEditorButton
{
	[self.navigationController pushViewController:temporaryFormEditorViewController animated:YES];
}
#pragma mark -
@end
