//
//  TemplateEditorViewController.m
//  Dev
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateEditorController.h"
#import "Constants.h"
#import "JSON.h"
#import "SyncManager.h"

#import "ElementPicker.h"
#import "TemplateElement.h"

#define keyboardHeightPortrait		264
#define keyboardHeightLandscape		352

#define tableHeightFullPortrait		960 - 112
#define tableHeightHalfPortrait		696

#define tableHeightFullLandscape	704 - 112
#define tableHeightHalfLandscape	352


@implementation TemplateEditorController

@synthesize table;

@synthesize data;
@synthesize views;

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
    [table release];
	
	[data release];
	[views release];
	
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
	[self clear];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(keyboardWillShow:)
	 name:UIKeyboardWillShowNotification
	 object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(keyboardWillHide:)
	 name:UIKeyboardWillHideNotification
	 object:nil];
}
-(void) viewDidDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidDisappear:animated];
}
-(void) delayedScrollToSection
{
	[table scrollToRowAtIndexPath:[table indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void) selectSection:(NSUInteger)index
{
	[table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionBottom];
	[NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(delayedScrollToSection) userInfo:nil repeats:NO];
}
-(void) keyboardWillShow:(id)selector
{
	UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
	float height = tableHeightHalfPortrait;
	if(orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight)
		height = tableHeightHalfLandscape;
	[table setFrame:CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, height)];
}
-(void) keyboardWillHide:(id)selector
{
	UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
	float height = tableHeightFullPortrait;
	if(orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight)
		height = tableHeightFullLandscape;
	[table setFrame:CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, height)];
}

-(void) setIndexes
{
	TemplateElement * temp = nil;
	for(int i = 0; i < [views count]; i++)
		{
		temp = [views objectAtIndex:i];
		[temp setIndex:i];
		}
}
-(void) viewDidAppear:(BOOL)animated
{
	// make views from data
	if([data count])
		{
		[views removeAllObjects];
		NSString * type;
		TemplateElement * element;
		for(NSMutableDictionary * dict in data)
			{
			type = [dict objectForKey:@"type"];
			if(type)
				{
				element = [ElementPicker elementOfType:type];
				[element setDelegate:self];
				[element setDictionary:dict];
				[views addObject:element];
				}
			else
				{
				}
			}
		[self setIndexes];
		[table reloadData];
		}
	[self stopEditing];
}

- (void)viewDidUnload
{
    [self setTable:nil];
	
	[self setData:nil];
	[self setViews:nil];
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Member Functions
-(void) editElementAfterIndex:(NSUInteger)index
{
	index++;
	if(index < [views count])
		[[views objectAtIndex:index] beginEditing];
	else
		[table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}
-(BOOL) templateIsValid
{ 
	return YES;
}
-(void) newTemplateWithName:(NSString *)name group:(NSString *)group
{
	[self clear];
	NSDictionary * dict = [data objectAtIndex:0];
	[dict setValue:name forKey:@"template name"];
	[dict setValue:group forKey:@"group name"];
	[table reloadData];
}
-(void) newElementOfType:(NSString*)type
{
	TemplateElement * element = [ElementPicker elementOfType:type];
	[element setDelegate:self];
	[data addObject:[element dictionary]];
	[views addObject:element];
	[self setIndexes];
	[table reloadData];
}

- (void) commitToDB{
    SyncManager *sync = [[SyncManager alloc] init];
    //sync.delegate = self;
    //Create deep copy with mutable elements of data array
    [sync syncTemplate: [(NSMutableArray*)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)data, kCFPropertyListMutableContainers) autorelease]];
}

- (IBAction)addElement
{
	[[[[ElementPicker alloc] initWithDelegate:self selector:@selector(newElementOfType:)] autorelease] show];
}

- (void) stopEditing
{
	[table setEditing:NO animated:YES];
}
- (void) startEditing
{
	if([views count])
		[table setEditing:YES animated:YES];
	else
		[self stopEditing];
}
- (IBAction)toggleEditing
{
	if([table isEditing])
		[self stopEditing];
	else
		[self startEditing];
}

- (IBAction)dump
{
	NSLog(@"\n%@", data);
}

