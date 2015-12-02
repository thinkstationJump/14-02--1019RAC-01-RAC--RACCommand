//
//  ViewController.m
//  ReactiveCocoa框架
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // RACCommand使用步骤
    // 1.创建命令 -> 2.执行命令
    
    // RACCommand使用注意点:内部不允许传入一个nil的信号
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // signalBlock调用时刻:只要命令一执行就会调用
        // signalBlock作用:处理事件
        NSLog(@"%@",input);
        
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
                NSLog(@"didSubscribe");
            // didSubscribe调用时刻:执行命令过程中,就会调用
            // didSubscribe作用:传递数据
            
            // subscriber -> [RACReplaySubject subject]
            // RACReplaySubject:把值保存起来,遍历所有的订阅者发送这个值
            [subscriber sendNext:@1];
            
            return nil;
        }];
    }];
    
    // 2.执行命令
    RACReplaySubject *replaySubject = (RACReplaySubject *)[command execute:@"执行命令"];
    
    
    // 3.获取命令中产生的数据,订阅信号
    [replaySubject subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
    // 1.创建订阅者,订阅信号
    // 2.遍历所有值,拿到订阅者去发送
    
    /* 执行流程:
    // 1.创建命令
        * 把signalBlock保存到命令中
     // 2.执行命令
        * 调用命令signalBlock
        * 创建多点传播连接类, 订阅源信号,并且设置源信号的订阅者为RACReplaySubject
        * 返回源信号的订阅者
    */
}

@end
