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
#import "TextFieldAlert.h"

#import "PopOverManager.h"

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
    
    //Menu button
	UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction:)]; 
    self.navigationItem.rightBarButtonItem = menuButton;
    [menuButton release];
    
    //Tab appearances
    //UIImage *copyBlackImage=[UIImage imageNamed:@"CopyBlack.png"];
    //[copyTemplateButton setImage:copyBlackImage forState:UIControlStateHighlighted];
    UIImage *deleteBlackImage=[UIImage imageNamed:@"deleteBlack.png"];
    [deleteTemplateButton setImage:deleteBlackImage forState:UIControlStateHighlighted];
    UIImage *editBlackImage=[UIImage imageNamed:@"editBlack.png"];
    [editTemplateButton setImage:editBlackImage forState:UIControlStateHighlighted];

    
}
-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadTemplateList];
//	[groupTableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:(NSUInteger[2]){0,0} length:2] animated:YES scrollPosition:UITableViewScrollPositionTop];
	
	[self filterByGroupName];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[PopOverManager sharedManager] dismissCurrentPopoverController:YES]; //dismiss popover
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
		if([group isEqualToString:ALL_GROUPS_STR] || [group isEqualToString:[dict valueForKey:templateGroupKey]])
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
	NSMutableDictionary * dict;
	NSString * group;
	NSString * name;
	BOOL published;
	
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
			id temp = [data objectAtIndex:0];
			if([temp isKindOfClass:[NSDictionary class]])
				dict = temp;
			else
				dict = [temp objectAtIndex:0];
			name = [dict objectForKey:templateNameKey];
			group = [dict objectForKey:templateGroupKey];
			published = [[dict objectForKey:templatePublishedKey] boolValue];
			dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:path, filePathKey, group, templateGroupKey, name, templateNameKey, [NSNumber numberWithBool:published], templatePublishedKey, data, @"data", nil];
			[self addGroupName:group];
			}
		if([dict count])
			[templateList addObject:dict];
		
		}
	[groupTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
							animated:YES
					  scrollPosition:UITableViewScrollPositionTop];
	[self filterByGroupName];
} // end load template list

-(BOOL) isTemplateAtIndexPublished:(NSUInteger)index
{
	NSDictionary * dict = [filteredTemplateList objectAtIndex:index];
	return [[dict objectForKey:templatePublishedKey] boolValue];
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
	NSUInteger row = [[templateTable indexPathForSelectedRow] row];
	NSString * path = [[filteredTemplateList objectAtIndex:row] objectForKey:filePathKey];
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
	[self loadTemplateList];
	
	// TODO: DROP from table
	[self disableButtons]; // because now there's no template selected
}
- (IBAction)deleteSelectedTemplate
{
    UIActionSheet *popupQuery = [[[UIActionSheet alloc] initWithTitle:CONFIRM_DELETE_TEMPLATE_STR delegate:self cancelButtonTitle:nil destructiveButtonTitle:CONFIRM_DELETE_BUTTON_STR otherButtonTitles:nil] autorelease];
	[popupQuery setTag:1];
	[popupQuery showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if([actionSheet tag] == 1 && buttonIndex == [actionSheet destructiveButtonIndex])
		[self confirmDeleteSelectedTemplate];
}

- (IBAction)editSelectedTemplate
{
	NSUInteger row = [[templateTable indexPathForSelectedRow] row];
	NSDictionary * dict = [filteredTemplateList objectAtIndex:row];
	NSString * path = [dict objectForKey:filePathKey];
	
	[templateEditor editTemplateAtPath:path];
	[self.navigationController pushViewController:templateEditor animated:YES];
}

- (void) copySelectedTemplateWithName:(NSString*)name
{
	NSString * path = [[filteredTemplateList objectAtIndex:[[templateTable indexPathForSelectedRow] row]] objectForKey:filePathKey];
	NSLog(@"Should duplicate and rename file at path:\n%@", path);
	// TODO
	// push editor
	// change template name
	// [editor save];
}

- (IBAction)copySelectedTemplate
{
	[TextFieldAlert showWithTitle:REQUEST_NEW_TEMPLATE_NAME_STR delegate:self selector:@selector(copySelectedTemplateWithName:)];
}

-(void) createTemplateWithName:(NSString*)name
{
	NSUInteger row = [[groupTable indexPathForSelectedRow] row];
	NSString * group = [groupNameList objectAtIndex:row];
	
	//[templateEditor clear];
	[templateEditor newTemplateWithName:name group:group];
	[self.navigationController pushViewController:templateEditor animated:YES];
}

- (IBAction)createTemplate
{
	[TextFieldAlert showWithTitle:REQUEST_NEW_TEMPLATE_NAME_STR delegate:self selector:@selector(createTemplateWithName:)];
}


//Menu button action
- (void) menuButtonAction:(id) sender{
    [[PopOverManager sharedManager] createMenuPopOver:accountProfileMenu fromButton:sender];
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
		text = [[filteredTemplateList objectAtIndex:[indexPath row]] objectForKey:templateNameKey];
		// NOTE: assign not published
		if(![self isTemplateAtIndexPublished:[indexPath row]])
			text = [NSString stringWithFormat:@"%@ (Not Published)", text];
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
