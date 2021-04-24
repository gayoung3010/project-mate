package com.kh.mate.erp.model.vo;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class EmpBoard implements Serializable{

	private int boardNo;
	private String category;
	private String title;
	private String content;
	private String empId;
	private Date regDate;
	private int enabled;
	private List<EmpBoardImage> empBoardImageList;
	private int readCount;
	
	//boardInfo 추가
	private int boardInfoNo;
	private int productNo;
	private int amount;
	
	//상품명 지점명  추가
	private String productName;
	private String empName;
	private int stock;
}
