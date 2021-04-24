package com.kh.mate.cs.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.kh.mate.common.Pagebar;
import com.kh.mate.cs.model.dao.CsDAO;
import com.kh.mate.cs.model.vo.Cs;
import com.kh.mate.cs.model.vo.CsImages;
import com.kh.mate.cs.model.vo.CsReply;

import lombok.extern.slf4j.Slf4j;

@Transactional(propagation = Propagation.REQUIRED,  
			   isolation = Isolation.READ_COMMITTED, 
			   rollbackFor = Exception.class)
@Slf4j
@Service
public class CsServiceImpl implements CsService {

	@Autowired
	private CsDAO csDAO;

	@Override
	public List<Cs> selectCsList(Pagebar pb) {
		int totalContents = csDAO.getSearchContent(pb);
		pb.setTotalContents(totalContents);
		return csDAO.selectCsList(pb);
	}
	
	@Override
	public int insertCs(Cs cs) {
		int result = 0;

		result = csDAO.insertCs(cs);

		if(cs.getCsImage().getOriginalFilename() != null) {
			CsImages csImage = cs.getCsImage();
			csImage.setCsNo(cs.getCsNo());
			result = csDAO.insertCsImage(csImage);
			log.debug("csImage={}", csImage);
		}
		
		return result;
	}

	
	@Override
	public int deleteCs(int csNo) {
		
		return csDAO.deleteCs(csNo);
	}
	
	@Transactional(readOnly = true)
	@Override
	public Cs selectOneCs(int csNo) {
		
		Cs cs = csDAO.selectOneCs(csNo);
		
		CsImages csImage = csDAO.selectCsImage(csNo);
		cs.setCsImage(csImage);
		return cs;
	}
	
	//
	@Override
	public Cs selectOneCsCollection(int csNo) {
		
		return csDAO.selectOneCsCollection(csNo);
	}
	
	//첨부파일 하나
	@Override
	public CsImages selectOneAttachment(int csNo) {
		
		return csDAO.selectOneAttachment(csNo);
	}

	@Override
	public List<CsReply> csReplyList(int csNo) {
		
		return csDAO.csReplyList(csNo);
	}

	@Override
	public int csReply(CsReply csReply) {
		
		return csDAO.csReplyEnroll(csReply);
	}

	@Override
	public int csDeleteReply(int csReplyNo) {
		
		return csDAO.csDeleteReply(csReplyNo);
	}

	@Override
	public List<Cs> selectCsList() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public CsImages selectCsImage(int csNo) {
		// TODO Auto-generated method stub
		return csDAO.selectCsImage(csNo);
	}

	
	
	
	
}
