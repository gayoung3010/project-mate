package com.kh.mate.erp.model.vo;

import java.io.Serializable;

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
public class EmpBoardImage implements Serializable{

	private int boardImageNo;
	private String originalFilename;
	private String renamedFilename;
	private int boardNo;
	
}
