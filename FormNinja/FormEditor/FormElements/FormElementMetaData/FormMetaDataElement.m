//
//  FormMetaDataElement.m
//  FormNinja
//
//  Created by Ron Lugge on 6/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "FormMetaDataElement.h"
#import "AccountClass.h"

@implementation FormMetaDataElement
@synthesize formAgentField;
@synthesize formBeginDateField;
@synthesize formFinalDateField;
@synthesize formCoordinatesField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[formAgentField release];
	[formBeginDateField release];
	[formFinalDateField release];
	[formCoordinatesField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[self setFormAgentField:nil];
	[self setFormBeginDateField:nil];
	[self setFormFinalDateField:nil];
	[self setFormCoordinatesField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)	setDictionary:(NSMutableDictionary *)arg
{
	//[self reset];
	[super setDictionary:arg];
	
	if(![self.dictionary valueForKey:formAgentKey])
		[self.dictionary setValue:CURRENT_USERNAME forKey:formAgentKey];
	if(![self.dictionary valueForKey:formBeginDateKey])
		[self.dictionary setValue:CURRENT_DATE_AND_TIME forKey:formBeginDateKey];
	if(![self.dictionary valueForKey:formFinalDateKey])
		[self.dictionary setValue:@"Not Finished" forKey:formFinalDateKey];
	if(![self.dictionary valueForKey:formCoordinatesKey])
		[self.dictionary setValue:@"Not Available" forKey:formCoordinatesKey];
	if(![self.dictionary valueForKey:formCoordinatesAccuracyKey])
		[self.dictionary setValue:@"" forKey:formCoordinatesAccuracyKey];
	
	[formAgentField setText:[dictionary valueForKey:formAgentKey]];
	[formBeginDateField setText:[dictionary valueForKey:formBeginDateKey]];
	[formFinalDateField setText:[dictionary valueForKey:formFinalDateKey]];
	NSString * coords;
	if([[dictionary valueForKey:formCoordinatesAccuracyKey] length])
	coords = [NSString stringWithFormat:GPS_COORD_AND_ACC_FORMAT,
						 [dictionary valueForKey:formCoordinatesKey],
						 [dictionary valueForKey:formCoordinatesAccuracyKey]];
	else
		coords = @"No Coordinates";
	[formCoordinatesField setText:coords];
}

@end
