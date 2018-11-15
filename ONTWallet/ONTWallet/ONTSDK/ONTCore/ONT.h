//
//  ONT.h
//  ONTWallet
//
//  Created by zhangyutao on 2018/8/4.
//  Copyright © 2018年 zhangyutao. All rights reserved.
//

#ifndef ONT_h
#define ONT_h

#define kONTMainNet NO  // MainNet or TestNet
//#define kONTRpcURL kONTMainNet?@"http://dappnode1.ont.io:20336":@"http://polaris1.ont.io:20336"
//#define kONTRestfulURL kONTMainNet?@"http://dappnode1.ont.io:20334":@"http://polaris1.ont.io:20334"

#define kONTRpcURL @"http://192.168.2.176:20336"
#define kONTRestfulURL @"http://192.168.2.176:20334"


#define kONTScanTxURL(hash) kONTMainNet?[NSString stringWithFormat:@"https://explorer.ont.io/transaction/%@",hash]:[NSString stringWithFormat:@"https://explorer.ont.io/transaction/%@/testnet",hash]
#define kONTExplorerBaseURL(version) kONTMainNet?[NSString stringWithFormat:@"https://explorer.ont.io/api/v%@/explorer",version]:[NSString stringWithFormat:@"https://polarisexplorer.ont.io/api/v%@/explorer",version]

#endif /* ONT_h */
