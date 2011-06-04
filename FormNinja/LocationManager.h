//
//  LocationManager.h
//  FormNinja
//
//  Created by Ollin on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationManager : NSObject <CLLocationManagerDelegate>{
    CLLocationManager* locationManager;
    
    BOOL locationDefined;
    BOOL locationDenied;

	float latitude;
	float longitude;
}

@property (readonly, nonatomic) float latitude, longitude;
@property (readonly, nonatomic) BOOL locationDefined, locationDenied;


+ (LocationManager*)locationManager;

- (void) startUpdates;
- (void) stopUpdates;
- (BOOL) locationServicesEnabled;
- (BOOL) hasValidLocation;

@end
