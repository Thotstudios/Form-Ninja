//
//  TemplateEditorViewController.m
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateEditorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "parentFieldViewController.h"
#import "JSON.h"
#import "AccountClass.h"
#import "Constants.h"


@implementation TemplateEditorViewController
@synthesize scrollView;
@synthesize templateData, groupViews;
@synthesize labelField;
@synthesize templateControlView;
@synthesize dictValue;
@synthesize testDict;

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
    self.groupViews=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize=CGSizeMake(768, 88+77);
    if(dictValue!=nil)
    {
        labelField.text=[dictValue valueForKey:@"templateLabel"];
        for (NSDictionary *curGroup in [dictValue valueForKey:@"templateGroups"]) {
            templateGroupViewController *newVC=[[templateGroupViewController alloc] initWithNibName:@"templateGroupViewController" bundle:[NSBundle mainBundle]];
            [newVC setByDictionary:curGroup];
            [groupViews addObject: newVC];
            [self.view addSubview:newVC.view];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Keyboard control functions

//Need to worry about scroll positioning; HOW?!
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

#pragma mark - load and save data


-(void)setByDictionary:(NSDictionary *) aDictionary
{
    dictValue=aDictionary;
    labelField.text=[aDictionary valueForKey:@"templateLabel"];
    for (NSDictionary *curGroup in [aDictionary valueForKey:@"templateGroups"]) {
        templateGroupViewController *newVC=[[templateGroupViewController alloc] initWithNibName:@"templateGroupViewController" bundle:[NSBundle mainBundle]];
        [newVC setByDictionary:curGroup];
        [groupViews addObject: newVC];
        [self.view addSubview:newVC.view];
        [newVC release];
    }
    [self redoHeights];
}

-(NSDictionary *)getDictionaryValue
{
    NSMutableDictionary *templateDictionary=[NSMutableDictionary dictionary];
    [templateDictionary setValue:labelField.text forKey:@"templateLabel"];
    NSMutableArray *groupArray=[NSMutableArray array];
    for (templateGroupViewController *curGroup in groupViews) {
        [groupArray addObject:[curGroup getDictionaryData]];
    }
    [templateDictionary setValue:groupArray forKey:@"templateGroups"];
    return templateDictionary;
}

#pragma mark - interface

/*
 -(IBAction)newFieldButtonTouched
 {
 float newPosition=self.addFieldButton.frame.origin.y;
 NSMutableDictionary *newFieldDictionary;
 newFieldDictionary=[[NSMutableDictionary alloc] init];
 [newFieldDictionary setObject:@"string" forKey:@"type"];
 
 
 
 stringFieldViewController *newVC=[[stringFieldViewController alloc] initWithNibName:@"stringFieldViewController" bundle:[NSBundle mainBundle]];
 float newHeight=newVC.view.layer.bounds.size.height;
 [newFieldDictionary setObject:[NSNumber numberWithFloat:newHeight] forKey:@"height"];
 [newFieldDictionary setObject:newVC forKey:@"fieldVC"];
 
 
 
 
 //Generate animation positions for add field button and relocate it
 CGPoint addFieldButtonStartPosition=CGPointMake(self.addFieldButton.frame.origin.x+self.addFieldButton.frame.size.width/2,
 self.addFieldButton.frame.origin.y+self.addFieldButton.frame.size.height/2);
 
 self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
 self.addFieldButton.frame.origin.y+newHeight+10, 
 self.addFieldButton.frame.size.width,  
 self.addFieldButton.frame.size.height);
 
 CGPoint addFieldButtonStopPosition=CGPointMake(self.addFieldButton.frame.origin.x+self.addFieldButton.frame.size.width/2,
 self.addFieldButton.frame.origin.y+self.addFieldButton.frame.size.height/2);
 
 
 //generate animation positions for delete button and relocate it
 CGPoint deleteButtonStartPosition=CGPointMake(self.deleteButton.frame.origin.x+self.deleteButton.frame.size.width/2,
 self.deleteButton.frame.origin.y+self.deleteButton.frame.size.height/2);
 
 self.deleteButton.frame=CGRectMake(self.deleteButton.frame.origin.x,
 self.deleteButton.frame.origin.y+newHeight+10, 
 self.deleteButton.frame.size.width,  
 self.deleteButton.frame.size.height);
 
 CGPoint deleteButtonStopPosition=CGPointMake(self.deleteButton.frame.origin.x+self.deleteButton.frame.size.width/2,
 self.deleteButton.frame.origin.y+self.deleteButton.frame.size.height/2);
 
 
 //generate animation positions for publish button and relocate it
 CGPoint publishButtonStartPosition=CGPointMake(self.publishButton.frame.origin.x+self.publishButton.frame.size.width/2,
 self.publishButton.frame.origin.y+self.publishButton.frame.size.height/2);
 
 self.publishButton.frame=CGRectMake(self.publishButton.frame.origin.x,
 self.publishButton.frame.origin.y+newHeight+10, 
 self.publishButton.frame.size.width,  
 self.publishButton.frame.size.height);
 
 CGPoint publishButtonStopPosition=CGPointMake(self.publishButton.frame.origin.x+self.publishButton.frame.size.width/2,
 self.publishButton.frame.origin.y+self.publishButton.frame.size.height/2);
 
 
 //generate animation positions for save button and relocate it
 CGPoint saveButtonStartPosition=CGPointMake(self.saveButton.frame.origin.x+self.saveButton.frame.size.width/2,
 self.saveButton.frame.origin.y+self.saveButton.frame.size.height/2);
 
 self.saveButton.frame=CGRectMake(self.saveButton.frame.origin.x,
 self.saveButton.frame.origin.y+newHeight+10, 
 self.saveButton.frame.size.width,  
 self.saveButton.frame.size.height);
 
 CGPoint saveButtonStopPosition=CGPointMake(self.saveButton.frame.origin.x+self.saveButton.frame.size.width/2,
 self.saveButton.frame.origin.y+self.saveButton.frame.size.height/2);
 
 
 
 
 
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
 CABasicAnimation *moveAddFieldButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 CABasicAnimation *saveButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 CABasicAnimation *deleteButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 CABasicAnimation *publishButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 
 newFieldAnimation.duration=.5;
 moveAddFieldButtonAnimation.duration=.50;
 saveButtonAnimation.duration=.50;
 deleteButtonAnimation.duration=.50;
 publishButtonAnimation.duration=.50;
 newFieldAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
 moveAddFieldButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 saveButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 deleteButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 publishButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 newFieldAnimation.fromValue=[NSNumber numberWithFloat:0];
 moveAddFieldButtonAnimation.fromValue=[NSValue valueWithCGPoint:addFieldButtonStartPosition];
 saveButtonAnimation.fromValue=[NSValue valueWithCGPoint:saveButtonStartPosition];
 deleteButtonAnimation.fromValue=[NSValue valueWithCGPoint:deleteButtonStartPosition];
 publishButtonAnimation.fromValue=[NSValue valueWithCGPoint:publishButtonStartPosition];
 newFieldAnimation.toValue=[NSNumber numberWithFloat:1];
 moveAddFieldButtonAnimation.toValue=[NSValue valueWithCGPoint:addFieldButtonStopPosition];
 saveButtonAnimation.toValue=[NSValue valueWithCGPoint:saveButtonStopPosition];
 deleteButtonAnimation.toValue=[NSValue valueWithCGPoint:deleteButtonStopPosition];
 publishButtonAnimation.toValue=[NSValue valueWithCGPoint:publishButtonStopPosition];
 
 [addFieldButton.layer addAnimation:moveAddFieldButtonAnimation forKey:@"position"];
 [deleteButton.layer addAnimation:deleteButtonAnimation forKey:@"position"];
 [saveButton.layer addAnimation:saveButtonAnimation forKey:@"position"];
 [publishButton.layer addAnimation:publishButtonAnimation forKey:@"position"];
 [newVC.view.layer addAnimation:newFieldAnimation forKey:@"opacity"];
 
 
 
 
 
 //NSMutableDictionary *newField=[[NSMutableDictionary alloc] init];
 //[self.templateData addObject:newField];
 //[newField setObject:[NSNumber numberWithFloat:728] forKey:@"height"];
 //[newField setObject:@"stringField" forKey:@"type"];
 
 //CGRect myRect=CGRectMake(20, 88, [(NSNumber*)[newField objectForKey:@"height"] floatValue], 134);
 
 //stringFieldViewController *aCont=[[stringFieldViewController alloc] initWithNibName:@"stringFieldViewController" bundle:[NSBundle mainBundle]];
 //aCont.view.frame=myRect;
 //[scrollView addSubview:aCont.view];
 
 
 
 }*/

-(IBAction) newGroupButtonTouched
{
    //float newPosition=self.templateControlView.frame.origin.y;
    //NSMutableDictionary
    
    float newPosition=self.templateControlView.layer.frame.origin.y;
    templateGroupViewController *newGroupView=[[templateGroupViewController alloc] initWithNibName:@"templateGroupViewController" bundle:[NSBundle mainBundle]];
    newGroupView.delegate=self;
    newGroupView.view.frame=CGRectMake(20, 
                                       newPosition, 
                                       self.view.frame.size.width-40,
                                       122);
    [groupViews addObject:newGroupView];
    [self.scrollView addSubview:newGroupView.view];
    self.templateControlView.frame=CGRectMake(self.templateControlView.layer.frame.origin.x, 
                                              newGroupView.view.layer.frame.origin.y+newGroupView.view.layer.frame.size.height+10, 
                                              self.templateControlView.frame.size.width,
                                              self.templateControlView.frame.size.height);
    scrollView.contentSize=CGSizeMake(scrollView.contentSize.width,
                                      self.templateControlView.frame.origin.y+self.templateControlView.frame.size.height+20);
}


-(IBAction) deleteButtonPressed
{
    NSLog(@"delete button pressed");
    for (templateGroupViewController *curGroup in [groupViews copy]) {
        [self removeGroupButtonPressed:curGroup];
    }
    [self setByDictionary:testDict];
}

-(IBAction) saveButtonPressed
{
    NSLog(@"save button pressed");
    self.testDict=[self getDictionaryValue];
}

-(IBAction) publishButtonPressed
{
    
}

#pragma mark - Own delegate functions


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Template Field Delegate Functions
/*
 -(void) removeButtonPressed:(stringFieldViewController *)field
 {
 
 CABasicAnimation *moveAddFieldButtonAnimation, *moveDeleteButtonAnimation, *movePublishButtonAnimation, *moveSaveButtonAnimation, *moveViewAnimation;
 CGPoint moveStart, moveStop, moveAddFieldButtonStart, moveAddFieldButtonStop, moveDeleteButtonStart, moveDeleteButtonStop, movePublishButtonStart, movePublishButtonStop, moveSaveButtonStart, moveSaveButtonStop;
 CGRect oldFrame;
 
 NSDictionary *current;
 int currentIndex;
 for (int i=0; i<[groupViews count]; i++) {
 current=[fieldViews objectAtIndex:i];
 if([current valueForKey:@"fieldVC"]==field)
 {
 [groupViews removeObject:current];
 
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
 
 
 //create move animation points for addFieldButton and move it
 moveAddFieldButtonStart=CGPointMake(addFieldButton.frame.origin.x+addFieldButton.frame.size.width/2,
 addFieldButton.frame.origin.y+addFieldButton.frame.size.height/2);
 
 self.addFieldButton.frame=CGRectMake(self.addFieldButton.frame.origin.x,
 newPosition+10, 
 self.addFieldButton.frame.size.width,  
 self.addFieldButton.frame.size.height);
 
 moveAddFieldButtonStop=CGPointMake(addFieldButton.frame.origin.x+addFieldButton.frame.size.width/2,
 addFieldButton.frame.origin.y+addFieldButton.frame.size.height/2);
 
 //create move animation points for deleteButton and move it
 moveDeleteButtonStart=CGPointMake(deleteButton.frame.origin.x+deleteButton.frame.size.width/2,
 deleteButton.frame.origin.y+deleteButton.frame.size.height/2);
 
 self.deleteButton.frame=CGRectMake(self.deleteButton.frame.origin.x,
 newPosition+10, 
 self.deleteButton.frame.size.width,  
 self.deleteButton.frame.size.height);
 
 moveDeleteButtonStop=CGPointMake(deleteButton.frame.origin.x+deleteButton.frame.size.width/2,
 deleteButton.frame.origin.y+deleteButton.frame.size.height/2);
 
 //create move animation points for addFieldButton and move it
 moveSaveButtonStart=CGPointMake(saveButton.frame.origin.x+saveButton.frame.size.width/2,
 saveButton.frame.origin.y+saveButton.frame.size.height/2);
 
 self.saveButton.frame=CGRectMake(self.saveButton.frame.origin.x,
 newPosition+10, 
 self.saveButton.frame.size.width,  
 self.saveButton.frame.size.height);
 
 moveSaveButtonStop=CGPointMake(saveButton.frame.origin.x+saveButton.frame.size.width/2,
 saveButton.frame.origin.y+saveButton.frame.size.height/2);
 
 //create move animation points for publishButton and move it
 movePublishButtonStart=CGPointMake(publishButton.frame.origin.x+publishButton.frame.size.width/2,
 publishButton.frame.origin.y+publishButton.frame.size.height/2);
 
 self.publishButton.frame=CGRectMake(self.publishButton.frame.origin.x,
 newPosition+10, 
 self.publishButton.frame.size.width,  
 self.publishButton.frame.size.height);
 
 movePublishButtonStop=CGPointMake(publishButton.frame.origin.x+publishButton.frame.size.width/2,
 publishButton.frame.origin.y+publishButton.frame.size.height/2);
 
 
 
 moveAddFieldButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 moveSaveButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 moveDeleteButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 movePublishButtonAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
 
 moveAddFieldButtonAnimation.duration=.50;
 moveSaveButtonAnimation.duration=.50;
 moveDeleteButtonAnimation.duration=.50;
 movePublishButtonAnimation.duration=.50;
 
 moveAddFieldButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 moveSaveButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 moveDeleteButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 movePublishButtonAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 
 moveAddFieldButtonAnimation.fromValue=[NSValue valueWithCGPoint:moveAddFieldButtonStart];
 moveSaveButtonAnimation.fromValue=[NSValue valueWithCGPoint:moveSaveButtonStart];
 moveDeleteButtonAnimation.fromValue=[NSValue valueWithCGPoint:moveDeleteButtonStart];
 movePublishButtonAnimation.fromValue=[NSValue valueWithCGPoint:movePublishButtonStart];
 
 moveAddFieldButtonAnimation.toValue=[NSValue valueWithCGPoint:moveAddFieldButtonStop];
 moveSaveButtonAnimation.toValue=[NSValue valueWithCGPoint:moveSaveButtonStop];
 moveDeleteButtonAnimation.toValue=[NSValue valueWithCGPoint:moveDeleteButtonStop];
 movePublishButtonAnimation.toValue=[NSValue valueWithCGPoint:movePublishButtonStop];
 
 [addFieldButton.layer addAnimation:moveAddFieldButtonAnimation forKey:@"position"];
 [deleteButton.layer addAnimation:moveDeleteButtonAnimation forKey:@"position"];
 [saveButton.layer addAnimation:moveSaveButtonAnimation forKey:@"position"];
 [publishButton.layer addAnimation:movePublishButtonAnimation forKey:@"position"];
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
 lastViewAnimation.toValue=[NSValue valueWithCGRect:lastStop];*//*
                                                                 
                                                                 
                                                                 //[currentView.view.layer addAnimation:currentViewAnimation forKey:@"frame"];
                                                                 //[lastView.view.layer addAnimation:lastViewAnimation forKey:@"frame"];
                                                                 
                                                                 
                                                                 currentView.view.frame=currentStop
                                                                 /*CGRectMake(lastView.view.frame.origin.x,
                                                                 lastView.view.frame.origin.y,
                                                                 currentView.view.frame.size.width,
                                                                 currentView.view.frame.size.height)*//*;
                                                                                                       
                                                                                                       
                                                                                                       lastView.view.frame=lastStop
                                                                                                       /*CGRectMake(lastView.view.frame.origin.x,
                                                                                                       lastView.view.frame.origin.y+10+([[current valueForKey:@"height"] floatValue]),
                                                                                                       lastView.view.frame.size.width,
                                                                                                       lastView.view.frame.size.height)*//*;
                                                                                                                                          
                                                                                                                                          }*/

/*-(BOOL) textFieldShouldReturn:(UITextField *) textField fromStringField:(parentFieldViewController *) field
 {
 [textField resignFirstResponder];
 return YES;
 }*/

#pragma mark - Graphics Functions

-(CGPoint) generateAnimationPositionFromFrame:(CGRect) frame
{
    return CGPointMake(frame.origin.y+frame.size.width/2,
                       frame.origin.x+frame.size.height/2);
}

-(void) redoHeights
{
    float curHeight=88;
    for (templateGroupViewController *currentGroup in groupViews) {
        currentGroup.view.frame=CGRectMake(currentGroup.view.frame.origin.x,
                                           curHeight,
                                           currentGroup.view.frame.size.width,
                                           currentGroup.view.frame.size.height);
        curHeight=curHeight+10+currentGroup.view.frame.size.height;
    }
    templateControlView.frame=CGRectMake(templateControlView.frame.origin.x, 
                                         curHeight, 
                                         templateControlView.frame.size.width, 
                                         templateControlView.frame.size.height);
    scrollView.contentSize=CGSizeMake(scrollView.contentSize.width, templateControlView.frame.size.height+curHeight+10);
}

#pragma mark - Group Delegate Functions

-(void) removeGroupButtonPressed:(templateGroupViewController *)group
{
    [group.view removeFromSuperview];
    [groupViews removeObject:group];
    [self redoHeights];
}
-(void) addGroupButtonPressed:(templateGroupViewController *)group
{
    
}
-(void) moveGroupUpButtonPressed:(templateGroupViewController *)group
{
    
}
-(void) moveGroupDownButtonPressed:(templateGroupViewController *)group
{
    
}
-(void) changedHeightForGroup:(templateGroupViewController *) group
{
    [self redoHeights];
}

@end
