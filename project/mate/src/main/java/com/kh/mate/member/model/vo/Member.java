package com.kh.mate.member.model.vo;

import java.io.Serializable;
import java.sql.Date;

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
public class Member {

	private String memberId;
	private String memberPWD;
	private String memberName;
	private String gender;
	private String phone;
	private Date enrollDate;
	
}
