//
//  SHColorFontDefine.h
//  ZJForum
//
//  Created by Andy on 15/12/13.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "HexColor.h"

#ifndef SHColorFontDefine_h
#define SHColorFontDefine_h

// 取色值相关的方法
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:(a)]

#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a)        [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
blue:((float)(v & 0x0000FF))/255.0 \
alpha:a]


//#define SHCOlor_main        [UIColor colorWithHexString:@"#638eec"]
#define SHCOlor_main        [UIColor colorWithHexString:@"#45b2cf"]
#define SHColor_light       [UIColor colorWithHexString:@"#999999"]
#define SHColor_separator   [UIColor colorWithHexString:@"#eeeeee"]
#define SHColor_background  [UIColor colorWithHexString:@"#F5F5F5"]
#define SHColor_text        [UIColor colorWithHexString:@"#333333"]
#define SHColor_navbkg      [UIColor colorWithHexString:@"#E066FF"]
#define SHColor_selected    [UIColor colorWithHexString:@"#CB7954"]
#define SHColor_blue        [UIColor colorWithHexString:@"#608BF1"]



#endif /* SHColorFontDefine_h */
