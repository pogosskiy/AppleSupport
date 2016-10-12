//
//  EXMSharedClass.h
//  SandboxTest
//
//  Created by Mikhail Pogosskiy on 11/10/2016.
//  Copyright © 2016 Mikhail Pogosskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EXMSharedClassProtocol <NSObject>
@required
@property (atomic, assign) BOOL connectionFlag;
@end

@interface EXMSharedClass : NSObject <EXMSharedClassProtocol>

@end
