//
//  CCContact.m
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import "CCContact.h"
#import "CCPersonalCard.h"
#import "CCProfilePicture.h"
#import "CCWorkCard.h"

struct CCContactDirtyProperties {
    unsigned int CCContactDirtyPropertyCreatedAt:1;
    unsigned int CCContactDirtyPropertyFirstName:1;
    unsigned int CCContactDirtyPropertyFullName:1;
    unsigned int CCContactDirtyPropertyIdentifier:1;
    unsigned int CCContactDirtyPropertyLastName:1;
    unsigned int CCContactDirtyPropertyPersonalCard:1;
    unsigned int CCContactDirtyPropertyProfilePicture:1;
    unsigned int CCContactDirtyPropertyUpdatedAt:1;
    unsigned int CCContactDirtyPropertyWorkCard:1;
};

@interface CCContact ()
@property (nonatomic, assign, readwrite) struct CCContactDirtyProperties contactDirtyProperties;
@end

@interface CCContactBuilder ()
@property (nonatomic, assign, readwrite) struct CCContactDirtyProperties contactDirtyProperties;
@end

@implementation CCContact
+ (NSString *)className
{
    return @"CCContact";
}
+ (NSString *)polymorphicTypeIdentifier
{
    return @"contact";
}
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithModelDictionary:dictionary];
}
- (instancetype)init
{
    return [self initWithModelDictionary:@{}];
}
- (instancetype)initWithModelDictionary:(NS_VALID_UNTIL_END_OF_SCOPE NSDictionary *)modelDictionary
{
    NSParameterAssert(modelDictionary);
    if (!modelDictionary) {
        return self;
    }
    if (!(self = [super init])) {
        return self;
    }
        {
            __unsafe_unretained id value = modelDictionary[@"created_at"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_createdAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyCreatedAt = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"first_name"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_firstName = [value copy];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyFirstName = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"full_name"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_fullName = [value copy];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyFullName = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"id"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_identifier = [value integerValue];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyIdentifier = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"last_name"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_lastName = [value copy];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyLastName = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"personal_card"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_personalCard = [CCPersonalCard modelObjectWithDictionary:value];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyPersonalCard = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"profile_picture"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_profilePicture = [CCProfilePicture modelObjectWithDictionary:value];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyProfilePicture = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"updated_at"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_updatedAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyUpdatedAt = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"work_card"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_workCard = [CCWorkCard modelObjectWithDictionary:value];
                }
                self->_contactDirtyProperties.CCContactDirtyPropertyWorkCard = 1;
            }
        }
    if ([self class] == [CCContact class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (instancetype)initWithBuilder:(CCContactBuilder *)builder
{
    NSParameterAssert(builder);
    return [self initWithBuilder:builder initType:PlankModelInitTypeDefault];
}
- (instancetype)initWithBuilder:(CCContactBuilder *)builder initType:(PlankModelInitType)initType
{
    NSParameterAssert(builder);
    if (!(self = [super init])) {
        return self;
    }
    _createdAt = builder.createdAt;
    _firstName = builder.firstName;
    _fullName = builder.fullName;
    _identifier = builder.identifier;
    _lastName = builder.lastName;
    _personalCard = builder.personalCard;
    _profilePicture = builder.profilePicture;
    _updatedAt = builder.updatedAt;
    _workCard = builder.workCard;
    _contactDirtyProperties = builder.contactDirtyProperties;
    if ([self class] == [CCContact class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(initType) }];
    }
    return self;
}
- (NSString *)debugDescription
{
    NSArray<NSString *> *parentDebugDescription = [[super debugDescription] componentsSeparatedByString:@"\n"];
    NSMutableArray *descriptionFields = [NSMutableArray arrayWithCapacity:9];
    [descriptionFields addObject:parentDebugDescription];
    struct CCContactDirtyProperties props = _contactDirtyProperties;
    if (props.CCContactDirtyPropertyCreatedAt) {
        [descriptionFields addObject:[@"_createdAt = " stringByAppendingFormat:@"%@", _createdAt]];
    }
    if (props.CCContactDirtyPropertyFirstName) {
        [descriptionFields addObject:[@"_firstName = " stringByAppendingFormat:@"%@", _firstName]];
    }
    if (props.CCContactDirtyPropertyFullName) {
        [descriptionFields addObject:[@"_fullName = " stringByAppendingFormat:@"%@", _fullName]];
    }
    if (props.CCContactDirtyPropertyIdentifier) {
        [descriptionFields addObject:[@"_identifier = " stringByAppendingFormat:@"%@", @(_identifier)]];
    }
    if (props.CCContactDirtyPropertyLastName) {
        [descriptionFields addObject:[@"_lastName = " stringByAppendingFormat:@"%@", _lastName]];
    }
    if (props.CCContactDirtyPropertyPersonalCard) {
        [descriptionFields addObject:[@"_personalCard = " stringByAppendingFormat:@"%@", _personalCard]];
    }
    if (props.CCContactDirtyPropertyProfilePicture) {
        [descriptionFields addObject:[@"_profilePicture = " stringByAppendingFormat:@"%@", _profilePicture]];
    }
    if (props.CCContactDirtyPropertyUpdatedAt) {
        [descriptionFields addObject:[@"_updatedAt = " stringByAppendingFormat:@"%@", _updatedAt]];
    }
    if (props.CCContactDirtyPropertyWorkCard) {
        [descriptionFields addObject:[@"_workCard = " stringByAppendingFormat:@"%@", _workCard]];
    }
    return [NSString stringWithFormat:@"CCContact = {\n%@\n}", debugDescriptionForFields(descriptionFields)];
}
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(CCContactBuilder *builder))block
{
    NSParameterAssert(block);
    CCContactBuilder *builder = [[CCContactBuilder alloc] initWithModel:self];
    block(builder);
    return [builder build];
}
- (BOOL)isEqual:(id)anObject
{
    if (self == anObject) {
        return YES;
    }
    if ([anObject isKindOfClass:[CCContact class]] == NO) {
        return NO;
    }
    return [self isEqualToContact:anObject];
}
- (BOOL)isEqualToContact:(CCContact *)anObject
{
    return (
        (anObject != nil) &&
        (_identifier == anObject.identifier) &&
        (_createdAt == anObject.createdAt || [_createdAt isEqualToDate:anObject.createdAt]) &&
        (_firstName == anObject.firstName || [_firstName isEqualToString:anObject.firstName]) &&
        (_fullName == anObject.fullName || [_fullName isEqualToString:anObject.fullName]) &&
        (_lastName == anObject.lastName || [_lastName isEqualToString:anObject.lastName]) &&
        (_personalCard == anObject.personalCard || [_personalCard isEqual:anObject.personalCard]) &&
        (_profilePicture == anObject.profilePicture || [_profilePicture isEqual:anObject.profilePicture]) &&
        (_updatedAt == anObject.updatedAt || [_updatedAt isEqualToDate:anObject.updatedAt]) &&
        (_workCard == anObject.workCard || [_workCard isEqual:anObject.workCard])
    );
}
- (NSUInteger)hash
{
    NSUInteger subhashes[] = {
        17,
        [_createdAt hash],
        [_firstName hash],
        [_fullName hash],
        (NSUInteger)_identifier,
        [_lastName hash],
        [_personalCard hash],
        [_profilePicture hash],
        [_updatedAt hash],
        [_workCard hash]
    };
    return PINIntegerArrayHash(subhashes, sizeof(subhashes) / sizeof(subhashes[0]));
}
- (instancetype)mergeWithModel:(CCContact *)modelObject
{
    return [self mergeWithModel:modelObject initType:PlankModelInitTypeFromMerge];
}
- (instancetype)mergeWithModel:(CCContact *)modelObject initType:(PlankModelInitType)initType
{
    NSParameterAssert(modelObject);
    CCContactBuilder *builder = [[CCContactBuilder alloc] initWithModel:self];
    [builder mergeWithModel:modelObject];
    return [[CCContact alloc] initWithBuilder:builder initType:initType];
}
- (NSDictionary *)dictionaryObjectRepresentation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:9];
    if (_contactDirtyProperties.CCContactDirtyPropertyCreatedAt) {
        if (_createdAt != (id)kCFNull) {
            NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey];
            if ([[valueTransformer class] allowsReverseTransformation]) {
                [dict setObject:[valueTransformer reverseTransformedValue:_createdAt] forKey:@"created_at"];
            } else {
                [dict setObject:[NSNull null] forKey:@"created_at"];
            }
        } else {
            [dict setObject:[NSNull null] forKey:@"created_at"];
        }
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyFirstName) {
        if (_firstName != (id)kCFNull) {
            [dict setObject:_firstName forKey:@"first_name"];
        } else {
            [dict setObject:[NSNull null] forKey:@"first_name"];
        }
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyFullName) {
        if (_fullName != (id)kCFNull) {
            [dict setObject:_fullName forKey:@"full_name"];
        } else {
            [dict setObject:[NSNull null] forKey:@"full_name"];
        }
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyIdentifier) {
        [dict setObject:@(_identifier) forKey: @"id"];
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyLastName) {
        if (_lastName != (id)kCFNull) {
            [dict setObject:_lastName forKey:@"last_name"];
        } else {
            [dict setObject:[NSNull null] forKey:@"last_name"];
        }
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyPersonalCard) {
        if (_personalCard != (id)kCFNull) {
            [dict setObject:[_personalCard dictionaryObjectRepresentation] forKey:@"personal_card"];
        } else {
            [dict setObject:[NSNull null] forKey:@"personal_card"];
        }
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyProfilePicture) {
        if (_profilePicture != (id)kCFNull) {
            [dict setObject:[_profilePicture dictionaryObjectRepresentation] forKey:@"profile_picture"];
        } else {
            [dict setObject:[NSNull null] forKey:@"profile_picture"];
        }
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyUpdatedAt) {
        if (_updatedAt != (id)kCFNull) {
            NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey];
            if ([[valueTransformer class] allowsReverseTransformation]) {
                [dict setObject:[valueTransformer reverseTransformedValue:_updatedAt] forKey:@"updated_at"];
            } else {
                [dict setObject:[NSNull null] forKey:@"updated_at"];
            }
        } else {
            [dict setObject:[NSNull null] forKey:@"updated_at"];
        }
    }
    if (_contactDirtyProperties.CCContactDirtyPropertyWorkCard) {
        if (_workCard != (id)kCFNull) {
            [dict setObject:[_workCard dictionaryObjectRepresentation] forKey:@"work_card"];
        } else {
            [dict setObject:[NSNull null] forKey:@"work_card"];
        }
    }
    return dict;
}
#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super init])) {
        return self;
    }
    _createdAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"created_at"];
    _firstName = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"first_name"];
    _fullName = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"full_name"];
    _identifier = [aDecoder decodeIntegerForKey:@"id"];
    _lastName = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"last_name"];
    _personalCard = [aDecoder decodeObjectOfClass:[CCPersonalCard class] forKey:@"personal_card"];
    _profilePicture = [aDecoder decodeObjectOfClass:[CCProfilePicture class] forKey:@"profile_picture"];
    _updatedAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"updated_at"];
    _workCard = [aDecoder decodeObjectOfClass:[CCWorkCard class] forKey:@"work_card"];
    _contactDirtyProperties.CCContactDirtyPropertyCreatedAt = [aDecoder decodeIntForKey:@"created_at_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyFirstName = [aDecoder decodeIntForKey:@"first_name_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyFullName = [aDecoder decodeIntForKey:@"full_name_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyIdentifier = [aDecoder decodeIntForKey:@"id_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyLastName = [aDecoder decodeIntForKey:@"last_name_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyPersonalCard = [aDecoder decodeIntForKey:@"personal_card_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyProfilePicture = [aDecoder decodeIntForKey:@"profile_picture_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyUpdatedAt = [aDecoder decodeIntForKey:@"updated_at_dirty_property"] & 0x1;
    _contactDirtyProperties.CCContactDirtyPropertyWorkCard = [aDecoder decodeIntForKey:@"work_card_dirty_property"] & 0x1;
    if ([self class] == [CCContact class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.createdAt forKey:@"created_at"];
    [aCoder encodeObject:self.firstName forKey:@"first_name"];
    [aCoder encodeObject:self.fullName forKey:@"full_name"];
    [aCoder encodeInteger:self.identifier forKey:@"id"];
    [aCoder encodeObject:self.lastName forKey:@"last_name"];
    [aCoder encodeObject:self.personalCard forKey:@"personal_card"];
    [aCoder encodeObject:self.profilePicture forKey:@"profile_picture"];
    [aCoder encodeObject:self.updatedAt forKey:@"updated_at"];
    [aCoder encodeObject:self.workCard forKey:@"work_card"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyCreatedAt forKey:@"created_at_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyFirstName forKey:@"first_name_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyFullName forKey:@"full_name_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyIdentifier forKey:@"id_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyLastName forKey:@"last_name_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyPersonalCard forKey:@"personal_card_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyProfilePicture forKey:@"profile_picture_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyUpdatedAt forKey:@"updated_at_dirty_property"];
    [aCoder encodeInt:_contactDirtyProperties.CCContactDirtyPropertyWorkCard forKey:@"work_card_dirty_property"];
}
@end

@implementation CCContactBuilder
- (instancetype)initWithModel:(CCContact *)modelObject
{
    NSParameterAssert(modelObject);
    if (!(self = [super init])) {
        return self;
    }
    struct CCContactDirtyProperties contactDirtyProperties = modelObject.contactDirtyProperties;
    if (contactDirtyProperties.CCContactDirtyPropertyCreatedAt) {
        _createdAt = modelObject.createdAt;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyFirstName) {
        _firstName = modelObject.firstName;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyFullName) {
        _fullName = modelObject.fullName;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyIdentifier) {
        _identifier = modelObject.identifier;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyLastName) {
        _lastName = modelObject.lastName;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyPersonalCard) {
        _personalCard = modelObject.personalCard;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyProfilePicture) {
        _profilePicture = modelObject.profilePicture;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyUpdatedAt) {
        _updatedAt = modelObject.updatedAt;
    }
    if (contactDirtyProperties.CCContactDirtyPropertyWorkCard) {
        _workCard = modelObject.workCard;
    }
    _contactDirtyProperties = contactDirtyProperties;
    return self;
}
- (CCContact *)build
{
    return [[CCContact alloc] initWithBuilder:self];
}
- (void)mergeWithModel:(CCContact *)modelObject
{
    NSParameterAssert(modelObject);
    CCContactBuilder *builder = self;
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyCreatedAt) {
        builder.createdAt = modelObject.createdAt;
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyFirstName) {
        builder.firstName = modelObject.firstName;
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyFullName) {
        builder.fullName = modelObject.fullName;
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyIdentifier) {
        builder.identifier = modelObject.identifier;
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyLastName) {
        builder.lastName = modelObject.lastName;
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyPersonalCard) {
        id value = modelObject.personalCard;
        if (value != nil) {
            if (builder.personalCard) {
                builder.personalCard = [builder.personalCard mergeWithModel:value initType:PlankModelInitTypeFromSubmerge];
            } else {
                builder.personalCard = value;
            }
        } else {
            builder.personalCard = nil;
        }
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyProfilePicture) {
        id value = modelObject.profilePicture;
        if (value != nil) {
            if (builder.profilePicture) {
                builder.profilePicture = [builder.profilePicture mergeWithModel:value initType:PlankModelInitTypeFromSubmerge];
            } else {
                builder.profilePicture = value;
            }
        } else {
            builder.profilePicture = nil;
        }
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyUpdatedAt) {
        builder.updatedAt = modelObject.updatedAt;
    }
    if (modelObject.contactDirtyProperties.CCContactDirtyPropertyWorkCard) {
        id value = modelObject.workCard;
        if (value != nil) {
            if (builder.workCard) {
                builder.workCard = [builder.workCard mergeWithModel:value initType:PlankModelInitTypeFromSubmerge];
            } else {
                builder.workCard = value;
            }
        } else {
            builder.workCard = nil;
        }
    }
}
- (void)setCreatedAt:(NSDate *)createdAt
{
    _createdAt = [createdAt copy];
    _contactDirtyProperties.CCContactDirtyPropertyCreatedAt = 1;
}
- (void)setFirstName:(NSString *)firstName
{
    _firstName = [firstName copy];
    _contactDirtyProperties.CCContactDirtyPropertyFirstName = 1;
}
- (void)setFullName:(NSString *)fullName
{
    _fullName = [fullName copy];
    _contactDirtyProperties.CCContactDirtyPropertyFullName = 1;
}
- (void)setIdentifier:(NSInteger)identifier
{
    _identifier = identifier;
    _contactDirtyProperties.CCContactDirtyPropertyIdentifier = 1;
}
- (void)setLastName:(NSString *)lastName
{
    _lastName = [lastName copy];
    _contactDirtyProperties.CCContactDirtyPropertyLastName = 1;
}
- (void)setPersonalCard:(CCPersonalCard *)personalCard
{
    _personalCard = personalCard;
    _contactDirtyProperties.CCContactDirtyPropertyPersonalCard = 1;
}
- (void)setProfilePicture:(CCProfilePicture *)profilePicture
{
    _profilePicture = profilePicture;
    _contactDirtyProperties.CCContactDirtyPropertyProfilePicture = 1;
}
- (void)setUpdatedAt:(NSDate *)updatedAt
{
    _updatedAt = [updatedAt copy];
    _contactDirtyProperties.CCContactDirtyPropertyUpdatedAt = 1;
}
- (void)setWorkCard:(CCWorkCard *)workCard
{
    _workCard = workCard;
    _contactDirtyProperties.CCContactDirtyPropertyWorkCard = 1;
}
@end
