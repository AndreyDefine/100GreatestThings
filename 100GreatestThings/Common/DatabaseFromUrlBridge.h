//
//  DatabaseFromUrlBridge.h
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

/** Класс для работы c локальной базой данных и
 сетью. Синглтон.
 */
#import <Foundation/Foundation.h>
#import "Things_task.h"

@interface DatabaseFromUrlBridge : NSObject
{
}

//Core Data common properties
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//Получить экземпляр синглтона
+ (DatabaseFromUrlBridge *) getSharedInstance;
//Загрузить основную таблицу списков из интернета, и сохранить её в бд
- (void) LoadDataFromURL:(void (^)(NSError*))responseBlock;
//Загрузить таблицу с настройками приложения, и сохранить её в NSUserDefaults
- (void) GetSettings:(void (^)(NSError*))responseBlock;
//Загрузить таблицу с описаниями уровней, и сохранить её в бд
- (void) GetLevels:(void (^)(NSError*))responseBlock;
//Сохранить базу данных
- (void)saveContext;
//Загрузить картинку
- (UIImage*) LoadImage:(NSString*)value;
//Загрузить с кешированием картинку из интернета, и по завершении поместить её в указанный imageview
-(void)LoadImage:(NSString*)image_url todisk:(NSString*)disk_image_url toimageview:(UIImageView*)imageview;

//получить количество экспы нужной для уровня
-(int)getExpaForLevel:(int)level;
//получить энергию для уровня
-(int)getEnergyForLevel:(int)level;
@end
