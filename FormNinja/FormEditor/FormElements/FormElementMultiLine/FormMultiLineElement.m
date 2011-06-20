//
//  FormMultiLineElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormMultiLineElement.h"


@implementation FormMultiLineElement

@synthesize minLabel, maxLabel, curLabel;

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

-(IBAction) reset
{
	[self.dictionary removeObjectForKey:elementFormValueKey];
    [self.valueField setText:[self.dictionary objectForKey:elementValueKey]];
}

-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
    
    NSString *stringValue=[self.dictionary valueForKey:elementFormValueKey];
    if (stringValue) {
        [self.valueField setText:stringValue];
    }
	else
    {
        [self.valueField setText:[self.dictionary valueForKey:elementValueKey]];
    }
	[self.minLabel setText:[self.dictionary valueForKey:elementMinLengthKey]];
	[self.maxLabel setText:[self.dictionary valueForKey:elementMaxLengthKey]];
    
    stringValue=[self.dictionary valueForKey:@"finished"];
    if ([stringValue isEqualToString:@"yes"]) {
        self.valueField.editable=NO;
    }
    else
        self.valueField.editable=YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSString * key = elementFormValueKey;
	
	if(key) [self.dictionary setValue:[textView text] forKey:key];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [curLabel setText:[NSString stringWithFormat:@"%i",[textView.text length]]];
    //TODO:  validate length
}

@end
