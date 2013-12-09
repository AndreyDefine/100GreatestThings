//
//  CustomProgressBar.h
//  100GreatestThings
//
//  Created by baskakov on 02/12/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//


/**Кастомный ProgressView, для отображения прогресса через картинку и числовое значение.
 Синглтон.
 */
#import <UIKit/UIKit.h>

@interface CustomProgressBar : UIView
{
    UIImageView * imageViewA;
    UIImageView * imageViewB;
    UILabel* expirience;
    int _range;
}

//полный уровень прогресса
@property (nonatomic,readwrite) int fullRange;

//добавить прогрессбар с заданными размерами и картинками, в указанном вью.
+(CustomProgressBar*)addProgressBarInFrame:(CGRect)frame onView:(id)inview withRange:(int)range image1:(NSString*)imagename1 imagebackground:(NSString*)imagenamebackground fullRange:(int)infullRange;
//установить прогресс на прогрессбаре
-(void)setProgress:(int)range;

@end
