//
//  SignatureAlertView.m
//  FormNinja
//
//  Created by Hackenslacker on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignatureAlertView.h"

#import "SignatureView.h"

#define signWidth 400
#define signHeight 150
#define horizontalMargin 13
#define framePadding 42 + 2 * horizontalMargin

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
	
	CGRect rect;
	
	UIView * curView;
	int i = 0;
	while(![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		
		rect = curView.frame;
		rect.size.width = signWidth + 8;
		[curView setFrame:rect];
		
		i++;
		}
	
	rect = self.frame;
	rect.origin.x -= 69;
	rect.origin.y -= 0.50 * signHeight;
	rect.size.height += signHeight;
	
	rect.size.width += 18;
	if(signatureView.frame.size.width == 0)
		{
		//rect.origin.x -= 69;
		rect.size.width += 2;
		rect.size.height += 16;
		}
	
	[self setFrame:rect];
	
	float yPosition = curView.frame.origin.y + curView.frame.size.height + 8;
	[signatureView setFrame:CGRectMake(horizontalMargin, yPosition, signWidth, signHeight)];

	
	while([[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]])
		{
		curView = [self.subviews objectAtIndex:i];
		rect = curView.frame;
		rect.origin.y += signHeight;
		rect.size.width = signWidth + 4;
		[curView setFrame:rect];
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
