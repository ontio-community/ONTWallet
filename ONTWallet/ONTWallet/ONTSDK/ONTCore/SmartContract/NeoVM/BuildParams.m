//
//  BuildParameter.m
//  ONTWallet
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import "BuildParams.h"
#import "AbiFunction.h"
#import "Parameter.h"
#import "NSMutableData+ONTScriptBuilder.h"
#import "ONTBool.h"
#import "ONTInteger.h"
#import "ONTLong.h"
#import "ONTAddress.h"
#import "ONTStruct.h"

@implementation BuildParams

+ (NSData *)serializeAbiFunction:(AbiFunction *)fun {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    [list addObject:[fun.name dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    for (Parameter* param in fun.parameters) {
        if ([@"ByteArray" isEqualToString:param.type]) {
            [tmp addObject: param.value];
        }
    }
    
    if ([list count] > 0) {
        [list addObject:tmp];
    }

    return [BuildParams createCodeParamsScript:list];
}

+(NSData *)createCodeParamsScript:(NSArray<NSObject *> *)array{
    NSMutableData *data = [NSMutableData new];
    for (int i = [array count] - 1; i >= 0; i--) {
        NSObject* val = [array objectAtIndex:i];
        if ([val isKindOfClass:NSData.class]) {
            [data pushData:(NSData *)val];
        }else if ([val isKindOfClass:ONTBool.class]){
            [data pushBool:((ONTBool *)val).value];
        }else if ([val isKindOfClass:ONTInteger.class]){
            [data pushNumber:@(((ONTInteger *)val).value)];
        }else if ([val isKindOfClass:ONTLong.class]){
            [data pushNumber:@(((ONTLong *)val).value)];
        }else if ([val isKindOfClass:ONTAddress.class]){
            [data pushData:((ONTAddress *)val).publicKeyHash160];
        }else if ([val isKindOfClass:NSString.class]){
            [data pushData:[((NSString *)val) dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([val isKindOfClass:NSArray.class] || [val isKindOfClass:NSMutableArray.class]){
            NSArray<NSObject *> *a = (NSArray<NSObject *> *)val;
            [data addData:[BuildParams createCodeParamsScript:a]];
            [data pushNumber:@(a.count)];
            [data pushPack];
        }
    }
    
    return data;
}

@end
