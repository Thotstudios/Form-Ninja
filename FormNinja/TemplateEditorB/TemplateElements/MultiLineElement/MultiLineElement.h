//
//  MultiLineElement.h
//  Dev
//
//  Created by Hackenslacker on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface MultiLineElement : TemplateElement <UITextFieldDelegate, UITextViewDelegate>
{
	UITextView *valueField;
	UITextField *minimumLengthField;
	UITextField *maximumLengthField;
}

@property (nonatomic, retain) IBOutlet UITextView *valueField;
@property (nonatomic, retain) IBOutlet UITextField *minimumLengthField;
@property (nonatomic, retain) IBOutlet UITextField *maximumLengthField;

@end
