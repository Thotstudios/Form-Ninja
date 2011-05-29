//
//  RepeatingElement.h
//  FormNinja
//
//  Created by Hackenslacker on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
