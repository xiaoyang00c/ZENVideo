
#import <Foundation/Foundation.h>

typedef enum {
    NSStringAuthCodeEncoded,
    NSStringAuthCodeDecoded
} NSStringAuthCode;


@interface NSString (Base64)

- (NSString *)authCode:(NSString *)auth_key operation:(NSStringAuthCode)operation encoding:(NSStringEncoding)encoding;

- (NSString *)authCodeEncoded:(NSString *)key encoding:(NSStringEncoding)encoding;

- (NSString *)authCodeEncoded:(NSString *)key;

- (NSString *)authCodeDecoded:(NSString *)key encoding:(NSStringEncoding)encoding;

- (NSString *)authCodeDecoded:(NSString *)key;

@end
