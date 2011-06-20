//
//  FormMultiLineElement.h
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiLineElement.h"

@interface FormMultiLineElement : MultiLineElement {
    
}

-(void)setFinished;

@property (nonatomic, retain) IBOutlet UILabel *minLabel, *maxLabel, *curLabel;

@end
