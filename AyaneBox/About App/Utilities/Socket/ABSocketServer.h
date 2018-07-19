//
//  UdpServer.h
//  AyaneBox
//
//  Created by wenjun on 2018/4/10.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

@protocol ABSocketServerDelegate <NSObject>

- (void)socket:(GCDAsyncSocket *)sock didAcceptAudioNewSocket:(GCDAsyncSocket *)newSocket;
- (void)socket:(GCDAsyncSocket *)sock didAcceptExplorerNewSocket:(GCDAsyncSocket *)newSocket;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address port:(UInt16)port;

- (void)audioSocketDidDisconnect:(GCDAsyncSocket *)sock;
- (void)explorerSocketDidDisconnect:(GCDAsyncSocket *)sock;

- (void)socket:(GCDAsyncSocket *)sock didReadAudioData:(NSData *)data;
- (void)socket:(GCDAsyncSocket *)sock didReadExplorerData:(NSData *)data;

@end

@interface ABSocketServer : NSObject

@property (nonatomic, weak) id <ABSocketServerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *explorerClientArray;
@property (nonatomic, strong) NSMutableArray *audioClientArray;

@property (nonatomic, strong) GCDAsyncUdpSocket *udpServer;
@property (nonatomic, strong) GCDAsyncSocket *gcdSocket;
@property (nonatomic, strong) GCDAsyncSocket *audioSocket;

/** 启动UDP服务 */
- (void)startUDP;

/** 停止UDP服务 */
- (void)stopUDP;

- (void)sendUDPData:(NSData *)data toHost:(NSString *)host Port:(int)port Tag:(int)tag;

-(void)gcdSocketGetMacWithPort:(UInt16)port;

-(void)gcdSocketGetAudioDataWithPort:(UInt16)port;

@end
