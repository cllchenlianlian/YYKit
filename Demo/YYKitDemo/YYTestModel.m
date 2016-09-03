//
//  YYTestModel.m
//  YYKitDemo
//
//  Created by DMW_W on 16/8/26.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "YYTestModel.h"

@implementation YYTestModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"role" : @"sex_type"};
}

- (NSString *)role {
    return [self _srole];
}

- (NSString *)_srole {
    if (_role && ![_role isEqualToString:@""]) {
        if ([_role isEqualToString:@"1"]) {
            if (YES) {
                return @"1";
            }
            else{
                return @"T";
            }
        } else if ([_role isEqualToString:@"0"]) {
            if (YES) {
                return @"0";
            }
            else{
                return @"B";
            }
        } else if ([_role isEqualToString:@"0.5"]){
            if (YES) {
                return @"0.5";
            }
            else{
                return  @"V";
            }
        } else {
            if (YES) {
                return @"~";
            }
            else{
                return @"~";
            }
        }
    } else {
        return @"";
    }
}

@end
