//
//  LoadSaveImageFromUrl.h
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

/** Класс для работы c загрузкой картинок. Загрузка
 Сохранение, извлечение по адресу
 */

#import <Foundation/Foundation.h>

@interface LoadSaveImageFromUrl : NSObject

//Получить картинку из интернета, синхронно (для текущего потока)
-(UIImage *) getImageFromURL:(NSString *)fileURL async:(BOOL)asynchronous;
//Сохранить картинку по имени, в указанной директории
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName inDirectory:(NSString *)directoryPath;
//Загрузить картинку по имени из директории
-(UIImage *) loadImage:(NSString *)fileName inDirectory:(NSString *)directoryPath;

@end
