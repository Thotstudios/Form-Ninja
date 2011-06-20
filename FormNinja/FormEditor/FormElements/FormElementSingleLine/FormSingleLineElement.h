//
//  FormSingleLineElement.h
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleLineElement.h"

@interface FormSingleLineElement : SingleLineElement <UITextFieldDelegate> {
    
}

-(void)setFinished;

@property (nonatomic, retain) IBOutlet UILabel *curLength;
@property (nonatomic, retain) IBOutlet UILabel *maxLength;
@property (nonatomic, retain) IBOutlet UILabel *minLength;

@end
