//
//  CustomCell.h
//  CustomCellTutorial
//
//  Created by Nick on 7/26/12.
//  Copyright (c) 2012 Phereo.com. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Things_list.h"
/**
 возможные состояния ячейки, соответствует названиям
 */
enum {
    CustomCellOpened = 1,
    CustomCellFacebook = 2,
    CustomCellTwitter = 3,
    CustomCellEnergy = 4,
    CustomCellLevel = 5
};
typedef NSUInteger CustomCellType;

/** Кастомная ячейка списка, отвечает за внешний вид ячейки списка
 */
@interface CustomCell : UITableViewCell
{
}

//свойства
//тип ячейки
@property (nonatomic, readwrite) CustomCellType customCellType;
//название списка
@property (nonatomic, strong) IBOutlet UILabel *labelListName;
//прогресс списка
@property (nonatomic, strong) IBOutlet UILabel *labelProgress;
//ссылка на ManagedObject things_list, при задании этого свойства, происходит приведение ячейки таблицы в нужный вид
@property (strong, nonatomic) Things_list *things_list;
//главная кнопка
@property (nonatomic, strong) IBOutlet UIButton *buttonView1;
//вью, в который выводится тень
@property (nonatomic, strong) IBOutlet UIImageView*viewShadow;
//главная картинка списка
@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
//список друзей
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *friendsCollection;
//картинка закрытого списка
@property (nonatomic, strong) IBOutlet UIImageView *imageLock;
//сообщение закрытого списка
@property (nonatomic, strong) IBOutlet UILabel *labelLock;
//необходимый для открытия уровень, если список закрыт
@property (nonatomic, strong) IBOutlet UILabel *labelLockLevel;
//необходимая энергия
@property (nonatomic, strong) IBOutlet UILabel *labelEnergy;
//надпись nrg, под количеством необходимой энергии
@property (nonatomic, strong) IBOutlet UILabel *labelNrg;
//вью, в котором всё лежит, с круглыми краями
@property (nonatomic, strong) IBOutlet UIView *roundRectView;
//для закрытого списка, по уровню вью закрытости
@property (nonatomic, strong) IBOutlet UIView *lockView;
//для закрытого списка, по уровню
@property (nonatomic, strong) IBOutlet UIView *lockViewLvl;
//ссылка на управляющий tableViewController
@property (nonatomic, weak) UITableViewController* tableViewController;


//ссылка на навигейшн контроллер
@property (strong, nonatomic) UINavigationController* navigationController;
//ссылка на сториборд
@property (strong, nonatomic) UIStoryboard* storyboard;

//события на нажатия на кнопку списка
//Если список открыт
-(void)buttonTouched:(id)sender;
//Если список закрыт фейсбуком
-(void)buttonTouchFacebook:(id)sender;
//Если список закрыт твиттером
-(void)buttonTouchTwitter:(id)sender;
//Если список закрыт уровнем
-(void)buttonTouchLevel:(id)sender;
//Если список закрыт энергией
-(void)buttonTouchEnergy:(id)sender;

//обновить родительскую таблицу
-(void)updateTable;


@end
