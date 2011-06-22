//
//  PopOverManager.h
//  FormNinja
//
//  Created by Paul Salazar on 6/12/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormNinjaAppDelegate.h"
#import "MainMenu.h"


@protocol PopOverManagerDelegate;


@interface PopOverManager : NSObject <UIPopoverControllerDelegate>{
    UIPopoverController *currentPopoverController;
    BOOL permitCurrentPopoverControllerToDismiss;
    FormNinjaAppDelegate *appDelegate;
    MainMenu *mainMenu;
    
    //Implementing delegate is optional but required for vc specific functionality
    id <PopOverManagerDelegate> delegate;
}

@property (nonatomic, retain) UIPopoverController *currentPopoverController;
@property (nonatomic, assign) BOOL permitCurrentPopoverControllerToDismiss;
@property (nonatomic, retain) FormNinjaAppDelegate *appDelegate;
@property (nonatomic, retain) MainMenu *mainMenu;
@property (nonatomic, assign) id delegate;

+ (id)sharedManager;

- (void) createMenuPopOver:(int) type fromButton:(id) button;

- (void)presentPopoverController:(UIPopoverController *)pc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
- (void)presentPopoverController:(UIPopoverController *)pc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void)presentControllerInPopoverController:(UIViewController *)vc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
- (void)presentControllerInPopoverController:(UIViewController *)vc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void)dismissCurrentPopoverController:(BOOL)animated;
- (void)dismissCurrentPopoverController:(BOOL)animated withSelectedOption:(int) selectedOption;

@end


//Delegate to perform view specific actions
@protocol PopOverManagerDelegate <NSObject>

@optional - (void) emailForm;
@optional - (void) airPrintForm;


@end