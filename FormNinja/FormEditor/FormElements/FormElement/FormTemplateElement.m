//
//  FormTemplateElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormTemplateElement.h"


@implementation FormTemplateElement

#pragma mark - Inherited Methods

#pragma mark - Delegate Methods
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	return allowEditing;
}

-(void)setFinished
{
    [self.dictionary setValue:@"yes" forKey:@"finished"];
}
@end
