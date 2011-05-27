//
//  SignatureAlertView.m
//  FormNinja
//
//  Created by Hackenslacker on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignatureAlertView.h"

#import "SignatureView.h"

#define SignWidth 400
#define SignHeight 150
#define HorizontalMargin 13
#define FramePadding 42 + 2 * HorizontalMargin

@implementation SignatureAlertView

@synthesize signatureView;
@synthesize callback;
@synthesize selector;
@synthesize success;
@synthesize failure;

-(id) initWithTitle:(NSString *)title delegate:(id)delegateArg onSuccess:(SEL)successArg onFailure:(SEL)failureArg
{
	if(!(self = [super initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"Cancel Signing" otherButtonTitles:@"Clear Signature", @"Confirm Signature", nil])) return self;
	
	[self setCallback:delegateArg];
	[self setSuccess:successArg];
	[self setFailure:failureArg];
	
	return self;
}
-(id) initWithDelegate:(id)delegateArg onSuccess:(SEL)successArg onFailure:(SEL)failureArg
{
	return [self initWithTitle:@"Signature Required" delegate:delegateArg onSuccess:successArg onFailure:failureArg];
}

-(void) show
{
	[self setSignatureView:[[SignatureView alloc] initWithFrame:CGRectZero]];
	[signatureView setBackgroundColor:[UIColor whiteColor]];
	[self addSubview:signatureView];
	[super show];
}
-(void) layoutSubviews
{
	[super layoutSubviews];
	
	UIView * curView;
	int i = 0;
	while(![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		if([curView isKindOfClass:[UILabel class]])
			[curView setFrame:CGRectMake(curView.frame.origin.x, curView.frame.origin.y, SignWidth, curView.frame.size.height)];
		i++;
		}
	
	float yPosition = curView.frame.origin.y + curView.frame.size.height + 8;
	[signatureView setFrame:CGRectMake(HorizontalMargin, yPosition, SignWidth, SignHeight)];

	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - 0.5 * SignHeight, signatureView.frame.size.width + FramePadding, self.frame.size.height + SignHeight + 16)];
	
	while([[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		//[curView setFrame:CGRectMake(curView.frame.origin.x, curView.frame.origin.y + SignHeight, curView.frame.size.width, curView.frame.size.height)];
		[curView setFrame:CGRectMake(curView.frame.origin.x, curView.frame.origin.y + SignHeight, SignWidth, curView.frame.size.height)];
		i++;
		}
}

-(void) dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	switch(buttonIndex)
	{
		case 0: // cancel
		[callback performSelector:failure];
		break;
		case 1: // clear sig
		[signatureView clearSignature];
		return;
		case 2: // confirm sig
		[callback performSelector:success withObject:[signatureView imageView].image];
		break;
	}
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}
@end
