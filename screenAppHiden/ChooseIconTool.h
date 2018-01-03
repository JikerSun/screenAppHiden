//
//  ChooseIconTool.h
//  screenAppHiden
//
//  Created by 触手TV on 2017/12/29.
//  Copyright © 2017年 触手TV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChooseIconTool : NSObject
+ (ChooseIconTool *) getInstance ;

@property (nonatomic, strong)   UIImage * iconImageOri;

@property (nonatomic, strong)   UIImage * iconImageClip;


@end
