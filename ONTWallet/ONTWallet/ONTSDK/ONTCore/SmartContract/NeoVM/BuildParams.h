//
//  BuildParameter.h
//  ONTWallet
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AbiFunction;

@interface BuildParams : NSObject

+(NSData*)serializeAbiFunction:(AbiFunction*)fun;
+(NSData *)createCodeParamsScript:(NSArray<NSObject *> *)array;

@end
