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

- init {
    self = [super init];
    
    if (self) {
        //Initial values based off current local user info
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userDict = [defaults dictionaryForKey:userInfo]; //get user info
        
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
    
    return self;
}


//Singelton accessor
+ (AccountClass *)  sharedAccountClass{
	static AccountClass *sharedAccountClass;
	
	@synchronized(self)
	{
		if (!sharedAccountClass)
			sharedAccountClass = [[AccountClass alloc] init];
	}
	
	return sharedAccountClass;
}


@end
