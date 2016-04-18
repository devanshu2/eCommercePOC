//
//  HomeProductListTableViewCell.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeProductListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *productImageView;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *price;

@end
