//
//  Oep4.m
//  ONTWallet
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import "Oep4.h"
#import "AbiFunction.h"
#import "Parameter.h"
#import "ONTAddress.h"
#import "NeoVM.h"
#import "NSString+Base58.h"
#import "NSData+Hash.h"
#import "ONTUtils.h"

@implementation Oep4 {
    NeoVM* _vm;
    ONTAddress* _contractAddressOnt;    // default is strong pointer
}

- (instancetype)initWithVM:(NeoVM*)vm {
    self = [super init];
    if (self) {
        _vm = vm;
    }
    return self;
}

- (void)queryBalanceOf:(NSString*)address
              queryCallback:(void (^)(NSString *balance, NSError *error))callback {
    ONTAddress* addr = [[ONTAddress alloc] initWithAddressString:address];
    
    Parameter* param = [[Parameter alloc] init];
    param.name = @"address";
    param.type = @"ByteArray";
    [param setValue:addr.publicKeyHash160];
    
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"balanceOf";
    func.returntype = @"Integer";
    [func addParam:param];
    
    [_vm sendTransactionWithContract:_contractAddressOnt
                            bySender:nil
                             byPayer:nil
                         payGasLimit:0
                         payGasPrice:0
                           withParam:func
                           isPreExec:YES
                            callback:^(id result, NSError *error) {
        if (error) {
            callback(@"0", error);
        } else {
            NSString* balance = [(NSDictionary*)result objectForKey:@"Result"];
            if ([@"" isEqualToString:balance]) {
                balance = @"0";
            }
            
            balance = [ONTUtils decimalNumberWithHexString:[NSString hexWithData:[[balance hexToData] reverse]]];
            callback(balance, nil);
        }
    }];
    
}

- (void)setContractAddress:(NSString *)contractAddress {
    _contractAddress = contractAddress;
    
    // need reverse
    _contractAddressOnt = [[ONTAddress alloc] initWithData:[[_contractAddress hexToData] reverse]];
}

@end
