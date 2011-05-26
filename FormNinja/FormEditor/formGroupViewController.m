//
//  formGroupViewController.m
//  FormNinja
//
//  Created by Programmer on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "formGroupViewController.h"


@implementation formGroupViewController
@synthesize groupLabel;
@synthesize fieldArray;
@synthesize dictValue;

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

#pragma mark - Data persistence

-(void)setByDict:(NSDictionary *) aDict
{
    dictValue=aDict;
    if (groupLabel!=nil) {
        groupLabel.text=[dictValue valueForKey:@"label"];
        for ( NSDictionary *curDict in [dictValue valueForKey:@"fields"]) {
            formFieldParentViewController *parent=[formFieldParentViewController alloc];
            formFieldParentViewController *child=[parent allocFieldFromDictionary:curDict];
            [fieldArray addObject:child];
            [self.view addSubview: child.view];
            [parent release];
        }
    }
}

-(NSDictionary *)getDictValue
{
    NSMutableDictionary *newDict=[NSMutableDictionary dictionary];
    [newDict setValue:groupLabel.text forKey:@"label"];
    NSMutableArray *dicsArray=[NSMutableArray array];
    for (formFieldParentViewController *curView in fieldArray) {
        [dicsArray addObject:[curView getDictValue]];
    }
    [newDict setValue:dicsArray forKey:@"fields"];
    return newDict;
}

@end
