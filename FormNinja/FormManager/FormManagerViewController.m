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
@end

@implementation FormManagerViewController

@synthesize formList;
@synthesize filteredFormList;
@synthesize formNameList;

@synthesize formTable;
@synthesize createFormButton;
@synthesize resumeFormButton;
@synthesize viewFormButton;

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
	[filteredFormList release];
	[formNameList release];
    [formTable release];
    [formEditorViewController release];
	[createFormButton release];
	[resumeFormButton release];
    [viewFormButton release];
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

	[self setFormList:[NSMutableArray array]];
	[self setFilteredFormList:[NSMutableArray array]];
	[self setFormNameList:[NSMutableArray array]];

    //Menu button
	UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction:)]; 
    self.navigationItem.rightBarButtonItem = menuButton;
    [menuButton release];
    
    
    UIImage *createBlackImage=[UIImage imageNamed:@"startNewFormBlack.png"];
    [createFormButton setImage:createBlackImage forState:UIControlStateHighlighted];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
	[self setFilteredFormList:nil];
	[self setFormNameList:nil];
    [self setFormTable:nil];
    [self setFormEditorViewController:nil];
	[self setCreateFormButton:nil];
	[self setResumeFormButton:nil];
    [self setViewFormButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self loadFormList];
}
#pragma mark - Instance Methods
-(void) filterFormsByTemplate
{
	[filteredFormList removeAllObjects];
	NSString * templateName = nil;
	if([templateList count])
		templateName = [[templateList objectAtIndex:[[templateTable indexPathForSelectedRow] row]] objectForKey:templateNameKey];
	for(NSDictionary * dict in formList)
		{
		if(!templateName || [templateName isEqualToString:[dict objectForKey:templateNameKey]])
			[filteredFormList addObject:dict];
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
			
			dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:path, filePathKey, group, templateGroupKey, templateName, templateNameKey, formName, formNameKey, nil];
			}
		if(dict)
			{
			[formList addObject:dict];
			if([[formMetaData valueForKey:formCompletedKey] boolValue])
				formName = [NSString stringWithFormat:@"%@ (Incomplete)"];
			[formNameList addObject:formName];
			}
		}
	[self filterFormsByTemplate];
}

- (IBAction)newFormWithSelectedTemplate
{
	NSUInteger row = [[templateTable indexPathForSelectedRow] row];
	NSDictionary * dict = [filteredTemplateList objectAtIndex:row];
	NSString * path = [dict objectForKey:filePathKey];
	
	[formEditorViewController newFormWithTemplateAtPath:path];
	[self.navigationController pushViewController:formEditorViewController animated:YES];
}

-(void) loadSelectedForm
{
	NSUInteger row = [[formTable indexPathForSelectedRow] row];
	NSDictionary * dict = [filteredFormList objectAtIndex:row];
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

//Presents popover menu
- (void) menuButtonAction:(id) sender{
    [[PopOverManager sharedManager] createMenuPopOver:formManagerMenu fromButton:sender];
}

-(void) disableButtons
{
	[super disableButtons];
	[createFormButton setEnabled:NO];	[createFormButton setAlpha:0.50];
	[resumeFormButton setEnabled:NO];	[resumeFormButton setAlpha:0.50];
	[viewFormButton setEnabled:NO];		[viewFormButton setAlpha:0.50];
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
		[viewFormButton setEnabled:YES];	[viewFormButton setAlpha:1.00];
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
		r = [filteredFormList count];
	
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
		[[cell textLabel] setText:[[filteredFormList objectAtIndex:row] objectForKey:formNameKey]];
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
		break;
		
		case 2: // template table
		[self filterFormsByTemplate];
		break;
		
		case 3: // form table
		[self enableButtons];
		break;
	}
}
@end
