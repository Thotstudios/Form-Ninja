//
//  MainMenu.m
//  FormNinja
//
//  Created by Hackenslacker on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "Constants.h"

@implementation MainMenu
@synthesize templateEditorViewController;
@synthesize accountEditor;
@synthesize loginViewController;
@synthesize templateManagerViewContoller;
@synthesize loginExpirationLabel;

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
	[templateEditorViewController release];
	[accountEditor release];
	[loginViewController release];
	[loginExpirationLabel release];
	[templateManagerViewContoller release];
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
	NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
	
	long loginExpiration = [opt integerForKey:loginExpirationKey];
	
	if(loginExpiration < time(0))
		{
		if(1) // TODO: has_internet_access
			[self.navigationController pushViewController:loginViewController animated:YES];
		// else
		// extend expiration
		}
	
	{ // set Login Expiration Label message
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
		[loginExpirationLabel setText:[NSString stringWithFormat:@"Login expires in %i %@", count, units]];
	} // end set Login Expiration Label message
	
	
}

- (void)viewDidUnload
{
	[self setTemplateEditorViewController:nil];
	[self setAccountEditor:nil];
	[self setLoginViewController:nil];
	[self setLoginExpirationLabel:nil];
	[self setTemplateManagerViewContoller:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark - Interface Actions

- (IBAction)buttonPressedForms:(id)sender
{
}

- (IBAction)buttonPressedTemplateManagement:(id)sender
{
	[self.navigationController pushViewController:templateManagerViewContoller animated:YES];
}

- (IBAction)buttonPressedAccount:(id)sender
{
	[self.navigationController pushViewController:accountEditor animated:YES];
}

- (IBAction)requireLogin
{
	NSUserDefaults * opt = [NSUserDefaults standardUserDefaults];
	[opt setInteger:0 forKey:loginExpirationKey];
	[opt synchronize];
	
	[self.navigationController pushViewController:loginViewController animated:YES];
}

// TODO temporary
- (IBAction)buttonPressedTemplateEditor:(id)sender
{
	[self.navigationController pushViewController:templateEditorViewController animated:YES];
}
@end
