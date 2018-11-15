//
//  AbiFunction.h
//  ONTWallet
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Parameter;

@interface AbiFunction : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* returntype;
@property (nonatomic,strong) NSMutableArray<Parameter*>* parameters;

-(void)addParam:(Parameter*) param;
-(void)setParamsValue:(id)firstobj, ... NS_REQUIRES_NIL_TERMINATION;
@end

