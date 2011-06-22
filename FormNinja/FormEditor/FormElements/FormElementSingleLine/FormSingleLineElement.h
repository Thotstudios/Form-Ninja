//
//  FormSingleLineElement.h
//  FormNinja
//
//  Created by Ron Lugge on 6/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleLineElement.h"

@interface FormSingleLineElement : SingleLineElement <UITextFieldDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UILabel *curLength;
@property (nonatomic, retain) IBOutlet UILabel *maxLength;
@property (nonatomic, retain) IBOutlet UILabel *minLength;

@end
