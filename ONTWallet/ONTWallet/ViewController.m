//
//  ViewController.m
//  ONTWallet
//
//  Created by zhangyutao on 2018/7/13.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import "ViewController.h"
#import "ONT.h"
#import "ONTUtils.h"
#import "ONTAccount.h"
#import "ONTRpcApi.h"
#import "ONTBalance.h"
#import "ONTMnemonicCode.h"
#import "Oep4.h"
#import "NeoVM.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creat wallet
//    [self testCreateNewWallet];
    
//    [self testOep4Init];
//    [self testSendOep4];
    [self testOep4QueryBalanceOf];
//    [self testOep4QueryDecimals];
//    [self testOep4Queries];
    
//    [self testOep4Approve];
//    [self testOep4SendTransferFrom];
//    [self testOep4QueryAllowance];
    
    // GET Get Best Block Hash
    //[self testGetBestBlockHash];
    
    // GET Block With TxHash
    //[self testGetBlockWithTxHash];
    
    // GET Block With Height
    //[self testGetBlockWithHeight];
    
    //GET Block Count
    //[self testGetBlockCount];
    
    //GET Block Hash With Height
    //[self testGetBlockHashWithHeight];
    
    ///GET Connection Count
    //[self testGetConnectionCount];
    
    //GET Rawtransaction With TxHash
    //[self testGetRawtransactionWithTxHash];
    
    // Send ONT
    //[self testSendONT];
    
    // Send ONG
    //[self testSendONG];
    
    // Claim ONG
    //[self testClaimONG];
    
    //GET Storage WithScript Hash
    //[self testGetStorageWithScriptHash];
    
    //GET Version
    //[self testGetVersion];
    
    //GET Contract State With ScriptHash
    //[self testGetContractStateWithScriptHash];
    
    //Get Mempool TxCount
    //[self testGetMempoolTxCount];
    
    //Get Mempool TxState With TxHash
    //[self testGetMempoolTxStateWithTxHash];
    
    //Get Smart Code Event With TxHash
    //[self testGetSmartCodeEventWithTxHash];
    
    //Get Smart Code Event With Block Height
    //[self testGetSmartCodeEventWithBlockHeight];
    
    //Get Block Height With Txhash
    //[self testGetBlockHeightWithTxhash];
    
    //GET Balance
    //[self testGetBalabce];
    
    // Get Merkle Proof With TxHash
    //[self testGetMerkleProofWithTxHash];
    
    // GET Gas Price
    //[self testGetGasPrice];
    
    // Get Allowance With Asset ONT
    //[self testGetAllowanceWithAssetONT];
    
    // Get Allowance With Asset ONG
    //[self testGetAllowanceWithAssetONG];
    
    // GET Unbound Ong
    //[self testGetUnboundOng];
    
    // Get Block Txs With Height
    //[self testGetBlockTxsWithHeight];
    
    // Get Network ID
    //[self testGetNetworkID];
    
}

- (void)testCreateNewWallet {
    // acct1
    // L44EwAY5X8afopnLxbytoU9KGH9pCZP37WxrvnDgvMkei9wrBfUe
    // AUvfyDwjEeCrBZWYTakazA9hQVQnaxYX46
    
    // acct2
    // L5YLmKhPooKXgE81dRdiqqnBFUSXdsv34DmStex1Xu8fDtyAJ4Bj
    // AUwN8rcsEK4TkiYZFCdcjdxChx2aEHG3DN
    
    ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT123ont"];
    NSLog(@"=== 【ONTAccount】=== wif:%@", [account.privateKey toWif]);
    NSLog(@"=== 【ONTAccount】=== address:%@", account.address.address);
    NSLog(@"=== 【ONTAccount】=== \n%@", account.description);
    NSLog(@"=== 【ONTAccount】=== \n%@", account.encryptMnemonicText);
    NSString *mnemonicText = [ONTMnemonicCode decryptMnemonicCode:account.encryptMnemonicText password:@"ONT123ont" address:account.address.address];
    if ([mnemonicText isEqualToString:account.mnemonicText]) {
        NSLog(@"助记词解析正确！！！");
    } else {
        NSLog(@"助记词解析错误！！！");
    }
}

