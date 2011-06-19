//
//  FormGeoSignature.h
//  FormNinja
//
//  Created by Hackenslacker on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GeoSignatureElement.h"

@interface FormGeoSignatureElement : GeoSignatureElement {
    IBOutlet UIButton *mapButton;
}

@property (nonatomic, retain) UIButton *mapButton;


-(void)setFinished;
- (IBAction) viewSigButtonAction;

@end
