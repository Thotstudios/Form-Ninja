//
//  RegistrationConnectionHandler.h
//  FormNinja
//
//  Created by Programmer on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceLink.h"

@interface RegistrationConnectionHandler : WebServiceLink {
    
}

-(void)registerNewUserWithUserName:(NSString *) username andPassword:(NSString *) password andFName:(NSString *)fName andLName:(NSString *)lName andEmail:(NSString *)email andZip:(NSString *)zip andZipExt:(NSString *)zipExt andPhoneNumber:(NSString *)phoneNumber andCompany:(NSString *)company andSecurityQuestion:(NSString *)securityQuestion andSecurityAnswer:(NSString *)securityAnswer;

@end
