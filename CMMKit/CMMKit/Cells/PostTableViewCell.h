//
//  PostTableViewCell.h
//  CMMKit
//
//  Created by Keylonnie Miller on 8/2/18.
//  Copyright © 2018 Keylonnie Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell

-(void)setPostCellWithTitle:(NSString*)title user:(NSString *)username photo:(UIImage *)image time:(NSString *)time category:(NSString *)category;

@end
