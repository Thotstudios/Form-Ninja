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

#import "ElementPicker.h"
#import "TemplateElement.h"
#import "TextFieldAlert.h"

#define keyboardHeightPortrait		264
#define keyboardHeightLandscape		352

#define tableHeightFullPortrait		960 - 112
#define tableHeightHalfPortrait		696

#define tableHeightFullLandscape	704 - 112
#define tableHeightHalfLandscape	352

@interface TemplateEditorController()
- (void) generateViewArray;
- (void) setIndexes;
- (void) newElementOfType:(NSString *)type;
@end

@implementation TemplateEditorController

@synthesize table;
@synthesize dataArray;
@synthesize viewArray;

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
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTable:nil];
	[self setDataArray:nil];
	[self setViewArray:nil];
	
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
	[self generateViewArray];
	[self setIndexes];
	[table reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Miscellaneous

- (void) commitToDB
{
    //Convert nsdate object to string as json cannot parse nsdate objects
    NSMutableArray *dbArray;
	dbArray = [[dataArray mutableCopy] autorelease];
	
    NSMutableDictionary *dict;
	dict = [dbArray objectAtIndex:0];
	[dict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"creation date"]] forKey:@"creation date"];
    
    //Get json string
    //TODO: add image support
	// NOTE: image is NSData object -Chad
    NSString *dbData = [dbArray JSONRepresentation]; 
    NSLog(@"committing %@", dbData);
	// TODO: save to Pending Uploads folder
	// uploading to DB should be handled elsewhere.
	// -Chad
}

#pragma mark - Member Functions
- (void) generateViewArray
{
	if([dataArray count])
		{
		[viewArray removeAllObjects];
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
						element = [ElementPicker elementOfType:type delegate:self];
						[element setDictionary:dict]; // TODO: fix
						[rowArray addObject:element];
						}
					}
			else
				{
				NSMutableDictionary *dict = sectionDict;
				NSLog(@"\n%@", dict);
				type = [dict objectForKey:elementTypeKey];
				if(type)
					{
					element = [ElementPicker elementOfType:type delegate:self];
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
	[table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
	return;
}

-(void) saveToPath:(NSString*)path
{
	if(!path) return;
	
	if(!([[NSFileManager defaultManager] fileExistsAtPath:TEMPLATE_PATH]))
		[[NSFileManager defaultManager] createDirectoryAtPath:TEMPLATE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
	
	if([dataArray writeToFile:path atomically:YES])
		{
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

- (IBAction)save
{
	[self.view endEditing:NO];
	
	NSMutableDictionary * dict;
	dict = [dataArray objectAtIndex:0];
	
	NSString * group = [dict objectForKey:templateGroupKey];
	NSString * template = [dict objectForKey:templateNameKey];
	
	if(!group) group = @"No Group";
	if(!template) template = [NSString stringWithFormat:@"%i", time(0)];
	
	NSString * path;
	path = [NSString stringWithFormat:@"%@/%@-%@%@", TEMPLATE_PATH, group, template, TEMPLATE_EXT];
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
-(void) selectElementAtIndexPath:(NSIndexPath*)indexPath
{
	[table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
	[NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(delayedScrollToSection) userInfo:nil repeats:NO];
}

#pragma mark Template Functions

-(void) newTemplateWithName:(NSString *)name group:(NSString *)group
{
	// TODO: maybe save existing
	
	[self setDataArray:[NSMutableArray array]];
	[self setViewArray:[NSMutableArray array]];
	
	//TemplateElement * element = [ElementPicker elementOfType:@"MetaData" delegate:self];
	
	NSMutableDictionary * dict;
	dict = [NSMutableDictionary dictionary];
	[dict setValue:@"MetaData" forKey:elementTypeKey];
	[dict setValue:name forKey:templateNameKey];
	[dict setValue:group forKey:templateGroupKey];
	[dict setValue:@"Bob Johnson" forKey:templateCreatorKey];
	[dict setValue:[NSDate date] forKey:templateCreationDateKey];
	
	[dataArray addObject:dict];
	//[viewArray addObject:[NSMutableArray arrayWithObject:element]];
	
	//[self generateViewArray];
	
	[table reloadData];
	
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addSection) userInfo:nil repeats:NO];
}

-(BOOL) templateIsValid
{ 
	BOOL ret = YES;
	if(ret) ret = [dataArray isKindOfClass:[NSArray class]];
	for(id sectionData in dataArray)
		{
		if(ret) ret = [sectionData isKindOfClass:[NSDictionary class]];
		}
	if(ret) [self generateViewArray];
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
	TemplateElement * element = [ElementPicker elementOfType:@"Label" delegate:self];
	[[element dictionary] setValue:headerName forKey:@"label"];
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
	[[[[TextFieldAlert alloc] initWithTitle:@"New Section Name"
								   delegate:self
								   selector:@selector(addSectionWithName:)] autorelease] show];
	//[self addSectionWithHeader:@"<Section Header>"];
	// TODO:
	// pop up textfield alert to get correct header string
}

#pragma mark Element Functions
- (void)addElement
{
	[[[[ElementPicker alloc] initWithDelegate:self selector:@selector(newElementOfType:)] autorelease] show];
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
	[[[viewArray objectAtIndex:section] objectAtIndex:row] beginEditing];
}


-(void) moveElementFromIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath
{
	int fromSection = [fromIndexPath section];
	int toSection = [toIndexPath section];
	int fromRow = [fromIndexPath row];
	int toRow = [toIndexPath row];
	
	if(toSection == 0)
		toSection ++;
	if(toSection >= [dataArray count])
		toSection --;
	
// TODO: range checking
	
	NSMutableDictionary * fromSectionDict = [dataArray objectAtIndex:fromSection];
	NSMutableDictionary * toSectionDict = [dataArray objectAtIndex:toSection];
	NSMutableArray * fromSectionData = [fromSectionDict objectForKey:sectionDataKey];
	NSMutableArray * toSectionData = [toSectionDict objectForKey:sectionDataKey];
	
	if(toRow == 0)
		toRow ++;
	if(toRow >= [toSectionData count])
		toRow --;
	
	
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

//if(templateIsMultilevel) {
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
	if(section == 0 || row == 0) return;
	
	NSMutableDictionary * sectionDict = [dataArray objectAtIndex:section];
	NSMutableArray * sectionData = [sectionDict objectForKey:sectionDataKey];
	
	[sectionData removeObjectAtIndex:row];
	if([sectionData count])
		[[viewArray objectAtIndex:section] removeObjectAtIndex:row];
	else
		{
		[dataArray removeObjectAtIndex:section];
		[viewArray removeObjectAtIndex:section];
		}
}

#pragma mark Temporary
- (IBAction)dump
{
	NSLog(@"\n%@", dataArray);
}

#pragma mark - TableView DataSource

-(NSString*) tableView:(UITableView*) tableView titleForHeaderInSection:(NSInteger)section
{
	NSString * ret = nil;
	NSMutableDictionary * dict;
	dict = [dataArray objectAtIndex:section];
	
	if(!ret) ret = [dict objectForKey:sectionHeaderKey];
	if(!ret) ret = [dict objectForKey:elementTypeKey];
	if(!ret) ret = [dict objectForKey:@"label"];
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
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
