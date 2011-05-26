//
//  FormEditorViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormEditorViewController.h"


@implementation FormEditorViewController

@synthesize formLabel, templateLabel, timeLabel;
@synthesize scrollView;
@synthesize dictValue;
@synthesize fieldGroups;
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
    
    templateLabel.text=[dictValue valueForKey:@"templateLabel"];
    formLabel.text=[dictValue valueForKey:@"formLabel"];
    for (NSDictionary *curDict in [dictValue valueForKey:@"templateGroups"]) {
        formGroupViewController *curGroupVC=[[formGroupViewController alloc] initWithNibName:@"formGroupViewController" bundle:[NSBundle mainBundle]];
        [curGroupVC setByDict:curDict];
        [self.view addSubview:curGroupVC.view];
        curGroupVC.view.frame=CGRectMake(10, 0, self.view.frame.size.width, curGroupVC.view.frame.size.height);
        [fieldGroups addObject:curGroupVC];
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

#pragma mark - Graphics Functions

-(void) rearrangeGroups
{
    
}

#pragma mark - Data persistence

-(void)setByDict:(NSDictionary *) aDict
{
    self.dictValue=aDict;
    if (formLabel!=nil) {
        templateLabel.text=[dictValue valueForKey:@"templateLabel"];
        formLabel.text=[dictValue valueForKey:@"formLabel"];
        for (NSDictionary *curDict in [dictValue valueForKey:@"templateGroups"]) {
            formGroupViewController *curGroupVC=[[formGroupViewController alloc] initWithNibName:@"formGroupViewController" bundle:[NSBundle mainBundle]];
            [curGroupVC setByDict:curDict];
            [self.view addSubview:curGroupVC.view];
            curGroupVC.view.frame=CGRectMake(10, 0, self.view.frame.size.width, curGroupVC.view.frame.size.height);
            [fieldGroups addObject:curGroupVC];
        }
    }
}
-(NSDictionary *)getDictValue
{
    NSMutableDictionary *newDic=[NSMutableDictionary dictionary];
    [newDic setValue:formLabel.text forKey:@"formLabel"];
    [newDic setValue:templateLabel.text forKey:@"templateLabel"];
    NSMutableArray *groupsArray=[NSMutableArray array];
    for (formGroupViewController *curGroup in fieldGroups) {
        [groupsArray addObject:[curGroup getDictValue]];
    }
    [newDic setValue:groupsArray forKey:@"templateGroups"];
    return newDic;
}

@end
