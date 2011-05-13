//
//  TemplateEditorViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateEditorViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation TemplateEditorViewController
@synthesize scrollView;
@synthesize templateData, fieldViews;
@synthesize addFieldButton;
@synthesize labelField;

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


-(void) setTemplateDataWithArray:(NSMutableArray *)newData
{
    self.fieldViews=nil;
    self.fieldViews=[NSMutableArray array];
    self.templateData=[newData mutableCopy];
    NSDictionary *currentFieldDic=[templateData objectAtIndex:0];
    NSMutableDictionary *currentViewDic;
    CGRect newFrame;float newHeight, newPosition;
    UIViewController *lastController;
    
    labelField.text=[currentFieldDic objectForKey:@"label"];
    for (int i=1; i<[templateData count]; i++) {
        currentFieldDic=[templateData objectAtIndex:i];
        if ([[currentFieldDic valueForKey:@"type"] isEqualToString:@"string"]) 
        {
            stringFieldViewController *newStringVC=[[stringFieldViewController alloc] 
                                                    initWithNibName:@"stringFieldViewController" 
                                                    bundle:[NSBundle mainBundle]];
            
            [newStringVC setByDictionary:currentFieldDic];
            [currentViewDic setValue:newStringVC forKey:@"fieldVC"];
            newHeight=(newStringVC.view.layer.bounds.size.height);
            [currentViewDic setValue:[NSNumber numberWithFloat:newHeight] forKey:@"height"];
            if (lastController!=nil) 
            {
                newPosition=lastController.view.frame.origin.y+lastController.view.frame.size.height+10;
            }
            else
            {
                newPosition=88;
            }
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
            newStringVC.view.frame=newFrame;
            [self.view addSubview:newStringVC.view];
            lastController=newStringVC;
        }
    }
    
    addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
                                    lastController.view.frame.origin.y+lastController.view.frame.size.height+10,
                                    self.addFieldButton.frame.size.width,
                                    self.addFieldButton.frame.size.height);
}


-(NSArray *) reduceTemplateToArray
{
    NSMutableArray *templateDataArray=[NSMutableArray array];
    NSMutableDictionary *currentDictionary=[NSMutableDictionary dictionary];
    [currentDictionary setValue:labelField.text forKey:@"label"];
    [currentDictionary setValue:@"template" forKey:@"type"];
    [templateDataArray addObject:currentDictionary];
    for (int i=0; i<[fieldViews count]; i++) {
        [templateDataArray addObject:[[[fieldViews objectAtIndex:i] objectForKey:@"fieldVC"] dictionaryValue]];
    }
    return nil;
}

