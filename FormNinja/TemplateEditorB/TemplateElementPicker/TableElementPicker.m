//
//  TableElementPicker.m
//  Dev
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableElementPicker.h"

#import "TemplateElement.h"

#import "TemplateElement.h"
#import "MetaDataElement.h"
#import "SingleLineElement.h"
#import "MultiLineElement.h"
#import "AddressElement.h"
#import "SignatureElement.h"

#define tableWidth 262
#define tableHeight 160
#define horizontalMargin 11

@interface TableElementPicker()
+(void) loadElementDictionary;
@end

@implementation TableElementPicker

static NSMutableDictionary * elementList = nil;
static BOOL dictionaryIsLoaded = NO;

//@synthesize alert;
@synthesize callback;
@synthesize selector;
@synthesize table;

//@synthesize type;
@synthesize elementTypes;

-(id) initWithDelegate:(id)delegateArg selector:(SEL)selectorArg
{
	if(!(self = [super initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"confirm", nil])) return self;
	
	[self setCallback:delegateArg];
	[self setSelector:selectorArg];
	frameHeight = 0;
	frameYPosition = 0;
	orientation = -1; //[[UIDevice currentDevice] orientation];
	if(!dictionaryIsLoaded) [TableElementPicker loadElementDictionary];
	
	// TODO: move to static array
	[self setElementTypes:[elementList allKeys]];
	
	return self;
}
-(void) show
{
	[self setTable:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped]];
	[self addSubview:table];
	[table setDelegate:self];
	[table setDataSource:self];
	[super show];
}
-(BOOL) orientationChanged
{
	UIDeviceOrientation cur =
	[[UIDevice currentDevice] orientation];
	if(orientation == cur)
		return NO;
	orientation = cur;
	return YES;
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
	
	float yPosition = curView.frame.origin.y + curView.frame.size.height + 8;
	[table setFrame:CGRectMake(horizontalMargin, yPosition, tableWidth, tableHeight)];
	
	if(!frameHeight) 
		frameHeight = self.frame.size.height + tableHeight + 16;
	if(!frameYPosition)
		frameYPosition = self.frame.origin.y - 0.5 * tableHeight;
	
	[self setFrame:CGRectMake(self.frame.origin.x, frameYPosition, self.frame.size.width, frameHeight)];
	
	while([[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		if([curView isEqual:table])
			break;
		[curView setFrame:CGRectMake(curView.frame.origin.x, curView.frame.origin.y + tableHeight, curView.frame.size.width, curView.frame.size.height)];
		i++;
		}
}

#pragma mark -

+(void) loadElementDictionary
{
	NSString * path;
	path = [[NSBundle mainBundle] pathForResource:@"ElementList" ofType:@"plist"];
	
	elementList = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	dictionaryIsLoaded = YES;
}

#pragma mark -

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [elementTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[[cell textLabel] setText:[elementTypes objectAtIndex:row]];
    
    return cell;
}

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self setType:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
}
*/
#pragma mark - Class Methods

+(TemplateElement*) elementOfType:(NSString *)type
{
	if(!dictionaryIsLoaded) [TableElementPicker loadElementDictionary];
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	TemplateElement * element = nil;
	
	
	element = [[[NSClassFromString([elementList objectForKey:type]) alloc] init] autorelease];
	
	if(!element)
		element = [[[TemplateElement alloc] init] autorelease];
	
	if(element)
		{
		[element.view setFrame:CGRectMake(0, 0, 768, element.view.frame.size.height)];
		[dict setObject:type forKey:@"type"];
		[element setDictionary:dict];
		}
	return element;
}

+(void) registerTemplateElement:(Class)classType name:(NSString*)name
{
	[elementList setObject:classType forKey:name];
}

@end

