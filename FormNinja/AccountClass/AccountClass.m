//
//  AccountClass.m
//  FormNinja
//
//  Created by Hackenslacker on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountClass.h"
#import "Constants.h"


@implementation AccountClass

@synthesize userID;
@synthesize username;
@synthesize passwordHash;
@synthesize firstName;
@synthesize lastName;
@synthesize emailAddress;
@synthesize companyName;
@synthesize phoneNumber;
@synthesize securityQuestion;
@synthesize securityAnswer;
@synthesize zipCode;
@synthesize zipCodeExt;


- (void) loadValuesFromFile{
    //Initial values based off current local user info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDict = [defaults dictionaryForKey:userInformation]; //get user info
    
    self.userID = [userDict objectForKey:userIDNumber];
    self.username = [userDict objectForKey:userName];
    self.firstName = [userDict objectForKey:userFirstName];
    self.lastName = [userDict objectForKey:userLastName];
    self.passwordHash = [userDict objectForKey:userPassword];
    self.companyName = [userDict objectForKey:userCompany];
    self.emailAddress = [userDict objectForKey:userEmail];
    self.phoneNumber = [userDict objectForKey:userPhoneNumber];
    self.zipCode = [userDict objectForKey:userZipCode];
    self.zipCodeExt = [userDict objectForKey:userExtendedZip];
}

- init {
    self = [super init];
    
    if (self) {
        [self loadValuesFromFile];
    }
    
    return self;
}


//Singelton accessor
+ (AccountClass *)  sharedAccountClass{
	static AccountClass *sharedAccountClass;
	
	@synchronized(self)
	{
		if (!sharedAccountClass)
			// Does this leak? -Chad
			sharedAccountClass = [[AccountClass alloc] init];
	}
	
	return sharedAccountClass;
}


+ (void) invalidateAccountInformation
{
    //Remove user info locally
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:userInformation];
    [defaults synchronize];
    
    //Invalidate singleton 
    [[self sharedAccountClass] invalidate];
}


- (void) saveWithDict:(NSDictionary *) userDict{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
        
    [saveDict setObject:[userDict objectForKey:userIDNumber] forKey:userIDNumber];
    [saveDict setObject:[userDict objectForKey:userName] forKey:userName];
    [saveDict setObject:[userDict objectForKey:userPassword ] forKey:userPassword];
    [saveDict setObject:[userDict objectForKey:userEmail] forKey:userEmail];
    [saveDict setObject:[userDict objectForKey:userFirstName] forKey:userFirstName];
    [saveDict setObject:[userDict objectForKey:userLastName] forKey:userLastName];
    [saveDict setObject:[userDict objectForKey:userZipCode] forKey:userZipCode];
    
    //Optional values as of now
    if([userDict objectForKey:userCompany])
        [saveDict setObject:[userDict objectForKey:userCompany] forKey:userCompany];
    
    if([userDict objectForKey:userPhoneNumber])
        [saveDict setObject:[userDict objectForKey:userPhoneNumber] forKey:userPhoneNumber];
    
    if([userDict objectForKey:userExtendedZip])
        [saveDict setObject:[userDict objectForKey:userExtendedZip] forKey:userExtendedZip];
    
    [defaults setObject:saveDict forKey:userInformation];
    [defaults synchronize];
    
    [self loadValuesFromFile];
}


- (void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
    
    if(self.userID)
        [saveDict setObject:self.userID forKey:userIDNumber];
    
    [saveDict setObject:self.username forKey:userName];
    [saveDict setObject:self.passwordHash forKey:userPassword];
    [saveDict setObject:self.emailAddress forKey:userEmail];
    [saveDict setObject:self.firstName forKey:userFirstName];
    [saveDict setObject:self.lastName forKey:userLastName];
    [saveDict setObject:self.zipCode forKey:userZipCode];
    
    //Optional values as of now
    if(self.companyName)
        [saveDict setObject:self.companyName forKey:userCompany];
    
    if(self.phoneNumber)
        [saveDict setObject:self.phoneNumber forKey:userPhoneNumber];
    
    if(self.zipCodeExt)
        [saveDict setObject:self.zipCodeExt forKey:userExtendedZip];
    
    [defaults setObject:saveDict forKey:userInformation];
    [defaults synchronize];
}


//Resets account info
- (void) invalidate{
    self.username = nil;
    self.passwordHash = nil;
    self.emailAddress = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.zipCode = nil;
    self.zipCodeExt = nil;
    self.phoneNumber = nil;
    self.userID = nil;
}


@end
