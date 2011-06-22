//
//  FormManagerViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormManagerViewController.h"
#import "Constants.h"


@interface FormManagerViewController()
-(void) loadFormList;
-(void) filterFormsByGroup;
@end

@implementation FormManagerViewController

@synthesize formList;
@synthesize formListFilteredByGroup;
@synthesize formListFilteredByTemplate;
@synthesize formNameList;

@synthesize formTable;
@synthesize createFormButton;
@synthesize resumeFormButton;
@synthesize viewFormButton;
@synthesize deleteFormButton;

@synthesize formEditorViewController;

- (void)dealloc
{
	[formList release];
	[formListFilteredByGroup release];
	[formListFilteredByTemplate release];
	[formNameList release];
    [formTable release];
    [formEditorViewController release];
	[createFormButton release];
	[resumeFormButton release];
    [viewFormButton release];
    [deleteFormButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	[self setFormList:[NSMutableArray array]];
	[self setFormListFilteredByGroup:[NSMutableArray array]];
	[self setFormListFilteredByTemplate:[NSMutableArray array]];
	[self setFormNameList:[NSMutableArray array]];

    //Menu button
	UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction:)]; 
    self.navigationItem.rightBarButtonItem = menuButton;
    [menuButton release];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[self loadFormList];
	
    [[PopOverManager sharedManager] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[PopOverManager sharedManager] dismissCurrentPopoverController:YES]; //dismiss popover
    [[PopOverManager sharedManager] setDelegate:nil];
}

- (void)viewDidUnload
{
	[self setFormList:nil];
	[self setFormListFilteredByGroup:nil];
	[self setFormListFilteredByTemplate:nil];
	[self setFormNameList:nil];
    [self setFormTable:nil];
    [self setFormEditorViewController:nil];
	[self setCreateFormButton:nil];
	[self setResumeFormButton:nil];
    [self setViewFormButton:nil];
    [self setDeleteFormButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Instance Methods

-(BOOL) isSelectedFormCompleted
{
	BOOL ret = NO;
	NSIndexPath * indexPath = [formTable indexPathForSelectedRow];
	if(indexPath)
		{
		NSInteger row = [indexPath row];
		NSMutableDictionary * dict = [formListFilteredByTemplate objectAtIndex:row];
		ret = [[dict valueForKey:formCompletedKey] boolValue];
		}
	return ret;
}
-(void) filterFormsByGroup
{
	[formListFilteredByGroup removeAllObjects];
	[formListFilteredByTemplate removeAllObjects];
	
	NSString * groupName = [groupNameList objectAtIndex:[[groupTable indexPathForSelectedRow] row]];
	for(NSDictionary * dict in formList)
		{
		if([groupName isEqualToString:ALL_GROUPS_STR] || [groupName isEqualToString:[dict valueForKey:templateGroupKey]])
			{
			[formListFilteredByGroup addObject:dict];
			[formListFilteredByTemplate addObject:dict];
			}
		}
	[formTable reloadData];
}

-(void) filterFormsByTemplate
{
	[formListFilteredByTemplate removeAllObjects];
	NSString * templateName = nil;
	if([filteredTemplateList count])
		templateName = [[filteredTemplateList objectAtIndex:[[templateTable indexPathForSelectedRow] row]] objectForKey:templateNameKey];
	for(NSDictionary * dict in formListFilteredByGroup)
		{
		if([templateName isEqualToString:[dict objectForKey:templateNameKey]])
			[formListFilteredByTemplate addObject:dict];
		}
	[formTable reloadData];
}

-(void) loadFormList
{
	NSArray * directory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:FORM_PATH error:nil];
	
	NSString * path;
	NSMutableArray * data;
	NSString * templateName;
	NSString * formName;
	NSString * group;
	NSMutableDictionary * formMetaData;
	NSMutableDictionary * dict;
	BOOL isComplete;
	
	[formList removeAllObjects];
	[formNameList removeAllObjects];
	
	for(NSString * file in directory)
		{
		data = nil;
		group = nil;
		templateName = nil;
		formName = nil;
		dict = nil;
		
		path = [NSString stringWithFormat:@"%@/%@", FORM_PATH, file];
		data = [NSMutableArray arrayWithContentsOfFile:path];
		if([data count])
			{
			formMetaData = [data objectAtIndex:0];
			
			templateName = [formMetaData objectForKey:templateNameKey];
			group = [formMetaData objectForKey:templateGroupKey];
			
			formName = [formMetaData objectForKey:formNameKey];
			// agent
			// begin date
			// end date
			isComplete = [[formMetaData valueForKey:formCompletedKey] boolValue];
			
			dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:path, filePathKey, group, templateGroupKey, templateName, templateNameKey, formName, formNameKey, [NSNumber numberWithBool:isComplete], formCompletedKey, nil];
			}
		if(dict)
			{
			[formList addObject:dict];
			if(![[formMetaData valueForKey:formCompletedKey] boolValue])
				formName = [NSString stringWithFormat:@"%@ (Incomplete)", formName];
			[formNameList addObject:formName];
			}
		}
	[self filterFormsByGroup];
}

- (IBAction)newFormWithSelectedTemplate
{
	NSIndexPath * indexPath = [templateTable indexPathForSelectedRow];
	if(!indexPath) return;
	NSUInteger row = [indexPath row];
	NSDictionary * dict = [filteredTemplateList objectAtIndex:row];
	NSString * path = [dict objectForKey:filePathKey];
	
	[formEditorViewController newFormWithTemplateAtPath:path];
	[self.navigationController pushViewController:formEditorViewController animated:YES];
}

