//
//  YYTestTableViewCell.h
//  YYKitDemo
//
//  Created by DMW_W on 16/8/25.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTableViewCell.h"
#import "YYControl.h"
#import "YYTestModel.h"


#define cellWidth  (( kScreenWidth - 8 ) / 3 )
#define cellHeigth (( kScreenWidth - 8 ) / 3 / 112 * 160 )

@class ZKNearCollectionCell;
@interface ZKNeaStatusLayout : NSObject 

@property (nonatomic , assign) CGFloat height;
@property (nonatomic , assign) CGFloat picHeight;
@property (nonatomic , assign) CGFloat textHeight;
@property (nonatomic , strong) YYTextLayout *textLayout;
@property (nonatomic , strong) YYTextLayout *roleLayout;

@property (nonatomic ,readonly) YYTestModel *model;
- (instancetype)initWithModel:(YYTestModel *)model;

@end

@interface ZKNeaStatusView : UIView

@property (nonatomic , strong) UIView    *contentView;
@property (nonatomic , strong) CALayer   *imageView;
@property (nonatomic , strong) CALayer   *newbie;
@property (nonatomic , strong) CALayer   *online;
@property (nonatomic , strong) YYLabel   *textLabel;
@property (nonatomic , strong) YYLabel   *roleLabel;

@property (nonatomic , strong) ZKNeaStatusLayout *layout;
@property (nonatomic , weak)   ZKNearCollectionCell *cell;

@end

@interface ZKNearCollectionCell : UICollectionViewCell

@property (nonatomic, strong) ZKNeaStatusView *statusView;
- (void)setLayout:(ZKNeaStatusLayout *)layout;

@end
