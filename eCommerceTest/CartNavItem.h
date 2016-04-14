//
//  CartNavItem.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartNavItem : UIView

@property(nonatomic, assign) NSInteger cartCount;
@property(nonatomic, readonly, getter=getViewWidth) CGFloat viewWidth;

@end
