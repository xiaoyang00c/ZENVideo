//
//  NSMutableArray+MoveObject.h
//  ZJForum
//
//  Created by Andy on 16/2/25.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MoveObject)
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end
