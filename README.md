# ONTWallet
A lib for ONT wallet.


## Usage

#### Create a new wallet

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890"];
```

#### Import wallet with mnemonic

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" mnemonicText:@"use dinner opinion jewel detail inquiry popular enough diary upper concert identify"];
```

#### Import wallet with private key (hex)

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" privateKeyHex:@"c3cc0e31af0e085299b38962281fceeb39cca70ac4ecc3bbd46e25154a9fb317"];
```

#### Import wallet with wif

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L3nKDP3Wh3zmVktyFPGFegEUhJrpRcorosqk71X91rmjxnXtAFqb"];
```

#### Import wallet with keystore

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet-1" password:@"ONT123ont" keystore:@"{\"scrypt\":{\"r\":8,\"p\":8,\"n\":4096,\"dkLen\":64},\"address\":\"APjeNaCXGAVVXKPe6n8wYgFjeh3mLoqHWV\",\"key\": \"mLMLOpaZWhEcKNAN+p8rd43bmxDdY4t4DIK2eh1N2D51qhUCpnFlf4dl+op4uTk6\",\"label\":\"ONT-Wallet\",\"type\":\"A\",\"algorithm\":\"ECDSA\",\"salt\":\"\\/3qtmiaVilaqMdKVPPOeKA==\",\"parameters\":{\"curve\":\"P-256\"}}"];
```

#### Send asset ONT

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
NSString *txHex = [account makeTransferTxWithToken:ONTTokenTypeONT toAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" amount:@"10" gasPrice:500 gasLimit:20000];
NSLog(@"txHex == %@", txHex);

[[ONTRpcApi shareInstance] sendRawtransactionWithHexTx:txHex preExec:NO callback:^(NSString *txHash, NSError *error) {
    if (error) {
        NSLog(@"error == %@", error);
    } else {
        NSLog(@"txHash == %@", txHash);
    }
}];
```

#### Send asset ONG

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
NSString *txHex = [account makeTransferTxWithToken:ONTTokenTypeONG toAddress:@"AatvPQVe1RECTqoAxe9FtSdWGnABVjMExv" amount:@"3" gasPrice:500 gasLimit:20000];
NSLog(@"txHex == %@", txHex);

[[ONTRpcApi shareInstance] sendRawtransactionWithHexTx:txHex preExec:NO callback:^(NSString *txHash, NSError *error) {
    if (error) {
        NSLog(@"error == %@", error);
    } else {
        NSLog(@"txHash == %@", txHash);
    }
}];
```

#### Claim ONT

```
ONTAccount *account = [[ONTAccount alloc] initWithName:@"ONT-Wallet" password:@"ONT1234567890" wif:@"L2pGnv7waHczPursyuGDCBBU6GuoVBHkKF6uKjeFfiy584LQUqir"];
NSString *txHex = [account makeClaimOngTxWithAddress:account.address.address amount:@"0.000000001" gasPrice:500 gasLimit:20000];
NSLog(@"Claim ONG txHex == %@", txHex);

[[ONTRpcApi shareInstance] sendRawtransactionWithHexTx:txHex preExec:NO callback:^(NSString *txHash, NSError *error) {
NSLog(@"txHash == %@,error:%@",txHash, error);
    if (error) {
        NSLog(@"error == %@", error);
    } else {
        NSLog(@"txHash == %@", txHash);
    }
}];
```

#### OEP4 support
```
- (void)testOep4QueryBalanceOf {
    [NeoVM shareInstance].oep4.contractAddress = @"7b236dcf51b1004f6cce63ade53d5d61680a7442";
    
    // AUwN8rcsEK4TkiYZFCdcjdxChx2aEHG3DN
    // Ae67o5x6TUau9ctxSFAvicMEwEvLe6P93S
    [[NeoVM shareInstance].oep4 queryBalanceOf:@"AUwN8rcsEK4TkiYZFCdcjdxChx2aEHG3DN" queryCallback:^(NSString *balance, NSError *error) {
        NSLog(@"balance == %@, %@", balance, [error localizedDescription]);
    }];
}
```
