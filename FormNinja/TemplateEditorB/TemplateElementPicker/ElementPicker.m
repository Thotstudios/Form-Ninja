//
//  TableElementPicker.m
//  Dev
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ElementPicker.h"
#import "Constants.h"

#import "TemplateElement.h"
#import "MetaDataElement.h"
#import "SingleLineElement.h"
#import "MultiLineElement.h"
#import "AddressElement.h"
#import "SignatureElement.h"

@interface ElementPicker()
+(void) loadElementDictionary;
@end

@implementation ElementPicker

static NSMutableDictionary * elementDictionary = nil;

@synthesize callback;
@synthesize selector;
@synthesize table;

@synthesize elementList;

#pragma mark - Init and Memory

-(id) initWithDelegate:(id)delegateArg selector:(SEL)selectorArg
{
	if(!(self = [super initWithTitle:@"Select Type" message:nil delegate:nil cancelButtonTitle:CANCEL_STR otherButtonTitles:CONFIRM_STR, nil])) return self;
	
	[self setCallback:delegateArg];
	[self setSelector:selectorArg];
	orientation = -1;
	
	tableWidth = 262;
	tableHeight = 160;
	horizontalMargin = 11;
	
	portraitFrame = CGRectMake(242, 385, 284, 275);
	landscapeFrame = CGRectMake(370, 257, 284, 275);
	
	[ElementPicker loadElementDictionary];
	
	[self setElementList:[[elementDictionary allKeys] mutableCopy]];
	[elementList removeObject:@"MetaData"];
	[elementList sortUsingSelector:@selector(compare:)];
	return self;
}

-(void) dealloc
{
	[table release];
	[callback release];
	[elementList release];
	[super dealloc];
}
#pragma mark - AlertView Button Responses

-(BOOL) orientationChanged
{
	UIDeviceOrientation cur =
	[[UIDevice currentDevice] orientation];
	if(orientation == cur)
		return NO;
	orientation = cur;
	return YES;
}

-(void) show
{
	[self setTable:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped]];
	[self addSubview:table];
	[table setDelegate:self];
	[table setDataSource:self];
	[super show];
}

-(CGRect) getProperFrame
{
	CGRect rect;
	if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
		rect = portraitFrame;
	else
		rect = landscapeFrame;
	return rect;
}

-(void) layoutSubviews
{
	if(![self orientationChanged])
		return;
	
	[super layoutSubviews];
	UIView * curView;
	int i = 0;
	while(![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		i++;
		}
	
	CGRect rect = self.frame;
	rect = [self getProperFrame];
	[self setFrame:rect];
	[[self.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
	
	float yPosition = curView.frame.origin.y + curView.frame.size.height + 8;
	[table setFrame:CGRectMake(horizontalMargin, yPosition, tableWidth, tableHeight)];
	
	while([[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		if([curView isEqual:table])
			break;
		[curView setFrame:CGRectMake(curView.frame.origin.x, curView.frame.origin.y + tableHeight, curView.frame.size.width, curView.frame.size.height)];
		i++;
		}
}

-(void) dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	switch(buttonIndex)
	{
		case 0: // cancel
		break;
		case 1: // confirm selection
		if([table indexPathForSelectedRow])
			[callback performSelector:selector withObject:[[[table cellForRowAtIndexPath:[table indexPathForSelectedRow]] textLabel] text]];
		break;

	}
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [elementList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Element Table Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[[cell textLabel] setText:[elementList objectAtIndex:row]];
    
    return cell;
}

#pragma mark - Class Methods

+(void) loadElementDictionary
{
	if(elementDictionary) return;
	
	NSString * path;
	path = [[NSBundle mainBundle] pathForResource:@"ElementList" ofType:@"plist"];
	
	elementDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

+(TemplateElement*) elementOfType:(NSString *)type delegate:(id)delegate
{
	[ElementPicker loadElementDictionary];
	
	TemplateElement * element;
	element = [[[NSClassFromString([elementDictionary valueForKey:type]) alloc] init] autorelease];
	
	if(element)
		{
		[element setDelegate:delegate];
		[element setDictionary:[NSMutableDictionary dictionaryWithObject:type forKey:elementTypeKey]];
		}
	return element;
}

+(void) showWithDelegate:(id)delegateArg selector:(SEL)selectorArg
{
	[[[[ElementPicker alloc] initWithDelegate:delegateArg selector:selectorArg] autorelease] show];
}
@end

