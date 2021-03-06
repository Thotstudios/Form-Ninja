//
//  TextFieldAlert.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/27/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldAlert : UIAlertView <UITextFieldDelegate>
{
	UIDeviceOrientation orientation;
	UITextField * textField;
    id callback;
	SEL selector;
	
	float textFieldHeight;
	float textFieldWidth;
	
	CGRect portraitFrame;
	CGRect landscapeFrame;
}
@property (nonatomic, retain) UITextField * textField;
@property (nonatomic, retain) id callback;
@property SEL selector;

-(id) initWithTitle:(NSString*)title delegate:(id)delegateArg selector:(SEL)selectorArg;

+(void) showWithTitle:(NSString*)title delegate:(id)delegateArg selector:(SEL)selectorArg;

@end
