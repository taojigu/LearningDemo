//
//  ViewController.m
//  RunLoop
//
//  Created by 顾吉涛Air on 2018/7/28.
//  Copyright © 2018年 顾吉涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSMachPortDelegate>

@property (nonatomic, assign) NSInteger clickCount;
@property (nonatomic, strong) NSMachPort *mainPort;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mainPort = [[NSMachPort alloc] init];
    self.mainPort.delegate = self;
    [[NSRunLoop mainRunLoop] addPort:self.mainPort forMode:NSRunLoopCommonModes];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRunLoopClicked:(id)sender {
    self.clickCount ++;
    NSInteger thisCount = self.clickCount;
    
    //每次点击，生成一个新的 Thread，打印 NewThread is Running 之后，需要保证当前 Thread 仍然处于活跃状态，三秒钟后打印log
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"NewThread is Running");
        [self performSelector:@selector(printLog:) withObject:@(thisCount) afterDelay:3];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];//如果去掉这一行，thread就会立刻结束，3秒钟后，printLog不会被执行
    }];
    [thread start];
    
}

- (void)printLog:(NSObject *)objc {
    NSLog(@"PrintLog: %@",objc);
}

- (IBAction)stopRunLoopClicked:(id)sender {
    
}

# pragma mark -- 线程间通讯

- (IBAction)threadCommunicateButtonClicked:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("com.RunLoop", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        @autoreleasepool{
            [self sendSubThreadMessage];
        }
    });
}

- (void)sendSubThreadMessage{
    if ([NSThread currentThread] == [NSThread mainThread]) {
        return;
    }
    NSLog(@"Start at sub thread");
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    NSMachPort *thisPort = [[NSMachPort alloc] init];
    NSString *componetString = @"ContextName";
    NSData *data = [componetString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *components = [[NSMutableArray alloc] initWithArray:@[data]];
    [self.mainPort sendBeforeDate:[NSDate date] components:components from:thisPort reserved:0];
    
}

#pragma mark --

- (void)handleMachMessage:(void *)msg {
    if ([NSThread currentThread] != [NSThread mainThread]){
        NSLog(@"Not handle mach message outside main thread");
    }
    //NSMessagePort *msgPort = (__bridge NSMessagePort *)msg;
    //NSArray *components = [msgPort valueForKey:@"components"];
    //NSLog(@"Component from sub thread: %@",components);
}




@end
