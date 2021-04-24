package com.kh.mate.company.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.mate.company.model.dao.CompanyDAO;

@Service
public class CompanyServiceImpl implements CompanyService {

	@Autowired
	private CompanyDAO companyDAO;

	@Override
	public List<Map<String, Object>> getAllCompany() {
		return companyDAO.getAllCompany();
	}
}