- (void)testGetBestBlockHash {
    [[ONTRpcApi shareInstance] getBestBlockHashCallback:^(NSString *txHash, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"txHash == %@", txHash);
        }
    }];
}

- (void)testGetBlockWithTxHash {
    [[ONTRpcApi shareInstance] getBlockWithTxHash:@"8d1e6acf0e304cba71e92fb47cb67e72b586b646508cee941405bb2e2dddaee2" verbose:NO callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetBlockWithHeight {
    [[ONTRpcApi shareInstance] getBlockWithHeight:108172 verbose:NO callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetBlockCount {
    [[ONTRpcApi shareInstance] getBlockCountCallback:^(NSInteger blockCount, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"blockCount == %ld", (long)blockCount);
        }
    }];
}

- (void)testGetBlockHashWithHeight {
    [[ONTRpcApi shareInstance] getBlockHashWithHeight:108172 callback:^(NSString *txHash, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"txHash == %@", txHash);
        }
    }];
}

- (void)testGetConnectionCount {
    [[ONTRpcApi shareInstance] getConnectionCountCallback:^(NSInteger connectionCount, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"connectionCount == %ld", (long)connectionCount);
        }
    }];
}

- (void)testGetRawtransactionWithTxHash {
    [[ONTRpcApi shareInstance] getRawtransactionWithTxHash:@"8d1e6acf0e304cba71e92fb47cb67e72b586b646508cee941405bb2e2dddaee2" verbose:YES callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testSendONT {
    ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
    NSString *txHex = [account makeTransferTxWithToken:ONTTokenTypeONT toAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" amount:@"10" gasPrice:500 gasLimit:20000];
    NSLog(@"txHex == %@", txHex);
    
    [[ONTRpcApi shareInstance] sendRawtransactionWithHexTx:txHex preExec:NO callback:^(NSString *txHash, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"txHash == %@", txHash);
            NSLog(@"View on explorer：%@", kONTScanTxURL(txHash));
        }
    }];
}

- (void)testOep4QueryBalanceOf {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    // AUwN8rcsEK4TkiYZFCdcjdxChx2aEHG3DN
    // Ae67o5x6TUau9ctxSFAvicMEwEvLe6P93S
    [[NeoVM shareInstance].oep4 queryBalanceOf:@"AUwN8rcsEK4TkiYZFCdcjdxChx2aEHG3DN" queryCallback:^(NSString *balance, NSError *error) {
        NSLog(@"balance == %@, %@", balance, [error localizedDescription]);
    }];
}

- (void)testOep4QueryDecimals {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    [[NeoVM shareInstance].oep4 queryDecimalsWithQueryCallback:^(NSString *result, NSError *error) {
        NSLog(@"result == %@, %@", result, [error localizedDescription]);
    }];
}

- (void)testOep4Queries {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    [[NeoVM shareInstance].oep4 queryTotalSupply:^(NSString *result, NSError *error) {
        NSLog(@"result == %@, %@", result, [error localizedDescription]);
    }];
    [[NeoVM shareInstance].oep4 queryName:^(NSString *result, NSError *error) {
        NSLog(@"result == %@, %@", result, [error localizedDescription]);
    }];
    [[NeoVM shareInstance].oep4 querySymbol:^(NSString *result, NSError *error) {
        NSLog(@"result == %@, %@", result, [error localizedDescription]);
    }];
}

- (void)testOep4Init {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    ONTAccount *acct = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
    
    NSLog(@"from address:%@", acct.address.address);
    
    BOOL isPreExec = YES;
    [[NeoVM shareInstance].oep4 sendInit:acct
                              byGasPayer:acct
                             useGasLimit:0//10000000
                             useGasPrice:0//500
                                 preExec:isPreExec
                           queryCallback:^(id result, NSError *error) {
                                   //                                   NSLog(@"result == %@, %@", result, [error localizedDescription]);
                                   if (isPreExec) {
                                       NSString* gasConsumed = [(NSDictionary*)result objectForKey:@"Gas"];
                                       NSLog(@"\nGas == %@", result);
                                   } else {
                                       NSString* txhash = (NSString*)result;
                                       NSLog(@"\ntxhash == %@", txhash);
                                       [self testOep4QueryBalanceOf];
                                   }
                               }];

}
- (void)testSendOep4 {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    ONTAccount *from = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];

    NSLog(@"from address:%@", from.address.address);
    
    BOOL isPreExec = NO;
    [[NeoVM shareInstance].oep4 sendTransfer:from
                                          to:@"ASrLANryFnqwSt76h2YbhssdZeRGagRYem"
                                  withAmount:1000000000
                                  byGasPayer:from
                                 useGasLimit:20000
                                 useGasPrice:500
                                     preExec:isPreExec
                               queryCallback:^(id result, NSError *error) {
//                                   NSLog(@"result == %@, %@", result, [error localizedDescription]);
                                   if (isPreExec) {
                                       NSString* gasConsumed = [(NSDictionary*)result objectForKey:@"Gas"];
                                       NSLog(@"\nGas == %@", result);
                                   } else {
                                       NSString* txhash = (NSString*)result;
                                       NSLog(@"\ntxhash == %@", txhash);
                                       [self testOep4QueryBalanceOf];
                                   }
                               }];
}

