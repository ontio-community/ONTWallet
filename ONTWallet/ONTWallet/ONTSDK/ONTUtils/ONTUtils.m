//
//  ONTUtils.m
//  ONTWallet
//
//  Created by zhangyutao on 2018/8/4.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import "ONTUtils.h"

@implementation ONTUtils

+ (NSString *)base64EncodedString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"json 解析失败：%@",error);
        return nil;
    }
    return dictionary;
}

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary {
    if (dictionary == nil) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"json 解析失败：%@",error);
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (BOOL)isValidKeystoreJson:(NSString *)keystoreJson {
    if (!keystoreJson || keystoreJson.length == 0) {
        return NO;
    }
    NSError *error = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[keystoreJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        return NO;
    }
    NSObject *address = [data objectForKey:@"address"];
    NSObject *type = [data objectForKey:@"type"];
    return ((address && [address isKindOfClass:[NSString class]]) && (type && [type isKindOfClass:[NSString class]] && [type isEqual:@"A"]));
}

+ (NSString *)noWhiteSpaceString:(NSString *)string {
    NSString *newString = string;
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return newString;
}

+ (NSString *)decimalNumber:(NSString *)number byDividingBy:(NSString *)divideNumber {
    if (number == nil || number.length == 0 || divideNumber == nil || divideNumber.length == 0) {
        return @"0.0";
    }
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:divideNumber];
    NSDecimalNumber *result = [decimalNumber1 decimalNumberByDividingBy:decimalNumber2];
    return result.stringValue;
}

+ (NSString *)decimalNumber:(NSString *)number byMultiplyingBy:(NSString *)multiplyNumber {
    if (number == nil || number.length == 0 || multiplyNumber == nil || multiplyNumber.length == 0) {
        return @"0.0";
    }
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:multiplyNumber];
    NSDecimalNumber *result = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
    return result.stringValue;
}

+ (NSString *)decimalNumberWithHexString:(NSString *)numberHexString {
    if (![numberHexString hasPrefix:@"0x"]) {
        numberHexString = [@"0x" stringByAppendingString:numberHexString];
    }
    NSScanner* scanner = [NSScanner scannerWithString:numberHexString];
    unsigned long long number;
    [scanner scanHexLongLong:&number];
    return [[NSNumber numberWithUnsignedLongLong:number] stringValue];
}

@end
