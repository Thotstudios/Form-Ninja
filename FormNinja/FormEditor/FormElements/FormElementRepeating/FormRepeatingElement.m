//
//  FormRepeatingElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormRepeatingElement.h"


@implementation FormRepeatingElement


#pragma mark - View lifecycle


-(void)setFinished
{
    [self.dictionary setValue:@"yes" forKey:@"finished"];
}

@end
