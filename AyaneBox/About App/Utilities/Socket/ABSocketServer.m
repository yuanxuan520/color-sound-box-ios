//
//  ABSocketServer.m
//  AyaneBox
//
//  Created by wenjun on 2018/4/10.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "ABSocketServer.h"

@interface ABSocketServer () <GCDAsyncUdpSocketDelegate>
//,GCDAsyncSocketDelegate
@property NSUInteger curPort;

@end

@implementation ABSocketServer

/* 启动udp 服务器，监听6002端口 */
- (void)startUDP:(NSUInteger)port {
    NSError *error = nil;
    if (port != self.curPort) {
        self.curPort = port;
    }
    if (self.udpServer == nil) {
        
        self.udpServer = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("udp server work queue", DISPATCH_QUEUE_SERIAL)];
        
        if (![self.udpServer bindToPort:self.curPort error:&error]) {
            SLog(@"Error starting server (bind): %@", error);
            return;
        }
        
        if(![self.udpServer enableBroadcast:YES error:&error]){
            SLog(@"Error enableBroadcast (bind): %@", error);
            return;
        }
        
//        if (![self.udpServer joinMulticastGroup:@"224.0.0.1"  error:&error]) {
//            NSLog(@"Error joinMulticastGroup (bind): %@", error);
//            return;
//        }
        
        if (![self.udpServer beginReceiving:&error]) {
            [self.udpServer close];
            SLog(@"Error starting server (recv): %@", error);
            return;
        }
    }else {
        if (![self.udpServer bindToPort:self.curPort error:&error]) {
            SLog(@"Error starting server (bind): %@", error);
            return;
        }
        
        if(![self.udpServer enableBroadcast:YES error:&error]){
            SLog(@"Error enableBroadcast (bind): %@", error);
            return;
        }
        
        //        if (![self.udpServer joinMulticastGroup:@"224.0.0.1"  error:&error]) {
        //            NSLog(@"Error joinMulticastGroup (bind): %@", error);
        //            return;
        //        }
        
        if (![self.udpServer beginReceiving:&error]) {
            [self.udpServer close];
            SLog(@"Error starting server (recv): %@", error);
            return;
        }
    }
}

- (void)startUDP {
    NSError *error = nil;

    if (self.udpServer == nil) {
        self.udpServer = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("udp server work queue", DISPATCH_QUEUE_SERIAL)];
        
//        if (![self.udpServer bindToPort:self.curPort error:&error]) {
//            SLog(@"Error starting server (bind): %@", error);
//            return;
//        }
        
        if(![self.udpServer enableBroadcast:YES error:&error]){
            SLog(@"Error enableBroadcast (bind): %@", error);
            return;
        }
        
        //        if (![self.udpServer joinMulticastGroup:@"224.0.0.1"  error:&error]) {
        //            NSLog(@"Error joinMulticastGroup (bind): %@", error);
        //            return;
        //        }
        
        if (![self.udpServer beginReceiving:&error]) {
            [self.udpServer close];
            SLog(@"Error starting server (recv): %@", error);
            return;
        }
    }
}

- (void)stopUDP {
    [self.udpServer close];
}

- (NSMutableArray*)explorerClientArray
{
    if (!_explorerClientArray) {
        _explorerClientArray = [NSMutableArray array];
    }
    return _explorerClientArray;
}

- (NSMutableArray*)audioClientArray
{
    if (!_audioClientArray) {
        _audioClientArray = [NSMutableArray array];
    }
    return _audioClientArray;
}

//-(void)gcdSocketGetMacWithPort:(UInt16)port{
//    if (!self.gcdSocket) {
//        NSError *error = nil;
//        dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL);
//        self.gcdSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dQueue];
//        [self.gcdSocket acceptOnPort:port error:&error];
//        SLog(@"开始监听：%d",port);
//    }
//}
//
//-(void)gcdSocketGetAudioDataWithPort:(UInt16)port{
//    if (!self.audioSocket) {
//        NSError *error = nil;
//        dispatch_queue_t dQueue = dispatch_queue_create("audio socket queue", NULL);
//        self.audioSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dQueue];
//        [self.audioSocket acceptOnPort:port error:&error];
//        SLog(@"开始监听：%d",port);
//    }
//}

/** 用已创建的udp服务器发送数据，使用默认的超时 */
- (void)sendUDPData:(NSData *)data toHost:(NSString *)host Port:(int)port Tag:(int)tag {
    if ([self.udpServer isClosed]) {
        self.udpServer = nil;
        [self startUDP:self.curPort];
    }
    
    [self.udpServer sendData:data toHost:host port:port withTimeout:20 tag:tag];
}


#pragma mark - UDP代理
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *host;
    UInt16 port=0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
//    SLog(@"收到UDP--host:%@ port:%d data:%@ address:%@", host, port, data, address);
    if ([_delegate respondsToSelector:@selector(udpSocket:host:didReceiveData:fromAddress:)]) {
        [_delegate udpSocket:sock host:host didReceiveData:data fromAddress:address];
    }
}

#pragma mark - 接收到数据代理函数
//- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
//    NSString *ip = [newSocket connectedHost];
//    uint16_t port = [newSocket connectedPort];
//    SLog(@"有新连接 [%@:%d] is %@", ip, port, newSocket);
//    if (sock == self.audioSocket) {
//        [self.audioClientArray addObject:newSocket];
//        if ([_delegate respondsToSelector:@selector(socket:didAcceptAudioNewSocket:)]) {
//            [_delegate socket:sock didAcceptAudioNewSocket:newSocket];
//        }
//    }else{
//        [self.explorerClientArray addObject:newSocket];
//        if ([_delegate respondsToSelector:@selector(socket:didAcceptExplorerNewSocket:)]) {
//            [_delegate socket:sock didAcceptExplorerNewSocket:newSocket];
//        }
//    }
//    [newSocket readDataWithTimeout:-1 tag:200];
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    NSString *ip = [sock connectedHost];
//    uint16_t port = [sock connectedPort];
//    SLog(@"接收到tcp [%@:%d] %@", ip, port, data);
//    if ([self.explorerClientArray containsObject:sock]) {
//        if ([_delegate respondsToSelector:@selector(socket:didReadExplorerData:)]) {
//            [_delegate socket:sock didReadExplorerData:data];
//        }
//    }else{
//        if ([_delegate respondsToSelector:@selector(socket:didReadAudioData:)]) {
//            [_delegate socket:sock didReadAudioData:data];
//        }
//    }
//
//    // 再次接收数据 因为这个方法只接收一次
//    [sock readDataWithTimeout:-1 tag:200];
//}
//
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
//    SLog(@"失去连接 %@", err);
//    if ([self.explorerClientArray containsObject:sock]) {
//        [self.explorerClientArray removeObject:sock];
//        if ([_delegate respondsToSelector:@selector(explorerSocketDidDisconnect:)]) {
//            [_delegate explorerSocketDidDisconnect:sock];
//        }
//    }else{
//        [self.audioClientArray removeObject:sock];
//        if ([_delegate respondsToSelector:@selector(audioSocketDidDisconnect:)]) {
//            [_delegate audioSocketDidDisconnect:sock];
//        }
//    }
//}

@end
