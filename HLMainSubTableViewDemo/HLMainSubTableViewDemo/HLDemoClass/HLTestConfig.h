//
//  HLTestConfig.h
//  HLMainSubTableViewDemo
//
//  Created by cainiu on 2018/12/26.
//  Copyright © 2018 HL. All rights reserved.
//

#ifndef HLTestConfig_h
#define HLTestConfig_h

#define kCNScreenW [UIScreen mainScreen].bounds.size.width
#define kCNScreenH [UIScreen mainScreen].bounds.size.height
#define kCNSafeAreaTopHeight (kCNScreenH == 812.0 ? 88 : 64)

#define TableHeaderFootNoView [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)]


#endif /* HLTestConfig_h */
