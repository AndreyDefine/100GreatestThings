//
//  CustomProgressBar.h
//  100GreatestThings
//
//  Created by baskakov on 02/12/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomProgressBar : UIView
{
    UIImageView * imageViewA;
    UIImageView * imageViewB;
    UILabel* expirience;
}

@property (nonatomic,readwrite) int fullRange;

+(CustomProgressBar*)addProgressBarInFrame:(CGRect)frame onView:(id)inview withRange:(int)range image1:(NSString*)imagename1 imagebackground:(NSString*)imagenamebackground fullRange:(int)infullRange;

-(void)setProgress:(int)range;

@end
