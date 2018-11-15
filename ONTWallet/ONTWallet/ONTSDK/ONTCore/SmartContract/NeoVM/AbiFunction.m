//
//  AbiFunction.m
//  ONTWallet
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#import "AbiFunction.h"

@implementation AbiFunction

-(instancetype)init{
    self = [super init];
    if (self) {
        _parameters = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addParam:(Parameter*) param {
    [_parameters addObject:param];
}

-(void)setParamsValue:(id)firstobj, ... NS_REQUIRES_NIL_TERMINATION {
    if (!firstobj) {
        return;
    }
    
    va_list objs;
    va_start(objs, firstobj);
    NSString *o;
    while ((o = va_arg(objs, id))) {
        
    }
    va_end(objs);
}

@end
