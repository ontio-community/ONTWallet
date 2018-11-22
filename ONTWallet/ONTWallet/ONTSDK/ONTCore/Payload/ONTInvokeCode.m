//
//  ONTInvokeCode.m
//  ONTWallet
//
//  Created by Yuzhiyou on 2018/7/24.
//  Copyright © 2018年 Yuzhiyou. All rights reserved.
//

#import "ONTInvokeCode.h"
#import "NSMutableData+ONTScriptBuilder.h"
#import "NSMutableData+Extend.h"

#define NATIVE_INVOKE_NAME @"Ontology.Native.Invoke"

@implementation ONTInvokeCode

- (instancetype)init{
    return [super initWithType:ONTTransactionTypeInvokeCode];
}
+ (ONTTransaction *)invokeCodeTransaction:(ONTAddress *)codeAddress initMethod:(NSString *)initMethod args:(NSData *)args payer:(ONTAddress *)payer gasLimit:(long)gasLimit gasPrice:(long)gasPrice{
    // Code
    NSMutableData *data = [NSMutableData new];
    if (args) {
        [data addData:args];
    }
    [data pushData:[initMethod dataUsingEncoding:NSUTF8StringEncoding]];
    [data pushData:codeAddress.publicKeyHash160];
    [data pushNumber:@(0)];
    [data addOpcode:ONT_OPCODE_SYSCALL];
    [data pushData:[NATIVE_INVOKE_NAME dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    ONTInvokeCode *invokeCode = [[ONTInvokeCode alloc] init];
    invokeCode.nonce = arc4random_uniform(INT_MAX);
    invokeCode.gasLimit = gasLimit;
    invokeCode.gasPrice = gasPrice;
    invokeCode.payer = payer;
    invokeCode.code = data;

    return invokeCode;
}

+ (ONTTransaction *)invokeNeoCodeTransaction:(ONTAddress *)codeAddress initMethod:(NSString *)initMethod args:(NSData *)args payer:(ONTAddress *)payer gasLimit:(long)gasLimit gasPrice:(long)gasPrice {
    NSMutableData *data = [NSMutableData new];
    
    [data addData:args];
    [data addByte:(Byte)0x67];
    [data addData:codeAddress.publicKeyHash160];
    
    ONTInvokeCode *invokeCode = [[ONTInvokeCode alloc] init];
    invokeCode.nonce = arc4random_uniform(INT_MAX);
    invokeCode.gasLimit = gasLimit;
    invokeCode.gasPrice = gasPrice;
    invokeCode.code = data;
    if (payer) {
        invokeCode.payer = payer;
    }
    return invokeCode;
}

/**
 * @brief Obtaining Exclusive byte stream data
 */
- (void)toExclusiveByte:(NSMutableData *)stream{
    [stream ont_appendVarData:_code];
}
@end