-(IBAction)newFieldButtonTouched
{
    float newPosition=self.addFieldButton.frame.origin.y;
    NSMutableDictionary *newFieldDictionary;
    newFieldDictionary=[[NSMutableDictionary alloc] init];
    [newFieldDictionary setObject:@"string" forKey:@"type"];
    
    CGPoint buttonStartPosition=CGPointMake(self.addFieldButton.frame.origin.x+self.addFieldButton.frame.size.width/2,
                                            self.addFieldButton.frame.origin.y+self.addFieldButton.frame.size.height/2);
    
    
    stringFieldViewController *newVC=[[stringFieldViewController alloc] initWithNibName:@"stringFieldViewController" bundle:[NSBundle mainBundle]];
    float newHeight=newVC.view.layer.bounds.size.height;
    [newFieldDictionary setObject:[NSNumber numberWithFloat:newHeight] forKey:@"height"];
    [newFieldDictionary setObject:newVC forKey:@"fieldVC"];
    
    self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
                                         self.addFieldButton.frame.origin.y+newHeight+10, 
                                         self.addFieldButton.frame.size.width,  
                                         self.addFieldButton.frame.size.height);
    
    CGPoint buttonEndPosition=CGPointMake(self.addFieldButton.frame.origin.x+self.addFieldButton.frame.size.width/2,
                                          self.addFieldButton.frame.origin.y+self.addFieldButton.frame.size.height/2);
    
    
    self.scrollView.contentSize=CGSizeMake(768, self.addFieldButton.frame.origin.y+37+20);
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
    
    
    
    [self.fieldViews addObject:newFieldDictionary];
    [self.scrollView addSubview:newVC.view];
    
    self.addFieldButton.layer.zPosition=newVC.view.layer.zPosition+1;
    
    CABasicAnimation *newFieldAnimation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    CABasicAnimation *moveButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    newFieldAnimation.duration=.5;
    moveButtonAnimation.duration=.50;
    newFieldAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    newFieldAnimation.fromValue=[NSNumber numberWithFloat:0];
    moveButtonAnimation.fromValue=[NSValue valueWithCGPoint:buttonStartPosition];
    newFieldAnimation.toValue=[NSNumber numberWithFloat:1];
    moveButtonAnimation.toValue=[NSValue valueWithCGPoint:buttonEndPosition];
    
    [addFieldButton.layer addAnimation:moveButtonAnimation forKey:@"position"];
    [newVC.view.layer addAnimation:newFieldAnimation forKey:@"opacity"];
    
    
    
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
    
    

    
    CABasicAnimation *moveButtonAnimation, *moveViewAnimation;
    CGPoint moveStart, moveStop;
    CGRect oldFrame;
    
    NSDictionary *current;
    int currentIndex;
    for (int i=0; i<[fieldViews count]; i++) {
        current=[fieldViews objectAtIndex:i];
        if([current valueForKey:@"fieldVC"]==field)
        {
            [fieldViews removeObject:current];
            
            CABasicAnimation *newFieldAnimation =[CABasicAnimation animationWithKeyPath:@"opacity"];
            newFieldAnimation.duration=.5;
            newFieldAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            newFieldAnimation.fromValue=[NSNumber numberWithFloat:0];
            newFieldAnimation.toValue=[NSNumber numberWithFloat:1];
            [field.view.layer addAnimation:newFieldAnimation forKey:@"opacity"];
            
            [field.view removeFromSuperview];
            currentIndex=i;
        }
    }
    float newPosition = 88, newHeight;
    CGRect newFrame;
    for (int i=0; i<[fieldViews count]; i++) {
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
            
            moveStop=CGPointMake(newFrame.origin.x+newFrame.size.width/2, newFrame.origin.y+newFrame.size.height/2);
            
            oldFrame=((stringFieldViewController*)[current objectForKey:@"fieldVC"]).view.frame;
            moveStart=CGPointMake(oldFrame.origin.x+oldFrame.size.width/2, oldFrame.origin.y+oldFrame.size.height/2);
            moveStop=CGPointMake(20+newFrame.size.width/2, newPosition+oldFrame.size.height/2);
            
            moveViewAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
            moveViewAnimation.duration=.50;
            moveViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            moveViewAnimation.fromValue=[NSValue valueWithCGPoint:moveStart];
            moveViewAnimation.toValue=[NSValue valueWithCGPoint:moveStop];
            
            [((stringFieldViewController*)[current objectForKey:@"fieldVC"]).view.layer addAnimation:moveViewAnimation forKey:@"position"];
            
            
            ((stringFieldViewController*)[current objectForKey:@"fieldVC"]).view.frame=newFrame;
        }
        newPosition+=newHeight+10;
    }
    
    moveStart=CGPointMake(addFieldButton.frame.origin.x+addFieldButton.frame.size.width/2,
                          addFieldButton.frame.origin.y+addFieldButton.frame.size.height/2);
    
    self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
                                         newPosition+10, 
                                         self.addFieldButton.frame.size.width,  
                                         self.addFieldButton.frame.size.height);
    
    moveStop=CGPointMake(addFieldButton.frame.origin.x+addFieldButton.frame.size.width/2,
                          addFieldButton.frame.origin.y+addFieldButton.frame.size.height/2);
    
    moveButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    moveButtonAnimation.duration=.50;
    moveButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveButtonAnimation.fromValue=[NSValue valueWithCGPoint:moveStart];
    moveButtonAnimation.toValue=[NSValue valueWithCGPoint:moveStop];

    [addFieldButton.layer addAnimation:moveButtonAnimation forKey:@"position"];
    
    self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
                                        newPosition+10, 
                                        self.addFieldButton.frame.size.width,  
                                        self.addFieldButton.frame.size.height);
}

