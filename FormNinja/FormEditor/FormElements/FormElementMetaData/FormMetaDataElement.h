//
//  FormMetaDataElement.h
//  FormNinja
//
//  Created by Ron Lugge on 6/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaDataElement.h"

@interface FormMetaDataElement : MetaDataElement {
    
	UITextField *formAgentField;
	UITextField *formBeginDateField;
	UITextField *formFinalDateField;
	UITextField *formCoordinatesField;
}

@property (nonatomic, retain) IBOutlet UITextField *formAgentField;
@property (nonatomic, retain) IBOutlet UITextField *formBeginDateField;
@property (nonatomic, retain) IBOutlet UITextField *formFinalDateField;
@property (nonatomic, retain) IBOutlet UITextField *formCoordinatesField;

@end
