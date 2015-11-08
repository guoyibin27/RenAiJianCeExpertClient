//
//  ReservationTableViewCell.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "ReservationTableViewCell.h"
#import "Constants.h"

@implementation ReservationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    
        _amount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 10, 100, 21)];
        _amount.textColor = Hex2UIColor(0xff6600);
        _amount.textAlignment = NSTextAlignmentRight;
        _amount.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE_MIDDLE];
        
        _reservationName = [[UILabel alloc] initWithFrame:CGRectMake(20, 10,SCREEN_WIDTH - (CGRectGetWidth(_amount.frame)) - 50,21)];
        _reservationName.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE_MIDDLE];
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_reservationName.frame) + 10, SCREEN_WIDTH - 40, 1)];
        _line.backgroundColor = Hex2UIColor(0x9a9a9a);
        
        _reserveDate = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_line.frame) + 5, SCREEN_WIDTH - 40,  21)];
        _reserveDate.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE_SMALL];
        _reserveDate.textColor = Hex2UIColor(0xa0a0a0);
        
        
        _reserveType = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_reserveDate.frame) + 5, SCREEN_WIDTH - 40,  21)];
        _reserveType.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE_SMALL];
        _reserveType.textColor = Hex2UIColor(0xa0a0a0);
        
        _reserveBy = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_reserveType.frame) + 5, SCREEN_WIDTH - 40,  21)];
        _reserveBy.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE_SMALL];
        _reserveBy.textColor = Hex2UIColor(0xa0a0a0);
        
        _reservationStatus = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_reserveBy.frame) + 5, SCREEN_WIDTH - 40,  21)];
        _reservationStatus.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE_SMALL];
        _reservationStatus.textColor = Hex2UIColor(0xa0a0a0);
        
        _entryRoom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EntryChatRoom"]];
        _entryRoom.frame = CGRectMake(SCREEN_WIDTH - 83, CGRectGetMaxY(_reservationStatus.frame) + 5, 73, 21);
        
        [self.contentView addSubview:_amount];
        [self.contentView addSubview:_line];
        [self.contentView addSubview:_reservationName];
        [self.contentView addSubview:_reservationStatus];
        [self.contentView addSubview:_reserveBy];
        [self.contentView addSubview:_reserveDate];
        [self.contentView addSubview:_reserveType];
        [self.contentView addSubview:_entryRoom];
    }
    return self;
}

@end
