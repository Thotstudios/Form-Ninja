//
//  TextFieldAlert.m
//  FormNinja
//
//  Created by Hackenslacker on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldAlert.h"
#import "Constants.h"

@implementation TextFieldAlert
@synthesize callback;
@synthesize selector;
@synthesize textField;

-(id) initWithTitle:(NSString*)title delegate:(id)delegateArg selector:(SEL)selectorArg
{
	if(!(self = [super initWithTitle:title message:nil delegate:nil cancelButtonTitle:CANCEL_STR otherButtonTitles:CONFIRM_STR, nil])) return self;
	
	[self setCallback:delegateArg];
	[self setSelector:selectorArg];
	[self setTextField:nil];
	orientation = -1;
	
	textFieldHeight = 31;
	textFieldWidth = 262;
	
	landscapeFrame = CGRectMake(356, 130, 284, 146);
	portraitFrame = CGRectMake(242, 318, 284, 146);
	
	return self;
}

-(void) dealloc
{
	[textField release];
	[callback release];
	[super dealloc];
}

-(void) show
{
	[self setTextField:[[UITextField alloc] initWithFrame:CGRectZero]];
	[textField setBorderStyle:UITextBorderStyleRoundedRect];
	[textField setTextAlignment:UITextAlignmentCenter];
	[self addSubview:textField];
	[textField setDelegate:self];
	[textField becomeFirstResponder];
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
	[super layoutSubviews];
	
	
	UIView * curView;
	int i = 0;
	while(![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		i++;
		}
	
	CGRect rect = [self getProperFrame];
	[self setFrame:rect];
	[[self.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
	
	float yPosition = curView.frame.origin.y + curView.frame.size.height + 8;
	[textField setFrame:CGRectMake(11, yPosition, textFieldWidth, textFieldHeight)];
	
	while(i < [self.subviews count] && [[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		if([curView isEqual:textField])
			break;
		[curView setFrame:CGRectMake(curView.frame.origin.x, curView.frame.origin.y + textFieldHeight, curView.frame.size.width, curView.frame.size.height)];
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
		if([textField text])
			[callback performSelector:selector withObject:[textField text]];
		break;
		
	}
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

+(void) showWithTitle:(NSString*)title delegate:(id)delegateArg selector:(SEL)selectorArg
{
	[[[[TextFieldAlert alloc] initWithTitle:title
								   delegate:delegateArg
								   selector:selectorArg] autorelease] show];
}

@end
