//
//  Items.h
//  ToDo App
//
//  Created by Sarah on 17/07/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Items : NSObject <NSCoding, NSSecureCoding>

@property NSString* title;
@property NSString* descriptionn;
@property NSNumber* priority;
@property NSNumber* type;
@property NSDate* date;
@property NSInteger ID;




-(instancetype)initWithID: (NSInteger)ID Andtitle :(NSString*)title Anddescription:(NSString*)descriptionn Andpriority:(NSNumber*)priority Andtype:(NSNumber*)type Anddate:(NSDate*)date;


@end

NS_ASSUME_NONNULL_END
