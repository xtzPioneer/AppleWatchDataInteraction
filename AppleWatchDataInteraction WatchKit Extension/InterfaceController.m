//
//  InterfaceController.m
//  AppleWatchDataInteraction WatchKit Extension
//
//  Created by xtz_pioneer on 2018/3/20.
//  Copyright © 2018年 zhangxiong. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "TXModel.h"
#import "TXCell.h"

@interface InterfaceController ()<WCSessionDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *deleteAllDataButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (nonatomic,strong)NSMutableArray * allReceiveObjects;
@property (nonatomic,strong)WCSession      * session;
@end


@implementation InterfaceController
- (NSMutableArray*)allReceiveObjects{
    if (!_allReceiveObjects) {
        _allReceiveObjects=[NSMutableArray array];
    }
    return _allReceiveObjects;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    //初始化WCSession(数据交互)
    self.session =[WCSession defaultSession];
    //遵循WCSessionDelegate代理
    self.session.delegate=self;
    //必须激活session
    [self.session activateSession];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)deleteAllData {
    NSRange range=NSMakeRange(0, self.allReceiveObjects.count);
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    [self.deleteAllDataButton setTitle:@"已删除全部\n并发送消息到iOS"];
    [self.allReceiveObjects removeAllObjects];
    //注意发送消息到iphone
    NSDictionary *infoDict = @{@"watch":@"watch已删除全部"};
    /*重点*/
    //发送消息-方法1
    [self.session transferUserInfo:infoDict];
    //发送消息-方法2
    //[self.session sendMessage:infoDict replyHandler:nil errorHandler:nil];
    
}
#pragma mark - WCSessionDelegate
//发送会失败回调
- (void)session:(WCSession *)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(NSError *)error {
    if (!error) {
        NSLog(@"watch消息发送成功");
    }else{
        NSLog(@"watch消息发送失败:%@",error);
    }
}
//接收数据回调-方法1 配合transferUserInfo使用
- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo{
    if (userInfo) {
        NSLog(@"watch接收到消息:%@",userInfo);
        [self upData:userInfo];
    }else{
        NSLog(@"watch没有接收到消息");
    }
}

//接收数据回调-方法2 配合sendMessage使用
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
    if (message) {
        NSLog(@"watch接收到消息:%@",message);
        [self upData:message];
    }else{
        NSLog(@"watch没有接收到消息");
    }
}
- (void)upData:(NSDictionary*)dict{
    __weak typeof(self) weakSelf=self;
    dispatch_async(dispatch_get_main_queue(), ^{
        TXModel * model=[TXModel modelWithDict:dict];
        [weakSelf.allReceiveObjects addObject:model];
        [weakSelf.deleteAllDataButton setTitle:[NSString stringWithFormat:@"count:%i\n点击此处删除全部",weakSelf.allReceiveObjects.count]];
        //新增数据
        [weakSelf.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0]  withRowType:@"TXCell"];
        TXCell *cell = [weakSelf.tableView rowControllerAtIndex:0];
        cell.model=model;
    });
}

@end



