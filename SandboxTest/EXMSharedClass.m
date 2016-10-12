//
//  EXMSharedClass.m
//  SandboxTest
//
//  Created by Mikhail Pogosskiy on 11/10/2016.
//  Copyright © 2016 Mikhail Pogosskiy. All rights reserved.
//

#import "EXMSharedClass.h"



@implementation EXMSharedClass
@synthesize connectionFlag;

- (id)init
{
	self = [super init];
	if(self != nil) {
		self.connectionFlag = NO;
	}
	return self;
}

@end
