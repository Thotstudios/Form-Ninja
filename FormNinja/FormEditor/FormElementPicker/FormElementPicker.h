//
//  FormElementPicker.h
//  FormNinja
//
//  Created by Ron Lugge on 6/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementPicker.h"
#import "FormTemplateElement.h"

@interface FormElementPicker : ElementPicker {
    
}

+(FormTemplateElement*) formElementOfType:(NSString *)type delegate:(id)delegate;

@end
