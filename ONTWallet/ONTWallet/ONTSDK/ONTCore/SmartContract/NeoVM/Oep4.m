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
#import "ONTLong.h"
#import "ONTAccount.h"

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

- (void)setContractAddress:(NSString *)contractAddress {
    _contractAddress = contractAddress;
    
    // need reverse
    _contractAddressOnt = [[ONTAddress alloc] initWithData:[[_contractAddress hexToData] reverse]];
}

- (void)sendInit:(ONTAccount*)acct
      byGasPayer:(ONTAccount*)payer
     useGasLimit:(long)gaslimit
     useGasPrice:(long)gasprice
         preExec:(BOOL)isPreExec
   queryCallback:(void (^)(id result, NSError *error))callback {
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"init";
    func.returntype = @"Boolean";
    
    [_vm sendTransactionWithContract:_contractAddressOnt
                            bySender:acct
                             byPayer:payer
                         payGasLimit:gaslimit
                         payGasPrice:gasprice
                           withParam:func
                           isPreExec:isPreExec
                            callback:callback];
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

- (void)queryDecimalsWithQueryCallback:(void (^)(NSString *val, NSError *error))callback {
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"decimals";
    func.returntype = @"Integer";

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
                                    NSString* rlt = [(NSDictionary*)result objectForKey:@"Result"];
                                    if ([@"" isEqualToString:rlt]) {
                                        rlt = @"0";
                                    }
                                    
                                    callback(rlt, nil);
                                }
                            }];

}

- (void)queryTotalSupply:(void (^)(NSString *val, NSError *error))callback {
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"totalSupply";
    func.returntype = @"Integer";
    
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
                                    NSString* rlt = [(NSDictionary*)result objectForKey:@"Result"];
                                    if ([@"" isEqualToString:rlt]) {
                                        rlt = @"0";
                                    }
                                    
                                    rlt = [ONTUtils decimalNumberWithHexString:[NSString hexWithData:[[rlt hexToData] reverse]]];
                                    
                                    callback(rlt, nil);
                                }
                            }];
}

- (void)queryParam:(NSString*)funcName ReturnedString:(void (^)(NSString *val, NSError *error))callback {
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = funcName;
    func.returntype = @"String";
    
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
                                    NSString* rlt = [(NSDictionary*)result objectForKey:@"Result"];
                                    if ([@"" isEqualToString:rlt]) {
                                        rlt = @"0";
                                    }
                                    
                                    rlt = [[NSString alloc] initWithData:[rlt hexToData] encoding:NSASCIIStringEncoding];
                                    
                                    callback(rlt, nil);
                                }
                            }];
}

- (void)queryName:(void (^)(NSString *val, NSError *error))callback {
    [self queryParam:@"name" ReturnedString:callback];
}

- (void)querySymbol:(void (^)(NSString *val, NSError *error))callback {
    [self queryParam:@"symbol" ReturnedString:callback];
}

- (void)sendTransfer:(ONTAccount*)from
                  to:(NSString*)to
          withAmount:(long)amount
          byGasPayer:(ONTAccount*)payer
         useGasLimit:(long)gaslimit
         useGasPrice:(long)gasprice
             preExec:(BOOL)isPreExec
       queryCallback:(void (^)(id result, NSError *error))callback {
    
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"transfer";
    func.returntype = @"Boolean";
    
    Parameter* param0 = [[Parameter alloc] init];
    param0.name = @"from";
    param0.type = @"ByteArray";
    [param0 setValue:from.address.publicKeyHash160];
    [func addParam:param0];
    
    ONTAddress* toaddr = [[ONTAddress alloc] initWithAddressString:to];
    Parameter* param1 = [[Parameter alloc] init];
    param1.name = @"to";
    param1.type = @"ByteArray";
    [param1 setValue:toaddr.publicKeyHash160];
    [func addParam:param1];
    
    Parameter* param2 = [[Parameter alloc] init];
    param2.name = @"value";
    param2.type = @"Integer";
    [param2 setValue:[[ONTLong alloc] initWithLong:amount]];
    [func addParam:param2];
    
    [_vm sendTransactionWithContract:_contractAddressOnt
                            bySender:from
                             byPayer:payer
                         payGasLimit:gaslimit
                         payGasPrice:gasprice
                           withParam:func
                           isPreExec:isPreExec
                            callback:callback];

}

