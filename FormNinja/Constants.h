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

//Form reply
#define formUserAccepted @"accepted"
#define formUserInformation @"userInfo"

#define formError @"error"

#define loginExpirationKey @"loginExpiration"
#define rememberUserKey	@"rememberUser"

// Group Constants
#define ALL_GROUPS_STR @"All Groups"

// Template constants
#define DOCUMENTS_PATH ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define TEMPLATE_DIR (@"/.")
#define TEMPLATE_PATH ([NSString stringWithFormat:@"%@%@", DOCUMENTS_PATH, TEMPLATE_DIR])