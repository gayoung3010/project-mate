package com.kh.mate.erp.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.mate.common.Pagebar;
import com.kh.mate.common.Utils;
import com.kh.mate.common.files.FileUtils;
import com.kh.mate.erp.model.service.ErpService;
import com.kh.mate.erp.model.vo.EMP;
import com.kh.mate.erp.model.vo.EmpBoard;
import com.kh.mate.erp.model.vo.EmpBoardImage;
import com.kh.mate.erp.model.vo.EmpBoardReply;
import com.kh.mate.log.vo.Receive;
import com.kh.mate.log.vo.RequestLog;
import com.kh.mate.member.model.vo.Member;
import com.kh.mate.product.model.vo.Product;
import com.kh.mate.product.model.vo.ProductMainImages;

@SessionAttributes({ "loginEmp", "loginMember" })
@Controller
public class ErpContorller {

	private static Logger log = LoggerFactory.getLogger(ErpContorller.class);
	// 호근 파일 다운용 Resource 추가
	@Autowired
	private ResourceLoader resourceLoader;

	@Autowired
	private ErpService erpService;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	/*
	 * JSP페이지 우회 메소드
	 */

	// ERP선택후 메뉴5개 : erpMain
	@RequestMapping("/ERP/erpMain.do")
	public ModelAndView erpMain(ModelAndView mav) {
		mav.setViewName("/ERP/erpMain");
		return mav;
	}

	// 현황조회 진입부 : EmpDetail
	@RequestMapping("/ERP/EmpDetail.do")
	public ModelAndView EmpDetail(ModelAndView mav) {
		mav.setViewName("/ERP/EmpDetail");
		return mav;
	}

	// 재고확인 진입 : StockLog paging 추가
	@RequestMapping("/ERP/StockLog.do")
	public String StockLog(Model model, HttpSession session, HttpServletRequest request,
			@RequestParam(required = false, defaultValue = "1") int cPage) {
		int numPerPage = 10;
		int pageBarSize = 5;
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);

		Map<String, Object> temp = new HashMap<>();
		List<EMP> empList = erpService.empList();
		pb.setOptions(temp);
		List<Map<String, Object>> mapList = erpService.StockLogMapList(pb);
		String pageBar = pb.getPagebar();

