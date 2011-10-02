//
//  WebServiceMessageQueue.m
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebServiceMessageQueue.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WebServiceMessageQueue
@synthesize messageQueue;
@synthesize error;
@synthesize usertoken, passtoken;
@synthesize tokenExpiration;

#pragma mark - Memory Management

static WebServiceMessageQueue *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (WebServiceMessageQueue *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        queueStatus=0;
        self.messageQueue=[NSMutableArray array];
        /*CHAD*/
        //Need to load usertoken, passtoken, and tokenExpiration!
    }
    return self;
}

-(void) dealloc
{
    
    [self.messageQueue release];
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

#pragma mark - Message Functions

-(void)addMessageToQueue:(WebServiceMessage *) message
{
    NSLog(@"WebServiceMessageQueue: addMessageToQueue");
    message.queueDelegate=self;
    NSLog(@"Count:  %i", [messageQueue count]);
    [self.messageQueue addObject:message];
    
    NSLog(@"Count:  %i", [messageQueue count]);
    if(queueStatus==0)
    {
        queueStatus=1;
        [self processNextMessage];
    }
}

#pragma mark - Queue Functions

-(int) queueStatus
{
    return queueStatus;
}

-(void)processNextMessage
{
    NSLog(@"WebServiceMessageQueue: processNextMessage");
    NSLog(@"%i", [messageQueue count]);
    [[messageQueue objectAtIndex:0] processMessage];
}
-(void)resumeProcessingQueue
{
    queueStatus=1;
}

-(BOOL)removeMessageFromQueue:(WebServiceMessage *)message
{
    if(message.status!=2)
    {
        [messageQueue removeObject:message];
        return true;
    }
    else
    {
        return false;
    }
}

-(void)clearQueue
{
    [[[messageQueue copy] autorelease] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [[WebServiceMessageQueue sharedInstance] removeMessageFromQueue:(WebServiceMessage *)obj];
     }];
    
    if([messageQueue count]==0)
    {
        queueStatus=0;
    }
    else
    {
        queueStatus=1;
    }
}

#pragma mark - Cryptographic functions
//Functions intended to help with the security of the queue, i. e. password generation

+ (NSString *) md5:(NSString *)str {
    //reference: http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

#pragma mark - Delegate Functions

-(void)messageFinishedSuccessfully:(WebServiceMessage *)message
{
    NSLog(@"Message Finished Successfully!");
    [self.messageQueue removeObject:message];
    if([messageQueue count]>0)
    {
        [self processNextMessage];
    }
    else
    {
        queueStatus=0;
    }
}

-(void)messageError:(NSError *)messageError
{
    queueStatus=3;
    self.error=messageError;
}

-(void)messageGaveUsernameToken:(NSString *)userToken passwordToken:(NSString *)passToken withTime:(NSDate *)date
{
    NSLog(@"user: %@ pass: %@ date: %@",userToken, passToken, [date description]);
    self.usertoken=userToken;
    self.passtoken=passToken;
    self.tokenExpiration=date;
    /*CHAD*/
    //persist data
}



@end