- (IBAction)clear
{
	[self setData:[NSMutableArray array]];
	[self setViews:[NSMutableArray array]];
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	[dict setValue:@"MetaData" forKey:@"type"];
	[dict setValue:@"Robert Paulson" forKey:@"creator name"];
	[dict setValue:[NSNumber numberWithBool:NO] forKey:@"published"];
	[dict setValue:@"No" forKey:@"published"];
	[dict setValue:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"] forKey:@"software version"];
	[data addObject:dict];
	
	TemplateElement * element = [ElementPicker elementOfType:@"MetaData"];
	[element setDelegate:self];
	[element setDictionary:[data objectAtIndex:0]];
	[views addObject:element];
	
	[self setIndexes];
	[table reloadData];
}

- (IBAction)save
{
	[self.view endEditing:NO];
	
	NSDictionary * dict = [data objectAtIndex:0];
	NSString * group = [dict objectForKey:@"group name"];
	NSString * template = [dict objectForKey:@"template name"];
	
	if(!group) group = @"No Group";
	if(!template) template = [NSString stringWithFormat:@"%i", time(0)];
	
	NSString * path = [NSString stringWithFormat:@"%@/%@-%@%@", TEMPLATE_PATH, group, template, TEMPLATE_EXT];
	
	if(path)
		{
		if(!([[NSFileManager defaultManager] fileExistsAtPath:TEMPLATE_PATH]))
			[[NSFileManager defaultManager] createDirectoryAtPath:TEMPLATE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
		
		if([data writeToFile:path atomically:YES])
			{
            [self commitToDB];
                
			UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Template saved."	delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"OK", nil];
			[popupQuery showInView:self.view];
			[popupQuery release];
			}
		else
			{
			UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Failed to save."	delegate:nil cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil];
			[popupQuery showInView:self.view];
			[popupQuery release];
			}
		}
}


#pragma mark - TableView DataSource

-(NSString*) tableView:(UITableView*) tableView titleForHeaderInSection:(NSInteger)section
{
	NSString * ret = nil;
	if(!ret) ret = [[data objectAtIndex:section] objectForKey:@"header"];
	if(!ret) ret = [[data objectAtIndex:section] objectForKey:@"type"];
	if(!ret) ret = [[data objectAtIndex:section] objectForKey:@"label"];
	if(!ret) ret = [[data objectAtIndex:section] objectForKey:@"template name"];
	if(!ret) ret = @"no header for this section";
	return ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger ret = 0;
	ret = [views count];
    return ret;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger ret = 1;
	//NSString * type = [[data objectAtIndex:section] objectForKey:@"type"];
	//if([[data objectAtIndex:section] isKindOfClass:[NSArray class]])
	//{
	//	ret = [[data objectAtIndex:section] count];
	//	}
	// TODO: recursive template elements might have multiple rows
    return ret;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat ret = 200;
    
	NSUInteger row = [indexPath row]; row = row;
	NSUInteger section = [indexPath section];
	
	ret = [[views objectAtIndex:section] view].frame.size.height;
	
	return ret;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row]; row = row;
	NSUInteger section = [indexPath section];
	
	// TODO: NSArray of cell type names
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	for (UIView *view in cell.subviews) {
		[view removeFromSuperview];
	}
	UIView * element = [[views objectAtIndex:section] view ];
	[element setFrame:CGRectMake(0, 0, cell.frame.size.width, element.frame.size.height)];
	[cell addSubview:[[views objectAtIndex:section] view]];
	
	
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 if([indexPath section] == 0)
	 return NO;
 return YES;
 }
 


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
		{
		// Delete the row from the data source
		[data removeObjectAtIndex:[indexPath section]];
		[views removeObjectAtIndex:[indexPath section]];
		
		//[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}   
	else if (editingStyle == UITableViewCellEditingStyleInsert)
		{
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	if([views count] == 0)
		[self toggleEditing];
	[table reloadData];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return NO if you do not want the item to be re-orderable.
	if([indexPath section] == 0)
		return NO;
	return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	int fromSection = [fromIndexPath section];
	//int fromRow = [fromIndexPath row];
	int toSection = [toIndexPath section];
	//int toRow = [toIndexPath row];
	
	if(toSection == 0)
		toSection ++;
	
	id temp;
	
	if(fromSection != toSection)
		{
		temp = [[data objectAtIndex:fromSection] retain];
		[data removeObjectAtIndex:fromSection];
		[data insertObject:temp atIndex:toSection];
		[temp release];
		
		temp = [[views objectAtIndex:fromSection] retain];
		[views removeObjectAtIndex:fromSection];
		[views insertObject:temp atIndex:toSection];
		[temp release];
		}
	
	[self setIndexes];
	
	[table reloadData];
}





#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSDictionary * dict = [data objectAtIndex:0];
	[dict setValue:[textField text] forKey:@"template name"];
	[table reloadData];
}

@end
