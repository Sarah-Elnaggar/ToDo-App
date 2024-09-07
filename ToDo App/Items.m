//
//  Items.m
//  ToDo App
//
//  Created by Sarah on 17/07/2024.
//

#import "Items.h"

@implementation Items

- (nonnull instancetype)initWithID: (NSInteger)ID Andtitle:(nonnull NSString *)title Anddescription:(nonnull NSString *)description Andpriority:(NSNumber*)priority Andtype:(NSNumber*)type Anddate:(NSDate*)date{
    if(self = [super init]){
        self.ID = ID;
        self.title = title;
        self.descriptionn = description;
        self.priority = priority;
        self.type = type;
        self.date = date;
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *) encoder {
    [encoder encodeInteger:_ID forKey:@"id"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_descriptionn forKey:@"description"];
    [encoder encodeObject:_priority forKey:@"priority"];
    [encoder encodeObject:_type forKey:@"type"];
    [encoder encodeObject:_date forKey:@"date"];

}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *) decoder {
    if((self = [super init])){
        _ID =[decoder decodeIntegerForKey:@"id"];
        _title =[decoder decodeObjectOfClass:[NSString class] forKey:@"title" ];
        _descriptionn =[decoder decodeObjectOfClass:[NSString class] forKey:@"description" ];
        _priority =[decoder decodeObjectOfClass:[NSNumber class] forKey:@"priority" ];
        _type =[decoder decodeObjectOfClass:[NSNumber class] forKey:@"type" ];
        _date =[decoder decodeObjectOfClass:[NSDate class] forKey:@"date" ];

    }
    
    return self;
}

+(BOOL)supportsSecureCoding{
    return YES;
}





@end
