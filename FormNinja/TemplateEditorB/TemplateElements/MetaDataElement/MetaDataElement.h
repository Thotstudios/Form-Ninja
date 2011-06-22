//
//  MetaDataElement.h
//  Dev
//
//  Created by Chad Hatcher on 5/25/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface MetaDataElement : TemplateElement <UITextFieldDelegate>
{
	UITextField *templateNameField;
	UITextField *templateGroupField;
	UITextField *creatorNameField;
	UITextField *creationDateField;
	UISwitch *publishedSwitch;
}
@property (nonatomic, retain) IBOutlet UITextField *templateNameField;
@property (nonatomic, retain) IBOutlet UITextField *templateGroupField;
@property (nonatomic, retain) IBOutlet UITextField *creatorNameField;
@property (nonatomic, retain) IBOutlet UITextField *creationDateField;
@property (nonatomic, retain) IBOutlet UISwitch *publishedSwitch;

-(IBAction) togglePublished;

@end
