//
//  ONTAccount.m
//  ONTWallet
//
//  Created by Yuzhiyou on 2018/7/13.
//  Copyright © 2018年 Yuzhiyou. All rights reserved.
//

#import "ONTAccount.h"
#import "crypto_scrypt.h"
#import "NSData+Extend.h"
#import "NSData+Hash.h"
#import "NSString+Base58.h"
#import "ONTMnemonicCode.h"
#import "ONTDeterministicKey.h"
#import "ONTECKey.h"
#import "IAGAesGcm.h"
#import "ONTStruct.h"
#import "ONTTransaction.h"
#import "ONTNativeBuildParams.h"
#import "ONTInvokeCode.h"
#import "ONTRpcApi.h"

@interface ONTAccount()

@property(nonatomic, readonly) NSString *password;

@end

@implementation ONTAccount

- (instancetype)initWithName:(NSString *)name password:(NSString *)password {
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
        
        // 随机数
        NSMutableData *randomData = [NSMutableData dataWithLength:16];
        int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
        if (result != noErr) {
            return nil;
        }
        // 助记词
        ONTMnemonicCode *mnemonicCode = [ONTMnemonicCode shareInstance];
        NSString *mnemonicText = [mnemonicCode toMnemonic:randomData];
        NSLog(@"助记词[%@]", mnemonicText);
        if (![mnemonicCode check:mnemonicText]) {
            return nil;
        }
        _mnemonicText = mnemonicText;
        
        NSData *seed = [mnemonicCode toSeed:[mnemonicText componentsSeparatedByString:@" "] withPassphrase:@""];
        
        ONTDeterministicKey *rootKey = [[ONTDeterministicKey alloc] initWithSeed:seed];
        
        NSMutableArray *path = [NSMutableArray new];
        [path addObject:[[ChildNumber alloc] initWithPath:44 Hardened:YES]];
        [path addObject:[[ChildNumber alloc] initWithPath:1024 Hardened:YES]];
        [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:YES]];
        [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
        [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
        
        ONTECKey *ecKey = [[rootKey Derive:path] toECKey];
        _privateKey = [[ONTPrivateKey alloc] initWithData:ecKey.privateKeyAsData];
        _publicKey = [[ONTPublicKey alloc] initWithData:ecKey.publicKeyAsData];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name password:(NSString *)password mnemonicText:(NSString *)mnemonicText {
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
        
        // 助记词
        ONTMnemonicCode *mnemonicCode  = [ONTMnemonicCode shareInstance];
        if (![mnemonicCode check:mnemonicText]) {
            return nil;
        }
        _mnemonicText = mnemonicText;
        
        NSData *seed = [mnemonicCode toSeed:[mnemonicText componentsSeparatedByString:@" "] withPassphrase:@""];
        
        ONTDeterministicKey *rootKey = [[ONTDeterministicKey alloc] initWithSeed:seed];
        
        NSMutableArray *path = [NSMutableArray new];
        [path addObject:[[ChildNumber alloc] initWithPath:44 Hardened:YES]];
        [path addObject:[[ChildNumber alloc] initWithPath:1024 Hardened:YES]];
        [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:YES]];
        [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
        [path addObject:[[ChildNumber alloc] initWithPath:0 Hardened:NO]];
        
        ONTECKey *ecKey = [[rootKey Derive:path] toECKey];
        _privateKey = [[ONTPrivateKey alloc] initWithData:ecKey.privateKeyAsData];
        _publicKey = [[ONTPublicKey alloc] initWithData:ecKey.publicKeyAsData];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name password:(NSString *)password privateKeyHex:(NSString *)privateKeyHex {
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
        
        ONTPrivateKey *privateKey = [[ONTPrivateKey alloc] initWithPrivateKeyHex:privateKeyHex];
        ONTECKey *ecKey = [[ONTECKey alloc] initWithPriKey:privateKey.data];
        _privateKey = [[ONTPrivateKey alloc] initWithData:ecKey.privateKeyAsData];
        _publicKey = [[ONTPublicKey alloc] initWithData:ecKey.publicKeyAsData];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name password:(NSString *)password wif:(NSString *)wif {
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
        
        ONTPrivateKey *privateKey = [[ONTPrivateKey alloc] initWithWif:wif];
        ONTECKey *ecKey = [[ONTECKey alloc] initWithPriKey:privateKey.data];
        _privateKey = [[ONTPrivateKey alloc] initWithData:ecKey.privateKeyAsData];
        _publicKey = [[ONTPublicKey alloc] initWithData:ecKey.publicKeyAsData];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name password:(NSString *)password keystore:(NSString *)keystore {
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
        
        // Keystore
        NSData *jsonData = [keystore dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *keystoreDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&error];
        if (error) {
            return nil;
        }
        // 检查参数
        if (![keystoreDic objectForKey:@"address"] ||
            ![keystoreDic objectForKey:@"salt"] ||
            ![keystoreDic objectForKey:@"key"] ||
            ![keystoreDic objectForKey:@"type"] ||
            ![keystoreDic objectForKey:@"algorithm"]) {
            return nil;
        }
        if (![[keystoreDic objectForKey:@"algorithm"] isEqualToString:@"ECDSA"] ||
            ![[keystoreDic objectForKey:@"type"] isEqualToString:@"A"]) {
            return nil;
        }
        if (name == nil && [keystoreDic objectForKey:@"label"]) {
            _name = [keystoreDic objectForKey:@"label"];
        }
        int n = [keystoreDic[@"scrypt"][@"n"] intValue];
        int r = [keystoreDic[@"scrypt"][@"r"] intValue];
        int p = [keystoreDic[@"scrypt"][@"p"] intValue];
        int dkLen = [keystoreDic[@"scrypt"][@"dkLen"] intValue];
        char stop = 0;
        
        NSData *passwordData = [[_password precomposedStringWithCompatibilityMapping] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *salt = [NSData decodeBase64:[keystoreDic objectForKey:@"salt"]];
        
        NSString *address = [keystoreDic objectForKey:@"address"];
        
        NSData *key = [NSData decodeBase64:[keystoreDic objectForKey:@"key"]];
        
        NSMutableData *derivedkey = [NSMutableData dataWithLength:dkLen];
        int status = crypto_scrypt(passwordData.bytes, (int)passwordData.length, salt.bytes, salt.length, n, r, p, derivedkey.mutableBytes,derivedkey.length, &stop);
        // Bad scrypt parameters
        if (status == -1) {
            NSLog(@"Bad scrypt parameters");
            return nil;
        }
        NSData *derivedhalf2 = [derivedkey subdataWithRange:NSMakeRange(32, 32)];
        NSData *iv = [derivedkey subdataWithRange:NSMakeRange(0, 12)];
        
        // AES GCM
        NSData *encryptedkey = [key subdataWithRange:NSMakeRange(0, key.length-IAGAuthenticationTagLength128)];
        NSData *tag = [key subdataWithRange:NSMakeRange(key.length-IAGAuthenticationTagLength128,IAGAuthenticationTagLength128)];
        NSData *aad = [address dataUsingEncoding:NSUTF8StringEncoding];
        NSData *privateKeyData = [encryptedkey aesGcm128Decrypt:derivedhalf2 iv:iv aad:aad tag:tag];
        if (!privateKeyData) {
            return nil;
        }
        // Account
        ONTECKey *ecKey = [[ONTECKey alloc] initWithPriKey:privateKeyData];
        _privateKey = [[ONTPrivateKey alloc] initWithData:ecKey.privateKeyAsData];
        _publicKey = [[ONTPublicKey alloc] initWithData:ecKey.publicKeyAsData];
        NSLog(@"%@", _publicKey.toAddress.address);
        if (![_publicKey.toAddress.address isEqualToString:address]) {
            return nil;
        }
    }
    return self;
}

- (ONTAddress *)address {
    return _publicKey.toAddress;
}

- (NSString *)encryptMnemonicText {
    if (_mnemonicText) {
        return [ONTMnemonicCode encryptMnemonicCode:_mnemonicText password:_password address:_publicKey.toAddress.address];
    }
    return nil;
}

- (NSString *)privateKeyHex {
    return _privateKey.data.hexString;
}

- (NSString *)wif {
    return _privateKey.toWif;
}

- (NSString *)keystore {
    return [self encrypt:self.password];
}

// 加密
- (NSString *)encrypt:(NSString *)password {
    int n = 4096;
    int r = 8;
    int p = 8;
    int dkLen = 64;
    char stop = 0;
    
    // Salt
    NSData *salt = [NSData randomWithSize:16];
    // Result
    NSMutableDictionary *keystore = [NSMutableDictionary dictionary];
    [keystore setObject:@"A" forKey:@"type"];
    [keystore setObject:_name forKey:@"label"];
    [keystore setObject:_publicKey.toAddress.address forKey:@"address"];
    [keystore setObject:@{
                          @"r":@(r),
                          @"p":@(p),
                          @"n":@(n),
                          @"dkLen":@(dkLen)
                          } forKey:@"scrypt"];
    [keystore setObject:@{
                          @"curve":@"P-256"
                          } forKey:@"parameters"];
    [keystore setObject:@"ECDSA" forKey:@"algorithm"];
    [keystore setObject:[[NSString alloc] initWithData:salt.base64 encoding:NSUTF8StringEncoding] forKey:@"salt"];
    
    // Private Key
    NSData *passwordData = [[password precomposedStringWithCompatibilityMapping] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *derivedkey = [NSMutableData dataWithLength:dkLen];
    int status = crypto_scrypt(passwordData.bytes, (int)passwordData.length, salt.bytes, salt.length, n, r, p, derivedkey.mutableBytes,derivedkey.length, &stop);
    // Bad scrypt parameters
    if (status == -1) {
        NSLog(@"Bad scrypt parameters");
        return nil;
    }
    NSData *derivedhalf2 = [derivedkey subdataWithRange:NSMakeRange(32, 32)];
    NSData *iv = [derivedkey subdataWithRange:NSMakeRange(0, 12)];
    
    // AES GCM
    NSData *aad = [_publicKey.toAddress.address dataUsingEncoding:NSUTF8StringEncoding];
    IAGCipheredData *cipheredData  = [_privateKey.data aesGcm128Encrypt:derivedhalf2 iv:iv aad:aad];
    
    // Key
    NSMutableData *key = [NSMutableData new];
    [key appendData:[NSData dataWithBytes:cipheredData.cipheredBuffer length:cipheredData.cipheredBufferLength]];
    [key appendData:[NSData dataWithBytes:cipheredData.authenticationTag length:cipheredData.authenticationTagLength]];
    [keystore setObject:[[NSString alloc] initWithData:key.base64 encoding:NSUTF8StringEncoding] forKey:@"key"];
    
    // Json -> String
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:keystore
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)makeTransferTxWithToken:(ONTTokenType)tokenType toAddress:(NSString *)toAddress amount:(NSString *)amount gasPrice:(long)gasPrice gasLimit:(long)gasLimit {
    ONTECKey *ecKey = [[ONTECKey alloc] initWithPriKey:self.privateKey.data];
    ONTPublicKey *publicKey = [[ONTPublicKey alloc] initWithData:ecKey.publicKeyAsData];
    
    ONTAddress *from = publicKey.toAddress;
    ONTAddress *to = [[ONTAddress alloc] initWithAddressString:toAddress];
    
    ONTAddress *contractAddress = nil;
    if (tokenType == ONTTokenTypeONT) {
        contractAddress = [[ONTAddress alloc] initWithData:ONT_CONTRACT.hexToData];
    } else {
        contractAddress = [[ONTAddress alloc] initWithData:ONG_CONTRACT.hexToData];
    }
    
    ONTStruct *ontStruct = [[ONTStruct alloc] init];
    [ontStruct add:from];
    [ontStruct add:to];
    NSDecimalNumber *amountValue = [NSDecimalNumber decimalNumberWithString:amount];
    if (tokenType == ONTTokenTypeONT) {
        [ontStruct add:[[ONTLong alloc] initWithLong:(long)(amountValue.doubleValue)]];
    } else if (tokenType == ONTTokenTypeONG) {
        [ontStruct add:[[ONTLong alloc] initWithLong:(long)(amountValue.doubleValue*1000000000)]];
    }
    
    ONTStructs *structs = [[ONTStructs alloc] init];
    [structs add:ontStruct];
    
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:structs];
    
    NSData *args = [ONTNativeBuildParams createCodeParamsScript:array];
    ONTTransaction *transaction = [ONTInvokeCode invokeCodeTransaction:contractAddress initMethod:@"transfer" args:args payer:from gasLimit:gasLimit gasPrice:gasPrice];
    
    // 签名
    ECKeySignature *sign = [ecKey sign:transaction.getSignHash];
    [transaction.signatures addObject:[[ONTSignature alloc] initWithPublicKey:ecKey.publicKeyAsData signature:sign.toDataNoV]];
    
    NSString *txHex = transaction.toRawByte.hexString;
    return txHex;
}

- (NSString *)makeClaimOngTxWithAddress:(NSString *)address amount:(NSString *)amount gasPrice:(long)gasPrice gasLimit:(long)gasLimit {
    ONTECKey *ecKey = [[ONTECKey alloc] initWithPriKey:self.privateKey.data];
    ONTPublicKey *publicKey = [[ONTPublicKey alloc] initWithData:ecKey.publicKeyAsData];
    
    ONTAddress *from = publicKey.toAddress;
    ONTAddress *to = [[ONTAddress alloc] initWithAddressString:address];
    
    ONTAddress *ontContractAddress = [[ONTAddress alloc] initWithData:ONT_CONTRACT.hexToData];
    ONTAddress *ongContractAddress = [[ONTAddress alloc] initWithData:ONG_CONTRACT.hexToData];
    
    ONTStruct *ontStruct = [[ONTStruct alloc] init];
    [ontStruct add:from];
    [ontStruct add:ontContractAddress];
    [ontStruct add:to];
    NSDecimalNumber *amountValue = [NSDecimalNumber decimalNumberWithString:amount];
    [ontStruct add:[[ONTLong alloc] initWithLong:(long)(amountValue.doubleValue*1000000000)]];
    
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:ontStruct];
    
    NSData *args = [ONTNativeBuildParams createCodeParamsScript:array];
    ONTTransaction *transaction = [ONTInvokeCode invokeCodeTransaction:ongContractAddress initMethod:@"transferFrom" args:args payer:from gasLimit:gasLimit gasPrice:gasPrice];
    
    // 签名
    ECKeySignature *sign = [ecKey sign:transaction.getSignHash];
    [transaction.signatures addObject:[[ONTSignature alloc] initWithPublicKey:ecKey.publicKeyAsData signature:sign.toDataNoV]];
    
    NSString *txHex = transaction.toRawByte.hexString;
    return txHex;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"【name】== %@\n【mnemonicText】== %@\n【encryptMnemonicText】== %@\n【privateKeyHex】== %@\n【wif】== %@\n【keystore】== %@\n【address】== %@", self.name, self.mnemonicText, self.encryptMnemonicText, self.privateKeyHex, self.wif, self.keystore, self.address.address];
}

- (BOOL)isEqualToAccount:(ONTAccount*)other {
    if (self == other) {
        return YES;
    }
    
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self.address.publicKeyHash160 isEqualToData:other.address.publicKeyHash160];
}
@end
