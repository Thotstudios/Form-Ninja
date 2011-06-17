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
#import "AccountClass.h"

#import "ElementPicker.h"
#import "TemplateElement.h"
#import "TextFieldAlert.h"

#define keyboardHeightPortrait		264
#define keyboardHeightLandscape		352

#define tableHeightFullPortrait		(960 - 112)
#define tableHeightHalfPortrait		(tableHeightFullPortrait - keyboardHeightPortrait)

#define tableHeightFullLandscape	(704 - 112)
#define tableHeightHalfLandscape	(tableHeightFullLandscape - keyboardHeightLandscape)

@interface TemplateEditorController()
- (void) generateViewArray;
- (void) setIndexes;
- (void) newElementOfType:(NSString *)type;
@end

@implementation TemplateEditorController

@synthesize table;
@synthesize dataArray;
@synthesize viewArray;
@synthesize path;

#pragma mark - Init and Memory
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [table release];
	[dataArray release];
	[viewArray release];
	[path release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTable:nil];
	[self setDataArray:nil];
	[self setViewArray:nil];
	[self setPath:nil];
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - View lifecycle

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

-(void) viewDidAppear:(BOOL)animated
{
	[self setIndexes];
	[self generateViewArray];
	[table reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Miscellaneous

- (void) commitToDB
{
    NSMutableDictionary *metaData = [dataArray objectAtIndex:0];
    if ([[metaData objectForKey:templatePublishedKey] intValue] == 1) {
        //Get json string
        [[SyncManager sharedSyncManager] addTemplateToSyncList:[(NSMutableArray*)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)dataArray, kCFPropertyListMutableContainers) autorelease]];
    }
}

#pragma mark - Member Functions

-(TemplateElement*) getElementOfType:(NSString*)type
{
	return [ElementPicker elementOfType:type delegate:self];
}

- (void) generateViewArray
{
	[self setViewArray:[NSMutableArray array]];
	if([dataArray count])
		{
		NSString * type;
		TemplateElement * element;
		
		NSMutableArray * rowArray;
		for(NSMutableDictionary * sectionDict in dataArray)
			{
			rowArray = [NSMutableArray array];
			NSMutableArray * sectionData = [sectionDict objectForKey:sectionDataKey];
			if(sectionData)
				for(NSMutableDictionary *dict in sectionData)
					{
					type = [dict objectForKey:elementTypeKey];
					if(type)
						{
						element = [self getElementOfType:type];
						[element setDictionary:dict]; // TODO: fix
						[rowArray addObject:element];
						}
					}
			else
				{
				NSMutableDictionary *dict = sectionDict;
				
				type = [dict objectForKey:elementTypeKey];
				if(type)
					{
					element = [self getElementOfType:type];
					[element setDictionary:dict]; // TODO fix
					[rowArray addObject:element];
					}
				}
			[viewArray addObject:rowArray];
			}
		}
}

- (IBAction)clear
{
	NSMutableDictionary * preserve;
	preserve = [[[dataArray objectAtIndex:0] retain] autorelease];
	[dataArray removeAllObjects];
	[dataArray addObject:preserve];
	[viewArray removeAllObjects];
	[self generateViewArray];
	[self setIndexes];
	[table reloadData]; // TODO: use something faster
	//[table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
	return;
}

-(void) saveToPath:(NSString*)pathArg
{
	if(!pathArg) return;
	
	if(!([[NSFileManager defaultManager] fileExistsAtPath:TEMPLATE_PATH]))
		[[NSFileManager defaultManager] createDirectoryAtPath:TEMPLATE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
	
	if([dataArray writeToFile:pathArg atomically:YES])
		{
		UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:TEMPLATE_SAVED_STR	delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:OKAY_STR, nil];
		[popupQuery showInView:self.view];
		[popupQuery release];
		}
	else
		{
		UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:SAVE_FAILED_STR	delegate:nil cancelButtonTitle:nil destructiveButtonTitle:OKAY_STR otherButtonTitles:nil];
		[popupQuery showInView:self.view];
		[popupQuery release];
		}
}

