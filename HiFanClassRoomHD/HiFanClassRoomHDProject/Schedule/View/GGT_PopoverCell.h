//
//  GGT_PopoverCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/18.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_PopoverCell : UITableViewCell

@property (nonatomic, copy) NSString *xc_name;

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@end
