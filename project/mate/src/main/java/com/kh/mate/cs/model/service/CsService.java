package com.kh.mate.cs.model.service;

import java.util.List;

import com.kh.mate.common.Pagebar;
import com.kh.mate.cs.model.vo.Cs;
import com.kh.mate.cs.model.vo.CsImages;
import com.kh.mate.cs.model.vo.CsReply;

public interface CsService {

	List<Cs> selectCsList(Pagebar pb);

	int insertCs(Cs cs);

	int deleteCs(int csNo);
	
	Cs selectOneCs(int csNo);

	Cs selectOneCsCollection(int csNo);

	CsImages selectOneAttachment(int csNo);

	List<CsReply> csReplyList(int csNo);
	
	int csReply(CsReply csReply);
	
	int csDeleteReply(int csReplyNo);

	List<Cs> selectCsList();

	CsImages selectCsImage(int csNo);



	
	

}
