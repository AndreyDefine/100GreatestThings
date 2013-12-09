//
//  MyNavigationControllerViewController.h
//  CustomCellTutorial
//
//  Created by baskakov on 14/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbriaRequest.h"
#import "CommonUserDefaults.h"
#import "FirstLoadingViewController.h"

/** Главный навигейшн контроллер, отвечает за вывод остальных
 вью контроллеров
 */

@interface MyNavigationControllerViewController : UINavigationController <UINavigationBarDelegate,UINavigationControllerDelegate,NSURLConnectionDelegate>
{    
    NSMutableData *_responseData;
}

//Кнопка показать меню, видна только из корневого вью
@property (strong, nonatomic)IBOutlet UIButton *buttonMenu;
//Кнопка вернуться назад, видна, если находимся в иерархии не на корневом вью
@property (strong, nonatomic)IBOutlet UIButton *buttonBack;
//кастомный бар
@property (strong, nonatomic) UIView *customBar;
//кастомный бар, для показа энергии
@property (strong, nonatomic) UIView *energyCustomBar;

//показать меню
-(void)showMenu:(id)sender;
//вернуться назад по стеку вьюконтроллеров
-(void)showBack:(id)sender;

@end
