package com.kh.mate.erp.model.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class EmpBoardReply implements Serializable{
	private int boardReplyNo;
	private String content;
	private Date regDate;
	private int boardNo;
	private String empId;
	private String empName;
	
}
