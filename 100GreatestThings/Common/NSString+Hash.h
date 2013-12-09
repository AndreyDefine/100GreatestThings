#import <Foundation/Foundation.h>

#import	<CommonCrypto/CommonHMAC.h>
#import	<CommonCrypto/CommonDigest.h>

/** Категория, для получения хеша, от строки
 */

@interface NSString (NSString_MD5)


//получить md5 для строки
- (NSString*) md5;




@end