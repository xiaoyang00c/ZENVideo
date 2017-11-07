//
//  CommonClass.h
//  TLSDPro
//
//  Created by Andy on 15-1-23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSString+MD5.h"

@interface CommonClass : NSObject
//16进制色转成RGB
+ (UIColor *)getColor:(NSString *)hexColor;
+(void)setExtraCellLineHidden: (UITableView *)tableView;
//加半透明的水印
+(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;//正则判断手机号码地址格式


+ (NSString *)timeConversionPerUnit:(NSTimeInterval )interval;
+(NSString*)timeDistanceSinceNow:(NSString*)time;


+(NSString *)compareDate:(NSString *)dateString;

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;


//距离
+(NSString*)distanceBetweenOrderBy:(double)lon1 :(double)lat1 :(double)lon2 :(double)lat2;
//加模糊效果函数，传入参数：image是图片，blur是模糊度（0~2.0之间）
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

//年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;

+ (CGSize)heightForExpressionText:(NSString*)expressionText maxWidth:(CGFloat)width;



#pragma 正则匹配昵称
+ (BOOL) validateNickname:(NSString *)nickname;
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma 转换成中文长度
+ (NSInteger)convertToInt:(NSString*)strtemp;
#pragma 正则匹配邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
/**
 *  字符串格式化null自动转为@""
 *
 *  @param str 任意类型的变量
 *
 *  @return 返回一个字符串
 */
+ (NSString *)judgeStr:(id)str;
//十进制数转16进制
+ (NSString *)ToHex:(uint16_t)tmpid;
@end
