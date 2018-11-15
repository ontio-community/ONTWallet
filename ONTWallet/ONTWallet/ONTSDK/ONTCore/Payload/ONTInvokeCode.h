//
//  ONTInvokeCode.h
//  ONTWallet
//
//  Created by Yuzhiyou on 2018/7/24.
//  Copyright © 2018年 Yuzhiyou. All rights reserved.
//

#import "ONTTransaction.h"

@interface ONTInvokeCode : ONTTransaction

@property (nonatomic,strong) NSData *code;

+ (ONTTransaction *)invokeCodeTransaction:(ONTAddress *)codeAddress initMethod:(NSString *)initMethod args:(NSData *)args payer:(ONTAddress *)payer gasLimit:(long)gasLimit gasPrice:(long)gasPrice;

+ (ONTTransaction *)invokeNeoCodeTransaction:(ONTAddress *)codeAddress initMethod:(NSString *)initMethod args:(NSData *)args payer:(ONTAddress *)payer gasLimit:(long)gasLimit gasPrice:(long)gasPrice;

@end
