//
//  parentFieldViewController.h
//  FormNinja
//
//  Created by Programmer on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class parentFieldViewController;
@protocol parentFieldViewControllerDelegate <NSObject>
@required

-(void) removeFieldButtonPressed:(parentFieldViewController *)field;
-(void) addFieldButtonPressed:(parentFieldViewController *)field;
-(void) moveFieldUpButtonPressed:(parentFieldViewController *)field;
-(void) moveFieldDownButtonPressed:(parentFieldViewController *)field;

/*- (BOOL)foo:(Foo *)foo willDoSomethingAnimated:(BOOL)flag;
 - (void)foo:(Foo *)foo didDoSomethingAnimated:(BOOL)flag;*/
@end


@interface parentFieldViewController : UIViewController {
    
}

@property (nonatomic, assign) id delegate;

-(parentFieldViewController *) allocFieldFromDic:(NSDictionary*) aDic;


-(IBAction) removeButtonPressed;
-(IBAction) addButtonPressed;
-(IBAction) moveUpButtonPressed;
-(IBAction) moveDownButtonPressed;

@end
