package com.kh.mate.cs.model.vo;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.type.Alias;

import com.kh.mate.cs.model.vo.CsImages;

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
public class Cs implements Serializable {

	private int csNo;
	private String title;
	private String content;
	private String memberId;
	private Date regDate;
	private int secret;
	private int notice;
	
	private CsImages csImage;
	private String renamedFilename;
	private int isReply;
	
}
