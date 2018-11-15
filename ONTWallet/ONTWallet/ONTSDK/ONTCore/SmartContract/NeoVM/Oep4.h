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

@interface Oep4 : NSObject

@property (nonatomic,strong) NSString* contractAddress;

- (instancetype)initWithVM:(NeoVM*)vm;

- (void)queryBalanceOf:(NSString*)address
              queryCallback:(void (^)(NSString *balance, NSError *error))callback;
//- (NSString*)sendTransfer:

@end

#endif /* Oep4_h */
