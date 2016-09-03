//
//  YYTestTableViewCell.m
//  YYKitDemo
//
//  Created by DMW_W on 16/8/25.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "ZKNearCollectionCell.h"

@implementation ZKNeaStatusLayout

- (instancetype)initWithModel:(YYTestModel *)model {
    self = [super init];
    _model = model;
    CGFloat width  = cellWidth - 2 * 8;
    CGFloat heigth = cellHeigth;
    _height        = heigth;
    _picHeight     = width;
    
    // name + dis
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.username];
    [text appendString:@"\n"];
    [text appendString:model.distance];
    text.font = [UIFont systemFontOfSize:13];
    text.color = [UIColor grayColor];
    text.lineBreakMode = NSLineBreakByCharWrapping;
    text.lineSpacing = 8;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width - 2 * 8 , heigth - _picHeight - 8)];
    container.maximumNumberOfRows = 2;
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    _textHeight = heigth - _picHeight - 8;
    
    text        = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [text appendString:model.role];
    text.font   = [UIFont systemFontOfSize:13];
    text.color  = [UIColor grayColor];
    text.lineBreakMode = NSLineBreakByCharWrapping;
    text.alignment   = NSTextAlignmentRight;
    text.lineSpacing = 8;
    container   = [YYTextContainer containerWithSize:CGSizeMake(20, heigth - _picHeight - 8)];
    container.maximumNumberOfRows = 2;
    _roleLayout = [YYTextLayout layoutWithContainer:container text:text];
    return self;
}


@end

@implementation ZKNeaStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.width  = cellWidth;
    frame.size.height = 1;
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.exclusiveTouch  = YES;
    
    CGFloat space = 8;
    
    _contentView = [UIView new];
    _contentView.width = cellWidth;
    _contentView.height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    
    _imageView = [CALayer new];
    _imageView.size = CGSizeMake(cellWidth - 2 * space, cellWidth - 2 * space);
    _imageView.top  = space;
    _imageView.left = space;
    _imageView.backgroundColor = [UIColor clearColor].CGColor;
    [_contentView.layer addSublayer:_imageView];
    
    _newbie      = [CALayer new];
    _newbie.size = CGSizeMake(24, 24);
    _newbie.right= cellWidth - space;
    _newbie.top  = space;
    
    _online = [CALayer layer];
    _online.contents = (__bridge id)([UIImage imageNamed:@"iconUserStatusOnlineNew"].CGImage);
    _online.size = CGSizeMake(9, 9);
    _online.right    = cellWidth - space - 3;
    [_contentView.layer addSublayer:_online];
    
    _textLabel = [YYLabel new];
    _textLabel.left = space;
    _textLabel.width = cellWidth - 2 * space;
    [_contentView addSubview:_textLabel];
    
    _roleLabel = [YYLabel new];
    _roleLabel.width = 20;
    _roleLabel.right = cellWidth - space;
    [_contentView addSubview:_roleLabel];
    return self;
}

- (void)setLayout:(ZKNeaStatusLayout *)layout {
    _layout = layout;
    [_imageView setImageWithURL:[NSURL URLWithString:_layout.model.avatar]
                         placeholder:nil
                             options:YYWebImageOptionSetImageWithFadeAnimation
                             manager:[self avatarImageManager] progress:nil transform:nil
                          completion:nil];
    if (layout.model.feature.length > 4) {
        _newbie.hidden = NO;
        [_newbie setImageWithURL:[NSURL URLWithString:layout.model.feature] options:YYWebImageOptionSetImageWithFadeAnimation];
    }else {
        _newbie.hidden = YES;
    }
    _online.hidden        = !layout.model.online;
    _online.bottom        = _imageView.bottom - 3;
    _textLabel.top        = _imageView.bottom ;
    _textLabel.height     = _layout.textHeight;
    _textLabel.textLayout = _layout.textLayout;
    
    _roleLabel.textLayout = _layout.roleLayout;
    _roleLabel.top        = _imageView.bottom;
    _roleLabel.height     = _layout.textHeight;
}
/** 生成圆角为2的图片 */
- (YYWebImageManager *)avatarImageManager {
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"weibo.avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image imageByRoundCornerRadius:2];
        };
    });
    return manager;
}

@end

@implementation ZKNearCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    _statusView = [ZKNeaStatusView new];
    [self.contentView addSubview:_statusView];
    _statusView.cell = self;
    return self;
}

- (void)setLayout:(ZKNeaStatusLayout *)layout {
    self.height = layout.height;
    _statusView.height = layout.height;
    _statusView.layout = layout;
}

@end
