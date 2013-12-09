//
//  TasksTableViewController.h
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//


/** Вывод таблицы задач, работает с CoreData по стандартной схеме.
 TableView dataSource и delegate
 */

#import <CoreData/CoreData.h>
#import "Things_list.h"

@interface TasksTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
}

//CoreData common
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
//экземпляр списка, нужен для отображения шапки таблицы, а также, отсюда берутся данные по задачам
@property (strong, nonatomic) Things_list *things_list;

//указатель на View шапки таблицы
@property (nonatomic, strong) IBOutlet UITableViewCell *headerCell;
//Перезагрузить данные таблицы
- (void)reloadData;

@end
