//
//  FormEditorViewController.m
//  FormNinja
//
//  Created by Programmer on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormEditorViewController.h"


@implementation FormEditorViewController

-(IBAction) saveButtonPressed
{
    //set form completion date.
    
    //Concern/Note to self:  I need to detect that throughout entire view, because if the form is completed, then no values should be editable.
}
-(IBAction) dumpButtonPressed
{
    
}
-(IBAction) finishButtonPressed
{
    
}

-(void) newFormWithTemplate:(NSMutableArray *)data
{
	[self setDataArray:data];
	// TODO: whatever (view) updates need to be called
}

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

@end
