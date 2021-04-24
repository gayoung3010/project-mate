package com.kh.mate.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.kh.mate.erp.model.vo.EMP;

import lombok.extern.slf4j.Slf4j;
@Slf4j
public class EmpCheckInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		EMP loginEmp = (EMP)session.getAttribute("loginEmp");

		if(loginEmp == null) {
			
			FlashMap map = new FlashMap();

			map.put("msg", "관리자 회원만 이용가능한 페이지입니다.");
			FlashMapManager manager = RequestContextUtils.getFlashMapManager(request);
			manager.saveOutputFlashMap(map, request, response);

			response.sendRedirect(request.getContextPath() + "/member/memberLogin.do");
			return false;
		}
		
		
		
		
		return super.preHandle(request, response, handler);
	}
	

}
