//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088901155826465"
//收款支付宝账号
#define SellerID  @"2290435357@qq.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"rlkrg70j6qsivz80ievys001pz2poe2g"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALbTOkLIiChFZC8zYWgfwdQt7QVXNRbdBeYQfl1qzMl2Y/xzT+TidTSpphdgSN0UouUuMkMLHjBFdOgNWROZprt+QpLNU2l8HO+RmCxkzMOYqBBMB3L4lRqDM0FnKk0GV7JNFUV4VdA9MmTOt6hoHL5ILC/NQFiR4NUFUrIDYXvrAgMBAAECgYBvxoykL/4uwN4TjZJMGr5ifwGedkbbB56HniXj71vtABj5S3bZNSr7W41UVWW25NsCy0+ndbCrSovDJAYF2bb5efeWeFeqMbJfqgNWp3/w6863B36h4dphMr2W+PfK3UD1VvjjDRauNC1iYW9GIMLOPHNE/Vis3pXDNFbASxRoAQJBAN9vZSpBzvBGJwZ2g/Irqpe3wGocfu1JyOlTSFOBobKnAYs1xFak8CR8bRMT3dB48+J2uQ1d4Ul9UVbmmO7dKOsCQQDReKDsTNpnQ5GlQbOfl50OVSpnCACW21yOw/pC+NDPy0CxOLWctYf8HZvW0kgTJg8MBXJZkjRHOMxGKiHpODkBAkEAvoZysZHkMCbh6DTvVnW9xhm+Tb12zkh4td16cxq7E2gtfNOgVHHZBIPFTttF7hr1fErYiXlgPhZKYdvI1QZpeQJBAMp/PboR9ZScOmEyaa3fSIIBjNM7Zi5v80NEa1tw45PtXiW0t8S9rK7qBKwgbnKseSFa5pd2gjlTzA4MTuoBYwECQEMb9lneAgdwIQf801OP1vMPUSlpf96DWD+ROXCWWPpJERKEk3ZbJgdy34ErlyzGfnUeODk9qGDcYI+/JQmKRKU="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
