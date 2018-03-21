//
//  TXModel.h
//  AppleWatchDataInteraction WatchKit Extension
//
//  Created by xtz_pioneer on 2018/3/20.
//  Copyright © 2018年 zhangxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const txAvatar  = @"avatar";
static NSString * const txName    = @"name";
static NSString * const txContent = @"content";
@interface TXModel : NSObject
@property (nonatomic,strong)NSData   * avatar;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * content;
- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)modelWithDict:(NSDictionary*)dict;
@end
