//
//  AppDelegate.m
//  SandboxPair
//
//  Created by Mikhail Pogosskiy on 06/10/2016.
//  Copyright © 2016 Mikhail Pogosskiy. All rights reserved.
//

#import "AppDelegate.h"
#import "EXMSharedClass.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	id proxy = [NSConnection rootProxyForConnectionWithRegisteredName:@"com.mpogosskiy.SandboxTest.shared" host:nil];
	[proxy setProtocolForProxy:@protocol(EXMSharedClassProtocol)];
	[self changeFlag:proxy];
	
	[self performSelector:@selector(stop) withObject:nil afterDelay:30];
	
}

- (void)changeFlag:(id<EXMSharedClassProtocol>)proxy
{
	[proxy setConnectionFlag:YES];
}

- (void)stop
{
	[NSApp terminate:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
	NSAlert* alert = [[NSAlert alloc] init];
	alert.messageText = @"Helper app: File was recieved. application:openFile: is working";
	[alert addButtonWithTitle:@"OK"];
	[alert runModal];
	return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray<NSString *> *)filenames
{
	NSAlert* alert = [[NSAlert alloc] init];
	alert.messageText = @"Helper app: Files was recieved. application:openFiles: is working";
	[alert addButtonWithTitle:@"OK"];
	[alert runModal];
}
@end
