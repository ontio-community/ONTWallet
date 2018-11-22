//
//  NeoVM.h
//  ONTWallet
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Oep4;
@class ONTAccount;
@class AbiFunction;
@class ONTAddress;

@interface NeoVM : NSObject

@property (nonatomic,readonly,strong) Oep4* oep4;

+ (instancetype)shareInstance;

- (void)sendTransactionWithContract:(ONTAddress*)contract
                         bySender:(ONTAccount*) sender
                          byPayer:(ONTAccount*) payer
                      payGasLimit:(long)gaslimit
                      payGasPrice:(long)gasprice
                        withParam:(AbiFunction*)param
                        isPreExec:(Boolean)preExec
                         callback:(void (^)(id result, NSError *error))callback;

@end
