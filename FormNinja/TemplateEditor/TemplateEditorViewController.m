//
//  TemplateEditorViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateEditorViewController.h"


@implementation TemplateEditorViewController
@synthesize scrollView;
@synthesize templateData, fieldViews;
@synthesize addFieldButton;

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
    self.fieldViews=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize=CGSizeMake(768, 88+37+20);
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

-(IBAction)newFieldButtonTouched
{
    
    //this is the defined hieght for field view controllers.
    //For the moment, I intend to make this a constant just for ease-of-programming, in the end
    //I'll need to reprogram it to be variable.  Which WILL make life difficult.
    const float newHeight=134;
    float newPosition;
    NSMutableDictionary *newFieldDictionary;
    newPosition=self.addFieldButton.frame.origin.y;
    newFieldDictionary=[[NSMutableDictionary alloc] init];
    [newFieldDictionary setObject:@"string" forKey:@"type"];
    [newFieldDictionary setObject:[NSNumber numberWithFloat:newHeight] forKey:@"height"];
    self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
                                         self.addFieldButton.frame.origin.y+newHeight+20, 
                                         self.addFieldButton.frame.size.width,  
                                         self.addFieldButton.frame.size.height);
    self.scrollView.contentSize=CGSizeMake(768, self.addFieldButton.frame.origin.y+37+20);
    
    stringFieldViewController *newVC=[[stringFieldViewController alloc] initWithNibName:@"stringFieldViewController" bundle:[NSBundle mainBundle]];
    newVC.view.frame=CGRectMake(20, newPosition, 728, newHeight);
    //[newVC.view autoresizingMask]
    newVC.view.autoresizingMask=(UIViewAutoresizingFlexibleWidth);
    
    [newFieldDictionary setObject:newVC forKey:@"fieldVC"];
    
    [self.fieldViews addObject:newFieldDictionary];
    [self.scrollView addSubview:newVC.view];
    /*
    
    NSMutableDictionary *newField=[[NSMutableDictionary alloc] init];
    [self.templateData addObject:newField];
    [newField setObject:[NSNumber numberWithFloat:728] forKey:@"height"];
    [newField setObject:@"stringField" forKey:@"type"];
    
    CGRect myRect=CGRectMake(20, 88, [(NSNumber*)[newField objectForKey:@"height"] floatValue], 134);
    
    stringFieldViewController *aCont=[[stringFieldViewController alloc] initWithNibName:@"stringFieldViewController" bundle:[NSBundle mainBundle]];
    aCont.view.frame=myRect;
    [scrollView addSubview:aCont.view];
     
    */
    
}

@end
