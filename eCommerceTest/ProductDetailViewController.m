//
//  ProductDetailViewController.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AppOptions.h"
#import "constants.h"
#import "CartManager.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

static NSString *cellIdentifierImage = @"imageCellIdentifier";
static NSString *cellIdentifierBasic = @"cellIdentifierBasic";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewItems];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setViewControllerNavigationBar];
    [self updateViewOnAppearing];
}

#pragma mark - Private Methods

- (void)initViewItems{
    [_addToCartButton setBackgroundColor:[UIColor blueColor]];
    [_addToCartButton.titleLabel setTextColor:[UIColor whiteColor]];
    _addToCartButton.layer.cornerRadius = 5.0;
    self.theTable.rowHeight = UITableViewAutomaticDimension;
    self.theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateViewOnAppearing{
    if ([[CartManager sharedInstance] isProductInCart:_theProduct]) {
        _cartMessageLabel.text = @"Product Already Available In Cart";
        _addToCartButtonTopCons.constant = 6.0;
    }
    else{
        _cartMessageLabel.text = @"";
        _addToCartButtonTopCons.constant = 17.0;
    }
}

- (void)setViewControllerNavigationBar{
    self.navigationItem.title = _theProduct.productName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = indexPath.row ? cellIdentifierBasic : cellIdentifierImage;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIImageView *productImage = (UIImageView *)[cell viewWithTag:1];
        [productImage sd_setImageWithURL:[NSURL URLWithString:_theProduct.productImageURL] placeholderImage:[UIImage imageNamed:PRODUCT_PLACEHOLDER_IMAGE_NAME]];
    }
    else if (indexPath.row == 1) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = _theProduct.productName;
        label.font = [UIFont boldSystemFontOfSize:17.0];
    }
    else if (indexPath.row == 2) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:@"%@ %.02f", CURRENCY_SYMBOL, _theProduct.productPrice];
        label.font = [UIFont systemFontOfSize:14.0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 200.0;
    }
    static UITableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [_theTable dequeueReusableCellWithIdentifier:cellIdentifierBasic];
    });
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - Actions

- (IBAction)addToCartButtonAction:(id)sender{
    
}


@end
