//
//  FormManagerViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormManagerViewController.h"
#import "Constants.h"

@implementation FormManagerViewController

@synthesize formList;

@synthesize formTable;
@synthesize createFormButton;
@synthesize resumeFormButton;

@synthesize formEditorViewController;

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
	[formList release];
    [formTable release];
    [formEditorViewController release];
	[createFormButton release];
	[resumeFormButton release];
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
	[self setFormList:nil];
    [self setFormTable:nil];
    [self setFormEditorViewController:nil];
	[self setCreateFormButton:nil];
	[self setResumeFormButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Instance Methods
-(void) filterTemplatesToPublished
{
	for(NSDictionary * dict in templateList)
		{
		if(!([[[[dict valueForKey:@"data"] objectAtIndex:0] valueForKey:@"published"] boolValue]))
			[templateList removeObject:dict];
		}
}
-(void) loadFormList
{
	//NSArray * directory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:FORM_PATH error:nil];
	
	
}

- (IBAction)newFormWithSelectedTemplate
{
	NSUInteger row = [[templateTable indexPathForSelectedRow] row];
	NSDictionary * dict = [filteredTemplateList objectAtIndex:row];
	NSMutableArray * data = [dict objectForKey:@"data"];
	
	// These two lines might be backwards:
	[self.navigationController pushViewController:formEditorViewController animated:YES];
	[formEditorViewController newFormWithTemplate:data];
}

- (IBAction)resumeSelectedForm
{
	// [formEditorViewController clear];
	[self.navigationController pushViewController:formEditorViewController animated:YES];
	// [formEditorViewController setData:nil/*selected data*/];
}

-(void) disableButtons
{
	[super disableButtons];
	[createFormButton setEnabled:NO];	[createFormButton setAlpha:0.50];
	[resumeFormButton setEnabled:NO];	[resumeFormButton setAlpha:0.50];
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
	[resumeFormButton setEnabled:YES];	[resumeFormButton setAlpha:1.00];
	}
	// TODO: lite version
}
#pragma mark - TableView DataSource


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	NSInteger r = 0;
	
	if([table tag] < 3)
		r = [super tableView:table numberOfRowsInSection:section];
	else
		r = [formList count];
	
	return r;
}
-(NSString*) tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section
{
	NSString * ret = nil;
	if([table tag] < 3)
		ret = [super tableView:table titleForHeaderInSection:section];
	else
		ret = @"Incomplete Forms"; // TODO: localize
	return ret;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
		[[cell textLabel] setText:[formList objectAtIndex:[indexPath row]]];
		break;
			
		case 2: // templates
		
		if([self isTemplateAtIndexPublished:[indexPath row]])
			[[cell textLabel] setTextColor:[UIColor blackColor]];
		else
			[[cell textLabel] setTextColor:[UIColor grayColor]];
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
		//[self filterByGroupName];
		break;
		
		case 2: // template table
		//[self enableButtons];
		break;
		
		case 3: // form table
		[self enableButtons];
		break;
	}
}
@end
