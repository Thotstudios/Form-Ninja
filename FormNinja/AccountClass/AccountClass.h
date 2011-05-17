//
//  AccountClass.h
//  FormNinja
//
//  Created by Hackenslacker on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccountClass : NSObject
{
    
	NSString * userID;
	NSString * username;
	NSString * passwordHash;
	NSString * firstName;
	NSString * lastName;
	NSString * emailAddress;
	NSString * companyName;
	NSString * phoneNumber;
	NSString * securityQuestion;
	NSString * securityAnswer;
	NSString * zipCode;
	NSString * zipCodeExt;
}

@property (retain, nonatomic) NSString * userID;
@property (retain, nonatomic) NSString * username;
@property (retain, nonatomic) NSString * passwordHash;
@property (retain, nonatomic) NSString * firstName;
@property (retain, nonatomic) NSString * lastName;
@property (retain, nonatomic) NSString * emailAddress;
@property (retain, nonatomic) NSString * companyName;
@property (retain, nonatomic) NSString * phoneNumber;
@property (retain, nonatomic) NSString * securityQuestion;
@property (retain, nonatomic) NSString * securityAnswer;
@property (retain, nonatomic) NSString * zipCode;
@property (retain, nonatomic) NSString * zipCodeExt;


- (void) saveWithDict:(NSDictionary *) userDict;
+ (AccountClass *) sharedAccountClass;

@end

/*
 USERID
 USERNAME
 PASSWORD
 FNAME
 LNAME
 EMAIL
 COMPANY
 PHONE NUMBER
 SECURITYQUESTION
 SECURITYANSWER
 ZIPCODE
 ZIPCODEEXT
 
 */