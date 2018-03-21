//
//  TXModel.m
//  AppleWatchDataInteraction WatchKit Extension
//
//  Created by xtz_pioneer on 2018/3/20.
//  Copyright © 2018年 zhangxiong. All rights reserved.
//

#import "TXModel.h"

@implementation TXModel
- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        self.avatar=dict[txAvatar];
        self.name=dict[txName];
        self.content=dict[txContent];
    }
    return self;
}
+ (instancetype)modelWithDict:(NSDictionary*)dict{
    return [[self alloc]initWithDict:dict];
}
@end
