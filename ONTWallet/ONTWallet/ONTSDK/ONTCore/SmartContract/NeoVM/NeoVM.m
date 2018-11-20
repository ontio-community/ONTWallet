//
//  NeoVM.m
//  ONTWallet
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import "NeoVM.h"
#import "Oep4.h"
#import "BuildParams.h"
#import "ONTInvokeCode.h"
#import "ONTAddress.h"
#import "ONTTransaction.h"
#import "ONTECKey.h"
#import "ONTAccount.h"
#import "ONTRpcApi.h"
#import "NSData+Extend.h"

@implementation NeoVM

static NeoVM *_instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        [_instance init];
    });
    return _instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _oep4 = [[Oep4 alloc] initWithVM:self];
    }
    return self;
}

- (void)sendTransactionWithContract:(ONTAddress *)contract
                         bySender:(ONTAccount *)sender
                          byPayer:(ONTAccount *)payer
                      payGasLimit:(long)gaslimit
                      payGasPrice:(long)gasprice
                        withParam:(AbiFunction *)param
                        isPreExec:(Boolean)preExec
                         callback:(void (^)(id result, NSError *error))callback {
    NSData* p = nil;
    if (param) {
        p = [BuildParams serializeAbiFunction:param];
    } else {
        p = [[NSData alloc] init];
    }
    
    ONTTransaction* tx = [ONTInvokeCode invokeNeoCodeTransaction:contract
                                                      initMethod:nil
                                                            args:p
                                                           payer:preExec ? nil : payer.address
                                                        gasLimit:preExec ? 0 : gaslimit
                                                        gasPrice:preExec ? 0 : gasprice];

    if (sender) {
        [tx addSign:sender];
        if ([sender isEqualToAccount:payer]) {
            [tx addSign:payer];
        }
    }

    NSString *txHex = tx.toRawByte.hexString;
    [[ONTRpcApi shareInstance] sendRawtransactionWithHexTx:txHex preExec:preExec callback:callback];
}

@end
