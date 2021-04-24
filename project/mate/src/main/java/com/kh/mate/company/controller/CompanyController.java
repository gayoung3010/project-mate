package com.kh.mate.company.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kh.mate.company.model.service.CompanyService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class CompanyController {

	@Autowired
	private CompanyService companyService;
	
	@RequestMapping(path = "company/location",
					method = RequestMethod.GET)
	public String location(Model model) {
		
			List<Map<String, Object>> mapList = companyService.getAllCompany();
			log.debug("mapList@controller = {}", mapList);
			
			model.addAttribute("mapList", mapList);
			
			return "company/location";

		
	}
	
	
	@ExceptionHandler({Exception.class}) 
	public String error(Exception e) { 
		log.error("exception = {}", e);
		return "common/error"; 
	}
}
