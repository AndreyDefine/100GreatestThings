//
//  DatabaseFromUrlBridge.h
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//


//класс для работы c локальной базой данных и
//сетью
#import <Foundation/Foundation.h>

@interface DatabaseFromUrlBridge : NSObject
{
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (DatabaseFromUrlBridge *) getSharedInstance;

- (void) LoadDataFromURL:(void (^)(NSError*))responseBlock;

- (void) GetSettings:(void (^)(NSError*))responseBlock;
- (void) GetLevels:(void (^)(NSError*))responseBlock;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (UIImage*) SaveImageToDisk:(NSString*)value;

-(void)LoadImage:(NSString*)image_url todisk:(NSString*)disk_image_url toimageview:(UIImageView*)imageview;

//получить количество экспы нужной для уровня
-(int)getExpaForLevel:(int)level;


//получить количество максимальной энергии на уровня
-(int)getEnergyForLevel:(int)level;

@end
