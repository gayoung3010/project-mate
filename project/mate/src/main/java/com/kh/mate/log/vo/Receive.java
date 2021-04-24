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
public class Receive {
	
	private int receiveNo;
	private String manufacturerId;
	private int amount;
	private Date regDate;
	private int confirm;
	private int productNo;
	private String empId;
	
	private String productName;
	private String category;
	private int price;
	private int stock;
}
