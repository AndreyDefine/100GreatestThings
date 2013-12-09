//
//  TaskCell.h
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Things_task.h"

/** Кастомная ячейка задачи, отвечает за внешний вид ячейки задачи
 */
@interface TaskCell : UITableViewCell
{
}

//номер строки
@property (nonatomic, strong) IBOutlet UILabel *rowNumber;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;
//кнопка "выполнено"
@property (nonatomic, strong) IBOutlet UILabel *titleView1;
//главная картинка задачи
@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
//список друзей
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *friendsCollection;
//ссылка на ManagedObject things_task, при задании этого свойства, происходит приведение ячейки таблицы в нужный вид
@property (strong, nonatomic) Things_task *things_task;
//ссылка на ManagedObject things_list
@property (strong, nonatomic) Things_list *things_list;
//ссылка на управляющий tableViewController
@property (nonatomic, weak) UITableViewController* tableViewController;

//выполнить задачу
-(IBAction)makeTask:(id)sender;
//обновить табилцу
-(void)updateTable;

@end
