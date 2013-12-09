//
//  FirstLoadingViewViewController.h
//  100GreatestThings
//
//  Created by baskakov on 28/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

/** Драфт класс, для отображения прогресса загрузки или вывода ошибки
 */

#import <UIKit/UIKit.h>

@interface FirstLoadingViewController : UIViewController

//поле, куда выводится служебная информация о загрузке
@property (strong, nonatomic)IBOutlet UILabel *messageLabel;

@end
