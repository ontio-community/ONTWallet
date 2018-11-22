//
//  ONTAddress.m
//  ONTWallet
//
//  Created by Yuzhiyou on 2018/7/24.
//  Copyright © 2018年 Yuzhiyou. All rights reserved.
//

#import "ONTAddress.h"
#import "Categories.h"
#import "NSMutableData+ONTScriptBuilder.h"

@implementation ONTAddress

- (instancetype)init{
    self = [super init];
    if (self) {
        _address = nil;
        _publicKeyHash160 = [NSMutableData dataWithLength:20];
    }
    return self;
}
/**
 * @brief Initialization method
 */
- (instancetype)initWithData:(NSData*)data{
    self = [super init];
    if (self) {
        if (data.length != 20) {
            return nil;
        }
        _publicKeyHash160 = data;
        _address = [self hash160ToAddress];
    }
    return self;
}
/**
 * @brief Initialization method
 */
- (instancetype)initWithAddressString:(NSString*)addressString{
    self = [super init];
    if (self) {
        if (addressString.length != 34) {
            return nil;
        }
        _address = addressString;
        _publicKeyHash160 = [self hash160];
        if (!_publicKeyHash160) {
            return nil;
        }
    }
    return self;
}
-(NSData *)hash160{
    NSData *data = [_address base58checkToData];
    
    unsigned char COIN_VERSION = 0x17;
    unsigned char data_coin_version;
    
    [data getBytes:&data_coin_version length:1];
    if (data_coin_version != COIN_VERSION) {
        return nil;
    }
    
    return [data subdataWithRange:NSMakeRange(1, 20)];
}
-(NSString *)hash160ToAddress{
    unsigned char COIN_VERSION = 0x17;
    NSString *hex = [[NSData dataWithBytes:&COIN_VERSION length:1].hexString stringByAppendingString:_publicKeyHash160.hexString];
    
    return [NSString base58checkWithData:hex.hexToData];
}
-(NSString *)description{
    return _address;
}
@end
