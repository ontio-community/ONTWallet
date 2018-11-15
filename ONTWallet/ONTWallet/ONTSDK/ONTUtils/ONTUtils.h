//
//  ONTUtils.h
//  ONTWallet
//
//  Created by zhangyutao on 2018/8/4.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONTUtils : NSObject

/**
 Base64 编码字符串

 @param string 原始字符串
 @return Base64 编码后的字符串
 */
+ (NSString *)base64EncodedString:(NSString *)string;

/**
 JSON 字符串 转 NSDictionary

 @param jsonString JSON 字符串
 @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 NSDictionary 转 JSON 字符串

 @param dictionary 字典
 @return NSString
 */
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;


/**
 检查是否有效Keystore

 @param keystoreJson Keystore
 @return BOOL
 */
+ (BOOL)isValidKeystoreJson:(NSString *)keystoreJson;


/**
 去除字符串中的空格、换行

 @param string 原始字符串
 @return 新字符串
 */
+ (NSString *)noWhiteSpaceString:(NSString *)string;


+ (NSString *)decimalNumber:(NSString *)number byDividingBy:(NSString *)divideNumber;
+ (NSString *)decimalNumber:(NSString *)number byMultiplyingBy:(NSString *)multiplyNumber;
+ (NSString *)decimalNumberWithHexString:(NSString *)numberHexString;

@end
