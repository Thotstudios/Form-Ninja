//
//  stringFieldViewController.h
//  FormNinja
//
//  Created by Programmer on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class stringFieldViewController;
@protocol stringFieldViewControllerDelegate <NSObject>
@required

-(void) removeButtonPressed:(stringFieldViewController *)field;
-(void) moveUpButtonPressed:(stringFieldViewController *)field;
-(void) moveDownButtonPressed:(stringFieldViewController *)field;
-(void) changeButtonPressed:(stringFieldViewController *)field;
-(BOOL) textFieldShouldReturn:(UITextField *) textField fromStringField:(stringFieldViewController *) self;

/*- (BOOL)foo:(Foo *)foo willDoSomethingAnimated:(BOOL)flag;
- (void)foo:(Foo *)foo didDoSomethingAnimated:(BOOL)flag;*/
@end

@interface stringFieldViewController : UIViewController <UITextFieldDelegate> {
    id <stringFieldViewControllerDelegate> delegate;
    IBOutlet UISlider *minLengthSlider, *maxLengthSlider;
    IBOutlet UILabel *minLengthLabel, *maxLengthLabel;
    IBOutlet UITextField *fieldNameTextField;
    
}

@property (nonatomic, retain) IBOutlet UISlider *minLengthSlider, *maxLengthSlider;
@property (nonatomic, retain) IBOutlet UILabel *minLengthLabel, *maxLengthLabel;
@property (nonatomic, retain) IBOutlet UITextField *fieldNameTextField;
@property (nonatomic, assign) id <stringFieldViewControllerDelegate> delegate;

-(void)setByDictionary:(NSDictionary *) aDictionary;
-(NSDictionary *) dictionaryValue;

//UI functionality
-(IBAction) changeTypeButtonPressed;
-(IBAction) removeButtonPressed;
-(IBAction) moveUpButtonPressed;
-(IBAction) moveDownButtonPressed;
-(IBAction) sliderUpdated:(UISlider *)theSlider;

@end
