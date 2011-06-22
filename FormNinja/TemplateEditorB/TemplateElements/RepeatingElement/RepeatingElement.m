//
//  RepeatingElement.m
//  FormNinja
//
//  Created by Chad Hatcher on 5/29/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "RepeatingElement.h"

#import "ElementPicker.h"

@implementation RepeatingElement
@synthesize repeatLimitField;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
	[self setRepeatLimitField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[repeatLimitField release];
    [super dealloc];
}

#pragma mark - Methods

- (IBAction)reset
{
	[super reset];
	[dictionary setValue:@"Repeating" forKey:elementTypeKey];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
}

-(void) newElementOfType:(NSString*)type
{
}

- (IBAction)addElement
{
	[ElementPicker showWithDelegate:self selector:@selector(newElementOfType:)];
}

@end