- (void)sendApprove:(ONTAccount*)owner
          toSpender:(NSString*)spender
         withAmount:(long)amount
         byGasPayer:(ONTAccount*)payer
        useGasLimit:(long)gaslimit
        useGasPrice:(long)gasprice
            preExec:(BOOL)isPreExec
      queryCallback:(void (^)(id result, NSError *error))callback {
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"approve";
    func.returntype = @"Boolean";
    
    Parameter* param0 = [[Parameter alloc] init];
    param0.name = @"owner";
    param0.type = @"ByteArray";
    [param0 setValue:owner.address.publicKeyHash160];
    [func addParam:param0];
    
    ONTAddress* spenderaddr = [[ONTAddress alloc] initWithAddressString:spender];
    Parameter* param1 = [[Parameter alloc] init];
    param1.name = @"spender";
    param1.type = @"ByteArray";
    [param1 setValue:spenderaddr.publicKeyHash160];
    [func addParam:param1];
    
    Parameter* param2 = [[Parameter alloc] init];
    param2.name = @"amount";
    param2.type = @"Integer";
    [param2 setValue:[[ONTLong alloc] initWithLong:amount]];
    [func addParam:param2];
    
    [_vm sendTransactionWithContract:_contractAddressOnt
                            bySender:owner
                             byPayer:payer
                         payGasLimit:gaslimit
                         payGasPrice:gasprice
                           withParam:func
                           isPreExec:isPreExec
                            callback:callback];
}

- (void)sendTransferFrom:(ONTAccount*)sender
                    from:(NSString*)from
                      to:(NSString*)to
              withAmount:(long)amount
              byGasPayer:(ONTAccount*)payer
             useGasLimit:(long)gaslimit
             useGasPrice:(long)gasprice
                 preExec:(BOOL)isPreExec
           queryCallback:(void (^)(id result, NSError *error))callback {
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"transferFrom";
    func.returntype = @"Boolean";
    
    Parameter* param0 = [[Parameter alloc] init];
    param0.name = @"spender";
    param0.type = @"ByteArray";
    [param0 setValue:sender.address.publicKeyHash160];
    [func addParam:param0];
    
    ONTAddress* fromaddr = [[ONTAddress alloc] initWithAddressString:from];
    Parameter* param1 = [[Parameter alloc] init];
    param1.name = @"from";
    param1.type = @"ByteArray";
    [param1 setValue:fromaddr.publicKeyHash160];
    [func addParam:param1];
    
    ONTAddress* toaddr = [[ONTAddress alloc] initWithAddressString:to];
    Parameter* param2 = [[Parameter alloc] init];
    param2.name = @"to";
    param2.type = @"ByteArray";
    [param2 setValue:toaddr.publicKeyHash160];
    [func addParam:param2];
    
    Parameter* param3 = [[Parameter alloc] init];
    param3.name = @"amount";
    param3.type = @"Integer";
    [param3 setValue:[[ONTLong alloc] initWithLong:amount]];
    [func addParam:param3];
    
    [_vm sendTransactionWithContract:_contractAddressOnt
                            bySender:sender
                             byPayer:payer
                         payGasLimit:gaslimit
                         payGasPrice:gasprice
                           withParam:func
                           isPreExec:isPreExec
                            callback:callback];

}

- (void)queryAllowance:(NSString*)owner
           withSpender:(NSString*)spender
         queryCallback:(void (^)(NSString *balance, NSError *error))callback {
    AbiFunction* func = [[AbiFunction alloc] init];
    func.name = @"allowance";
    func.returntype = @"Integer";
    
    ONTAddress* owneraddr = [[ONTAddress alloc] initWithAddressString:owner];
    Parameter* param0 = [[Parameter alloc] init];
    param0.name = @"owner";
    param0.type = @"ByteArray";
    [param0 setValue:owneraddr.publicKeyHash160];
    [func addParam:param0];
    
    ONTAddress* spenderaddr = [[ONTAddress alloc] initWithAddressString:spender];
    Parameter* param1 = [[Parameter alloc] init];
    param1.name = @"spender";
    param1.type = @"ByteArray";
    [param1 setValue:spenderaddr.publicKeyHash160];
    [func addParam:param1];

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
                                    NSString* rlt = [(NSDictionary*)result objectForKey:@"Result"];
                                    if ([@"" isEqualToString:rlt]) {
                                        rlt = @"0";
                                    }
                                    
                                    rlt = [ONTUtils decimalNumberWithHexString:[NSString hexWithData:[[rlt hexToData] reverse]]];
                                    
                                    callback(rlt, nil);
                                }
                            }];

}

@end
