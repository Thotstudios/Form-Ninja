//
//  RegistrationMessage.h
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceMessage.h"
#import "Constants.h"

@protocol RegistrationMessageDelegate <NSObject>

-(void)registrationSuccessful;
-(void)registrationFailedWithError:(NSError *) error;

@end

@interface RegistrationMessage : WebServiceMessage {
    /*
     RegistrationMessage error domain codes:
     0:  Unable to create connection
     1:  Server rejected connection
     */
}




@property (nonatomic, assign) id <RegistrationMessageDelegate> regDelegate;
@property (nonatomic, retain) NSString *username, *password, *fname, *lname, *email, *zip, *zipExt, *company, *phoneNumber, *securityQuestion, *securityAnswer;

+(RegistrationMessage *)registerNewUserWithUserName:(NSString *) username andPassword:(NSString *) password andFName:(NSString *)fName andLName:(NSString *)lName andEmail:(NSString *)email andZip:(NSString *)zip andZipExt:(NSString *)zipExt andPhoneNumber:(NSString *)phoneNumber andCompany:(NSString *)company andSecurityQuestion:(NSString *)securityQuestion andSecurityAnswer:(NSString *)securityAnswer andDelegate:(id <RegistrationMessageDelegate, MessageDelegate>)delegate;

@end
