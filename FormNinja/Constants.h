//
//  Constants.h
//  FormNinja
//
//  Created by Ollin on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//User info 
#define userInformation @"userInformation"
#define userIDNumber @"userID"
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
#define formSecretQuestion @"secretQuestion"
#define formSecretAnswer @"secretAnswer"
#define fromTemplateData @"templateData"


//Form reply keys
#define formUserAccepted @"accepted"
#define formUserInformation @"userInfo"
#define formRegistrationAccepted @"registered"
#define formError @"error"
#define formTrue @"True"
#define formPasswordChangeAccepted @"passwordChanged"

#define loginExpirationKey @"loginExpiration"
#define rememberUserKey	@"rememberUser"

// Template and Form dictionary keys
#define templateNameKey				@"template name"
#define templateGroupKey			@"group name"
#define templateCreatorKey			@"creator name"
#define templateCreationDateKey		@"creation date"
#define templatePublishedKey		@"published"
#define templateVersionKey			@"template version"

#define sectionHeaderKey			@"header"
#define sectionDataKey				@"section data"

#define elementTypeKey				@"type"
#define elementSectionIndexKey		@"section index"
#define elementRowIndexKey			@"row index"

//Form URLs
#define updateAccountURL @"http://thotstudios.com/formninja/accountUpdate.php"
#define accountRegisterURL @"http://www.thotstudios.com/formninja/register.php"
#define userLoginURL @"http://thotstudios.com/formninja/login.php"
#define templateUploadURL @"http://thotstudios.com/formninja/templateUpload.php"

// Group Constants
#define ALL_GROUPS_STR @"All Groups" /* TODO: localize */

// Template constants
#define DOCUMENTS_PATH	([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define TEMPLATE_DIR	(@"Templates")
#define TEMPLATE_PATH	([NSString stringWithFormat:@"%@/%@", DOCUMENTS_PATH, TEMPLATE_DIR])
#define TEMPLATE_EXT	(@".xml")

#define FORM_DIR		(@"Forms")
#define FORM_PATH		([NSString stringWithFormat:@"%@/%@", DOCUMENTS_PATH, TEMPLATE_DIR])
#define FORM_EXT		(@".xml")

#define CONFIRM_DELETE_TEMPLATE_TITLE_STR @"Are you sure you want to delete this template?" /* TODO: localize */
#define CONFIRM_DELETE_TEMPLATE_BUTTON_STR @"Yes, delete it" /* TODO: localize */






