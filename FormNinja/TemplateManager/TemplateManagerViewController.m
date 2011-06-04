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
-(void) filterByGroupName;
-(void) disableButtons;
-(void) enableButtons;
@end

@implementation TemplateManagerViewController

@synthesize groupNameList;
@synthesize templateList;
@synthesize filteredTemplateList;

@synthesize groupTable;
@synthesize templateTable;

@synthesize deleteTemplateButton;
@synthesize copyTemplateButton;
@synthesize editTemplateButton;
@synthesize createTemplateButton;

@synthesize templateEditor;

#pragma mark - Memory

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
	[groupNameList release];
	[templateList release];
	[filteredTemplateList release];
	
	[groupTable release];
	[templateTable release];
	
	[deleteTemplateButton release];
	[copyTemplateButton release];
	[editTemplateButton release];
	[createTemplateButton release];
	
    [templateEditor release];
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
	[self setGroupNameList:[NSMutableArray array]];
	[self setTemplateList:[NSMutableArray array]];
	[self setFilteredTemplateList:[NSMutableArray array]];
}
-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//[groupNameList addObject:ALL_GROUPS_STR];
	[self loadTemplateList];
//	[groupTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:(NSUInteger[2]){0,0} length:2] animated:YES scrollPosition:UITableViewScrollPositionTop];
	
	[self filterByGroupName];
	
}
-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[groupTable reloadData];
	[templateTable reloadData];
}

- (void)viewDidUnload
{
	[self setGroupNameList:nil];
	[self setTemplateList:nil];
	[self setFilteredTemplateList:nil];
	
	[self setGroupTable:nil];
	[self setTemplateTable:nil];
	
	[self setDeleteTemplateButton:nil];
	[self setCopyTemplateButton:nil];
	[self setEditTemplateButton:nil];
	[self setCreateTemplateButton:nil];
	
    [self setTemplateEditor:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Instance Methods
-(void) filterByGroupName
{
	NSString * group = [groupNameList objectAtIndex:[[groupTable indexPathForSelectedRow] row]];
	[filteredTemplateList removeAllObjects];
	for(NSDictionary * dict in templateList)
		{
		if([group isEqualToString:ALL_GROUPS_STR] || [group isEqualToString:[dict valueForKey:@"group name"]])
			[filteredTemplateList addObject:dict];
		}
	[templateTable reloadData];
	[self disableButtons];
}
-(void) addGroupName:(NSString*)group
{
	if(!group) return;

	for(NSString * name in groupNameList)
		{
		if([name isEqualToString:group])
			return;
		}
	[groupNameList addObject:group];
}
-(void) loadTemplateList
{
	NSArray * directory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:TEMPLATE_PATH error:nil];
	
	NSString * path;
	NSMutableArray * data;
	NSString * name;
	NSString * group;
	NSMutableDictionary * dict;
	
	// clear the name list and path list
	[groupNameList removeAllObjects];
	[groupNameList addObject:ALL_GROUPS_STR];
	[templateList removeAllObjects];
	
	for(NSString * file in directory)
		{
		data = nil;
		group = nil;
		name = nil;
		dict = nil;
		
		path = [NSString stringWithFormat:@"%@/%@", TEMPLATE_PATH, file];
		data = [NSMutableArray arrayWithContentsOfFile:path];
		if([data count])
			{
			name = [[data objectAtIndex:0] objectForKey:@"template name"];
			group = [[data objectAtIndex:0] objectForKey:@"group name"];
			[self addGroupName:group];
			dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:path, @"path", group, @"group name", name, @"template name", data, @"data", nil];
			}
		if([dict count])
			[templateList addObject:dict];
		
		}
	[groupTable selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:(NSUInteger[2]){0,0} length:2] animated:YES scrollPosition:UITableViewScrollPositionTop];
	[self filterByGroupName];
} // end load template list

-(BOOL) isTemplateAtIndexPublished:(NSUInteger)index
{
	NSDictionary * dict = [filteredTemplateList objectAtIndex:index];
	NSArray * data = [dict valueForKey:@"data"];
	NSDictionary * meta = [data objectAtIndex:0];
	id value = [meta valueForKey:@"published"];
	BOOL isPublished = [value boolValue];
	return isPublished;
}
-(BOOL) isSelectedTemplatePublished
{
	NSUInteger index = [[templateTable indexPathForSelectedRow] row];
	return [self isTemplateAtIndexPublished:index];
}
-(void) disableButtons
{
	[deleteTemplateButton setEnabled:NO];	[deleteTemplateButton setAlpha:0.50];
	[copyTemplateButton setEnabled:NO];		[copyTemplateButton setAlpha:0.50];
	[editTemplateButton setEnabled:NO];		[editTemplateButton setAlpha:0.50];
	
	// TODO: check demo/lite version and template count:
	//[newButton setEnabled:NO];		[newButton setAlpha:0.50];
}

