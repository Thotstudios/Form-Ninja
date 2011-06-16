//
//  FormEditorViewController.m
//  FormNinja
//
//  Created by Programmer on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormEditorViewController.h"
#import "FormTemplateElement.h"
#import "FormElementPicker.h"
#import "PopOverManager.h"

@implementation FormEditorViewController

-(IBAction) saveButtonPressed
{
    //set form completion date.
    
    //Concern/Note to self:  I need to detect that throughout entire view, because if the form is completed, then no values should be editable.
}
-(IBAction) dumpButtonPressed
{
    
}
-(IBAction) finishButtonPressed
{
    
}

-(void) newFormWithTemplate:(NSMutableArray *)data
{
	[self setDataArray:data];
	// TODO: whatever (view) updates need to be called
}

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

    //Menu button
	UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonAction:)]; 
    self.navigationItem.rightBarButtonItem = menuButton;
    [menuButton release];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[PopOverManager sharedManager] dismissCurrentPopoverController:YES]; //dismiss popover
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

- (void) generateViewArray
{
    NSLog(@"Test");
	[self setViewArray:[NSMutableArray array]];
	if([dataArray count])
    {
		NSString * type;
		TemplateElement * element;
		
		NSMutableArray * rowArray;
		for(NSMutableDictionary * sectionDict in dataArray)
        {
			rowArray = [NSMutableArray array];
			NSMutableArray * sectionData = [sectionDict objectForKey:sectionDataKey];
			if(sectionData)
				for(NSMutableDictionary *dict in sectionData)
                {
                    NSLog(@"Test2");
					type = [dict objectForKey:elementTypeKey];
					if(type)
                    {
                        NSLog(@"test: %@", type);
						element = [FormElementPicker formElementOfType:type];
						[element setDictionary:dict]; // TODO: fix
						[rowArray addObject:element];
                    }
                }
			else
            {
				NSMutableDictionary *dict = sectionDict;
				
				type = [dict objectForKey:elementTypeKey];
				if(type)
                {
                    NSLog(@"Test3");
					element = [FormElementPicker formElementOfType:type];
					[element setDictionary:dict]; // TODO fix
					[rowArray addObject:element];
                }
            }
			[viewArray addObject:rowArray];
        }
    }
}


//Presents popover menu
- (void) menuButtonAction:(id) sender{
    [[PopOverManager sharedManager] createMenuPopOver:accountProfileMenu fromButton:sender];
}

@end
