//
//  FormEditorViewController.m
//  FormNinja
//
//  Created by Programmer on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormEditorViewController.h"
#import "FormTemplateElement.h"
#import "FormElementPicker.h"
#import "AccountClass.h"
#import "PopOverManager.h"

@implementation FormEditorViewController

@synthesize allowEditing;

#pragma mark - View Lifecycle

-(void) viewDidLoad
{
    [super viewDidLoad];
	
    //Menu button
	UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction:)]; 
    self.navigationItem.rightBarButtonItem = menuButton;
    [menuButton release];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[PopOverManager sharedManager] dismissCurrentPopoverController:YES]; //dismiss popover
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark -

-(IBAction) saveButtonPressed
{
	if(!([[NSFileManager defaultManager] fileExistsAtPath:FORM_PATH]))
		[[NSFileManager defaultManager] createDirectoryAtPath:FORM_PATH withIntermediateDirectories:YES attributes:nil error:nil];
	
	if([dataArray writeToFile:path atomically:YES])
		{
		[[[[UIAlertView alloc] initWithTitle:FORM_SAVED_STR message:nil delegate:nil cancelButtonTitle:OKAY_STR otherButtonTitles:nil] autorelease] show];
		}
	else
		{
		[[[[UIAlertView alloc] initWithTitle:SAVE_FAILED_STR message:nil delegate:nil cancelButtonTitle:OKAY_STR otherButtonTitles:nil] autorelease] show];
		}
	
}

-(IBAction) finishButtonPressed
{
    NSMutableDictionary * dict = [dataArray objectAtIndex:0];
	[dict setValue:[NSNumber numberWithBool:YES] forKey:formCompletedKey];
	[dict setValue:CURRENT_DATE_AND_TIME forKey:formFinalDateKey];
    
    //Concern/Note to self:  I need to detect that throughout entire view, because if the form is completed, then no values should be editable.
	
	// Do whatever else to finalized the form
	// e.g. upload to database, or add to pending sync list
	
	[self saveButtonPressed];
}

-(void) abortFormConfirmed
{
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	[self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)abortFormPressed
{
	UIActionSheet * sheet = [[[UIActionSheet alloc] initWithTitle:@"Really abondon this form?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:CONFIRM_DELETE_BUTTON_STR otherButtonTitles:nil] autorelease];
	[sheet setTag:1];
	[sheet showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if([actionSheet tag] == 1 && buttonIndex == [actionSheet destructiveButtonIndex])
		[self abortFormConfirmed];
}

-(void) newFormWithTemplateAtPath:(NSString *)pathArg
{
	[self setDataArray:[NSMutableArray arrayWithContentsOfFile:pathArg]];
	NSMutableDictionary * dict = [dataArray objectAtIndex:0];
	
	NSString * group = [dict objectForKey:templateGroupKey];
	NSString * template = [dict objectForKey:templateNameKey];
	NSString * agent = CURRENT_USERNAME;
	NSString * formName = [NSString stringWithFormat:@"%@-%i", template, time(0)];
	
	[dict setValue:formName forKey:formNameKey];
	[dict setValue:agent forKey:formAgentKey];
	[dict setValue:CURRENT_DATE_AND_TIME forKey:formBeginDateKey];
	
	[self setPath:[NSString stringWithFormat:@"%@/%@-%@-%@-%@.%@", FORM_PATH, group, template, agent, formName, FORM_EXT]];
	[self setAllowEditing:YES];
}

-(void) loadFormAtPath:(NSString*) pathArg
{
	[self setPath:pathArg];
	[self setDataArray:[NSMutableArray arrayWithContentsOfFile:path]];
}

# pragma mark - Member Functions
-(TemplateElement*) getElementOfType:(NSString*)type
{
	TemplateElement * element = [FormElementPicker formElementOfType:type delegate:self];
	[element setAllowEditing:allowEditing];
	return element;
}


//Presents popover menu
- (void) menuButtonAction:(id) sender{
    [[PopOverManager sharedManager] createMenuPopOver:accountProfileMenu fromButton:sender];
}

@end
