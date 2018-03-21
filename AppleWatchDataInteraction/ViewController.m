//
//  ViewController.m
//  AppleWatchDataInteraction
//
//  Created by xtz_pioneer on 2018/3/20.
//  Copyright © 2018年 zhangxiong. All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "TXModel.h"
@interface ViewController ()<WCSessionDelegate>
@property (nonatomic,strong)WCSession * session;
@property (nonatomic,strong)UIButton  * button;
@property (nonatomic,strong)UILabel   * label;
@property (nonatomic,strong)NSTimer   * timer;
@property (nonatomic,assign,getter=isTimerStatus)BOOL timerStatus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"AppleWatchDataInteraction";
    //初始化WCSession(数据交互)
    self.session=[WCSession defaultSession];
    //遵循WCSessionDelegate代理
    self.session.delegate=self;
    //必须激活session
    [self.session activateSession];
    //UI布局
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    button.center = self.view.center;
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button setTitle:[self dateStr] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(sendMessageToWatch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100,self.view.frame.size.width-(100*2) , 200)];
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击按钮发送信息到watch";
    [self.view addSubview:label];
    self.label = label;
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateBtnTitle:) userInfo:nil repeats:YES];
    self.timerStatus = YES;
    // Do any additional setup after loading the view, typically from a nib.
}
//时间
- (NSString *)dateStr {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH时mm分ss秒"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
//发送数据到watch
- (void)sendMessageToWatch:(id)sender{
    if (!self.isTimerStatus) {
        //开始定时器
        NSDate *date = [NSDate distantPast];
        [self.timer setFireDate:date];
        self.label.text = @"点击按钮发送信息到watch";
    }
    NSData * avatarData=UIImageJPEGRepresentation([UIImage imageNamed:@"001"], 0.5);
    NSString *contnet = [@"Hello," stringByAppendingString:[NSString stringWithFormat:@"--%@",[self dateStr]]];
    NSDictionary * infoDict=@{txAvatar:avatarData,
                              txName:@"zhangxiong",
                              txContent:contnet
                              };
    /*重点*/
    //发送消息-方法1
    [self.session transferUserInfo:infoDict];
    //发送消息-方法2
    //[self.session sendMessage:infoDict replyHandler:nil errorHandler:nil];
}
//更新按钮标题
- (void)updateBtnTitle:(id)sender{
    [self.button setTitle:[self dateStr] forState:UIControlStateNormal];
}
#pragma mark - WCSessionDelegate
//发送会失败回调
- (void)session:(WCSession *)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(NSError *)error {
    if (!error) {
        NSLog(@"iOS消息发送成功");
    }else{
        NSLog(@"iOS消息发送失败:%@",error);
    }
}
//接收数据回调-方法1 配合transferUserInfo使用
- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo{
    if (userInfo) {
        NSLog(@"iOS接收到消息:%@",userInfo);
        NSLog(@"线程---1=%@",[NSThread currentThread]);
        __weak typeof(self) weakSelf=self;
        dispatch_async(dispatch_get_main_queue(),^{
            NSLog(@"线程---2=%@",[NSThread currentThread]);
            weakSelf.label.text = [NSString stringWithFormat:@"消息:%@\n%@",userInfo[@"watch"],[weakSelf dateStr]];
            //暂停定时器
            NSDate *date = [NSDate distantFuture];
            [weakSelf.timer setFireDate:date];
        });
    }else{
        NSLog(@"iOS没有接收到消息");
    }
    
}

//接收数据回调-方法2 配合sendMessage使用
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
    if (message) {
        NSLog(@"iOS接收到消息:%@",message);
        NSLog(@"线程---1=%@",[NSThread currentThread]);
        __weak typeof(self) weakSelf=self;
        dispatch_async(dispatch_get_main_queue(),^{
            NSLog(@"线程---2=%@",[NSThread currentThread]);
            weakSelf.label.text = [NSString stringWithFormat:@"watch:%@\n%@",message[@"watch"],[weakSelf dateStr]];
            //暂停定时器
            NSDate *date = [NSDate distantFuture];
            [weakSelf.timer setFireDate:date];
        });
    }else{
        NSLog(@"iOS没有接收到消息");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
