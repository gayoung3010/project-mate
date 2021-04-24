package com.kh.mate.cs.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.kh.mate.common.Pagebar;
import com.kh.mate.common.Utils;
import com.kh.mate.cs.model.service.CsService;
import com.kh.mate.cs.model.vo.Cs;
import com.kh.mate.cs.model.vo.CsImages;
import com.kh.mate.cs.model.vo.CsReply;

import lombok.extern.slf4j.Slf4j;


@Controller
@RequestMapping("/cs")
@Slf4j //PSA
public class CsController {

	@Autowired
	private CsService csService;
	
	@Autowired
	private ResourceLoader resourceLoader;
	
	@RequestMapping("/cs.do")
	@ResponseBody
	public ModelAndView boardList(ModelAndView mav,
								  @RequestParam(required=false, name="memberId") String memberId,
								  @RequestParam(required=false, name="secret") String secret,
								  @RequestParam(required=false, defaultValue = "1") int cPage
								  ,HttpServletRequest request) {
		int numPerPage = 10;
		int pageBarSize = 5;
		
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);
		
		Map<String, Object> options = new HashMap<>();
		options.put("memberId", memberId);
		options.put("secret", secret);
		pb.setOptions(options);
		
		List<Cs> list = csService.selectCsList(pb);
		log.debug("list = {}", list);
	
		String pageBar = pb.getPagebar();
		log.debug("pageBar = {}", pageBar);
		mav.addObject("memberId", memberId);
		mav.addObject("pageBar", pageBar);
		mav.addObject("list", list);
		mav.setViewName("cs/cs");
		return mav;
	}
