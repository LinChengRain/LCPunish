//
//  LCBaseModel.h
//  o2oCustomer
//
//  Created by YuChangLin on 16/7/20.
//  Copyright © 2016年 YuChangLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCBaseModel : NSObject <NSCoding>{
    
}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串


@end
