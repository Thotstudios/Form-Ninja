//
//  RepeatingElement.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/29/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface RepeatingElement : TemplateElement
{
    
	UITextField *repeatLimitField;
}
@property (nonatomic, retain) IBOutlet UITextField *repeatLimitField;
- (IBAction)addElement;

@end