-(void) moveUpButtonPressed:(stringFieldViewController *)field
{
    NSDictionary *current=Nil, *last=Nil;
    stringFieldViewController *currentView=nil, *lastView=nil;
    int index;
    for (int i=0; i<[fieldViews count]; i++) {
        last=current;
        lastView=currentView;
        current=[fieldViews objectAtIndex:i];
        currentView=[current objectForKey:@"fieldVC"];
        if (currentView==field) {
            index=i;
            i=[fieldViews count];
        }
    }
    if(index==0)
        return;
    [fieldViews removeObject:current];
    [fieldViews insertObject:current atIndex:index-1];
    
    //as documented http://developer.apple.com/library/mac/#qa/qa1620/_index.html
    
    CGRect currentStart=currentView.view.frame;
    CGRect lastStart=lastView.view.frame;
    
    CGRect currentStop=CGRectMake(lastView.view.frame.origin.x,
                                      lastView.view.frame.origin.y,
                                      currentView.view.frame.size.width,
                                      currentView.view.frame.size.height);
    
    CGRect lastStop=CGRectMake(lastView.view.frame.origin.x,
                               lastView.view.frame.origin.y+10+([[current valueForKey:@"height"] floatValue]),
                               lastView.view.frame.size.width,
                               lastView.view.frame.size.height);
    
    
    
    CGPoint currentAnimPositionStart=CGPointMake(currentStart.origin.x+currentStart.size.width/2,
                                                 currentStart.origin.y+currentStart.size.height/2);
    CGPoint lastAnimPositionStart=CGPointMake(lastStart.origin.x+lastStart.size.width/2,
                                              lastStart.origin.y+lastStart.size.height/2);
    
    CGPoint currentAnimPositionStop=CGPointMake(currentStop.origin.x+currentStart.size.width/2,
                                                currentStop.origin.y+currentStart.size.height/2);
    CGPoint lastAnimPositionStop=CGPointMake(lastStop.origin.x+lastStop.size.width/2,
                                             lastStop.origin.y+lastStop.size.height/2);
    
    
    CABasicAnimation *currentViewAnimation =[CABasicAnimation animationWithKeyPath:@"position"];
    CABasicAnimation *lastViewAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    currentViewAnimation.duration=.5;
    lastViewAnimation.duration=.5;
    currentViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    lastViewAnimation .timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    currentViewAnimation.fromValue=[NSValue valueWithCGPoint:currentAnimPositionStart];
    lastViewAnimation.fromValue=[NSValue valueWithCGPoint:lastAnimPositionStart];
    currentViewAnimation.toValue=[NSValue valueWithCGPoint:currentAnimPositionStop];
    lastViewAnimation.toValue=[NSValue valueWithCGPoint:lastAnimPositionStop];
    [currentView.view.layer addAnimation:currentViewAnimation forKey:@"position"];
    [lastView.view.layer addAnimation:lastViewAnimation forKey:@"position"];
    
    
    currentView.view.frame=currentStop;
    lastView.view.frame=lastStop;
}

