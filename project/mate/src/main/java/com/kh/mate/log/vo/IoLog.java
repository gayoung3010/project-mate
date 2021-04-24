package com.kh.mate.log.vo;

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
public class IoLog {
	//입출고
	private int ioNo;
	private String status;
	private int amount;
	private Date ioDate;
	private int productNo;
	private String empId;
	private String content;
	
}
