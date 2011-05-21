//
//  SignatureViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignatureViewController : UIViewController
{
	CGPoint lastPoint;
	UIImageView *drawImage;
}

@property (retain, nonatomic) UIImageView * drawImage;

-(UIImage*) image;
-(IBAction) clearSignature;

@end