-(void) moveDownButtonPressed:(stringFieldViewController *)field
{
    NSDictionary *current=Nil, *last=Nil;
    stringFieldViewController *currentView=nil, *lastView=nil;
    int index;
    for (int i=0; i<[fieldViews count]; i++) {
        last=current;
        lastView=currentView;
        current=[fieldViews objectAtIndex:i];
        currentView=[current objectForKey:@"fieldVC"];
        if (lastView==field) {
            index=i;
            i=[fieldViews count];
        }
        else if(i==[fieldViews count]-1)
            return;
    }
    [fieldViews removeObject:last];
    [fieldViews insertObject:last atIndex:index];
    
    //as documented http://developer.apple.com/library/mac/#qa/qa1620/_index.html
    
    CGRect currentStart=currentView.view.frame, lastStart=lastView.view.frame;
    CGRect currentStop=CGRectMake(lastView.view.frame.origin.x,
                                  lastView.view.frame.origin.y,
                                  currentView.view.frame.size.width,
                                  currentView.view.frame.size.height);
    CGRect lastStop=CGRectMake(lastView.view.frame.origin.x,
                               lastView.view.frame.origin.y+10+([[current valueForKey:@"height"] floatValue]),
                               lastView.view.frame.size.width,
                               lastView.view.frame.size.height);
    
    CGPoint currentAnimPositionStart=CGPointMake(currentStart.origin.x+currentStart.size.width/2,
                                                 currentStart.origin.y+currentStart.size.height/2);
    CGPoint lastAnimPositionStart=CGPointMake(lastStart.origin.x+lastStart.size.width/2,
                                                 lastStart.origin.y+lastStart.size.height/2);
    
    CGPoint currentAnimPositionStop=CGPointMake(currentStop.origin.x+currentStart.size.width/2,
                                                 currentStop.origin.y+currentStart.size.height/2);
    CGPoint lastAnimPositionStop=CGPointMake(lastStop.origin.x+lastStop.size.width/2,
                                              lastStop.origin.y+lastStop.size.height/2);
    
    CABasicAnimation *currentViewAnimation =[CABasicAnimation animationWithKeyPath:@"position"];
    CABasicAnimation *lastViewAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    currentViewAnimation.duration=.5;
    lastViewAnimation.duration=.5;
    currentViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    lastViewAnimation .timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    currentViewAnimation.fromValue=[NSValue valueWithCGPoint:currentAnimPositionStart];
    lastViewAnimation.fromValue=[NSValue valueWithCGPoint:lastAnimPositionStart];
    currentViewAnimation.toValue=[NSValue valueWithCGPoint:currentAnimPositionStop];
    lastViewAnimation.toValue=[NSValue valueWithCGPoint:lastAnimPositionStop];
    [currentView.view.layer addAnimation:currentViewAnimation forKey:@"position"];
    [lastView.view.layer addAnimation:lastViewAnimation forKey:@"position"];
    
    /*CABasicAnimation *frameAnimation = [CABasicAnimation animation];
    frameAnimation.duration = 2.5;
    frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    currentView.view.layer.actions = [NSDictionary dictionaryWithObjectsAndKeys:frameAnimation, @"frame", nil];
    lastView.view.layer.actions = [NSDictionary dictionaryWithObjectsAndKeys:frameAnimation, @"frame", nil];*/
    
    /*CABasicAnimation *currentViewAnimation =[CABasicAnimation animationWithKeyPath:@"frame"];
    CABasicAnimation *lastViewAnimation=[CABasicAnimation animationWithKeyPath:@"frame"];
    
    currentViewAnimation.duration=1;
    lastViewAnimation.duration=1;
    currentViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    lastViewAnimation .timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    currentViewAnimation.fromValue=[NSValue valueWithCGRect:currentStart];
    lastViewAnimation.fromValue=[NSValue valueWithCGRect:lastStart];
    currentViewAnimation.toValue=[NSValue valueWithCGRect:currentStop];
    lastViewAnimation.toValue=[NSValue valueWithCGRect:lastStop];*/
    
    
    //[currentView.view.layer addAnimation:currentViewAnimation forKey:@"frame"];
    //[lastView.view.layer addAnimation:lastViewAnimation forKey:@"frame"];
    
    
    currentView.view.frame=currentStop
    /*CGRectMake(lastView.view.frame.origin.x,
                                      lastView.view.frame.origin.y,
                                      currentView.view.frame.size.width,
                                      currentView.view.frame.size.height)*/;
    
    
    lastView.view.frame=lastStop
    /*CGRectMake(lastView.view.frame.origin.x,
                                   lastView.view.frame.origin.y+10+([[current valueForKey:@"height"] floatValue]),
                                   lastView.view.frame.size.width,
                                   lastView.view.frame.size.height)*/;
     
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
