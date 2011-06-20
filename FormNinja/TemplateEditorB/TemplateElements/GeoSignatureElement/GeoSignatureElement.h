//
//  GeoSignatureElement.h
//  FormNinja
//
//  Created by Hackenslacker on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignatureElement.h"

@interface GeoSignatureElement : SignatureElement
{
    
UILabel *gpsLabel;
UISwitch *gpsSwitch;
}

@property (nonatomic, retain) IBOutlet UILabel *gpsLabel;
@property (nonatomic, retain) IBOutlet UISwitch *gpsSwitch;


- (IBAction)toggleAllowGps;
- (void) fixGpsLabel;

@end
