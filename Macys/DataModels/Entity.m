//
//  Entity.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "Entity.h"

@implementation Entity

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        self.id = dictionary[@"id"];
        self.name = dictionary[@"name"];
    }
    return self;
}

- (instancetype)init {
    
    self = [self initWithJSONDictionary:nil];
    if (self) {
        
    }
    return self;
}

@end
