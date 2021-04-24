package com.kh.mate.cs.model.vo;

import java.io.Serializable;
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
public class CsImages implements Serializable{

	private int csImageNo;
	private String originalFilename;
	private String renamedFilename;
	private int csNo;
}
