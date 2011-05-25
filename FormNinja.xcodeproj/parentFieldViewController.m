//
//  parentFieldViewController.m
//  FormNinja
//
//  Created by Programmer on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "parentFieldViewController.h"
#import "stringFieldViewController.h"


@implementation parentFieldViewController

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

-(parentFieldViewController *) allocFieldFromDic:(NSDictionary *)aDic
{
    parentFieldViewController *fieldController=nil;
    NSString *type=[aDic valueForKey:@"type"];
    if (type==@"string") {
        fieldController=[[stringFieldViewController alloc] initWithNibName:@"stringFieldViewController" bundle:[NSBundle mainBundle]];
        NSLog(@"Checking value: %f", fieldController.view.frame.size.height);
    }
    else
    {
        NSLog(@"WARNING!  Unidentified type passed to parentFieldViewController in dictionary!");
        //Throw error -- how?
    }
    return [fieldController autorelease];
}

@end
