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
	
    //set form completion date.
    
    //Concern/Note to self:  I need to detect that throughout entire view, because if the form is completed, then no values should be editable.
}

-(IBAction) finishButtonPressed
{
    
}


-(void) newFormWithTemplateAtPath:(NSString *)pathArg
{
	[self setDataArray:[NSMutableArray arrayWithContentsOfFile:pathArg]];
	NSMutableDictionary * dict = [dataArray objectAtIndex:0];
	
	NSString * group = [dict objectForKey:templateGroupKey];
	NSString * template = [dict objectForKey:templateNameKey];
	NSString * agent;
	AccountClass * user = [AccountClass sharedAccountClass];
	if([user firstName] && [user lastName])
		agent = [NSString stringWithFormat:@"%@ %@", [user firstName], [user lastName]];
	else
		agent = @"John Doe";
	NSString * formName = [NSString stringWithFormat:@"%i", time(0)];
	
	[dict setValue:formName forKey:formNameKey];
	[dict setValue:agent forKey:formAgentKey];
	[dict setValue:[NSDate date] forKey:formBeginDateKey];
	
	[self setPath:[NSString stringWithFormat:@"%@/%@-%@-%@-%@", FORM_PATH, group, template, agent, formName]];
}
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
-(void) editFormAtPath:(NSString*) pathArg
{
	[self setPath:pathArg];
	[self setDataArray:[NSMutableArray arrayWithContentsOfFile:path]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

# pragma mark - Member Functions
-(TemplateElement*) getElementOfType:(NSString*)type
{
	return [FormElementPicker formElementOfType:type delegate:self];
}


//Presents popover menu
- (void) menuButtonAction:(id) sender{
    [[PopOverManager sharedManager] createMenuPopOver:accountProfileMenu fromButton:sender];
}

@end
