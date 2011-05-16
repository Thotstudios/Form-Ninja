//
//  MainMenu.m
//  FormNinja
//
//  Created by Hackenslacker on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"


@implementation MainMenu
@synthesize templateEditorViewController;
@synthesize accountEditor;
@synthesize loginViewController;

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
	[self setTemplateEditorViewController:nil];
	[self setAccountEditor:nil];
	[self setLoginViewController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)buttonPressedForms:(id)sender{
}

- (IBAction)buttonPressedManagement:(id)sender {
}

- (IBAction)buttonPressedAccount:(id)sender
{
	[self.navigationController pushViewController:accountEditor animated:YES];
}

- (IBAction)requireLogin:(id)sender
{
	[self.navigationController pushViewController:loginViewController animated:YES];
}

// TODO temporary
- (IBAction)buttonPressedTemplateEditor:(id)sender
{
	[self.navigationController pushViewController:templateEditorViewController animated:YES];
}
@end
