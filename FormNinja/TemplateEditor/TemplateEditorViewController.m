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




- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector
     (keyboardWillShow:) 
     name: UIKeyboardDidShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self 
     selector:@selector
     (keyboardWillHide:) name:
     UIKeyboardDidHideNotification
     object:nil];
    
}

//Keyboard control functions

- (void)keyboardWillShow:(NSNotification *)aNotification {
    if (!displayKeyboard) {
        [self moveTextViewForKeyboard:aNotification up:YES];
        displayKeyboard=YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    if(displayKeyboard)
    {
        [self moveTextViewForKeyboard:aNotification up:NO]; 
        displayKeyboard=NO;
    }
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up{
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = scrollView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    newFrame.size.height -= keyboardFrame.size.height * (up? 1 : -1);
    scrollView.frame = newFrame;
    
    [UIView commitAnimations];
}



-(void) keyboardDidHide: (NSNotification *)notif {
    if (!displayKeyboard) {
        return; 
    }
    
    self.scrollView.frame = CGRectMake(0, 0, 768, 1004);
    
    self.scrollView.contentOffset =offset;
    
    displayKeyboard = NO;
    
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
    float newPosition=self.addFieldButton.frame.origin.y;
    NSMutableDictionary *newFieldDictionary;
    newFieldDictionary=[[NSMutableDictionary alloc] init];
    [newFieldDictionary setObject:@"string" forKey:@"type"];
    [newFieldDictionary setObject:[NSNumber numberWithFloat:newHeight] forKey:@"height"];
    self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
                                         self.addFieldButton.frame.origin.y+newHeight+10, 
                                         self.addFieldButton.frame.size.width,  
                                         self.addFieldButton.frame.size.height);
    self.scrollView.contentSize=CGSizeMake(768, self.addFieldButton.frame.origin.y+37+20);
    
    stringFieldViewController *newVC=[[stringFieldViewController alloc] initWithNibName:@"stringFieldViewController" bundle:[NSBundle mainBundle]];
    CGRect newFrame;
    if(self.interfaceOrientation==UIInterfaceOrientationPortrait | 
       self.interfaceOrientation== UIInterfaceOrientationPortraitUpsideDown)
    {
        newFrame=CGRectMake(20, 
                            newPosition, 
                            (self.view.frame.size.width-40), 
                            newHeight);
        
    }
    else
    {
        newFrame=CGRectMake(20, 
                            newPosition, 
                            (self.view.frame.size.height-40), 
                            newHeight);
        
    }
    newVC.view.frame=newFrame;
    //[newVC.view autoresizingMask]
    newVC.view.autoresizingMask=(UIViewAutoresizingFlexibleWidth);
    [newVC setDelegate:self];
    
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

//UITextField Delegate


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Template Field Delegate Functions

-(void) removeButtonPressed:(stringFieldViewController *)field
{
    NSDictionary *current;
    int currentIndex;
    for (int i=0; i<[fieldViews count]; i++) {
        current=[fieldViews objectAtIndex:i];
        NSLog(@"removeButtonPressed first loop");
        if([current valueForKey:@"fieldVC"]==field)
        {
            [fieldViews removeObject:current];
            [field.view removeFromSuperview];
            currentIndex=i;
        }
    }
    float newPosition = 88, newHeight;
    CGRect newFrame;
    for (int i=0; i<[fieldViews count]; i++) {
        NSLog(@"removeButtonPressed second loop");
        current=[fieldViews objectAtIndex:i];
        newHeight=[[current objectForKey:@"height"] floatValue];
        if(i>=currentIndex)
        {
            if(self.interfaceOrientation==UIInterfaceOrientationPortrait | 
               self.interfaceOrientation== UIInterfaceOrientationPortraitUpsideDown)
            {
                newFrame=CGRectMake(20, 
                                    newPosition, 
                                    (self.view.frame.size.width-40), 
                                    newHeight);
                
            }
            else
            {
                newFrame=CGRectMake(20, 
                                    newPosition, 
                                    (self.view.frame.size.height-40), 
                                    newHeight);
                
            }
            ((stringFieldViewController*)[current objectForKey:@"fieldVC"]).view.frame=newFrame;
        }
        newPosition+=newHeight+10;
    }
    self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
                                        newPosition+10, 
                                        self.addFieldButton.frame.size.width,  
                                        self.addFieldButton.frame.size.height);
}

-(void) moveUpButtonPressed:(stringFieldViewController *)field
{
    
}

-(void) moveDownButtonPressed:(stringFieldViewController *)field
{
    
}

-(void) changeButtonPressed:(stringFieldViewController *)field
{
    
}

-(BOOL) textFieldShouldReturn:(UITextField *) textField fromStringField:(stringFieldViewController *) field
{
    [textField resignFirstResponder];
    return YES;
}

@end
