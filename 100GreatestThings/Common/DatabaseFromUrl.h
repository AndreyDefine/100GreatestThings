//
//  DatabaseFromUrl.h
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseFromUrl : NSObject
{
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (DatabaseFromUrl *) getSharedInstance;

- (void) LoadDataFromURL:(void (^)(void))responseBlock;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end
