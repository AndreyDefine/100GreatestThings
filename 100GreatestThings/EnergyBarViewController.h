//
//  EnergyBarViewController.h
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgressBar.h"

/** Бар для показа количества энергии.
 Синглтон.
 */

@interface EnergyBarViewController : UIViewController
{
    //таймер, по срабатыванию которого происходит добавление энергии
    NSTimer *aTimer;
}

//отображение прогресса, текущего состояния энергии
@property (strong, nonatomic) CustomProgressBar* energybar;

//получить экземпляр синглтона
+(EnergyBarViewController*)getSharedInstance;
//произвести добавление энергии (через покупку)
-(IBAction)getMoreMoney:(id)sender;

//добавить энергию
-(void)addenergy:(float)inenergy;
//установить максимальный уровень энергии
-(void)setmaxenergy:(float)inenergy;

@end
