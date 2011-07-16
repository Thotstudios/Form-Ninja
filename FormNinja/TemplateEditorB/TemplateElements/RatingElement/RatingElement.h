//
//  RatingElement.h
//  FormNinja
//
//  Created by Hackenslacker on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface RatingElement : TemplateElement {
    
	UISegmentedControl *ratingSegControl;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *ratingSegControl;
- (IBAction)ratingChanged;

@end
