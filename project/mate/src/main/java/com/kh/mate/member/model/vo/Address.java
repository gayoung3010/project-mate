package com.kh.mate.member.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Address {
	
	private String addressName;
	private String memberId;
	private String receiverName;
	private String receiverPhone;
	private String addr1;
	private String addr2;
	private String addr3;
	private Date regDate;

}
