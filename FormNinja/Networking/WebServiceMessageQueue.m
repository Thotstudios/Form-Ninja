//
//  WebServiceMessageQueue.m
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebServiceMessageQueue.h"


@implementation WebServiceMessageQueue
@synthesize messageQueue;
@synthesize error;

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



@end
