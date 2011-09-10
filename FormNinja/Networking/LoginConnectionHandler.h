//
//  LoginConnectionHandler.h
//  FormNinja
//
//  Created by Programmer on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceLink.h"


@interface LoginConnectionHandler : WebServiceLink {
    
}

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *) password;

@end
