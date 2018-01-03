//
//  ChooseIconTool.m
//  screenAppHiden
//
//  Created by 触手TV on 2017/12/29.
//  Copyright © 2017年 触手TV. All rights reserved.
//

#import "ChooseIconTool.h"

@implementation ChooseIconTool
static ChooseIconTool * instance = nil;

+ (ChooseIconTool *) getInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[ChooseIconTool alloc]init];
        }
    }
    return instance;
}





@end
