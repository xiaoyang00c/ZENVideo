//
//  NSMutableArray+MoveObject.m
//  ZJForum
//
//  Created by Andy on 16/2/25.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "NSMutableArray+MoveObject.h"

@implementation NSMutableArray (MoveObject)
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (toIndex != fromIndex && fromIndex < [self count] && toIndex < [self count])
    {
        id obj = [self objectAtIndex:fromIndex];

        [self removeObjectAtIndex:fromIndex];
        if (toIndex >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:toIndex];
        }
    }
}
@end