-(void) loadSelectedForm
{
	NSIndexPath * indexPath = [formTable indexPathForSelectedRow];
	if(!indexPath) return;
	NSUInteger row = [indexPath row];
	NSDictionary * dict = [formListFilteredByTemplate objectAtIndex:row];
	NSString * path = [dict objectForKey:filePathKey];
	
	[formEditorViewController loadFormAtPath:path];
	[self.navigationController pushViewController:formEditorViewController animated:YES];
}
- (IBAction)editSelectedForm
{
	[formEditorViewController setAllowEditing:YES];
	[self loadSelectedForm];
}

- (IBAction)viewSelectedForm
{
	[formEditorViewController setAllowEditing:NO];
	[self loadSelectedForm];
}

-(void) deleteSelectedFormConfirm
{
	NSIndexPath * indexPath = [formTable indexPathForSelectedRow];
	if(!indexPath) return;
	NSInteger row = [indexPath row];
	NSDictionary * dict = [formListFilteredByTemplate objectAtIndex:row];
	NSString * path = [dict valueForKey:filePathKey];
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	[self loadFormList];
	[self disableButtons];
}
- (IBAction)deleteSelectedForm
{
	if(![formTable indexPathForSelectedRow]) return;
	UIActionSheet * sheet = [[[UIActionSheet alloc] initWithTitle:CONFIRM_DELETE_FORM_STR delegate:self cancelButtonTitle:nil destructiveButtonTitle:CONFIRM_DELETE_BUTTON_STR otherButtonTitles:nil] autorelease];
	[sheet setTag:2];
	[sheet showInView:self.view];
}

//Presents popover menu
- (void) menuButtonAction:(id) sender{
    if([formTable indexPathForSelectedRow])
        [[PopOverManager sharedManager] createMenuPopOver:formManagerMenu fromButton:sender];
    
    else
        [[PopOverManager sharedManager] createMenuPopOver:formManagerNoSendMenu fromButton:sender];
}

-(void) disableButtons
{
	[super disableButtons];
	[createFormButton setEnabled:NO];	[createFormButton setAlpha:0.50];
	[resumeFormButton setEnabled:NO];	[resumeFormButton setAlpha:0.50];
	[viewFormButton setEnabled:NO];		[viewFormButton setAlpha:0.50];
	[deleteFormButton setEnabled:NO];	[deleteFormButton setAlpha:0.50];
	// TODO: lite version
}
-(void) enableButtons 
{
	[super enableButtons];
	if([self isSelectedTemplatePublished])
		{
		[createFormButton setEnabled:YES];	[createFormButton setAlpha:1.00];
		}
	else
		{
		[createFormButton setEnabled:NO];	[createFormButton setAlpha:0.50];
		}
	if([formTable indexPathForSelectedRow])
		{
		if([self isSelectedFormCompleted])
			{
			[resumeFormButton setEnabled:NO];	[resumeFormButton setAlpha:0.50];
			}
		else
			{
			[resumeFormButton setEnabled:YES];	[resumeFormButton setAlpha:1.00];
			}
			
		[viewFormButton setEnabled:YES];	[viewFormButton setAlpha:1.00];
		[deleteFormButton setEnabled:YES];	[deleteFormButton setAlpha:1.00];
		}
	else
		{
		[resumeFormButton setEnabled:NO];	[resumeFormButton setAlpha:0.50];
		[viewFormButton setEnabled:NO];		[viewFormButton setAlpha:0.50];
		[deleteFormButton setEnabled:NO];	[deleteFormButton setAlpha:0.50];
		}
	// TODO: lite version
}


- (void) emailForm{
    //Get selected form and email
    NSLog(@"email");
}

- (void) airPrintForm{
    //Get selected form and airprint
    NSLog(@"airprint");
}


#pragma mark - TableView DataSource


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	NSInteger r = 0;
	
	if([table tag] < 3)
		r = [super tableView:table numberOfRowsInSection:section];
	else
		r = [formListFilteredByTemplate count];
	
	return r;
}
-(NSString*) tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section
{
	NSString * ret = nil;
	if([table tag] < 3)
		ret = [super tableView:table titleForHeaderInSection:section];
	else
		ret = @"Forms"; // TODO: localize
	return ret;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	NSString *CellIdentifier = nil;
	switch ([table tag])
	{
		case 3:
		CellIdentifier = @"Form Table Cell";
		break;
		
		default:
		CellIdentifier = @"Cell";
		break;
	}
    UITableViewCell *cell;
	
	// Obtain the cell...
	if([table tag] < 3)
		cell = [super tableView:table cellForRowAtIndexPath:indexPath];
	else
		cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
    // Configure the cell...
	switch ([table tag])
	{
		case 3: // forms
		[[cell textLabel] setText:[[formListFilteredByTemplate objectAtIndex:row] objectForKey:formNameKey]];
		break;
			
		case 2: // templates
		
		if([self isTemplateAtIndexPublished:row])
			[[cell textLabel] setTextColor:[UIColor blackColor]];
		else
			{
			[[cell textLabel] setTextColor:[UIColor grayColor]];
			// TODO: remove or fix
			if(![self isTemplateAtIndexPublished:row])
				{
				// change cell text
				}
			}
		break;
		
		case 1: // groups
		default:
		break;
	}
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[super tableView:table didSelectRowAtIndexPath:indexPath];
	switch([table tag])
	{
		case 1: // group table
		[self filterFormsByGroup];
		[formTable reloadData];
		break;
		
		case 2: // template table
		[self filterFormsByTemplate];
		[formTable reloadData];
		[self enableButtons];
		break;
		
		case 3: // form table
		[self enableButtons];
		break;
	}
}

#pragma mark - ActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if([actionSheet destructiveButtonIndex] == buttonIndex)
		{
		switch ([actionSheet tag])
			{
				case 2:
				[self deleteSelectedFormConfirm];
				break;
			}
		}
	
}
@end
