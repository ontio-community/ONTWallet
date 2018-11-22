//
//  Oep4.h
//  ONTWallet
//
//  Created by admin on 2018/11/13.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#ifndef Oep4_h
#define Oep4_h

#import <Foundation/Foundation.h>

@class NeoVM;
@class ONTAccount;

@interface Oep4 : NSObject

@property (nonatomic,strong) NSString* contractAddress;

- (instancetype)initWithVM:(NeoVM*)vm;

- (void)sendInit:(ONTAccount*)acct
          byGasPayer:(ONTAccount*)payer
         useGasLimit:(long)gaslimit
         useGasPrice:(long)gasprice
             preExec:(BOOL)isPreExec
       queryCallback:(void (^)(id result, NSError *error))callback;

- (void)queryBalanceOf:(NSString*)address
              queryCallback:(void (^)(NSString *balance, NSError *error))callback;
- (void)queryDecimalsWithQueryCallback:(void (^)(NSString *val, NSError *error))callback;
- (void)queryTotalSupply:(void (^)(NSString *val, NSError *error))callback;
- (void)queryName:(void (^)(NSString *val, NSError *error))callback;
- (void)querySymbol:(void (^)(NSString *val, NSError *error))callback;

- (void)sendTransfer:(ONTAccount*)from
                  to:(NSString*)to
          withAmount:(long)amount
          byGasPayer:(ONTAccount*)payer
         useGasLimit:(long)gaslimit
         useGasPrice:(long)gasprice
             preExec:(BOOL)isPreExec
       queryCallback:(void (^)(id result, NSError *error))callback;

- (void)sendApprove:(ONTAccount*)owner
          toSpender:(NSString*)spender
          withAmount:(long)amount
          byGasPayer:(ONTAccount*)payer
         useGasLimit:(long)gaslimit
         useGasPrice:(long)gasprice
             preExec:(BOOL)isPreExec
       queryCallback:(void (^)(id result, NSError *error))callback;

- (void)sendTransferFrom:(ONTAccount*)sender
                    from:(NSString*)from
                      to:(NSString*)to
              withAmount:(long)amount
              byGasPayer:(ONTAccount*)payer
             useGasLimit:(long)gaslimit
             useGasPrice:(long)gasprice
                 preExec:(BOOL)isPreExec
           queryCallback:(void (^)(id result, NSError *error))callback;

- (void)queryAllowance:(NSString*)owner
           withSpender:(NSString*)spender
         queryCallback:(void (^)(NSString *balance, NSError *error))callback;

@end

#endif /* Oep4_h */