		model.addAttribute("pageBar", pageBar);
		model.addAttribute("list", mapList);
		model.addAttribute("empList", empList);
		return "ERP/StockLog";
	}

	// 발주확인 진입 : OrderLog paging 추가
	@RequestMapping("/ERP/OrderLog.do")
	public String OrderLog(HttpSession session, HttpServletRequest request, Model model,
			@RequestParam(required = false, defaultValue = "1") int cPage) {
		int numPerPage = 10;
		int pageBarSize = 5;
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);

		EMP loginEmp = (EMP) session.getAttribute("loginEmp");
		int status = loginEmp.getStatus();
		Map<String, Object> temp = new HashMap<>();
		temp.put("status", status);
		// 로그인 회원이 관리자 아이디가 아닐 경우
		if (status == 1) {
			temp.put("branchId", loginEmp.getEmpId());
		}
		pb.setOptions(temp);

		List<Map<String, Object>> mapList = erpService.selectRequestMapList(pb);
		List<EMP> empList = erpService.empList();

		String pageBar = pb.getPagebar();
		model.addAttribute("pageBar", pageBar);
		model.addAttribute("empList", empList);
		model.addAttribute("list", mapList);
		return "ERP/OrderLog";
	}

	// 매출확인 진입 : PriceLog
	@RequestMapping("/ERP/PriceLog.do")
	public String PriceLog(Model model, @RequestParam(value = "year", required = false) String year,
			@RequestParam(value = "month", required = false) String month, HttpServletRequest request) {

		Map<String, Object> param = new HashMap<>();
		Calendar c = Calendar.getInstance();
		if (year == null || year.isEmpty() || year.equals("")) {
			year = String.valueOf(c.get(Calendar.YEAR));
			param.put("year", year);
			model.addAttribute("year", year);
		} else if (year != null) {
			param.put("year", year);
			model.addAttribute("year", year);
		}
		if (month != null) {
			param.put("month", month);
			model.addAttribute("month", month);
		}
		List<Map<String, Object>> mapList = erpService.ioLogMapList(param);

		HttpSession session = request.getSession();
		EMP emp = (EMP) session.getAttribute("loginEmp");

		List<Map<String, Object>> empList = erpService.empNameList(emp);

		List<String> yearList = erpService.yearList();

		model.addAttribute("yearList", yearList);
		model.addAttribute("mapList", mapList);
		model.addAttribute("empList", empList);

		return "ERP/PriceLog";
	}

	// 입출고 확인 진입 : ReceiveLog paging 추가
	@RequestMapping(value = "/ERP/ReceiveLog.do", method = RequestMethod.GET)
	public String ReceiveLog(Model model, @RequestParam(defaultValue = "1", required = false) int cPage,
			@RequestParam(value = "monthday", required = false) String monthday,
			@RequestParam(value = "empName", required = false) String empName,
			@RequestParam(value = "ioStatus", required = false) String ioStatus, HttpServletRequest request) {
		HttpSession session = request.getSession();
		EMP loginEmp = (EMP) session.getAttribute("loginEmp");

		int numPerPage = 10;
		int pageBarSize = 5;
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);

		Map<String, Object> param = new HashMap<>();
		param.put("empName", empName);
		param.put("ioStatus", ioStatus);

		if (monthday != null) {
			model.addAttribute("monthday", monthday);
			monthday = monthday.replaceAll("-", "");
			param.put("monthday", monthday);
			pb.setOptions(param);
			log.debug("monthday = {}", monthday);
		}

		if (loginEmp != null && !(loginEmp.getEmpId().equals("admin"))) {
			param.put("empId", loginEmp.getEmpId());
		} else {
			param.put("empId", loginEmp.getEmpId());
			pb.setOptions(param);
			List<EMP> list3 = erpService.empList(param);
			model.addAttribute("empList", list3);
		}

		pb.setOptions(param);
		List<Map<String, Object>> ioList = erpService.ioEmpList(pb);
		String pageBar = pb.getPagebar();

		model.addAttribute("pageBar", pageBar);
		model.addAttribute("ioList", ioList);
		model.addAttribute("SempName", empName);
		model.addAttribute("ioStatus", ioStatus);
		return "ERP/ReceiveLog";
	}

	// 박도균 제조사/지점 상세보기 : empInfoDetail
	@RequestMapping("/ERP/empInfoDetail.do")
	public String empInfoDetail(@RequestParam("empId") String empId, Model model) {

		EMP emp = erpService.selectOneEmp(empId);
		model.addAttribute("emp", emp);
		return "ERP/empInfoDetail";
	}

	// ERP게시판 : empBoardList paging 수정
	@RequestMapping(value = "/ERP/EmpBoardList.do", method = RequestMethod.GET)
	public String empBoardList(Model model, HttpServletRequest request, HttpServletResponse response,
			@RequestParam(required = false) String searchType, @RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false, defaultValue = "1") int cPage) {

		// paging bar 추가
		int numPerPage = 10;
		int pageBarSize = 5;
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);
		List<EMP> list = erpService.empList();
		// page map처리
		Map<String, Object> map = new HashMap<>();
		map.put("searchType", searchType);
		map.put("searchKeyword", searchKeyword);

		HttpSession session = request.getSession();
		EMP emp = (EMP) session.getAttribute("loginEmp");
		if (emp != null && emp.getStatus() == 2) {

			map.put("status", emp.getStatus());
			pb.setOptions(map);
		}

		pb.setOptions(map);
		List<EmpBoard> empBoardList = erpService.searchBoard(pb);
		int totalContents = erpService.getSearchContents(pb);
		pb.setTotalContents(totalContents);
		String pageBar = pb.getPagebar();
		model.addAttribute("list", list);
		// model 추가함
		model.addAttribute("empBoardList", empBoardList);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("pageBar", pageBar);
		return "ERP/empList";

	}

	// 박도균 지점/제조사 관리 : empManage paging 추가
	@RequestMapping("/ERP/empManage.do")
	public String empManage(Model model, HttpServletRequest request,
			@RequestParam(required = false, defaultValue = "1") int cPage,
			@RequestParam(value = "status", required = false) String status,
			@RequestParam(value = "searchType", required = false) String searchType,
			@RequestParam(value = "searchKeyword", required = false) String searchKeyword) {

		int numPerPage = 10;
		int pageBarSize = 5;
		Map<String, Object> param = new HashMap<>();
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);
		if (status != null && !status.equals("")) {
			String[] st = status.split(",");
			param.put("status", st);
		}
		param.put("searchType", searchType);
		param.put("searchKeyword", searchKeyword);

		pb.setOptions(param);
		List<Map<String, Object>> list = erpService.empList(pb);
		String pageBar = pb.getPagebar();

		log.debug("list= {}", list);
		model.addAttribute("pageBar", pageBar);
		model.addAttribute("status", status);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchType", searchType);
		model.addAttribute("list", list);
		return "ERP/empManage";
	}

	// 박도균 지점/제조사 생성 페이지 우회 : EmpEnroll
	@RequestMapping(value = "/ERP/EmpEnroll.do", method = RequestMethod.GET)
	public ModelAndView EmpEnroll(ModelAndView mav) {
		mav.setViewName("ERP/EmpEnroll");
		return mav;
	}

	// 박도균 제조사/지점 상세보기 페이지 우회
	@RequestMapping("/ERP/empInfoView.do")
	public String empInfoView(String empId, Model model) {

		model.addAttribute("emp", erpService.selectOneEmp(empId));
		return "ERP/empInfoView";
	}

	@RequestMapping("/ERP/searchInfo.do")
	public String searchInfo(HttpServletRequest request, @RequestParam(required = false, defaultValue = "1") int cPage,
			@RequestParam(required = false) String category, @RequestParam(required = false) String min,
			@RequestParam(required = false) String max, @RequestParam(required = false) String search,
			@RequestParam(required = false) String enabled, Model model) throws Exception {

		int numPerPage = 10;
		int pageBarSize = 5;
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);

		Map<String, Object> options = new HashMap<>();
		if (min != null && !min.equals(""))
			options.put("min", new Integer(Integer.parseInt(min)));
		if (max != null && !max.equals(""))
			options.put("max", new Integer(Integer.parseInt(max)));
		if (category != null && !category.equals("")) {
			String[] cate = category.split(",");
			options.put("category", cate);
		}
		try {
			Integer.parseInt(search);
			options.put("search", search);
			options.put("productNo", search);
		} catch (Exception e) {
			options.put("search", search);
		}
		if (enabled != null && !enabled.equals(""))
			options.put("enabled", new Integer(Integer.parseInt(enabled)));
		options.put("loginEmp", ((EMP) request.getSession().getAttribute("loginEmp")).getEmpId());
		pb.setOptions(options);

		List<Map<String, Object>> list = erpService.getProductList(pb);

		String pageBar = pb.getPagebar();
		log.debug("pageBar = {}", pageBar);

		model.addAttribute("pageBar", pageBar);
		model.addAttribute("category", category);
		model.addAttribute("list", list);

		return "/ERP/searchInfo";
	}

	// 김종완 상품등록 페이지 우회 : productEnroll
	@RequestMapping(value = "/ERP/productEnroll.do", method = RequestMethod.GET)
	public String productinsert(Model model) {

		// 제조사 리스트 전송
		List<EMP> list = erpService.empList();
		model.addAttribute("list", list);
		return "/ERP/productEnroll";
	}

	// 김종완 상품 수정 페이지 연결
	@RequestMapping(value = "/ERP/productUpdate.do", method = RequestMethod.GET)
	public String productUpdate(@RequestParam("productNo") int productNo, RedirectAttributes redirectAttr, Model model)
			throws Exception {

		try {
			Product product = erpService.selectProductOne(productNo);
			List<ProductMainImages> list = erpService.selectProductMainImages(productNo);
			model.addAttribute("product", product);
			model.addAttribute("list", list);
			return "ERP/productUpdate";
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttr.addFlashAttribute("msg", "페이지 연결 오류, 확인 후 다시 시도해주세요!");
			return "redirect:/ERP/searchInfo.do";
		}
	}

	// 발주 요청 가져오기
	@RequestMapping("/ERP/ProductRequestList.do")
	public String productRequestList(HttpSession session, Model model, RedirectAttributes red) {

		try {
			// 로그인 되어있는 아이디 -> 제조사 아이디
			EMP loginEmp = (EMP) session.getAttribute("loginEmp");
			// Request_log, product 함께 전송 필요
			List<RequestLog> listMap = erpService.selectRequestList(loginEmp.getEmpId());
			model.addAttribute("list", listMap);
			return "ERP/requestList";
		} catch (Exception e) {
			e.printStackTrace();
			red.addFlashAttribute("페이지에 오류가 있습니다. 확인 후 다시 시도해주세요.");
			return "redirect:/ERP/ProductRequestList.do";
		}
	}

	// 입고 페이지 우회
	@RequestMapping("/ERP/ProductReceive.do")
	public String productReceiveList(HttpSession session, Model model) {

		// 로그인 되어있는 아이디 -> 지점아이디
		EMP loginEmp = (EMP) session.getAttribute("loginEmp");
		// Request_log, product 함께 전송 필요
		List<Receive> list = erpService.selectReceiveList(loginEmp.getEmpId());
		model.addAttribute("list", list);
		return "ERP/receiveList";
	}

	// 호근 게시판 우회
	@RequestMapping("/ERP/EmpBoardEnroll.do")
	public void EmpboardEnroll() {

	}

	// 호근 게시판 수정 페이지 우회
	@RequestMapping("/ERP/EmpBoardDetail.do")
	public ModelAndView empBoardDetail(@RequestParam(required = false, name = "loginEmp") EMP loginEmp,
			@RequestParam("no") int no, ModelAndView mav, HttpServletRequest request, HttpServletResponse response) {

		// 조회수 관련 처리 시작
		Cookie[] cookies = request.getCookies();
		String boardCookieVal = "";
		boolean hasRead = false;

		if (cookies != null) {
			for (Cookie c : cookies) {
				String name = c.getName();
				String value = c.getValue();

				if ("erpBoardCookie".equals(name)) {
					boardCookieVal = value;
				}

				if (value.contains("[" + no + "]")) {
					hasRead = true;
					break;
				}
			}
		}

		if (hasRead == false) {
			Cookie erpBoardCookie = new Cookie("erpBoardCookie", boardCookieVal + "[" + no + "]");
			erpBoardCookie.setMaxAge(365 * 24 * 60 * 60);
			erpBoardCookie.setPath(request.getContextPath() + "/ERP/EmpBoardDetail.do");
			response.addCookie(erpBoardCookie);
		}

		EmpBoard empBoard = erpService.selectOneEmpBoard(no, hasRead);
		// 게시판 상세보기에서 요청글 일때 제조사 지점 재고 출렷
		if (loginEmp != null && empBoard.getCategory().equals("req")) {
			Map<String, Object> map = new HashMap<>();
			map.put("productNo", empBoard.getProductNo());
			map.put("empId", loginEmp.getEmpId());
			EmpBoard loginEmpStock = erpService.selectEmpStock(map);
			mav.addObject("loginEmpStock", loginEmpStock);
		}

		mav.addObject("empBoard", empBoard);
		mav.setViewName("ERP/EmpBoardDetail");
		return mav;
	}

	// 게시판 게시물 수정 페이지 우회
	@RequestMapping(value = "/ERP/empBoardUpdate.do", method = RequestMethod.GET)
	public String empBoardUpdate(@RequestParam("boardNo") int boardNo, Model model) {

		EmpBoard empBoard = erpService.selectOneEmpBoard(boardNo);

		List<EmpBoardImage> list = erpService.selectBoardImage(boardNo);
		log.debug("empBoard = {}", empBoard);
		log.debug("list = {}", list);

		model.addAttribute("empBoard", empBoard);
		model.addAttribute("list", list);

		return "ERP/EmpBoardUpdate";
	}

	// 박도균 지점/제조사 정보 수정
	@RequestMapping(value = "/ERP/infoUpdate.do", method = RequestMethod.POST)
	public String infoUpdate(EMP emp) {
		emp.setEmpPwd(bcryptPasswordEncoder.encode(emp.getEmpPwd()));
		erpService.infoUpdate(emp);
		return "redirect:/ERP/empManage.do";
	}

	// 박도균 지점/제조사 정보 삭제
	@PostMapping("/ERP/infoDelete.do")
	public String infoDelete(EMP emp, RedirectAttributes redirectAttr) {

		String empId = emp.getEmpId();
		try {
			int result = erpService.updateEmpDelete(empId);
			redirectAttr.addFlashAttribute("msg", "삭제가 완료되었습니다.");

		} catch (Exception e) {
			redirectAttr.addFlashAttribute("msg", "삭제에 실패하였습니다. 확인 후 다시 시도하여주세요");
		}

		return "redirect:/ERP/empManage.do";

	}

	// 박도균 지점/제조사 생성
	@RequestMapping(value = "/ERP/EmpEnroll.do", method = RequestMethod.POST)
	public String EmpEnroll(RedirectAttributes redirectAttr, EMP emp) {

		emp.setEmpPwd(bcryptPasswordEncoder.encode(emp.getEmpPwd()));
		int result = erpService.insertEmp(emp);
		String msg = result > 0 ? "생성 성공" : "생성 실패";
		redirectAttr.addFlashAttribute("msg", msg);
		return "redirect:/ERP/empManage.do";
	}

	// 비밀번호 중복 확인 (ajax)
	@RequestMapping("/ERP/checkIdDuplicate.do")
	@ResponseBody
	public Map<String, Object> checkIdDuplicate(@RequestParam("empId") String empId) {
		Map<String, Object> map = new HashMap<>();

		boolean isAvailable = erpService.selectOneEmp(empId) == null;
		map.put("empId", empId);
		map.put("isAvailable", isAvailable);
		return map;
	}

	// 상품 발주
	@ResponseBody
	@PostMapping("/ERP/productOrder.do")
	public Map<String, Object> productOrder(@RequestParam int productNo, @RequestParam String empId,
			@RequestParam int amount, @RequestParam String manufacturerId, RedirectAttributes redirectAttr) {

		Map<String, Object> param = new HashMap<>();
		param.put("empId", empId);
		param.put("productNo", productNo);
		param.put("amount", amount);
		param.put("manufacturerId", manufacturerId);
		log.debug("param = {}", param);
		int result = erpService.productOrder(param);

		Map<String, Object> map = new HashMap<>();
		map.put("msg", result > 0 ? "발주 요청 완료" : "발주 요정 실패");
		return map;
	}

	// 김종완 상품 등록 POST
	@RequestMapping(value = "/ERP/productEnroll.do", method = RequestMethod.POST)
	public String productEnroll(Product product, @RequestParam("upFile") MultipartFile[] upFiles,
			@RequestParam(value = "content", defaultValue = "내용을 입력해 주세요.") String content,
			@RequestParam("imgDir") String imgDir, HttpServletRequest request, RedirectAttributes redirectAttr)
			throws Exception {
		try {
			// Content내 img태그 -> 저장 폴더명 변경
			if (!content.equals("내용을 입력해 주세요.")) {
				String repCont = content.replaceAll("temp", imgDir);
				product.setContent(repCont);
			} else {
				product.setContent(content);
			}

			// 썸네일로 사용할 이미지 저장
			List<ProductMainImages> mainImgList = new ArrayList<>();
			String saveDirectory = request.getServletContext().getRealPath("/resources/upload/mainimages");

			for (MultipartFile upFile : upFiles) {

				// 파일을 선택하지 않고 전송한 경우
				if (upFile.isEmpty()) {
					// 섬네일 이미지는 반드시 필요하기 때문에 제출하지 않은 경우 에러넘겨줘야됨.
					throw new Exception("파일을 첨부해 주세요.");
				}
				// 파일을 첨부하고 전송한 경우
				else {
					// 1.1 파일명(renamdFilename) 생성
					String renamedFilename = Utils.getRenamedFileName(upFile.getOriginalFilename());

					// 1.2 메모리(RAM)에 저장되어있는 파일 -> 서버 컴퓨터 디렉토리 저장 tranferTo
					File dest = new File(saveDirectory, renamedFilename);
					upFile.transferTo(dest);

					// 1.3 ProductMainImages객체 생성
					ProductMainImages mainImgs = new ProductMainImages();
					mainImgs.setOriginalFilename(upFile.getOriginalFilename());
					mainImgs.setRenamedFilename(renamedFilename);
					mainImgList.add(mainImgs);

				}

			}

			// Product객체에 MainImages객체를 Setting
			product.setPmiList(mainImgList);

			// ProductImage 임시 저장 폴더
			String tempDir = request.getServletContext().getRealPath("/resources/upload/temp");
			// ProductImage 저장 폴더
			String realDir = request.getServletContext().getRealPath("/resources/upload/" + imgDir);
			File folder1 = new File(tempDir);
			File folder2 = new File(realDir);

			List<String> productImages = new ArrayList<>();
			// Content에 Image파일이 있을 경우 (temp폴더내 파일이 저장되었을 경우)
			if (folder1.listFiles().length > 0) {
				// productImage객체 생성 후 DB에 저장
				productImages = FileUtils.getFileName(folder1);
				product.setProductImagesName(productImages);
			}

			// DB에 Product insert
			int result = erpService.productEnroll(product);

			// product입력 시, file입력 처리 -> DB에 image등록과 동시에 fileDir옮기기
			if (result > 0) {
				// folder1의 파일 -> folder2로 복사
				FileUtils.fileCopy(folder1, folder2);
				// folder1의 파일 삭제
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "상품 추가 완료");
			} else {
				// folder1의 파일 삭제
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "상품 추가 실패");
			}

			return "redirect:/ERP/searchInfo.do";

		} catch (Exception e) {
			e.printStackTrace();
			redirectAttr.addFlashAttribute("msg", "페이지 오류 발생, 확인 후 다시 시도해주세요!");
			return "redirect:/ERP/searchInfo.do";
		}
	}

	// 김종완 상품등록 | 수정페이지 뒤로가기 클릭 시 파일 삭제
	@RequestMapping(value = "/ERP/fileDelMethod.do", method = RequestMethod.GET)
	public String fileDelete(HttpServletRequest request) {
		// 파일 삭제
		String tempDir = request.getServletContext().getRealPath("/resources/upload/temp");
		File folder1 = new File(tempDir);
		FileUtils.fileDelete(folder1.toString());

		return "redirect:/ERP/searchInfo.do";

	}

	// 김종완 상품정보 수정
	@RequestMapping(value = "/ERP/productUpdate.do", method = RequestMethod.POST)
	public String productUpdate(Product product, @RequestParam("upFile") MultipartFile[] upFiles,
			@RequestParam("fileChange") int fileChange, @RequestParam("productImageNo") String[] productImageNos,
			@RequestParam(value = "content", defaultValue = "내용을 입력해 주세요") String content,
			@RequestParam("imgDir") String imgDir, RedirectAttributes redirectAttr, HttpServletRequest request)
			throws Exception {

		try {
			// Content내 img태그 -> 저장 폴더명 변경
			if (!content.equals("내용을 입력해 주세요.")) {
				String repCont = content.replaceAll("temp", imgDir);
				product.setContent(repCont);
			} else {
				product.setContent(content);
			}

			// fileChange값이 1이면 섬네일 이미지 수정감지
			if (fileChange > 0) {
				// DB에 저장되어있는 이미지명 불러오기
				List<ProductMainImages> storedMainImgs = erpService.selectProductMainImages(product.getProductNo());
				// 섬네일 이미지를 저장하는 폴더의 절대 경로
				String mainDirectory = request.getServletContext().getRealPath("/resources/upload/mainimages/");

				// 저장된 파일 삭제
				for (ProductMainImages smi : storedMainImgs) {
					boolean result = new File(mainDirectory, smi.getRenamedFilename()).delete();
					log.debug("result = {}", result);
				}

				// 새로 넘어온 파일 저장
				List<ProductMainImages> mainImgList = new ArrayList<>();
				for (MultipartFile upFile : upFiles) {
					String renamedFilename = Utils.getRenamedFileName(upFile.getOriginalFilename());

					File dest = new File(mainDirectory, renamedFilename);
					upFile.transferTo(dest);

					ProductMainImages newMainImgs = new ProductMainImages();
					newMainImgs.setOriginalFilename(upFile.getOriginalFilename());
					newMainImgs.setRenamedFilename(renamedFilename);
					newMainImgs.setProductNo(product.getProductNo());
					mainImgList.add(newMainImgs);

				}

				product.setPmiList(mainImgList);

			}

			// 새로 등록된 본문의 이미지 저장
			String tempDir = request.getServletContext().getRealPath("/resources/upload/temp");
			String realDir = request.getServletContext().getRealPath("/resources/upload/" + imgDir);
			File folder1 = new File(tempDir);
			File folder2 = new File(realDir);
			if (folder1.listFiles().length > 0) {
				List<String> productImages = FileUtils.getFileName(folder1);
				product.setProductImagesName(productImages);
			}

			int result = erpService.productUpdate(product);

			if (result > 0) {
				// 업데이트 성공 시 -> 폴더 옮기며 성공 메세지 reDir
				FileUtils.fileCopy(folder1, folder2);
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "상품 수정 성공");

				return "redirect:/ERP/searchInfo.do";

			} else {
				// 업데이트 실패 시 -> temp 폴더 내부 파일 삭제, 실패 메세지 reDir
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "상품 수정 실패, 확인 후 다시 시도하여주세요!");
				return "redirect:/ERP/searchInfo.do";
			}

		} catch (Exception e) {
			e.printStackTrace();
			redirectAttr.addFlashAttribute("msg", "상품 수정 실패, 확인 후 다시 시도하여주세요!");
			return "redirect:/ERP/searchInfo.do";
		}

	}

	// 김종완 상품삭제 -> enabled 1로 업데이트
	@RequestMapping(value = "/ERP/productDelete.do", method = RequestMethod.GET)
	public String productDelete(@RequestParam("productNo") String productNo, HttpServletRequest request,
			RedirectAttributes redirectAttr) {

		try {
			int result = erpService.UpdateProductToDelete(productNo);
			redirectAttr.addFlashAttribute("msg", "판매 목록에서 상품이 삭제되었습니다.");
		} catch (Exception e) {
			log.error("상품 삭제 업데이트 실패");
			redirectAttr.addFlashAttribute("msg", "상품 삭제에 실패하였습니다.");
		}

		return "redirect:/ERP/searchInfo.do";
	}

	// 발주 승인
	@RequestMapping("/ERP/appRequest.do")
	public String appRequest(@RequestParam("requestNo") int requestNo, RedirectAttributes redirectAttr) {

		int result = erpService.updateRequestToApp(requestNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "발주 완료");
		} else {
			redirectAttr.addFlashAttribute("msg", "발주 실패");
		}

		return "redirect:/ERP/ProductRequestList.do";
	}

	// 발주 거부
	@RequestMapping("/ERP/refRequest.do")
	public String refRequest(@RequestParam("requestNo") int requestNo, RedirectAttributes redirectAttr) {

		int result = erpService.updateRequestToRef(requestNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "발주요청이 거절되었습니다.");
		} else {
			redirectAttr.addFlashAttribute("msg", "요청 처리에 실패하였습니다. 다시 시도하여주세요.");
		}
		return "redirect:/ERP/ProductRequestList.do";
	}

	// 입고 승인 처리
	@RequestMapping("/ERP/appReceive.do")
	public String appReceive(@RequestParam("receiveNo") int receiveNo, RedirectAttributes redirectAttr) {

		// 해당 입고 목록 update처리
		int result = erpService.updateReceiveToApp(receiveNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "해당 상품 입고처리가 완료되었습니다.");
		} else {
			redirectAttr.addFlashAttribute("msg", "요청 처리에 실패하였습니다. 다시 시도하여주세요.");
		}

		return "redirect:/ERP/ProductReceive.do";
	}

	// 입고 거절 처리
	@RequestMapping("/ERP/refReceive.do")
	public String refReceive(@RequestParam("receiveNo") int receiveNo, RedirectAttributes redirectAttr) {

		// 해당 입고 목록 update처리
		int result = erpService.updateReceiveToref(receiveNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "해당 상품 입고처리가 거절되었습니다.");
		} else {
			redirectAttr.addFlashAttribute("msg", "요청 처리에 실패하였습니다. 다시 시도하여주세요.");
		}

		return "redirect:/ERP/ProductReceive.do";
	}

	// 김종완 재고 확인 검색 (ajax)
	@PostMapping("/ERP/searchStock.do")
	@ResponseBody
	public ResponseEntity<?> searchStock(@RequestParam(value = "branchId", required = false) String branchId,
			@RequestParam(value = "searchType", required = false) String searchType,
			@RequestParam(value = "searchKeyword", required = false) String searchKeyword) throws Exception {

		try {
			Map<String, String> param = new HashMap<>();
			param.put("branchId", branchId);
			param.put("searchType", searchType);
			param.put("searchKeyword", searchKeyword);
			List<Map<String, Object>> mapList = erpService.StockLogMapList(param);

			return new ResponseEntity<List<Map<String, Object>>>(mapList, HttpStatus.OK);

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	// 김종완 발주요청 페이지 검색 (ajax)
	@PostMapping("/ERP/searchRequest.do")
	@ResponseBody
	public ResponseEntity<?> searchRequest(
			@RequestParam(value = "manufacturerId", required = false) String manufacturerId,
			@RequestParam(value = "branchId", required = false) String branchId,
			@RequestParam(value = "searchType", required = false) String searchType,
			@RequestParam(value = "searchKeyword", required = false) String searchKeyword,
			@RequestParam(value = "confirm", required = false) String confirm) throws Exception {

		try {
			Map<String, Object> param = new HashMap<>();
			param.put("manufacturerId", manufacturerId);
			param.put("branchId", branchId);
			param.put("searchType", searchType);
			param.put("searchKeyword", searchKeyword);
			param.put("confirm", confirm);
			List<Map<String, Object>> mapList = erpService.selectRequestMapList(param);

			return new ResponseEntity<List<Map<String, Object>>>(mapList, HttpStatus.OK);

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<List<Map<String, Object>>>(HttpStatus.NOT_FOUND);
		}
	}

	// EMP 활성화
	@RequestMapping("/ERP/vitalEMP.do")
	public String vitalEmp(@RequestParam("empId") String empId, RedirectAttributes redirectAttr) {

		try {
			int result = erpService.vitalEmp(empId);
			redirectAttr.addFlashAttribute("msg", "해당 지점/제조사가 활성화 되었습니다.");

		} catch (Exception e) {
			redirectAttr.addFlashAttribute("msg", "해당 지점/제조사 활성화에 실패하였습니다. 확인 후 다시 시도하여주세요");
		}

		return "redirect:/ERP/empManage.do";
	}

	// 호근 관리자 로그인 및 로그인 세션 추가
	@PostMapping("/ERP/erpLogin.do")
	public String memberLogin(@RequestParam("empId") String empId, @RequestParam("empPwd") String empPwd,
			RedirectAttributes redirectAttr, Model model, HttpSession session) {
		log.debug("empId = {}", empId);
		log.debug("empPwd ={}", empPwd);

		EMP loginEmp = erpService.selectOneEmp(empId);

		log.debug("loginEmp = {}", loginEmp);
		String location = "";

		if (loginEmp != null && (loginEmp.getEmpId().equals(empId)) && (bcryptPasswordEncoder.matches(empPwd, loginEmp.getEmpPwd()))) {
			model.addAttribute("loginEmp", loginEmp);

			if (loginEmp.getEmpId().equals("admin")) {
				Member m = new Member();
				m.setMemberId(loginEmp.getEmpId());
				m.setMemberName(loginEmp.getEmpName());
				model.addAttribute("loginMember", m);
			}
			location = "redirect:/ERP/erpMain.do";
		} else {
			location = "redirect:/member/memberLogin.do";
			redirectAttr.addFlashAttribute("msg", "아이디와 비밀번호를 확인해주세요.");
		}
		return location;
	}

	// 로그아웃 세션만료
	@RequestMapping("/ERP/logout.do")
	public String empLogout(SessionStatus sessionStatus) {
		if (!sessionStatus.isComplete()) {
			sessionStatus.setComplete();

		}
		return "redirect:/";
	}

	// 호근 게시판 글 작성
	@PostMapping("/ERP/empBoardCkEnroll.do")
	public String empBoardCKEnroll(RedirectAttributes redirectAttr, EmpBoard empBoard, EMP emp,
			@RequestParam(value = "content", defaultValue = "내용을 입력해 주세요") String content,
			@RequestParam("imgDir") String imgDir, HttpServletRequest request, Model model,
			@RequestParam("upFile") MultipartFile[] upFiles) throws IllegalStateException, IOException {

		if (!content.equals("내용을 입력해 주세요.")) {
			String repCont = content.replaceAll("temp", imgDir);
			empBoard.setContent(repCont);
		}

		List<EmpBoardImage> empBoardImageList = new ArrayList<>();
		String saveDirectory = request.getServletContext().getRealPath("/resources/upload/empBoard");
		for (MultipartFile upFile : upFiles) {

			if (upFile.isEmpty()) {
				continue;
			} else {
				String renamedFilename = Utils.getRenamedFileName(upFile.getOriginalFilename());
				File dest = new File(saveDirectory, renamedFilename);
				upFile.transferTo(dest);
				EmpBoardImage empBoardImage = new EmpBoardImage();
				empBoardImage.setOriginalFilename(upFile.getOriginalFilename());
				empBoardImage.setRenamedFilename(renamedFilename);
				empBoardImageList.add(empBoardImage);
			}

		}
		log.debug("empBoardImageList = {}", empBoardImageList);
		empBoard.setEmpBoardImageList(empBoardImageList);
		empBoard.setEmpId(emp.getEmpId());

		log.debug("empBoard = {}", empBoard);

		int result = erpService.insertEmpBoard(empBoard);

		String tempDir = request.getServletContext().getRealPath("/resources/upload/temp");
		// ProductImage 저장 폴더
		String realDir = request.getServletContext().getRealPath("/resources/upload/" + imgDir);
		File folder1 = new File(tempDir);
		File folder2 = new File(realDir);

		// file입력 처리 -> DB에 image등록과 동시에 fileDir옮기기
		if (result > 0) {
			// folder1의 파일 -> folder2로 복사
			FileUtils.fileCopy(folder1, folder2);
			// folder1의 파일 삭제
			FileUtils.fileDelete(folder1.toString());
			redirectAttr.addFlashAttribute("msg", "게시글 등록 성공");
		} else {
			// folder1의 파일 삭제
			FileUtils.fileDelete(folder1.toString());
			redirectAttr.addFlashAttribute("msg", "게시글 등록 실패");
		}

		return "redirect:/ERP/EmpBoardList.do";
	}

	// 호근 게시판 댓글 등록
	@PostMapping("/ERP/empReplyEnroll.do")
	public String replyEnroll(EmpBoardReply boardReply, ModelAndView mav, RedirectAttributes redirectAttributes) {

		log.debug("boardReply= {}", boardReply);
		int result = erpService.boardReply(boardReply);
		log.debug("result = {}", result);

		log.debug("boardNo = {}", boardReply.getBoardNo());
		return "redirect:/ERP/EmpBoardDetail.do?no=" + boardReply.getBoardNo();
	}

	// 파일 다운로드
	@RequestMapping("/ERP/fileDownload.do")
	@ResponseBody
	public Resource empBoardDownload(@RequestParam("no") int boardImageNo, HttpServletRequest request,
			HttpServletResponse response, @RequestHeader("user-agent") String userAgent)
			throws UnsupportedEncodingException {

		log.debug("no = {}", boardImageNo);
		EmpBoardImage empBoardImage = erpService.empBoardFileDownload(boardImageNo);
		log.debug("empBoardImage = {}", empBoardImage);
		String saveDirectory = request.getServletContext().getRealPath("/resources/upload/empBoard");
		File downFile = new File(saveDirectory, empBoardImage.getRenamedFilename());

		Resource resource = resourceLoader.getResource("file:" + downFile);
		boolean isMSIE = userAgent.indexOf("MSIE") != -1 || userAgent.indexOf("Trident") != -1;
		String originalFilename = empBoardImage.getOriginalFilename();
		if (isMSIE) {
			originalFilename = URLEncoder.encode(originalFilename, "UTF-8").replaceAll("\\+", "%20");
		} else {
			originalFilename = new String(originalFilename.getBytes("UTF-8"), "ISO-8859-1");
		}
		response.setContentType("application/octet-stream; charset=utf-8");
		response.addHeader("Content-Disposition", "empBoardImage; filename=\"" + originalFilename + "\"");
		return resource;

	}

	// 호근 empBoard Reply 불러오기 (ajax)
	@GetMapping("/ERP/empReplyList.do")
	@ResponseBody
	public List<EmpBoardReply> empReplyList(Model model, @RequestParam("boardNo") int boardNo) {

		List<EmpBoardReply> list = erpService.replyList(boardNo);
		return list;
	}

	// 댓글 삭제
	@PostMapping("/ERP/erpBoardReply.do")
	@ResponseBody
	public Map<String, Object> replydelete(@RequestParam("boardReplyNo") int boardReplyNo,
			RedirectAttributes redirectAttr, Model model) {

		Map<String, Object> map = new HashMap<>();
		int result = erpService.deleteReply(boardReplyNo);
		boolean Available = (result > 0) ? true : false;
		map.put("isAvailable", Available);
		return map;
	}

	// 댓글 수정
	@PostMapping("/ERP/replyUpdateReal.do")
	@ResponseBody
	public Map<String, Object> replyUpdate(@RequestParam("boardReplyNo") int boardReplyNo,
			@RequestParam("content") String content, RedirectAttributes redirectAttr, Model model) {

		Map<String, Object> map = new HashMap<>();
		map.put("boardReplyNo", boardReplyNo);
		map.put("content", content);
		int result = erpService.updateReply(map);
		boolean Available = (result > 0) ? true : false;
		map.put("isAvailable", Available);
		return map;
	}

	// 게시판 상품리스트 가져오기 (ajax)
	@GetMapping("/ERP/productList.do")
	@ResponseBody
	public Map<String, Object> productList(Model model) {
		Map<String, Object> map = new HashMap<>();
		List<Product> list = erpService.erpProductList();
		map.put("productList", list);
		log.debug("map = {}", map);
		model.addAttribute("map", map);
		return map;
	}

	// 게시판 게시물 삭제
	@PostMapping("/ERP/boardDelete.do")
	@ResponseBody
	public Map<String, Object> empBoardDelete(@RequestParam("boardNo") int boardNo) {
		log.debug("boardNo = {}", boardNo);
		Map<String, Object> map = new HashMap<>();
		int result = erpService.empBoardDelete(boardNo);

		if (result > 0) {
			map.put("result", result);
		}

		return map;
	}

	// 게시판 게시물 수정
	@PostMapping("/ERP/empBoardCkUpdate.do")
	public String empCKBoardUpdate(EmpBoard empBoard, @RequestParam("upFile") MultipartFile[] upFiles,
			@RequestParam("fileChange") int fileChange, HttpServletRequest request)
			throws IllegalStateException, IOException {

		log.debug("empBoard= {}", empBoard);
		if (fileChange > 0) {
			List<EmpBoardImage> imageList = erpService.selectBoardImage(empBoard.getBoardNo());
			String mainDirectory = request.getServletContext().getRealPath("/resources/upload/empBoard/");

			// 저장된 파일 삭제
			for (EmpBoardImage image : imageList) {
				boolean result = new File(mainDirectory, image.getRenamedFilename()).delete();
				log.debug("result = {}", result);
			}

			// 새로 넘어온 파일 저장
			List<EmpBoardImage> updateImgList = new ArrayList<>();

			for (MultipartFile upFile : upFiles) {
				String renamedFilename = Utils.getRenamedFileName(upFile.getOriginalFilename());

				File dest = new File(mainDirectory, renamedFilename);
				upFile.transferTo(dest);

				EmpBoardImage newMainImgs = new EmpBoardImage();
				newMainImgs.setOriginalFilename(upFile.getOriginalFilename());
				newMainImgs.setRenamedFilename(renamedFilename);
				newMainImgs.setBoardNo(empBoard.getBoardNo());
				updateImgList.add(newMainImgs);

			}

			empBoard.setEmpBoardImageList(updateImgList);

		}

		String tempDir = request.getServletContext().getRealPath("/resources/upload/empBoard");
		File folder1 = new File(tempDir);

		int result = erpService.empBoardUpdate(empBoard);

		return "redirect:/ERP/EmpBoardList.do";
	}

	// 상품 재 판매 (ajax)
	@ResponseBody
	@PostMapping("/ERP/productResale.do")
	public Map<String, Object> productResale(@RequestParam("productNo") int productNo) {

		int result = erpService.productResale(productNo);
		Map<String, Object> map = new HashMap<>();
		String msg = result > 0 ? "성공" : "실패";
		map.put("msg", msg);
		return map;
	}

	// 호근 게시판 재고 전송 (ajax)
	@GetMapping("/ERP/StockTranslate")
	@ResponseBody
	public ResponseEntity<?> stockTranslate(@RequestParam("productNo") int productNo,
			@RequestParam("amount") int amount, @RequestParam("empId") String empId,
			@RequestParam("transEmpId") String transEmpId, @RequestParam("transStock") int transStock,
			@RequestParam("boardNo") int boardNo) {
		Map<String, Object> map = new HashMap<>();
		try {
			map.put("productNo", productNo);
			map.put("amount", amount);
			map.put("empId", empId);
			map.put("transEmpId", transEmpId);
			map.put("transStock", transStock);
			map.put("no", boardNo);

			int result = erpService.stockTranslate(map);

			boolean Available = (result > 0) ? true : false;
			map.put("isAvailable", Available);

			return new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);

		} catch (Exception e) {
			e.printStackTrace();
			map.put("msg", "페이지 오류 발생, 확인 후 다시 실행해 주세요");
			return new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
		}
	}
	
	@ExceptionHandler({Exception.class}) 
	public String error(Exception e) { 
		log.error("exception = {}", e);
		return "common/error"; 
	}
}
