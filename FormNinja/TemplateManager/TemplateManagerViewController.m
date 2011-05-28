//
//  TemplateManagerViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateManagerViewController.h"
#import "Constants.h"

#import "TemplateEditorController.h"

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
@synthesize templateEditorViewController;
@synthesize templateEditorB;

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
	
    [templateEditorViewController release];
	[deleteButton release];
	[modifyButton release];
	[duplicateButton release];
	[newButton release];
    [templateEditorB release];
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
	
    [self setTemplateEditorViewController:nil];
	[self setDeleteButton:nil];
	[self setModifyButton:nil];
	[self setDuplicateButton:nil];
	[self setNewButton:nil];
    [self setTemplateEditorB:nil];
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
	NSArray * tmp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS_PATH error:nil];
	
	// clear the name list and path list
	[templateNameList removeAllObjects];
	[templatePathList removeAllObjects];
	
	for(NSString * str in tmp)
		{
		// filter file list:
		if( ![str hasPrefix:@"."] )
			{
			[templatePathList addObject:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_PATH, str]];
			
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
	[[NSFileManager defaultManager] removeItemAtPath:[templatePathList objectAtIndex:[[templateTableView indexPathForSelectedRow] row]] error:NULL];
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

- (IBAction)updateSelectedTemplate
{
	[self.navigationController pushViewController:templateEditorB animated:YES];
	NSUInteger row = [[templateTableView indexPathForSelectedRow] row];
	NSString * path = [templatePathList objectAtIndex:row];
	NSMutableArray * data = [NSMutableArray arrayWithContentsOfFile:path];
	[templateEditorB setData:data];
}

- (void) duplicateSelectedTemplateNamed:(NSString*)newName
{
	// TODO
	// duplicate selected template
	// retain group name
	// rename template to newName
}

- (IBAction)duplicateSelectedTemplate
{
	// TODO
	NSLog(@"Should duplicate and rename file at path:\n%@", [templatePathList objectAtIndex:[[templateTableView indexPathForSelectedRow] row]]);
	// prompt for new name
	// call duplicateSelectedTemplateNamed: with string arg for new template name
}

- (IBAction)createNewTemplate
{
	[self.navigationController pushViewController:templateEditorViewController animated:YES];
}

- (IBAction)pushTemplateEditorB
{
	[self.navigationController pushViewController:templateEditorB animated:YES];
}


- (IBAction)testAddTemplateFile
{
	// make new file
	NSString * path = [NSString stringWithFormat:@"%@/No Group-%i.txt", DOCUMENTS_PATH, time(0)];
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
		//[self setSelectedTemplatePath:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_PATH, selectedTemplateName]];
		[self enableButtons];
		break;
		
		default:
		break;
	}
}


@end
