//
//  SingleLineElement.h
//  Dev
//
//  Created by Chad Hatcher on 5/22/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface SingleLineElement : TemplateElement <UITextFieldDelegate>
{
	UITextField *valueField;
	UITextField *minimumLengthField;
	UITextField *maximumLengthField;
}

@property (nonatomic, retain) IBOutlet UITextField *valueField;
@property (nonatomic, retain) IBOutlet UITextField *minimumLengthField;
@property (nonatomic, retain) IBOutlet UITextField *maximumLengthField;

@end
