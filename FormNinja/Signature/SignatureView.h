//
//  SignatureViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignatureView : UIView
{
	CGPoint lastPoint;
	UIImageView *imageView;
}

@property (retain, nonatomic) UIImageView * imageView;

-(IBAction) clearSignature;

@end
