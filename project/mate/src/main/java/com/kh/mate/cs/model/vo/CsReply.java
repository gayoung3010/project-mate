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
public class CsReply implements Serializable {

	private int csReplyNo;
	private String content;
	private Date regDate;
	private int csNo;
	private String memberId;
	private String memberName;
}