-(void) enableButtons
{
	[deleteTemplateButton setEnabled:YES];	[deleteTemplateButton setAlpha:1.00];
	[copyTemplateButton setEnabled:YES];	[copyTemplateButton setAlpha:1.00];
	[editTemplateButton setEnabled:YES];	[editTemplateButton setAlpha:1.00];
	
	// TODO: check demo/lite version and template count:
	//[newButton setEnabled:YES];		[newButton setAlpha:1.00];
}

#pragma mark - Interface Methods

-(void) confirmDeleteSelectedTemplate
{
	//NSUInteger row = [[templateTableView indexPathForSelectedRow] row];
	NSString * path = [[filteredTemplateList objectAtIndex:[[templateTable indexPathForSelectedRow] row]] objectForKey:@"path"];
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
	[self loadTemplateList];
	
	// TODO: DROP from table
	[self disableButtons]; // because now there's no template selected
}
- (IBAction)deleteSelectedTemplate
{
    UIActionSheet *popupQuery = [[[UIActionSheet alloc] initWithTitle:CONFIRM_DELETE_TEMPLATE_TITLE_STR delegate:self cancelButtonTitle:nil destructiveButtonTitle:CONFIRM_DELETE_TEMPLATE_BUTTON_STR otherButtonTitles:nil] autorelease];
	[popupQuery setTag:1];
	[popupQuery showInView:self.view];
}


- (IBAction)editSelectedTemplate
{
	NSUInteger row = [[templateTable indexPathForSelectedRow] row];
	NSDictionary * dict = [filteredTemplateList objectAtIndex:row];
	NSMutableArray * data = [dict objectForKey:@"data"];
	[templateEditor clear];
	[self.navigationController pushViewController:templateEditor animated:YES];
	[templateEditor setData:data];
}

- (void) copySelectedTemplateWithName:(NSString*)name
{
	// TODO
	// push editor
	// change template name
	// [editor save];
}

- (IBAction)copySelectedTemplate
{
	// TODO
	//NSUInteger row = [[templateTableView indexPathForSelectedRow] row];
	NSString * path = [[filteredTemplateList objectAtIndex:[[templateTable indexPathForSelectedRow] row]] objectForKey:@"path"];
	NSLog(@"Should duplicate and rename file at path:\n%@", path);
	// prompt for new name
	// call duplicateSelectedTemplateNamed: with string arg for new template name
}

- (IBAction)createTemplate
{
	NSString * name = @"Template Name";
	NSUInteger row = [[groupTable indexPathForSelectedRow] row];
	//NSDictionary * dict = [filteredTemplateList objectAtIndex:row];
	NSString * group = [groupNameList objectAtIndex:row];
	
	[self.navigationController pushViewController:templateEditor animated:YES];
	[templateEditor newTemplateWithName:name group:group];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// NSString * name = nil;
	switch([actionSheet tag])
	{
		case 1: // delete
		if(buttonIndex != [actionSheet cancelButtonIndex])
			[self confirmDeleteSelectedTemplate];
		break;
		
		case 2: // copy
		// get name
		// [self copySelectedTemplateWithName:name];
		break;
	}
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	NSInteger r = 0;
	switch([tableView tag])
	{
		case 1: // group table
		r = [groupNameList count];
		break;
		
		case 2: // template table
		r = [filteredTemplateList count];
		break;
	}
	return r;
}

-(NSString*) tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section
{
	NSString * r;
	NSString * group = [groupNameList objectAtIndex:[[groupTable indexPathForSelectedRow] row]];
	switch ([table tag])
	{
		case 1: // group table
		r = NSLocalizedString(@"Template Groups", @"Section Header for Groups table");
		break;
		
		case 2: // template table
		r = [NSString stringWithFormat:@"Available Templates (%@)", group]; // TODO: localize
		break;
		
		default:
		r = [NSString stringWithFormat:@"Error: Header for Unknown Table Tag (%i)", [table tag] ]; // TODO: localize
		break;
	}
	return r;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = nil;
	switch ([table tag])
	{
		case 2: // templates
		CellIdentifier = @"Template Table Cell";
		break;
		
		case 1: // groups
		CellIdentifier = @"Group Table Cell";
		break;
			
		default:
		CellIdentifier = @"Cell";
		break;
	}
    
    UITableViewCell *cell;
	cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    // Configure the cell...
	NSString * text = nil;
	switch([table tag])
	{
		case 1: // group table
		text = [groupNameList objectAtIndex:[indexPath row]];
		break;
		
		case 2: // template table
		text = [[filteredTemplateList objectAtIndex:[indexPath row]] objectForKey:@"template name"];
		break;
		
		default:
		text = [NSString stringWithFormat:@"Error: Cell for Unknown Table Tag (%i)", [table tag]];
		break;
	}
	[[cell textLabel] setText:text];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch([table tag])
	{
		case 1: // group table
		[self filterByGroupName];
		break;
		
		case 2: // template table
		[self enableButtons];
		break;
	}
}


@end
