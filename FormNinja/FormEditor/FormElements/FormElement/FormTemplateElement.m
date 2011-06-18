//
//  FormTemplateElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormTemplateElement.h"


@implementation FormTemplateElement

@synthesize labelLabel;

- (void)viewDidUnload
{
    [super viewDidUnload];
	[self setLabelLabel:nil];
}

- (void)dealloc
{
	[labelLabel release];
    [super dealloc];
}
#pragma mark - Inherited Methods

-(void) setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	
	[self.labelLabel setText:[self.dictionary objectForKey:elementLabelKey]];
    NSNumber *index=[self.dictionary objectForKey:@"label alignment"];
	switch ([index intValue])
	{
		case 0:
        self.labelLabel.textAlignment=UITextAlignmentLeft;
		break;
		case 1:
        self.labelLabel.textAlignment=UITextAlignmentCenter; 
		break;
		case 2:
        self.labelLabel.textAlignment=UITextAlignmentRight;
		break;
	}
}

#pragma mark - Delegate Methods
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	return allowEditing;
}
@end