- (void)testOep4Approve {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    ONTAccount *owner = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
    
    NSLog(@"from address:%@", owner.address.address);
    
    BOOL isPreExec = NO;
    [[NeoVM shareInstance].oep4 sendApprove:owner
                                  toSpender:@"AUvfyDwjEeCrBZWYTakazA9hQVQnaxYX46"
                                 withAmount:100000000
                                 byGasPayer:owner
                                useGasLimit:20000
                                useGasPrice:500
                                    preExec:isPreExec
                              queryCallback:^(id result, NSError *error) {
                                   if (isPreExec) {
                                       NSString* gasConsumed = [(NSDictionary*)result objectForKey:@"Gas"];
                                       NSLog(@"\nGas == %@", result);
                                   } else {
                                       NSString* txhash = (NSString*)result;
                                       NSLog(@"\ntxhash == %@", txhash);
                                       [self testOep4QueryAllowance];
                                   }
                               }];
}

- (void)testOep4SendTransferFrom {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    ONTAccount *sender = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT123ont" wif:@"L44EwAY5X8afopnLxbytoU9KGH9pCZP37WxrvnDgvMkei9wrBfUe"];
    
    NSLog(@"from address:%@", sender.address.address);
    
    BOOL isPreExec = NO;
    [[NeoVM shareInstance].oep4 sendTransferFrom:sender
                                            from:@"Ae67o5x6TUau9ctxSFAvicMEwEvLe6P93S"
                                              to:@"AUwN8rcsEK4TkiYZFCdcjdxChx2aEHG3DN"
                                      withAmount:10000000
                                      byGasPayer:sender
                                     useGasLimit:20000
                                     useGasPrice:500
                                         preExec:isPreExec
                                   queryCallback:^(id result, NSError *error) {
        if (isPreExec) {
            NSString* gasConsumed = [(NSDictionary*)result objectForKey:@"Gas"];
            NSLog(@"\nGas == %@", result);
        } else {
            NSString* txhash = (NSString*)result;
            NSLog(@"\ntxhash == %@", txhash);
            [self testOep4QueryAllowance];
        }
    }];
}

- (void)testOep4QueryAllowance {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    [[NeoVM shareInstance].oep4 queryAllowance:@"Ae67o5x6TUau9ctxSFAvicMEwEvLe6P93S"
                                   withSpender:@"AUvfyDwjEeCrBZWYTakazA9hQVQnaxYX46"
                                 queryCallback:^(NSString *balance, NSError *error) {
        NSLog(@"balance == %@, %@", balance, [error localizedDescription]);
    }];

}

- (void)testSendONG {
    ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
    NSString *txHex = [account makeTransferTxWithToken:ONTTokenTypeONG toAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" amount:@"3" gasPrice:500 gasLimit:20000];
    NSLog(@"txHex == %@", txHex);
    
    [[ONTRpcApi shareInstance] sendRawtransactionWithHexTx:txHex preExec:NO callback:^(NSString *txHash, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"txHash == %@", txHash);
            NSLog(@"View on explorer：%@", kONTScanTxURL(txHash));
        }
    }];
}

