//
//  Commen.h
//  GoddessClock
//
//  Created by wubing on 14-8-16.
//  Copyright (c) 2014年 iMac. All rights reserved.
//


#define filePrefixPath @"https://api.bangbangrobotics.com/"
#define picturePrefixPath @"https://api.bangbangrobotics.com/restful/sns/upload/snspic/"
#define avatarPrefixPath @"https://api.bangbangrobotics.com/restful/avatar/"

/*通知中心标示*/

#define kNotificationEditModuleDidSelectRing @"EditModuleDidSelectRing"
#define kNotificationEditModuleDidSelectDate @"EditModuleDidSelectDate"
#define kNotificationEditModuleDidSetMutiDate @"EditModuleDidSetMutiDate"
#define kNotificationEditModuleDidSetPeriod @"EditModuleDidSetPeriod"
#define kNotificationEditModuleDidSwitchNap @"EditModuleDidSwitchNap"
#define kNotificationEditModuleDidResetTitle @"EditModuleDidResetTitle"
#define kNotificationEditModuleDidSetVolume @"EditModuleDidSetVolume"
/** 个推配置 **/
// development
#define GetuiAppId           @"Q4Gn7U3F7G6VjojQb0l1L1"
#define GetuiAppKey          @"IH85qSyZtc8aGjTGNV8aM9"
#define GetuiAppSecret       @"CyEO5POzSyA4mCIt2ulH87"


#define TIME_NETOUT     30.0f

//UITableView group样式时,section高度 bug修复
#define KGTalbelViewStyleGroupedSectionHeightFix 0.00001f

// 导航中右按钮距离屏幕右边界的距离
#define KGNavigationRightButtonOffSetRightScreenDistance 7

//屏幕尺寸
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenMargin    10
#define FrameFactor     ScreenWidth/320
#define MainHeight      (ScreenHeight - StateBarHeight)
#define MainWidth       ScreenWidth
#define StateBarHeight  20
#define TabBarHeight    49
#define NavBarHeight    44
#define StandardY       (StateBarHeight + NavBarHeight)
#define NavStatusHeight StandardY
//系统判定
#define  IOS_VERSION        [[[UIDevice currentDevice]systemVersion]floatValue]

//工程文件
#define BUNDLE_PATH(file,ext) [[NSBundle mainBundle]pathForResource:file ofType:ext]
//fileurl
#define FILEURL(file) (file?[[NSURL alloc] initFileURLWithPath:file]:nil)
//url
#define URL(file)   (file?[[NSURL alloc] initWithString:file]:nil)
//加载图片
#define LOADIMAGE(file) [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:file]]

#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

//时间量级
#define TIME_SCALE 600

// 永久天数界限
#define KGForeverDayCountDivide 9000

//枚红色
#define MAINCOLOR_RGB 0xf73aa0
//背景灰
#define BACK_GRAY_RGB 0Xf6f6f8
//clock列表表头色值
#define TABLE_HEAD_RGB 0xeeeef0
//闹钟关闭时文字颜色值
#define RGB_CLOCK_CLOSED 0x818181

// 公用的灰色(十六进制)
#define COMMON_GRAY_COLOR_HEX @"#5e5e5e"
// 公用的绿色(十六进制)
#define COMMON_GREEN_COLOR_HEX @"#31AA39"


// 默认的tableView背景色
#define COMMON_DEFAULT_TABLEVIEW_BGCOLOR_HEX  @"#f0eff5"

//图片资源命名
#define BUTTON_PLAY    @"btn_commen_play"
#define ICON_COMMON_LITTLE_PLAY @"icon_common_little_play" // 播放小图标
#define ICON_COMMON_BIG_PLAY @"icon_common_big_play" // 播放大图标
#define ICON_COMMEN_RELOADING @"icon_reloading" //重新加载
#define NOTE_EXPIRE    @"note_video_expire"                                                                                                          
#define BUTTON_RENEW    @"btn_myRingMade_renew"
#define BUTTON_WRITE   @"btn_setclock_write"
#define AVATAR_COMMON_DEFAULT_PLACEHOLDER   @"avatar_common_default_placeholder" // 用户默认占位头像
#define DEFAULT_VIDEO_COVER  @""

#define IS_IOS7 (IOS_VERSION>=7.0)
#define IS_IOS8 (IOS_VERSION>=8.0)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断Reachability连通性域名
#define AFNetworkReachabilityDomain @"www.baidu.com"


#define kUserDefaultSurpriseVideosInfo @"kSurpriseVideosInfoUserDefault"

#ifdef   DEBUG
//#define  NSLog(...) NSLog(__VA_ARGS__);
#define  NSLog_METHOD NSLog(@"%s", __func__);
#else
#define  NSLog(...) ;
#define  NSLog_METHOD ;
#endif

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define iOS7Delta (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) ? 20 : 0 )

