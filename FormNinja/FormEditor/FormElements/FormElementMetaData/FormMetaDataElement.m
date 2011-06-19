//
//  FormMetaDataElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormMetaDataElement.h"
#import "AccountClass.h"

@implementation FormMetaDataElement

@synthesize templateNameLabel, templateGroupLabel, creationDateLabel, creatorNameLabel, formStartLabel, formFinishLabel, formFinishGPSLabel, formFillerLabel;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


-(void) setDate
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	NSDate *date = [self.dictionary valueForKey:formBeginDateKey];
	if(!date)
    {
		date = [NSDate date];
		[self.dictionary setValue:date forKey:formBeginDateKey];
    }
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[creationDateLabel setText:[dateFormatter stringFromDate:date]];
    
}

-(void)	setDictionary:(NSMutableDictionary *)arg
{
	//[self reset];
	[super setDictionary:arg];
	
	if(![self.dictionary valueForKey:formBeginDateKey])
		[self.dictionary setValue:CURRENT_DATE_AND_TIME forKey:formBeginDateKey];
	if(![self.dictionary valueForKey:formAgentKey])
		[self.dictionary setValue:CURRENT_USERNAME forKey:formAgentKey];
	if(![self.dictionary valueForKey:formFinalDateKey])
		[self.dictionary setValue:@"Not Finished" forKey:formFinalDateKey];

    [formFillerLabel setText:[self.dictionary valueForKey:formAgentKey]];
	[templateNameLabel setText:[self.dictionary valueForKey:templateNameKey]];
	[templateGroupLabel setText:[self.dictionary valueForKey:templateGroupKey]];
	[creatorNameLabel setText:[self.dictionary valueForKey:templateCreatorKey]];
	[creationDateLabel setText:[self.dictionary valueForKey:templateCreationDateKey]];
    
	[formStartLabel setText:[self.dictionary valueForKey:formBeginDateKey]];
	[formFinishLabel setText:[self.dictionary valueForKey:formFinalDateKey]];
    NSString *valueString=[self.dictionary valueForKey:@"finish location"];
    if (valueString==nil) {
        valueString=@"Not Available";
    }
    [formFinishGPSLabel setText:valueString];
    
	return;
	
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *date = [self.dictionary valueForKey:formBeginDateKey];
	if(!date)
    {
		date = [NSDate date];
		[self.dictionary setValue:date forKey:formBeginDateKey];
    }
    [formStartLabel setText:[dateFormatter stringFromDate:[self.dictionary valueForKey:formBeginDateKey]]];
    date=[self.dictionary valueForKey:formFinalDateKey];
    if (!date) {
        [formFinishLabel setText:@"Not Finished"];
    }
    else
    {
        [formFinishLabel setText:[dateFormatter stringFromDate:[self.dictionary valueForKey:formFinalDateKey]]];
    }

}

-(void)setFinished
{
    [self.dictionary setValue:[NSDate date] forKey:formFinalDateKey];
}

@end
