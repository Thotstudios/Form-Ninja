//
//  SignatureViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignatureView.h"

@implementation SignatureView

@synthesize imageView;

-(id) initWithFrame:(CGRect)frame
{
	NSLog(@"Signature initWithFrame");
	if(!(self = [super initWithFrame:frame])) return self;
	
	// setup
	
	return self;
}

- (void)dealloc
{
	[imageView release];
    [super dealloc];
}

#pragma mark - View lifecycle

-(void) drawRect:(CGRect)rect
{
	NSLog(@"Signature drawRect");
	[super drawRect:rect];
	[self clearSignature];
}

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:self];

	NSLog(@"Signature touchesBegan.");
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self];
	
	UIGraphicsBeginImageContext(self.frame.size);
	[imageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
//	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
	
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	imageView.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(IBAction) clearSignature
{
	[imageView setImage:nil];
	[self setImageView:[[UIImageView alloc] initWithImage:nil]];
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = self.frame.size;
	imageView.frame = rect;
	[self addSubview:imageView];
}

@end







