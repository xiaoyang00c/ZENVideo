//
//  NSString+MyCategory.h
//  GoddessClock
//
//  Created by wubing on 14-9-9.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyCategory)

- (BOOL)hasSubString:(NSString *)string;

+(BOOL)stringIsEmpty:(NSString *)aString shouldCleanWhiteSpace:(BOOL)cleanWhiteSpace;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

+ (NSString *)stringWithArab:(int)arab;

//去掉html标签
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

-(NSString *)compareDate:(NSDate *)date;

-(id)JSONValue;

/**
 * 得到附加上CRC16 Modbus校验码之后的字符
 */
- (NSString*)withCrc16Modbus;
- (NSData *)toNSData;
- (NSString *)toNSString:(NSData*)data;

+ (uint16_t)crc16:(const char *)buf length:(int)len;

//二进制转16进制
+ (NSString *)data2Hex:(NSData *)data;
//字符串转二进制
- (NSData *)changeTo2B;
// 截取字符串方法封装//
//截取字符串方法封装
- (NSString*)subStringFrom:(NSString*)startString to:(NSString*)endString;
@end
