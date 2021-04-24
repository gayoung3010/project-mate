package com.kh.mate.product.model.vo;

import java.util.Date;
import java.util.List;

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
public class Product {

	private int productNo;
	private String manufacturerId; //제조사
	private String productName;
	private int stock;
	private Date regDate;
	private String category;
	private String content;
	private int price;
	private int enabled;
	
	
	private List<String> productImagesName;
	private List<ProductImages> productImages;
	private List<ProductMainImages> pmiList;
	private String amount;
	
	private String empName;//지점명(임시)
	private String branchEmp; //지점ID(임시)
	private String empId;
	private int confirm;
}
