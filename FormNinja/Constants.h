//
//  Constants.h
//  FormNinja
//
//  Created by Paul Salazar on 5/16/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//


// TODO: TEMPORARY:
#define USE_DEMONSTRATION_FILES		1

// General Strings
#define OKAY_STR					@"OK"
#define CANCEL_STR					@"Cancel"
#define CONFIRM_STR					@"Confirm"
#define CLEAR_STR					@"Clear"
#define TEMPLATE_SAVED_STR			@"Template Saved"
#define FORM_SAVED_STR				@"Form Saved"
#define FORM_FINAL_STR				@"Form Completed"
#define SAVE_FAILED_STR				@"Failed to Save"
#define GPS_COORDINATES_FORMAT		@"%.3f, %.3f"
#define GPS_ACCURACY_FORMAT			@"+/- %@"
#define GPS_COORD_AND_ACC_FORMAT	@"GPS: (%@), %@"

// Shortcuts
#define CURRENT_DATE_AND_TIME	[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]
#define CURRENT_USERNAME		[NSString stringWithFormat:@"%@ %@", [[AccountClass sharedAccountClass] firstName], [[AccountClass sharedAccountClass] lastName]]

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

#define templateSyncListKey @"templateSyncListKey"

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

#define filePathKey					@"path"

#define formNameKey					@"form name"
#define formAgentKey				@"form agent"
#define formBeginDateKey			@"form begin date"
#define formFinalDateKey			@"form final date"
#define formCompletedKey			@"Form Completed"
#define formCoordinatesKey			@"Form Coordinates"
#define formCoordinatesAccuracyKey	@"Form GPS Accuracy"

// Element dictionary keys
#define elementLabelKey				@"label"
#define elementLabelAlignment		@"label alignment"
#define elementValueKey				@"value"
#define elementFormValueKey			@"form value"
#define elementMinLengthKey			@"minimum length"
#define elementMaxLengthKey			@"maximum length"

#define elementAddressLineKey			@"address line"
#define elementFormAddressLineKey		@"form address line"
#define elementAddressLine2Key			@"address line 2"
#define elementFormAddressLine2Key		@"form address line 2"
#define elementAddressCityNameKey		@"city name"
#define elementFormAddressCityNameKey	@"form city name"
#define elementAddressStateKey			@"state abbr"
#define elementFormAddressStateKey		@"form state abbr"
#define elementAddressZipKey			@"zip code"
#define elementFormAddressZipKey		@"form zip code"

#define elementTableDataKey				@"table data"
#define elementSignatureImageKey		@"signature image"
#define elementCoordinatesEnabledKey	@"GPS Enabled"
#define elementCoordinatesKey			@"coordinates"
#define elementCoordinatesAccuracyKey	@"GPS Accuracy"

#define elementRatingKey				@"Rating Element"
#define elementRatingValueKey			@"Rating Value"



//Form URLs
#define userInfoURL			@"http://www.rilburskryler.net/mobile/userinfo.php"
#define updateAccountURL	@"http://thotstudios.com/formninja/accountUpdate.php"
#define accountRegisterURL	@"http://www.thotstudios.com/formninja/register.php"
#define userLoginURL		@"http://thotstudios.com/formninja/login.php"
#define templateUploadURL	@"http://thotstudios.com/formninja/templateUpload.php"

// Group Constants
#define ALL_GROUPS_STR @"All Groups" /* TODO: localize */

// Template constants
#define DOCUMENTS_PATH	([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define TEMPLATE_PATH	([NSString stringWithFormat:@"%@/Templates", DOCUMENTS_PATH])
#define TEMPLATE_EXT	(@"xml")

#define FORM_PATH		([NSString stringWithFormat:@"%@/Forms", DOCUMENTS_PATH])
#define FORM_EXT		(@"xml")

#define CONFIRM_DELETE_TEMPLATE_STR		@"Are you sure you want to delete this template?" /* TODO: localize */
#define CONFIRM_DELETE_SECTION_STR		@"Are you sure you want to delete this section?" /* TODO: localize */
#define CONFIRM_DELETE_FORM_STR			@"Are you sure you want to delete this form?" /* TODO: localize */
#define CONFIRM_DELETE_BUTTON_STR		@"Yes, delete it" /* TODO: localize */
#define REQUEST_NEW_TEMPLATE_NAME_STR	@"New Template Name"
#define SIGNATURE_REQUIRED_STR			@"Signature Required"
#define TABLE_NEW_ENTRY_STR				@"New Entry"


//Popover menu constants
#define syncMenuOption @"Sync"
#define logoutMenuOption @"Logout"
#define newFormMenuOption @"Start New Form"
#define newTemplateMenuOption @"Start New Template"
#define airPrintFormMenuOption @"AirPrint Form"
#define emailFormMenuOption @"Email Form" 

//NSArray * const MenuType_toEnum[];

//Indicates what location type to share
typedef enum{
	accountProfileMenu,
    formManagerMenu,
    formManagerNoSendMenu
} MenuType;

//Indicates selected popover menu action
typedef enum{
	menuSyncSelected,
    menuLogoutSelected,
    menuNewFormSelected,
    menuNewTemplateSelected,
    menuAirPrintFormSelected,
    menuEmailFormSelected
} MenuSelectType;