//	@RequestMapping("/selectList.do")
//	@ResponseBody
//	public ResponseEntity<?> selectList(){
//		List<Cs> list = csService.selectCsList();
//		return new ResponseEntity<>(list, HttpStatus.OK);
//	}

	@RequestMapping(value = "/insertCs.do", method = RequestMethod.GET)
	public String insertCs() {
			return "cs/insertCs";
	}
	
	@RequestMapping(value = "/insertCs.do", method = RequestMethod.POST)
	public String insertsCs(Cs cs,
							RedirectAttributes redirectAttr,
							@RequestParam(value = "secret", defaultValue = "0") String secret_,
							@RequestParam(value = "upFile", required = false) MultipartFile upFile,
							@RequestParam("title") String title,
							@RequestParam("content") String content,
							@RequestParam("memberId") String memberId,
							@RequestParam(value = "notice", defaultValue = "0") String notice_,
							HttpServletRequest request) throws IllegalStateException, IOException{
		
			CsImages csImage = new CsImages();
			String saveDirectory = request.getServletContext().getRealPath("/resources/upload/cs");
				
			if(!upFile.isEmpty()) {
				String renamedFilename = Utils.getRenamedFileName(upFile.getOriginalFilename());	
				
				File file = new File(saveDirectory, renamedFilename);
				upFile.transferTo(file);
				
				
				csImage.setOriginalFilename(upFile.getOriginalFilename());
				csImage.setRenamedFilename(renamedFilename);
			}
			
			cs.setCsImage(csImage);
			
			log.debug("cs@controller = {}", cs);
			log.debug("csImage@controller = {}", csImage);
			
			int result = csService.insertCs(cs);

			cs.setContent(content);
			cs.setTitle(title);
			cs.setMemberId(memberId);
			cs.setSecret(secret_.equals("1") ? 1 : 0);
			cs.setNotice(notice_.equals("1") ? 1 : 0);
		
			String msg = (result > 0 ) ? "문의글이 등록되었습니다" : "문의글 등록에 실패했습니다";
		
			redirectAttr.addFlashAttribute("msg", msg);
		
		return "redirect:/cs/cs.do";
	}
	
	@RequestMapping(value = "/deleteCs.do",
			method = RequestMethod.POST)
	public String deleteCs(@RequestParam("csNo") String csNo_, 
						 RedirectAttributes redirectAttr){
	log.debug("문의글 삭제 번호 = {}", csNo_);
	int csNo = Integer.parseInt(csNo_);
	try {
		int result = csService.deleteCs(csNo);
		String msg = (result > 0) ? "문의글 삭제에 성공했습니다" : "문의글 삭제에 실패했습니다";
		redirectAttr.addFlashAttribute("msg", msg);
	} catch(Exception e) {
		log.error("문의글 삭제 오류", e);
		throw e;
	}
	return "redirect:/cs/cs.do";
	}
	
	
	@RequestMapping("/csDetail.do")
	public ModelAndView csDetail(@RequestParam("csNo") int csNo,
									ModelAndView mav) {
		log.debug("csno@controller = {}", csNo);
		Cs cs = csService.selectOneCsCollection(csNo);
		log.debug("cs@controller = {}", cs);
		CsImages csImage = csService.selectCsImage(csNo);
		
		if(csImage != null) {
			
			mav.addObject("csImage",csImage);
		}
		
		mav.addObject("cs", cs);
		mav.setViewName("cs/csDetail");
		return mav;
	}
	
	@RequestMapping("/fileDownload.do")
	@ResponseBody
	public Resource fileDownload(@RequestParam("csNo") int csNo,
								 HttpServletRequest request,
								 HttpServletResponse response,
								 @RequestHeader("user-agent") String userAgent) throws UnsupportedEncodingException {
		
		CsImages attach = csService.selectOneAttachment(csNo);
		String saveDirectory = request.getServletContext().getRealPath("resources/upload/cs");
		File downFile = new File(saveDirectory, attach.getRenamedFilename());
		
		Resource resource = resourceLoader.getResource("file:" + downFile);
		log.debug("resource = {}", resource);
	
		boolean isMSIE = userAgent.indexOf("Trident") != -1 || userAgent.indexOf("MSIE") != -1;
		
		String oName = attach.getOriginalFilename();
		
		if(isMSIE) oName = URLEncoder.encode(oName, "utf-8").replaceAll("\\+", "%20");
		else oName = new String(oName.getBytes("utf-8"), "iso-8859-1");
		
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + oName);
		
		return resource;
	}
	
	public void fileDownload(@RequestParam("csNo") int csNo,
							 HttpServletRequest request,
							 HttpServletResponse response,
							 ServletOutputStream sos,
							 @RequestHeader("user-agent") String userAgent) {
		log.debug("csNo = {}" ,csNo);
		CsImages csImages = csService.selectCsImage(csNo);
		log.debug("csImages = {}", csImages);
		String saveDirectory = request.getServletContext().getRealPath("/resources/upload/cs");
		File downFile = new File(saveDirectory, csImages.getRenamedFilename());
				
		try {
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(downFile));
			
			boolean isMSIE = userAgent.indexOf("Trident") != -1 || userAgent.indexOf("MSIE") != -1;
			
			String oName =  csImages.getOriginalFilename();
			
			if(isMSIE) oName = URLEncoder.encode(oName, "utf-8").replaceAll("\\+", "%20");
			else oName = new String(oName.getBytes("utf-8"), "iso-8859-1");
			
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment;filename=" + oName);
			
			int data = -1;
			while((data = bis.read()) != -1) {
				sos.write(data);
			}
			
			bis.close();
			sos.close();
		} catch (IOException e) {
			log.error("fileDownload = {}", e);
			
			FlashMap map = new FlashMap();
			map.put("msg", "지정된 파일을 찾을 수 없습니다.");
			FlashMapManager manager = RequestContextUtils.getFlashMapManager(request);
			manager.saveOutputFlashMap(map, request, response);

			try {
				response.sendRedirect(request.getHeader("referer"));
			} catch (IOException e1) {
				e1.printStackTrace();
			}

		}
		
	}
	
	@GetMapping("/csReplyList.do")
	@ResponseBody
	public List<CsReply> csReplyList(Model model, @RequestParam("csNo") int csNo){
		
		List<CsReply> list = csService.csReplyList(csNo);
		model.addAttribute("list", list);
		log.debug("replyList = {}", list);
		return list;
	}

	
	@PostMapping("/csReplyEnroll.do")
	public String csReplyEnroll(CsReply csReply, ModelAndView mav
							  ,RedirectAttributes redirectAttributes) {
			
		log.debug("csReply= {}", csReply);
		int result = csService.csReply(csReply);
		log.debug("result = {}", result);
		log.debug("result = {}", result);
		
		return "redirect:/cs/csDetail.do?csNo=" + csReply.getCsNo();
	}
	
	@PostMapping("/csReplyDelete.do")
	@ResponseBody
	public Map<String, Object> replydelete(@RequestParam("csReplyNo") int csReplyNo, RedirectAttributes redirectAttr, Model model) {
		
		Map<String, Object> map = new HashMap<>();
		log.debug("csReplyNo = {}", csReplyNo);
		int result = csService.csDeleteReply(csReplyNo);
		
		boolean Available= (result > 0) ?  true : false;
		log.debug("isValiable= {}", Available);
		map.put("isAvailable", Available);
		return map;
	}
	
	@ExceptionHandler({Exception.class}) 
	public String error(Exception e) { 
		log.error("exception = {}", e);
		return "common/error"; 
	}

}
