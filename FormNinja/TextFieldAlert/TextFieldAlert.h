//
//  TextFieldAlert.h
//  FormNinja
//
//  Created by Hackenslacker on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
}
@property (nonatomic, retain) UITextField * textField;
@property (nonatomic, retain) id callback;
@property SEL selector;

-(id) initWithTitle:(NSString*)title delegate:(id)delegateArg selector:(SEL)selectorArg;

+(void) showWithTitle:(NSString*)title delegate:(id)delegateArg selector:(SEL)selectorArg;

@end
