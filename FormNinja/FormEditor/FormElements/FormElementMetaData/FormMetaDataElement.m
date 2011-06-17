//
//  FormMetaDataElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormMetaDataElement.h"


@implementation FormMetaDataElement

@synthesize templateNameLabel, templateGroupLabel, creationDateLabel, creatorNameLabel, formStartLabel, formFinishLabel;

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
	/*
     NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
     [formatter setDateStyle:NSDateFormatterNoStyle];
     NSDate * date = [NSDate date];
     [creationDateField setText:[NSString stringWithFormat:@"%@", date]];
	 */
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
	[templateNameLabel setText:[self.dictionary valueForKey:templateNameKey]];
	[templateGroupLabel setText:[self.dictionary valueForKey:templateGroupKey]];
	[creatorNameLabel setText:[self.dictionary valueForKey:templateCreatorKey]];
	//if([dictionary valueforKey:@"formStartDate"]==nil) then set start date
	//[creationDateField setText:[dictionary valueForKey:templateCreationDateKey]];
    
    
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[creationDateLabel setText:[dateFormatter stringFromDate:[self.dictionary valueForKey:templateCreationDateKey]]];
    NSDate *date = [self.dictionary valueForKey:formBeginDateKey];
	if(!date)
    {
		date = [NSDate date];
		[self.dictionary setValue:date forKey:formBeginDateKey];
    }
    [formStartLabel setText:[dateFormatter stringFromDate:[self.dictionary valueForKey:formBeginDateKey]]];
    date=[self.dictionary valueForKey:formFinalDateKey];
    if (date) {
        [formFinishLabel setText:@"Not Finished"];
    }
    else
    {
        [formFinishLabel setText:[dateFormatter stringFromDate:[self.dictionary valueForKey:formFinalDateKey]]];
    }

}

@end
