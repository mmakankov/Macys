//
//  Entity.h
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entity : NSObject

/**
 Id of the entity
 */
@property (nonatomic) NSNumber *id;

/**
 Name of the entity
 */
@property (nonatomic) NSString *name;

/**
 Initialize new Entity. Designated initializer.
 @param dictionary Dictionary of products that was serialized from json
 @returns An initialized Entity
 */
- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;

@end
