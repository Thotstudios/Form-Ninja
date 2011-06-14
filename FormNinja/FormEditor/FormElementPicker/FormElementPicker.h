//
//  FormElementPicker.h
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementPicker.h"
#import "FormTemplateElement.h"

@interface FormElementPicker : ElementPicker {
    
}

+(FormTemplateElement*) formElementOfType:(NSString *)type;

@end
