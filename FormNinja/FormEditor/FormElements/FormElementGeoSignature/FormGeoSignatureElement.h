//
//  FormGeoSignature.h
//  FormNinja
//
//  Created by Chad Hatcher on 6/18/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GeoSignatureElement.h"

@interface FormGeoSignatureElement : GeoSignatureElement
{
    IBOutlet UIButton *mapButton;
}

@property (nonatomic, retain) UIButton *mapButton;

- (IBAction) viewSigButtonAction;

@end
