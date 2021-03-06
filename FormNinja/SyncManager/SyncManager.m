//
//  SyncManager.m
//  FormNinja
//
//  Created by Paul Salazar on 6/6/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "SyncManager.h"
#import "AccountClass.h"
#import "JSON.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

static NSMutableDictionary *syncList;


//Private methods
@interface SyncManager () 

- (void) loadList;

@end

@implementation SyncManager

@synthesize userID, delegate;


#pragma mark - Class Methods

+ (SyncManager *) sharedSyncManager{
    static  SyncManager *syncManager;
    
    @synchronized(self)
	{
		if (!syncManager)
            syncManager = [[SyncManager alloc] init];
        
        if (!syncList){
            syncList = [[NSMutableDictionary alloc] init];
            [syncManager loadList];
        }
	}
    
    return syncManager;
}


#pragma mark - Instance Methods

- init {
    self = [super init];
    
    if (self) {
        self.userID = [AccountClass sharedAccountClass].userID;
    }
    
    return self;
}


//Formats template to db compatible json string
- (NSString *) formatTemplate:(NSMutableArray *) array{
    NSMutableArray *dbArray = [[[NSMutableArray alloc] initWithArray:array] autorelease];
   // NSLog(@"%@", dbArray);
    //Check for json incompatible Signature fields
    for (NSMutableDictionary *dictionary in dbArray) {
        NSArray *dataDict = [dictionary objectForKey:sectionDataKey]; //get section data
        
        for(NSMutableDictionary *formData in dataDict){ //loop through form elements in section
            NSString *type = [formData objectForKey:elementTypeKey];
        
            if (formData && ([type isEqualToString:@"GeoSignature"]|| [type isEqualToString:@"Signature"])) {
                if([formData objectForKey:elementSignatureImageKey]){ //Check for signature nsdata
                    NSString *imageData = [ASIHTTPRequest base64forData:[formData objectForKey:elementSignatureImageKey]]; //Convert nsdata image info to base64 json compatible string
                
                    [formData setObject:imageData forKey:elementSignatureImageKey]; //Replace with base 64 data
                }
            }   
        }
    }
    
    //Return json string
    return [dbArray JSONRepresentation]; 
    
    /*
    //Prepare form
    NSURL *urlToSend = [[[NSURL alloc] initWithString: templateUploadURL] autorelease];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:urlToSend] autorelease];  
    [request setPostValue:self.userID forKey:userIDNumber];  
    [request setPostValue:dbData forKey:fromTemplateData];  
	
    //Send request
    request.delegate = self;
   // [request startAsynchronous];  uncomment to sync*/

}


//Adds template to sync list for later syncing
- (void) addTemplateToSyncList:(NSMutableArray *) dataArray{
    NSMutableDictionary *metaData = [dataArray objectAtIndex:0];
    NSString *templateName = [metaData objectForKey:templateNameKey];
    NSString *templateData = [self formatTemplate:dataArray];    
    NSString * group = [metaData objectForKey:templateGroupKey];
	
	if(!group) 
        group = @"No Group";
	
    if(!templateName) 
        templateName = [NSString stringWithFormat:@"%i", time(0)];
	
	NSString *fileName;
	fileName = [NSString stringWithFormat:@"%@-%@", group, templateName];

    [syncList setValue:templateData forKey:fileName];
}


- (void) saveList{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:syncList forKey:templateSyncListKey];
    [defaults synchronize];
}


- (void) loadList{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults objectForKey:templateSyncListKey])
        syncList = [defaults objectForKey:templateSyncListKey];
}


- (void) sync{
    for (NSString *data in syncList) {
        NSLog(@"sync");
    }
}


#pragma mark - ASIHTTPRequest Delegate Methods

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"fail %@", [request responseString]);
}


- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"success %@", [request responseString]);
}



#pragma mark - Dealloc

- (void)dealloc{
    [userID release];
    
    [super dealloc];
}


@end
