//
//  AlbumShowCell.m
//  获取相册Demo
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "AlbumModel.h"
#import "AlbumShowCell.h"

@interface AlbumShowCell ()
{
    UIButton    *selectedButton;
}
@end

@implementation AlbumShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _bottomView.hidden = YES;
    
    selectedButton = [[UIButton alloc] init];
    selectedButton.userInteractionEnabled = NO;
    [selectedButton setImage:ImageNamed(@"ablum_no_select") forState:UIControlStateNormal];
    [selectedButton setImage:ImageNamed(@"ablum_selected") forState:UIControlStateSelected];
    [self.contentView addSubview:selectedButton];
    [selectedButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [selectedButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [selectedButton autoSetDimensionsToSize:CGSizeMake(20, 20)];
}

- (void)applyData:(ALAsset *)asset andIsVideo:(BOOL)isVideo
{
    _albumImgV.image = [UIImage imageWithCGImage:asset.thumbnail];
    if (isVideo) {
        _timeL.text = [AlbumShowCell getTimeStringOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
}

+ (NSString *)getTimeStringOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *dateRef = [[NSDate alloc] init];
    NSDate *dateNow = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:dateRef];
    
    unsigned int uFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |
    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    
    NSDateComponents *components = [calendar components:uFlags
                                               fromDate:dateRef
                                                 toDate:dateNow
                                                options:0];
    NSString *retTimeInterval;
    if (components.hour > 0)
    {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)components.second];
    }
    
    else
    {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)components.second];
    }
    return retTimeInterval;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    selectedButton.selected = isSelect;
}

@end
















