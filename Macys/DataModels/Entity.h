//
//  Entity.h
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entity : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *name;

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;

@end
