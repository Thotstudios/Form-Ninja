//
//  TemplateManagerViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateManagerViewController.h"
#import "Constants.h"

@interface TemplateManagerViewController()
-(void) loadTemplateList;
-(void) disableButtons;
-(void) enableButtons;
@end

@implementation TemplateManagerViewController
@synthesize deleteButton;
@synthesize modifyButton;
@synthesize duplicateButton;
@synthesize newButton;

@synthesize groupTableView;
@synthesize groupNameList;
@synthesize selectedGroupName;

@synthesize templateTableView;
@synthesize templateNameList;
@synthesize templatePathList;
@synthesize selectedTemplateName;
@synthesize selectedTemplatePath;
@synthesize templateEditorViewController;

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
	[groupTableView release];
	[groupNameList release];
	[selectedGroupName release];
	
	[templateTableView release];
	[templateNameList release];
	[templatePathList release];
	[selectedTemplateName release];
	[selectedTemplatePath release];
	
    [templateEditorViewController release];
	[deleteButton release];
	[modifyButton release];
	[duplicateButton release];
	[newButton release];
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
	[self setGroupNameList:[[NSMutableArray alloc] init]];
	[self setTemplateNameList:[[NSMutableArray alloc] init]];
	[self setTemplatePathList:[[NSMutableArray alloc] init]];
}
-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	{ // load group name list and select All Groups
		[groupNameList addObject:ALL_GROUPS_STR];
		[groupTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:(NSUInteger[2]){0,0} length:2] animated:YES scrollPosition:UITableViewScrollPositionTop];
		
		[self setSelectedGroupName:ALL_GROUPS_STR];
	} // end load group name list
	
	[self loadTemplateList];
	[self disableButtons];
}

- (void)viewDidUnload
{
	[self setGroupTableView:nil];
	[self setGroupNameList:nil];
	[self setSelectedGroupName:nil];
	
	[self setTemplateTableView:nil];
	[self setTemplateNameList:nil];
	[self setTemplatePathList:nil];
	[self setSelectedTemplateName:nil];
	[self setSelectedTemplatePath:nil];
	
    [self setTemplateEditorViewController:nil];
	[self setDeleteButton:nil];
	[self setModifyButton:nil];
	[self setDuplicateButton:nil];
	[self setNewButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Instance Methods
-(void) loadTemplateList
{
	NSArray * tmp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:TEMPLATE_PATH error:nil];
	
	// clear the name list and path list
	[templateNameList removeAllObjects];
	[templatePathList removeAllObjects];
	
	for(NSString * str in tmp)
		{
		// filter file list:
		if( ![str hasPrefix:@"."] )
			{
			[templatePathList addObject:str];
			
			// TODO get template name
			[templateNameList addObject:str];
			}
		}
	[templateTableView reloadData];
} // end load template list

-(void) disableButtons
{
	[deleteButton setEnabled:NO];		[deleteButton setAlpha:0.50];
	[modifyButton setEnabled:NO];		[modifyButton setAlpha:0.50];
	[duplicateButton setEnabled:NO];	[duplicateButton setAlpha:0.50];
	
	// TODO: check demo and template count:
	//[newButton setEnabled:NO];		[newButton setAlpha:0.50];
}

-(void) enableButtons
{
	[deleteButton setEnabled:YES];		[deleteButton setAlpha:1.00];
	[modifyButton setEnabled:YES];		[modifyButton setAlpha:1.00];
	[duplicateButton setEnabled:YES];	[duplicateButton setAlpha:1.00];
	
	// TODO: check demo and template count:
	//[newButton setEnabled:YES];		[newButton setAlpha:1.00];
}

#pragma mark Interface Methods

-(void) confirmDeleteSelectedTemplate
{
	[[NSFileManager defaultManager] removeItemAtPath:selectedTemplatePath error:NULL];
	[self loadTemplateList];
	
	// TODO: DROP from table
	[self disableButtons]; // because now there's no template selected
}
- (IBAction)deleteSelectedTemplate
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:CONFIRM_DELETE_TEMPLATE_TITLE_STR delegate:self cancelButtonTitle:nil destructiveButtonTitle:CONFIRM_DELETE_TEMPLATE_BUTTON_STR otherButtonTitles:nil];
	
    [popupQuery showInView:self.view];
	
    [popupQuery release];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != [actionSheet cancelButtonIndex] && [[actionSheet title] isEqualToString:CONFIRM_DELETE_TEMPLATE_TITLE_STR])
		[self confirmDeleteSelectedTemplate];
}

- (IBAction)modifySelectedTemplate
{
	// TODO
}

- (IBAction)duplicateSelectedTemplate
{
	// TODO
}

- (IBAction)createNewTemplate
{
	[self.navigationController pushViewController:templateEditorViewController animated:YES];
}


- (IBAction)testAddTemplateFile
{
	// make new file
	NSString * path = [NSString stringWithFormat:@"%@/%i.txt", DOCUMENTS_PATH, time(0)];
	[[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
	[self loadTemplateList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSInteger r;
	switch([tableView tag])
	{
		case 1: // group table
		r = [groupNameList count];
		break;
		
		case 2: // template table
		r = [templateNameList count];
		break;
		
		default:
		r = 0;
		break;
	}
	return r;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString * r;
	switch ([tableView tag])
	{
		case 1: // group table
		//r = @"Template Groups";
		r = NSLocalizedString(@"Template Groups", @"Section Header for Groups table");
		break;
		
		
		case 2: // template table
		r = @"Available Templates"; // TODO: localize
		if([selectedGroupName length] > 0)
			r = [r stringByAppendingFormat:@" (%@)", selectedGroupName];
		break;
		
		
		default:
		r = @"Error Table Header Title"; // TODO: localize
		break;
	}
	return r;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
		{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
    
    // Configure the cell...
	switch([tableView tag])
	{
		case 1: // group table
		[[cell textLabel] setText:[groupNameList objectAtIndex:[indexPath row]]];
		break;
		
		case 2: // template table
		[[cell textLabel] setText:[templateNameList objectAtIndex:[indexPath row]]];
		break;
		
		default:
		break;
	}
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch([tableView tag])
	{
		case 1: // group table
		[self setSelectedGroupName:[groupNameList objectAtIndex:[indexPath row]]];
		[templateTableView reloadData];
		[self disableButtons];
		break;
		
		
		case 2: // template table
		[self setSelectedTemplateName:[templateNameList objectAtIndex:[indexPath row]]];
		[self setSelectedTemplatePath:[NSString stringWithFormat:@"%@/%@", TEMPLATE_PATH, selectedTemplateName]];
		[self enableButtons];
		break;
		
		
		default:
		break;
	}
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
