//
//  TableElement.m
//  FormNinja
//
//  Created by Hackenslacker on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableElement.h"


@implementation TableElement
@synthesize table;
//@synthesize data;

#pragma mark - View lifecycle


- (void)viewDidUnload
{
	[self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[table release];
    [super dealloc];
}

#pragma mark - Methods

- (IBAction)reset
{
	[super reset];
	[dictionary setValue:@"Table" forKey:elementTypeKey];
	[table reloadData];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	[table reloadData];
}

- (IBAction)addTableItem
{
	// TODO
	// TEMP:
	NSMutableArray * data = [dictionary valueForKey:elementTableDataKey];
	if(!data) data = [NSMutableArray array];
	switch([data count])
	{
		case 0: [data addObject:@"TODO:"];						break;
		case 1: [data addObject:@"Obtain string"];				break;
		case 2: [data addObject:@"from user"];					break;
		case 3: [data addObject:@"using TextFieldAlertView"];	break;
		
		default:
		[data addObject:[NSString stringWithFormat:@"line %i", [data count]]];
		break;
	}
	[dictionary setValue:data forKey:elementTableDataKey];
	[table reloadData];
}

- (IBAction)toggleEditing
{
	[table setEditing:!([table isEditing]) animated:YES];
}

#pragma mark - Table Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSMutableArray * data = [dictionary valueForKey:elementTableDataKey];
	return [data count] + 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPathArg
{
	NSMutableArray * data = [dictionary valueForKey:elementTableDataKey];
	
    static NSString *CellIdentifier = @"Table Element Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	if([indexPathArg row] < [data count])
	[[cell textLabel] setText:[data objectAtIndex:[indexPathArg row]]];
	else
		[[cell textLabel] setText:@"New Line"];
	
	
    return cell;
}
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}
*/

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPathArg
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
	
	NSMutableArray * data = [dictionary valueForKey:elementTableDataKey];
	
	if([indexPathArg row] == [data count])
		style = UITableViewCellEditingStyleInsert;
	
	return style;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPathArg
{
	NSMutableArray * data = [dictionary valueForKey:elementTableDataKey];
	
	if (editingStyle == UITableViewCellEditingStyleDelete)
		{
		// Delete the row from the data source
		[data removeObjectAtIndex:[indexPathArg row]];
		}   
	else if (editingStyle == UITableViewCellEditingStyleInsert)
		{
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		[self addTableItem];
		}
	[table reloadData];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPathArg
{
	NSMutableArray * data = [dictionary valueForKey:elementTableDataKey];
	return [indexPathArg row] < [data count];
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	NSMutableArray * data = [dictionary valueForKey:elementTableDataKey];
	if([fromIndexPath row] < [data count] && [toIndexPath row] < [data count])
		{
		id temp = [[data objectAtIndex:[fromIndexPath row]] retain];
		[data removeObjectAtIndex:[fromIndexPath row]];
		[data insertObject:temp atIndex:[toIndexPath row]];
		[temp release];
		}
	
	[table reloadData];
}


@end
