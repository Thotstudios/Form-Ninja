//
//  SignatureViewController.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/20/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignatureView : UIView
{
	CGPoint lastPoint;
	UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView * imageView;

-(IBAction) clearSignature;

@end
