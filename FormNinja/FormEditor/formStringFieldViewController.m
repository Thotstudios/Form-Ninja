//
//  formStringFieldViewController.m
//  FormNinja
//
//  Created by Programmer on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "formStringFieldViewController.h"


@implementation formStringFieldViewController

@synthesize fieldText;
@synthesize fieldLabel, minChars, maxChars;
@synthesize indicator;
@synthesize dictValue;
@synthesize minLength, maxLength;
@synthesize delegate;

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
    if (dictValue!=nil) {
        self.fieldLabel.text=[dictValue valueForKey:@"label"];
        NSString *temp=[dictValue valueForKey:@"minLength"];
        self.minLength=[temp integerValue];
        temp=[dictValue valueForKey:@"maxLength"];
        self.maxLength=[temp integerValue];   
    }
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

#pragma mark - data persistance

-(void)setByDict:(NSDictionary *) aDict
{
    dictValue=aDict;
    if (fieldLabel!=nil) {
        
        self.fieldLabel.text=[dictValue valueForKey:@"label"];
        NSString *temp=[dictValue valueForKey:@"minLength"];
        self.minLength=[temp integerValue];
        temp=[dictValue valueForKey:@"maxLength"];
        self.maxLength=[temp integerValue];    
    }
}
-(NSDictionary *)getDictValue
{
    NSMutableDictionary *newDict=[NSMutableDictionary dictionary];
    
    [newDict setValue:@"string" forKey:@"type"];
    [newDict setValue:self.fieldLabel.text forKey:@"label"];
    [newDict setValue:self.fieldText.text forKey:@"string"];
    [newDict setValue:[NSString stringWithFormat:@"%i", minLength] forKey:@"minLength"];
    [newDict setValue:[NSString stringWithFormat:@"%i", maxLength] forKey:@"maxLength"];
    
    return newDict;
}

#pragma mark - User interaction

-(IBAction) indicatorButtonPressed
{
    
}

@end
