//
//  CustumAnnotationView.h
//  MapTest
//
//  Created by adan on 16/8/10.
//  Copyright © 2016年 adan. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class CustumView;

@interface CustumAnnotationView : MAAnnotationView
@property (nonatomic, strong, readwrite) CustumView *calloutView;
@end
