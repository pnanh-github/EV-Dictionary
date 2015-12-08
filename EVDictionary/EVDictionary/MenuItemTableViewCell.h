//
//  MenuItemTableViewCell.h
//  EVDictionary
//
//  Created by ADMIN on 11/5/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

@end
