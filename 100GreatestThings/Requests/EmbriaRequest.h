//
//  EmbriaRequest.h
//  HTTP_Embria
//
//  Created by baskakov on 25/11/13.
//  Copyright (c) 2013 baskakov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EmbriaRequest;
/** Протокол инкапсулирует в себе основные методы для отслеживания состояния
 осуществляемого запроса.
 */
@protocol EmbriaRequestDelegate <NSObject>

@required
/** Возвращает ответ сервера в виде Foundation объекта
 @param request запрос к которому относится вызов метода делегата
 @param response ответ сервера в виде Foundation объекта
 */
- (void)EmbriaRequest:(EmbriaRequest *)request response:(id)response error:(NSError*)requestError;

@end



/** Класс простого запроса, возвращает ответом Foundation объект из полученного JSON.
 Самый простой способ реализации запроса на сервер с использованием GET запроса, если нужна
 настройка, придётся всё переписать и воспользоваться NSURLConnection
 */

typedef void (^ResponseEmbriaBlock)(EmbriaRequest*, id, NSError*);
@interface EmbriaRequest : NSObject
{
    NSError *requestError;
    NSMutableData*urlData;
}
//делегат, в который возвращается ответ от сервера
@property (nonatomic, weak, readwrite) id <EmbriaRequestDelegate> delegate;
//выполнять запрос асинхронно
@property (nonatomic, readwrite) BOOL makeAsync;
//испльзовать ли URLConnection или dataWithContentsOfURL
@property (nonatomic, readwrite) BOOL useURLConnection;
//response block
@property (nonatomic, strong,readwrite) ResponseEmbriaBlock responseblock;

/** Выполнить запрос по адресу.
 @param inHttp адрес, по которому производится запрос
 */
- (void)makeRequest:(NSString*)inHttp;

@end
