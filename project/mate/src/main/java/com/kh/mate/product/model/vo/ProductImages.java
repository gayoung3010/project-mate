package com.kh.mate.product.model.vo;

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
public class ProductImages {
	
	private int productImageNo;
//	private String originalFilename;
	private String renamedFilename;
	private int productNo;
	//private String empId2;

}
