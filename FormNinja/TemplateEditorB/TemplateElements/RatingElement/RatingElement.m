//
//  RatingElement.m
//  FormNinja
//
//  Created by Hackenslacker on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RatingElement.h"


@implementation RatingElement
@synthesize ratingSegControl;


#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [self setRatingSegControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [ratingSegControl release];
    [super dealloc];
}
#pragma mark -
- (IBAction)reset
{
	[super reset];
	[ratingSegControl setSelectedSegmentIndex:0];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	[ratingSegControl setSelectedSegmentIndex:[[dictionary valueForKey:elementValueKey] integerValue]];
}

- (IBAction)ratingChanged
{
	[dictionary setValue:[NSNumber numberWithInteger:[ratingSegControl selectedSegmentIndex]] forKey:elementRatingValueKey];
}
@end
