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

-(void) setDictionary:(NSMutableDictionary *)arg
{
	[self.view setNeedsDisplay];
	[dictionary release];
	dictionary = [arg retain];
	[labelLabel setText:[dictionary objectForKey:@"label"]];
    NSNumber *index=[dictionary objectForKey:@"label alignment"];
    if ([index intValue]==0) {
        labelLabel.textAlignment=UITextAlignmentLeft;
    }
    else if([index intValue]==1)
    {
        labelLabel.textAlignment=UITextAlignmentCenter; 
    }
    else if([index intValue]==2)
    {
        labelLabel.textAlignment=UITextAlignmentRight;
    }
}

@end
