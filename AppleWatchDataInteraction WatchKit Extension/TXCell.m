//
//  TXCell.m
//  AppleWatchDataInteraction WatchKit Extension
//
//  Created by xtz_pioneer on 2018/3/20.
//  Copyright © 2018年 zhangxiong. All rights reserved.
//

#import "TXCell.h"
#import <WatchKit/WatchKit.h>
@interface TXCell ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *avatarImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *contentLabel;

@end

@implementation TXCell
- (void)setModel:(TXModel *)model{
    _model=model;
    [self.avatarImage setImageData:model.avatar];
    [self.nameLabel setText:model.name];
    [self.contentLabel setText:model.content];
}
@end
