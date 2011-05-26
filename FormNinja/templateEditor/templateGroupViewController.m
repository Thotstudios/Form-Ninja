//
//  templateGroupViewController.m
//  FormNinja
//
//  Created by Programmer on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "templateGroupViewController.h"
#import "fieldSelectionViewController.h"
#import "parentFieldViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation templateGroupViewController
@synthesize groupLabel;
@synthesize bottomControlsView;
@synthesize delegate;
@synthesize fieldViewControllers;
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
   
    self.fieldViewControllers=[NSMutableArray array];
    self.view.layer.cornerRadius=20; 
    if (dictValue!=nil) {
        groupLabel.text=[dictValue objectForKey:@"label"];
        for (NSDictionary *curDict in [dictValue valueForKey:@"fields"]) {
            parentFieldViewController *newVC=[[parentFieldViewController alloc] initWithNibName:@"parentFieldViewController" bundle:[NSBundle mainBundle]];
            parentFieldViewController *childVC=[newVC allocFieldFromDic:curDict];
            [self.fieldViewControllers addObject:childVC];
            [self.view addSubview:childVC.view];
            [newVC setDelegate:self];
            [newVC release];
        }
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

#pragma mark - Data Persistence Functions

-(NSDictionary *) getDictionaryData
{
    NSMutableDictionary *groupDictionary=[NSMutableDictionary dictionary];
    [groupDictionary setValue:groupLabel.text forKey:@"label"];
    NSMutableArray *fieldArray=[NSMutableArray array];
    for (parentFieldViewController *curView in fieldViewControllers) {
        [fieldArray addObject:[curView getDictionaryData]];
    }
    [groupDictionary setValue:fieldArray forKey:@"fields"];
    return groupDictionary;
}

-(void)setByDictionary:(NSDictionary *) aDictionary
{
    dictValue=aDictionary;
    groupLabel.text=[dictValue objectForKey:@"label"];
    for (NSDictionary *curDict in [dictValue valueForKey:@"fields"]) {
        if (self.fieldViewControllers!=nil) {
            NSLog(@"Field view controlers not nil");
        }
        if (self.fieldViewControllers==nil) {
            NSLog(@"Field view controlers IS IN FACT nil");
        }
        parentFieldViewController *newVC=[[parentFieldViewController alloc] initWithNibName:@"parentFieldViewController" bundle:[NSBundle mainBundle]];
        parentFieldViewController *childVC=[newVC allocFieldFromDic:curDict];
        [self.fieldViewControllers addObject:childVC];
        [self.view addSubview:childVC.view];
        [childVC setDelegate:self];
        [newVC release];
    }
    [self redoHeights];
}

#pragma mark - Interface Functions

-(IBAction) addGroupButtonPressed
{
    [self.delegate addGroupButtonPressed:self];
}

-(IBAction) removeGroupButtonPressed
{
    [self.delegate removeGroupButtonPressed:self];
}

-(IBAction) moveGroupUpButtonPressed
{
    [self.delegate moveGroupUpButtonPressed:self];
}

-(IBAction) moveGroupDownButtonPressed
{
    [self.delegate moveGroupDownButtonPressed:self];
}

-(IBAction) addFieldButtonPressed
{
    fieldSelectionViewController *selectionVC=[[fieldSelectionViewController alloc] initWithNibName:@"fieldSelectionViewController" bundle:[NSBundle mainBundle]];
    [self.view.superview.superview addSubview:selectionVC.view];
    selectionVC.view.frame=self.view.superview.frame;
    selectionVC.delegate=self;
}

#pragma mark - Field Delegate Functions

-(void) removeFieldButtonPressed:(parentFieldViewController *)field
{
    NSLog(@"templateGroup remove");
    [field.view removeFromSuperview];
    NSLog(@"count: %i", [fieldViewControllers count]);
    [fieldViewControllers removeObject:field];
    NSLog(@"count: %i", [fieldViewControllers count]);
    [self redoHeights];
}
-(void) addFieldButtonPressed:(parentFieldViewController *)field
{
    
}
-(void) moveFieldUpButtonPressed:(parentFieldViewController *)field
{
    
}
-(void) moveFieldDownButtonPressed:(parentFieldViewController *)field
{
    
}

#pragma mark - Field Selection View Delegate

-(void) fieldSelectionCancelButtonPressed:(fieldSelectionViewController *)controller
{
    [controller.view removeFromSuperview];
    [controller release];
}
-(void) fieldSelectionDidChooseFieldType:(NSString *)fieldType fromController:(fieldSelectionViewController *)controller
{
    [controller.view removeFromSuperview];
    [controller release];
    parentFieldViewController *parent=[parentFieldViewController alloc];
    parentFieldViewController *child=[parent allocFieldFromDic:[NSDictionary dictionaryWithObject:fieldType forKey:@"type"]];
    [fieldViewControllers addObject:child];
    [child setDelegate:self];
    [parent release];
    [self.view addSubview:child.view];
    [self redoHeights];
    [delegate changedHeightForGroup:self];
}

#pragma mark - Graphics

-(void) redoHeights
{
    float curHeight=65;
    for (parentFieldViewController *curView in fieldViewControllers) {
        curView.view.frame=CGRectMake(curView.view.frame.origin.x,
                                      curHeight,
                                      curView.view.frame.size.width,
                                      curView.view.frame.size.height);
        curHeight+=curView.view.frame.size.height+10;
    }
    bottomControlsView.frame=CGRectMake(bottomControlsView.frame.origin.x,
                                        curHeight,
                                        bottomControlsView.frame.size.width,
                                        bottomControlsView.frame.size.height);
    self.view.frame=CGRectMake(self.view.frame.origin.x,
                               self.view.frame.origin.y, 
                               self.view.frame.size.width,
                               curHeight+bottomControlsView.frame.size.height+10);
    NSLog(@"current view height is: %f", self.view.frame.size.height);
    NSLog(@"curheight is: %f", curHeight);
    [delegate changedHeightForGroup:self];
}

@end