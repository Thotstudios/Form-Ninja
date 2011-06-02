//
//  LocationManager.m
//  FormNinja
//
//  Created by Ollin on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"


//Private methods
@interface LocationManager()

//Make setters usable inside implementation
@property(readwrite, nonatomic) float latitude, longitude;
@property(readwrite, nonatomic) BOOL locationDefined, locationDenied;

- (void) reset;

@end


static LocationManager *globalLocationManager = nil; //Singleton location manager
static BOOL initialized = NO; //Indicates location manager initialization


@implementation LocationManager


@synthesize latitude, longitude, locationDenied, locationDefined;


#pragma mark - Class Methods

//Singleton accessor
+ (LocationManager*)locationManager
{
	@synchronized(self)
	{
		if (!globalLocationManager)
            globalLocationManager = [[LocationManager alloc] init];
	}
    
    return globalLocationManager;
}



#pragma mark Instance Methods

- (id) init
{
	if(initialized)
		return globalLocationManager;
	
	self = [super init];
    if (!self)
	{
		if(globalLocationManager)
			[globalLocationManager release];
		return nil;
	}
    
	
	locationManager = nil;
	initialized = YES;
	self.locationDenied = NO;
	[self reset];
    return self;
}


//Resets class variables
- (void) reset
{
	self.locationDefined = NO;
	self.latitude = 0.f;
	self.longitude = 0.f;
}


//Stops location updates
- (void) stopUpdates
{
	if (locationManager)
	{
		[locationManager stopUpdatingLocation];
	}
    
	[self reset];
}


//Checks if locations services are enabled on device
- (BOOL) locationServicesEnabled
{
	return [CLLocationManager locationServicesEnabled];
}


//Checks if there is valid location info to share
- (BOOL) hasValidLocation{
    return  (![self locationDenied] &&  [self locationDefined] && [self locationServicesEnabled]);
}


//Starts location update
- (void) startUpdates
{
	if (locationManager)
	{
		[locationManager stopUpdatingLocation];
	}
    
	else
	{
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.distanceFilter = 100;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	
	self.locationDefined = NO; //We still do not have a initial location
	[locationManager startUpdatingLocation];
}



#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation  fromLocation:(CLLocation *)oldLocation
{
	self.locationDenied = NO; //We are not being denied services from the user or elsewhere
    
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
    self.locationDefined = YES; //Initial location defined
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[self reset];
    
    if ([error domain] == kCLErrorDomain) 
	{
        switch ([error code]) 
		{
            case kCLErrorDenied: //App denied location services by user
				locationDenied = YES;
				[self stopUpdates];
                break;
                
            case kCLErrorLocationUnknown:
                break;
                
            default:
                break;
        }
	}	
}



#pragma mark - Dealloc

-(void)dealloc
{
	if(locationManager)
		[locationManager release];
    
	[super dealloc];
}

@end
