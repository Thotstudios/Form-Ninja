//
//  AddressElement.h
//  Dev
//
//  Created by Hackenslacker on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface AddressElement : TemplateElement <UITextFieldDelegate>
{
	UITextField *addressLineOneField;
	UITextField *addressLineTwoField;
	UITextField *cityNameField;
	UITextField *stateAbbrField;
	UITextField *zipCodeField;
}
@property (nonatomic, retain) IBOutlet UITextField *addressLineOneField;
@property (nonatomic, retain) IBOutlet UITextField *addressLineTwoField;
@property (nonatomic, retain) IBOutlet UITextField *cityNameField;
@property (nonatomic, retain) IBOutlet UITextField *stateAbbrField;
@property (nonatomic, retain) IBOutlet UITextField *zipCodeField;

@end