- (IBAction)save
{
	[self.view endEditing:NO];
	
	if(path)
		{
		[self saveToPath:path];
		[self commitToDB];
		}
}

- (IBAction)toggleEditing
{
	if([table isEditing] || [viewArray count] == 0)
		[table setEditing:NO animated:YES];
	else
		[table setEditing:YES animated:YES];
}

-(void) delayedScrollToSection
{
	[table scrollToRowAtIndexPath:[table indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark Template Functions

-(void) newTemplateWithName:(NSString *)name group:(NSString *)group
{
	// TODO: maybe save existing
	
	[self setDataArray:[NSMutableArray array]];
	[self setViewArray:[NSMutableArray array]];
	
	NSString * creator = nil;
	AccountClass * user = [AccountClass sharedAccountClass];
	if([user firstName] && [user lastName])
		creator = [NSString stringWithFormat:@"%@ %@", [user firstName], [user lastName]];
	if(!creator)
		creator = @"John Doe";
	
	NSMutableDictionary * dict;
	dict = [NSMutableDictionary dictionary];
	[dict setValue:@"MetaData" forKey:elementTypeKey];
	[dict setValue:name forKey:templateNameKey];
	[dict setValue:group forKey:templateGroupKey];
	[dict setValue:creator forKey:templateCreatorKey];
	[dict setValue:[NSDate date] forKey:templateCreationDateKey];
	
	[dataArray addObject:dict];
	
	[self setPath:[NSString stringWithFormat:@"%@/%@-%@%@", TEMPLATE_PATH, group, name, TEMPLATE_EXT]];
	
	[table reloadData];
	
	[NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(addSection) userInfo:nil repeats:NO];
}

-(void) editTemplateAtPath:(NSString*)pathArg
{
	[self setPath:pathArg];
	[self setDataArray:[NSMutableArray arrayWithContentsOfFile:path]]; 
}

-(BOOL) templateIsValid
{ 
	BOOL ret = YES;
	if(ret) ret = [dataArray isKindOfClass:[NSArray class]];
	for(id sectionData in dataArray)
		{
		if(ret) ret = [sectionData isKindOfClass:[NSDictionary class]];
		}
	if(ret) ret = [viewArray isKindOfClass:[NSArray class]];
	for(id rowArray in viewArray)
		{
		if(ret) ret = [rowArray isKindOfClass:[NSArray class]];
		if(ret)
			{
			for(id element in rowArray)
				{
				if(ret) ret = [element isKindOfClass:[TemplateElement class]];
				if(ret) ret = [element isValid];
				}
			}
		}
	return ret;
}

#pragma mark Section Functions
-(void) addSectionWithName:(NSString*)headerName
{
	TemplateElement * element = [ElementPicker elementOfType:elementLabelKey delegate:self];
	[[element dictionary] setValue:headerName forKey:elementLabelKey];
	[element setDictionary:[element dictionary]];
	
	NSMutableDictionary * sectionDict = [NSMutableDictionary dictionary];
	NSMutableArray * sectionArray = [NSMutableArray arrayWithObject:[element dictionary]];
	[sectionDict setValue:sectionArray									forKey:sectionDataKey];
	[sectionDict setValue:headerName									forKey:sectionHeaderKey];
	[sectionDict setValue:[NSNumber numberWithInt:[dataArray count]]	forKey:elementSectionIndexKey];
	[sectionDict setValue:[NSNumber numberWithInt:0]					forKey:elementRowIndexKey];
	
	[dataArray addObject:sectionDict];
	[viewArray addObject:[NSMutableArray arrayWithObject:element]];
	
	[self setIndexes];
	[table reloadData]; // TODO use the faster thing
}

-(IBAction) addSection
{
	[TextFieldAlert showWithTitle:@"New Section Name" delegate:self selector:@selector(addSectionWithName:)];
}

#pragma mark Element Functions
- (void)addElement
{
	[ElementPicker showWithDelegate:self selector:@selector(newElementOfType:)];
}
- (void)addElementBelowIndexPath:(NSIndexPath*)indexPath
{
	[table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
	[self addElement];
}

-(void) newElementOfType:(NSString*)type
{
	NSIndexPath * indexPath = [table indexPathForSelectedRow];
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSMutableDictionary * sectionDict = [dataArray objectAtIndex:section];
	NSMutableArray * sectionData = [sectionDict objectForKey:sectionDataKey];
	
	TemplateElement * element = [ElementPicker elementOfType:type delegate:self];
	row ++;
	
	[sectionData insertObject:[element dictionary] atIndex:row];
	[[viewArray objectAtIndex:section] insertObject:element atIndex:row];
	[self setIndexes];
	[table reloadData]; // TODO
}
-(void) selectElementAtIndexPath:(NSIndexPath*)indexPath
{
	[table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
	[NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(delayedScrollToSection) userInfo:nil repeats:NO];
}

-(void) focusNextElementAfter:(TemplateElement*)element
{
	NSMutableDictionary * dict = [element dictionary];
	NSUInteger section = [[dict objectForKey:elementSectionIndexKey] integerValue];
	NSUInteger row = [[dict objectForKey:elementRowIndexKey] integerValue];
	dict = [dataArray objectAtIndex:section];
	
	NSMutableArray * sectionData = [dict objectForKey:sectionDataKey];
	row ++;
	if(row >= [sectionData count])
		{
		row = 0;
		section ++;
		if(section >= [dataArray count])
			{
			[table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
			return;
			}
		}
	[table selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionTop];
	[[[viewArray objectAtIndex:section] objectAtIndex:row] beginEditing];
}

-(void) editElementAfterIndexPath:(NSIndexPath*)indexPath
{
	/*
	NSMutableDictionary * dict = [element dictionary];
	NSUInteger section = [[dict objectForKey:elementSectionIndexKey] integerValue];
	NSUInteger row = [[dict objectForKey:elementRowIndexKey] integerValue];
	*/
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSMutableDictionary * sectionDict = [dataArray objectAtIndex:section];
	NSMutableArray * sectionData = [sectionDict valueForKey:sectionDataKey];
	NSMutableDictionary * dict = [sectionData objectAtIndex:row];
	
	if(section > 0 && row == 0)
		{
		[sectionDict setValue:[dict objectForKey:elementLabelKey] forKey:sectionHeaderKey];
		[table reloadData];
		}
	
	row++;
	if(row >= [sectionData count])
		{
		row = 0;
		section ++;
		if(section >= [dataArray count])
			{
			// TODO: refactor this, since it's almost identical to what's used in focusNextElementAfter
			return; 
			}
		}
	[[[viewArray objectAtIndex:section] objectAtIndex:row] beginEditing];
}

-(void) moveElementFromIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath
{
	int fromSection = [fromIndexPath section];
	int toSection = [toIndexPath section];
	int fromRow = [fromIndexPath row];
	int toRow = [toIndexPath row];
	
	if(toSection <= 0) return;
	if(toSection >= [dataArray count]) return;
	
	if(fromSection == 0) return;
	if(fromSection >= [dataArray count]) return;
	
	NSMutableDictionary * fromSectionDict = [dataArray objectAtIndex:fromSection];
	NSMutableDictionary * toSectionDict = [dataArray objectAtIndex:toSection];
	NSMutableArray * fromSectionData = [fromSectionDict objectForKey:sectionDataKey];
	NSMutableArray * toSectionData = [toSectionDict objectForKey:sectionDataKey];
	
	if(toRow == 0) return;
	if(toRow >= [toSectionData count]) return;
	
	if(fromRow == 0) return;
	if(fromRow >= [toSectionData count]) return;

	id temp;
	
	temp = [[fromSectionData objectAtIndex:fromRow] retain];
	[fromSectionData removeObjectAtIndex:fromRow];
	[toSectionData insertObject:temp atIndex:toRow];
	[temp release];
	if([fromSectionData count] == 0)
		[dataArray removeObjectAtIndex:fromSection];
	
	temp = [[[viewArray objectAtIndex:fromSection] objectAtIndex:fromRow] retain];
	[[viewArray objectAtIndex:fromSection] removeObjectAtIndex:fromRow];
	[[viewArray objectAtIndex:toSection] insertObject:temp atIndex:toRow];
	[temp release];
	if([[viewArray objectAtIndex:fromSection] count] == 0)
		[viewArray removeObjectAtIndex:fromSection];
	
	
	[self setIndexes];
	[table reloadData];
	
}

- (void) moveUpElementAtIndexPath:(NSIndexPath*)fromIndexPath
{
	NSUInteger row = [fromIndexPath row];
	NSUInteger section = [fromIndexPath section];
	NSIndexPath * toIndexPath = nil;
	
	if(row) row--;
	else if(section)
		{
		section--;
		row = [[viewArray objectAtIndex:section] count];
		}
	
	toIndexPath = [NSIndexPath indexPathForRow:row	inSection:section];
	[self moveElementFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}
- (void) moveDownElementAtIndexPath:(NSIndexPath*)fromIndexPath
{
	NSUInteger row = [fromIndexPath row];
	NSUInteger section = [fromIndexPath section];
	NSIndexPath * toIndexPath = nil;
	
	row++;
	if(row >= [[viewArray objectAtIndex:section] count])
		{
		row = 0;
		section ++;
		}
	
	toIndexPath = [NSIndexPath indexPathForRow:row	inSection:section];
	[self moveElementFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (void) deleteElementAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	if(section == 0) return; // can't delete MetaData
	
	NSMutableDictionary * sectionDict = [dataArray objectAtIndex:section];
	NSMutableArray * sectionData = [sectionDict objectForKey:sectionDataKey];
	
	if(row == 0 && [sectionData count] > 1) return;
	
	[sectionData removeObjectAtIndex:row];
	if([sectionData count])
		[[viewArray objectAtIndex:section] removeObjectAtIndex:row];
	else
		{
		[dataArray removeObjectAtIndex:section];
		[viewArray removeObjectAtIndex:section];
		}
	[table reloadData];
}


-(void) setIndexes
{
	NSUInteger section = 0;
	for(NSMutableArray * rowArray in viewArray)
		{
		NSUInteger row = 0;
		for(TemplateElement * element in rowArray)
			{
			NSMutableDictionary * dict = [element dictionary];
			[dict setValue:[NSNumber numberWithInteger:section] forKey:elementSectionIndexKey];
			[dict setValue:[NSNumber numberWithInteger:row] forKey:elementRowIndexKey];
			row ++;
			}
		section ++;
		}
}

#pragma mark - TableView DataSource

-(NSString*) tableView:(UITableView*) tableView titleForHeaderInSection:(NSInteger)section
{
	NSString * ret = nil;
	NSMutableDictionary * dict;
	dict = [dataArray objectAtIndex:section];
	
	if(!ret) ret = [dict objectForKey:sectionHeaderKey];
	if(!ret) ret = [dict objectForKey:elementTypeKey];
	if(!ret) ret = [dict objectForKey:elementLabelKey];
	if(!ret) ret = @"Section Title Missing";
	return ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger ret = [viewArray count];
    return ret;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger ret = [[viewArray objectAtIndex:section] count];
    return ret;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat ret = [[[viewArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] view].frame.size.height;
	return ret;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	// TODO: NSArray of cell type names
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
		{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
    
    // Configure the cell...
	for (UIView *view in cell.subviews) {
		[view removeFromSuperview];
	}
	
	UIView * elementView = nil;
	elementView = [[[viewArray objectAtIndex:section] objectAtIndex:row] view];
	[elementView setFrame:CGRectMake(0, 0, cell.frame.size.width, elementView.frame.size.height)];
	
	[cell addSubview:elementView];
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([indexPath section] == 0 || [indexPath row] == 0)
		return NO;
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
		{
		[self deleteElementAtIndexPath:indexPath];
		
		// TODO: use these instead of reloadData,
		//[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}   
	else if (editingStyle == UITableViewCellEditingStyleInsert)
		{
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	[table reloadData];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return NO if you do not want the item to be re-orderable.
	if([indexPath section] == 0 || [indexPath row] == 0)
		return NO;
	return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	[self moveElementFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
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

@end
