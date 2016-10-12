//
//  AppDelegate.m
//  SandboxTest
//
//  Created by Mikhail Pogosskiy on 06/10/2016.
//  Copyright © 2016 Mikhail Pogosskiy. All rights reserved.
//

#import "AppDelegate.h"
#import <Security/Security.h>

#import "EXMSharedClass.h"

@interface AppDelegate ()
@property (strong) NSString* path;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate{
	EXMSharedClass* _sharedObject;
	NSConnection* _connection;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self nsConnectionSetup];
	
	//Testing
	_path = [[NSBundle mainBundle] pathForResource:@"SandboxPair" ofType:@"app"];
	_path = [_path stringByAppendingPathComponent:@"/Contents/MacOS/SandboxPair"];
	[self runTaskWithLaunchPath:_path];
	
	[self performSelector:@selector(sendFile) withObject:nil afterDelay:2];
	
	return;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[_sharedObject removeObserver:self forKeyPath:@"connectionFlag"];
}

- (BOOL)runTaskWithLaunchPath:(NSString*)launchPath
{
	NSTask* task = [NSTask new];
	if( ![[NSFileManager defaultManager] fileExistsAtPath:launchPath] )
	{
		NSLog(@"ERROR: Not found command %@", launchPath);
		return NO;
	}
	
	task.launchPath = launchPath;
	
	NSPipe* outPipe = [NSPipe pipe];
	NSPipe* errPipe = [NSPipe pipe];
	task.standardOutput = outPipe;
	task.standardError = errPipe;
	
	[task launch];
	
	int status = 0;
	errno = 0;
	return status == 0;
	
}

///Setup for NSConnection test
- (void)nsConnectionSetup
{
	_sharedObject = [EXMSharedClass new];
	_connection = [NSConnection new];
	[_connection setRootObject:_sharedObject];
	BOOL result = [_connection registerName:@"com.mpogosskiy.SandboxTest.shared"];
	
	if(!result) {
		NSLog(@"registration failed");
	}
	
	//Remote application will change the property connectionFlag of
	//_sharedObject and we will get a notification if it succeeds
	[_sharedObject addObserver:self forKeyPath:@"connectionFlag"
					   options:NSKeyValueObservingOptionInitial context:nil];
}

///Run openFile:withApplication: test
- (void)sendFile
{
	NSString* groupIdentifier = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppIdentifierPrefix"]
								stringByAppendingString:[[NSBundle mainBundle]
								objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey]];
	NSURL* sharedPath = [[NSFileManager defaultManager]
						 containerURLForSecurityApplicationGroupIdentifier:groupIdentifier];
	
	NSError* error = nil;
	[[NSFileManager defaultManager] createDirectoryAtURL:sharedPath
							 withIntermediateDirectories:YES attributes:nil error:&error];
	NSString* fileName = @"test.txt";
	
	fileName = [[@"~/Downloads/" stringByAppendingPathComponent:fileName]stringByExpandingTildeInPath];
	[@"test file" writeToFile:fileName atomically:YES
					 encoding:NSUTF8StringEncoding error:&error];
	NSLog(@"File written at path: %@", fileName);

	BOOL opened = [[NSWorkspace sharedWorkspace] openFile:fileName withApplication:_path];
	
	if(!opened) {
		NSLog(@"File was not opened in helper application");
	} else {
		NSLog(@"File was successfully opened in helper application");
	}
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary*)change context:(void *)context
{
	if([object isKindOfClass:[EXMSharedClass class]]) {
		EXMSharedClass* sharedObject = (EXMSharedClass*)object;
		if(sharedObject.connectionFlag) {
			NSAlert* alert = [[NSAlert alloc] init];
			alert.messageText = @"Main application: Shared object changed from helper, NSConnection is working";
			[alert addButtonWithTitle:@"OK"];
			[alert runModal];
		}
	}
}

@end