- (void)testClaimONG {
    ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
    NSString *txHex = [account makeClaimOngTxWithAddress:account.address.address amount:@"0.000000001" gasPrice:500 gasLimit:20000];
    NSLog(@"Claim ONG txHex == %@", txHex);
    
    [[ONTRpcApi shareInstance] sendRawtransactionWithHexTx:txHex preExec:NO callback:^(NSString *txHash, NSError *error) {
        NSLog(@"txHash == %@,error:%@",txHash, error);
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"txHash == %@", txHash);
            NSLog(@"View on explorer：%@", kONTScanTxURL(txHash));
        }
    }];
}

- (void)testGetStorageWithScriptHash {
    [[ONTRpcApi shareInstance] getStorageWithScriptHash:@"03febccf81ac85e3d795bc5cbd4e84e907812aa3" key:@"5065746572" callback:^(id result, NSError *error) {
    }];
}

- (void)testGetVersion {
    [[ONTRpcApi shareInstance] getVersionCallback:^(id result, NSError *error) {
    }];
}

- (void)testGetContractStateWithScriptHash {
    [[ONTRpcApi shareInstance] getContractStateWithScriptHash:@"0239dcf9b4a46f15c5f23f20d52fac916a0bac0d" verbose:YES  callback:^(id result, NSError *error) {
    }];
}

- (void)testGetMempoolTxCount {
    [[ONTRpcApi shareInstance] getMempoolTxCountCallback:^(id result, NSError *error) {
    }];
}

- (void)testGetMempoolTxStateWithTxHash {
    [[ONTRpcApi shareInstance] getMempoolTxStateWithTxHash:@"8d1e6acf0e304cba71e92fb47cb67e72b586b646508cee941405bb2e2dddaee2" callback:^(id result, NSError *error) {
    }];
}

- (void)testGetSmartCodeEventWithTxHash {
    [[ONTRpcApi shareInstance] getSmartCodeEventWithTxHash:@"8d1e6acf0e304cba71e92fb47cb67e72b586b646508cee941405bb2e2dddaee2" callback:^(NSInteger state, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"state == %ld", (long)state);
        }
    }];
}

- (void)testGetSmartCodeEventWithBlockHeight {
    [[ONTRpcApi shareInstance] getSmartCodeEventWithBlockHeight:108172 callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetBlockHeightWithTxhash {
    [[ONTRpcApi shareInstance] getBlockHeightWithTxhash:@"8d1e6acf0e304cba71e92fb47cb67e72b586b646508cee941405bb2e2dddaee2" callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetBalabce {
    [[ONTRpcApi shareInstance] getBalanceWithAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" callback:^(NSArray *balances, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            for (ONTBalance *balance in balances) {
                NSLog(@"%@ == %@", balance.name, balance.balances);
            }
        }
    }];
}

- (void)testGetMerkleProofWithTxHash {
    [[ONTRpcApi shareInstance] getMerkleProofWithTxHash:@"8d1e6acf0e304cba71e92fb47cb67e72b586b646508cee941405bb2e2dddaee2" callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetGasPrice {
    [[ONTRpcApi shareInstance] getGaspriceCallback:^(NSString *gasprice, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"gasprice == %@", gasprice);
        }
    }];
}

- (void)testGetAllowanceWithAssetONT {
    [[ONTRpcApi shareInstance] getAllowanceWithAsset:@"ONT" fromAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" toAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetAllowanceWithAssetONG {
    [[ONTRpcApi shareInstance] getAllowanceWithAsset:@"ONG" fromAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" toAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetUnboundOng {
    [[ONTRpcApi shareInstance] getUnboundOng:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" callback:^(NSString *amount, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"amount == %@", amount);
            NSLog(@"amount == %@", [ONTUtils decimalNumber:amount byDividingBy:@"1000000000"]);
        }
    }];
}

- (void)testGetBlockTxsWithHeight {
    [[ONTRpcApi shareInstance] getBlockTxsWithHeight:108172 callback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)testGetNetworkID {
    [[ONTRpcApi shareInstance] getNetworkIDCallback:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error == %@", error);
        } else {
            NSLog(@"result == %@", result);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
