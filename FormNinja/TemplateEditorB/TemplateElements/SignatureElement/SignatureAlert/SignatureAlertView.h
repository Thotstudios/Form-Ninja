//
//  SignatureAlertView.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/24/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SignatureView;

@interface SignatureAlertView : UIAlertView
{
	SignatureView * signatureView;
	id callback;
	SEL selector;
	SEL success;
	SEL failure;
}

@property (nonatomic, retain) SignatureView * signatureView;

@property (nonatomic, retain) id callback;
@property SEL selector;
@property SEL success;
@property SEL failure;

-(id) initWithTitle:(NSString *)title delegate:(id)delegate onSuccess:(SEL)success onFailure:(SEL)failure;
-(id) initWithDelegate:(id)delegate onSuccess:(SEL)success onFailure:(SEL)failure;

+(void) showWithDelegate:(id)delegate onSuccess:(SEL)success onFailure:(SEL)failure;

@end
