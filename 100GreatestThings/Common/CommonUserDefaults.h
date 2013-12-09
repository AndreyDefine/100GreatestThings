//
//  CommonUserDefaults.h
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

/** Класс для работы c NSUserDefaults изменение свойств класса ведёт к записи в
 настройки приложения, при чтении свойств всё берётся тоже из NSUserDefaults
 Синглтон.
 */

#import <Foundation/Foundation.h>

@interface CommonUserDefaults : NSObject
{
    NSUserDefaults *prefs;
}

//получить экземпляр синглтона
+ (CommonUserDefaults *) getSharedInstance;
//принудительное сохранение настроек
-(void)saveDefaults;
//первый ли раз открывается приложение, флаг должен быть сброшен в true, если приложение уже открывалось
@property (nonatomic) BOOL flagNotFirstLaunch;
//текущий уровень
@property (nonatomic) int level;
//количество экспы
@property (nonatomic) float expa;
//количество максимальной энергии (для уровня)
@property (nonatomic) float maxenergy;
//текущее количество энергии
@property (nonatomic) float energyrange;
//время последней синхронизации энергии, нужно чтобы энергия добавлялась и в оффлайн режиме
@property (nonatomic,strong) NSDate* lastlaunchdate;
//from server
@property (nonatomic)float energy_growth_rate;
@property (nonatomic)int facebook_login_energy_reward;
@property (nonatomic)int facebook_login_exp_reward;
@property (nonatomic)int twitter_login_energy_reward;
@property (nonatomic)int twitter_login_exp_reward;

@end
