//
//  Constants.h
//  FormNinja
//
//  Created by Ollin on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//User info 
#define userInfo @"userInformation"
#define userName @"userName"
#define userPassword @"userPassword"
#define userEmail @"email"
#define userFirstName @"firstName"
#define userLastName @"lastName"
#define userZipCode @"zipCode"
#define userExtendedZip @"zipeCodeExt"
#define userCompany @"company"
#define userPhoneNumber @"phoneNumber"

//Form constants
#define formUsername @"username"
#define formPassword @"password"
#define formFirstName @"firstName"
#define formLastName @"lastName"
#define formEmail @"email"
#define formZipCode @"zipCode"
#define formCompanyName @"companyName"
#define formPhoneNumber @"phoneNumber"
#define formZipCodeExt @"zipExt"

//Form reply
#define formUserAccepted @"accepted"
#define formUserInformation @"userInfo"

#define formError @"error"

#define loginExpirationKey @"loginExpiration"
#define rememberUserKey	@"rememberUser"

//Form URLs
#define updateAccountURL @"http://www.rilburskryler.net/mobile/accountUpdate.php"
#define accountRegisterURL @"http://www.rilburskryler.net/mobile/register.php"


// Group Constants
#define ALL_GROUPS_STR @"All Groups"

// Template constants
#define DOCUMENTS_PATH ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define TEMPLATE_DIR (@"/.")
#define TEMPLATE_PATH ([NSString stringWithFormat:@"%@%@", DOCUMENTS_PATH, TEMPLATE_DIR])

#define CONFIRM_DELETE_STR @"Really delete?"







