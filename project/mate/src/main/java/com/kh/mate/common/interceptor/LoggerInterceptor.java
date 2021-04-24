package com.kh.mate.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/**
 * 
 *  DispacherServlet --- Handler메소드에 호출되기 직전
 *  1. preHandle : 핸들러메소드 호출전
 *  2. postHandle : 핸들러메소드가 DispatcherServlet으로 리턴되기 전
 *  3. afterCompletion : view단 처리가 끝난 시점, 
 *
 */
public class LoggerInterceptor extends HandlerInterceptorAdapter{

	private static Logger log = LoggerFactory.getLogger(LoggerInterceptor.class);
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
			
		log.debug("=================start===================");
		log.debug(request.getRequestURI());
		log.debug("handler= {}",handler);
		log.debug("------------------------------------------");
		//항상 true를 리턴해야 정상적인 흐름이 가능하다. 만약에 false를 해버리면 끊긴다.
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView mav) throws Exception {
		//핸들러에 작성한 뷰모델을 확인할 수 있다.
		
		super.postHandle(request, response, handler, mav);
		
		log.debug("==================start2=====================");
		log.debug("mav = {}", mav);
		log.debug("------------------------------------------");
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
		super.afterCompletion(request, response, handler, ex);
		
		log.debug("==================start3=====================");
		log.debug("ex = {}", ex);
		log.debug("------------------------------------------");
		log.debug("==================end=====================\n");
	}

	
	
	
}
