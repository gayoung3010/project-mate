package com.kh.mate.product.model.vo;

import java.io.Serializable;

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
public class Cart implements Serializable{
	
	private String memberId;
	private int productNo;
	private int amount;
	
	private Product selectedProduct;

}