#define judgeStr(str)     [CommonClass judgeStr:str]

/**
 *客服QQ
 */
#define  kCustomServiceQQ   @"(QQ: 3112663781)"

/**
 通知相关
 */

#define  kNotificationToLogin               @"loginNotification"
#define  kNotificationToUserInfoChanged     @"userInfoChangedNotification"
#define  kNotificationToLoginStateChanged   @"loginStateChanged"
#define  kNotificationOfPaySucessed         @"paySucessed"
#define  kNotificationToHomeRefresh         @"homeRefresh"
#define  kNotificationOfFriendsSearchResult @"friendsSearch"

/**
 业务相关
 */
#define kUserUID                         @"uid"
#define kUMUserUID                       @"UMCUid"
#define kUserLevel                       @"userLevel"   //0：未认证 1：已司机认证 2：已提交资料认证中
#define kUserName                        @"username"
#define kUserAdmin                       @"userAdmin"
#define kNiceName                        @"nicename"
#define kEmail                           @"email"
#define kUserToken                       @"token"
#define kIdentificationId                @"identificationId"
#define kUserAvatar                      @"avatar"
#define kLunachAds                       @"lunachADs"
#define kLunachAdTid                     @"lunachADTid"
#define kLunachAdType                    @"lunachADType"
#define kSOSPhoneStatus                  @"SOSPhoneStatus"//紧急呼救电话是否打开标记
#define kSOSPhoneNumber                  @"SOSPhoneNumber"//紧急呼救电话

#define kUserShareCode                   @"userShareCode"
#define kCurrentCityName                 @"currentCityName"
#define kCurrentProvinceName             @"currentProvinceName"
//#define kCurrentLocation                @"currentLocation"
#define kCurrentLatitude                 @"lat"
#define kCurrentLongitude                @"lng"

#define PAGE_LIMIT 10
#define IS_IPHONE() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#ifndef kSupportFTAnimation
#define kSupportFTAnimation 1
#endif


typedef void (^VoidResultBlock)();


#define kAnimationDuration 0.8

//三方key
//SMS SDK
static  NSString *SMSSDK_APPKEY = @"81402a6c5a37";
static  NSString *SMSSDK_APPSECRET = @"94e53250a938cbc730fa76e2d9fe1b39";

//百度地图SDK
static  NSString *BaiDuSDK_APPKEY = @"uVkGw0ML9GYjCE74eGLR2Tu98Qn8CFR6";

//testin
static  NSString *TestIn_APPKEY = @"507cb34d52be0c266c4cd67e4813c00d";
//

//友盟
static  NSString *mobSDK_APPKEY = @"57032c4de0f55a211e000b0e";

//极光
static  NSString *JPUSHSDK_APP_KEY         = @"74bad69de01a11c6cd0fb751";
static  NSString *JPUSHSDK_CLIENT_SECRET   = @"e12decb4bcca4a912128b5da";

//shareSDK
static  NSString *SHARESDK_APPKEY = @"1c9850e76850c";
static  NSString *SHARESDK_APPSECRET = @"535d22825aa4992877d51face3b8caf1";

//新浪微博
static  NSString *SHARESDK_APPKEY_WB = @"2523841303";
static  NSString *SHARESDK_APPSECRET_WB = @"034be8dccb8f50be5112c9c12842cd26";

//微信支付
static  NSString *SHARESDK_APPKEY_WX = @"wx8813239c30318ece";
static  NSString *SHARESDK_APPSECRET_WX = @"fdea210b06e4964e463a51e775bf08a5";
static  NSString *WXPAYSDK_PARTERID = @"1238588702";

//QQ
static  NSString *SHARESDK_APPKEY_QQ = @"1104291507";
static  NSString *SHARESDK_APPSECRET_QQ = @"QcCU68aMW6Nc3uvS";

//U+SDK
static  NSString *USDK_APPID = @"MB-ZHSQ-0000";
static  NSString *USDK_APPKEY_TEST = @"bfdde0402eb03a32d0e999f21f01424d";//测试
static  NSString *USDK_APPKEY_PRODUCT = @"43c800651f37b75f9eed7efdf05753c9";//生产
static  NSString *USDK_APPSECRET = @"6BCFF623290ACB585B05A7E419D9537F";

//友盟微社区
static NSString *UMC_APP_KEY = @"58b0148bf43e487e440001e9";
static NSString *UMC_APP_SECRET = @"d6ae255db32193266bc3b6db06296b15";


typedef NS_ENUM(NSInteger, ZJTableViewCellButton) {
    ZJTableViewCellFavouriteButton    = 0,
    ZJTableViewCellCommentButton      = 1,
    ZJTableViewCellShareButton        = 2,
    ZJTableViewCellOtherButton        = 3,
};

