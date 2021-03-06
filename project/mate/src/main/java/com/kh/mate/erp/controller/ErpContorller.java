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
	// ?????? ?????? ????????? Resource ??????
	@Autowired
	private ResourceLoader resourceLoader;

	@Autowired
	private ErpService erpService;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	/*
	 * JSP????????? ?????? ?????????
	 */

	// ERP????????? ??????5??? : erpMain
	@RequestMapping("/ERP/erpMain.do")
	public ModelAndView erpMain(ModelAndView mav) {
		mav.setViewName("/ERP/erpMain");
		return mav;
	}

	// ???????????? ????????? : EmpDetail
	@RequestMapping("/ERP/EmpDetail.do")
	public ModelAndView EmpDetail(ModelAndView mav) {
		mav.setViewName("/ERP/EmpDetail");
		return mav;
	}

	// ???????????? ?????? : StockLog paging ??????
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

	// ???????????? ?????? : OrderLog paging ??????
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
		// ????????? ????????? ????????? ???????????? ?????? ??????
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

	// ???????????? ?????? : PriceLog
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

	// ????????? ?????? ?????? : ReceiveLog paging ??????
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

	// ????????? ?????????/?????? ???????????? : empInfoDetail
	@RequestMapping("/ERP/empInfoDetail.do")
	public String empInfoDetail(@RequestParam("empId") String empId, Model model) {

		EMP emp = erpService.selectOneEmp(empId);
		model.addAttribute("emp", emp);
		return "ERP/empInfoDetail";
	}

	// ERP????????? : empBoardList paging ??????
	@RequestMapping(value = "/ERP/EmpBoardList.do", method = RequestMethod.GET)
	public String empBoardList(Model model, HttpServletRequest request, HttpServletResponse response,
			@RequestParam(required = false) String searchType, @RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false, defaultValue = "1") int cPage) {

		// paging bar ??????
		int numPerPage = 10;
		int pageBarSize = 5;
		Pagebar pb = new Pagebar(cPage, numPerPage, request.getRequestURI(), pageBarSize);
		List<EMP> list = erpService.empList();
		// page map??????
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
		// model ?????????
		model.addAttribute("empBoardList", empBoardList);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("pageBar", pageBar);
		return "ERP/empList";

	}

	// ????????? ??????/????????? ?????? : empManage paging ??????
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

	// ????????? ??????/????????? ?????? ????????? ?????? : EmpEnroll
	@RequestMapping(value = "/ERP/EmpEnroll.do", method = RequestMethod.GET)
	public ModelAndView EmpEnroll(ModelAndView mav) {
		mav.setViewName("ERP/EmpEnroll");
		return mav;
	}

	// ????????? ?????????/?????? ???????????? ????????? ??????
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

	// ????????? ???????????? ????????? ?????? : productEnroll
	@RequestMapping(value = "/ERP/productEnroll.do", method = RequestMethod.GET)
	public String productinsert(Model model) {

		// ????????? ????????? ??????
		List<EMP> list = erpService.empList();
		model.addAttribute("list", list);
		return "/ERP/productEnroll";
	}

	// ????????? ?????? ?????? ????????? ??????
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
			redirectAttr.addFlashAttribute("msg", "????????? ?????? ??????, ?????? ??? ?????? ??????????????????!");
			return "redirect:/ERP/searchInfo.do";
		}
	}

	// ?????? ?????? ????????????
	@RequestMapping("/ERP/ProductRequestList.do")
	public String productRequestList(HttpSession session, Model model, RedirectAttributes red) {

		try {
			// ????????? ???????????? ????????? -> ????????? ?????????
			EMP loginEmp = (EMP) session.getAttribute("loginEmp");
			// Request_log, product ?????? ?????? ??????
			List<RequestLog> listMap = erpService.selectRequestList(loginEmp.getEmpId());
			model.addAttribute("list", listMap);
			return "ERP/requestList";
		} catch (Exception e) {
			e.printStackTrace();
			red.addFlashAttribute("???????????? ????????? ????????????. ?????? ??? ?????? ??????????????????.");
			return "redirect:/ERP/ProductRequestList.do";
		}
	}

	// ?????? ????????? ??????
	@RequestMapping("/ERP/ProductReceive.do")
	public String productReceiveList(HttpSession session, Model model) {

		// ????????? ???????????? ????????? -> ???????????????
		EMP loginEmp = (EMP) session.getAttribute("loginEmp");
		// Request_log, product ?????? ?????? ??????
		List<Receive> list = erpService.selectReceiveList(loginEmp.getEmpId());
		model.addAttribute("list", list);
		return "ERP/receiveList";
	}

	// ?????? ????????? ??????
	@RequestMapping("/ERP/EmpBoardEnroll.do")
	public void EmpboardEnroll() {

	}

	// ?????? ????????? ?????? ????????? ??????
	@RequestMapping("/ERP/EmpBoardDetail.do")
	public ModelAndView empBoardDetail(@RequestParam(required = false, name = "loginEmp") EMP loginEmp,
			@RequestParam("no") int no, ModelAndView mav, HttpServletRequest request, HttpServletResponse response) {

		// ????????? ?????? ?????? ??????
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
		// ????????? ?????????????????? ????????? ?????? ????????? ?????? ?????? ??????
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

	// ????????? ????????? ?????? ????????? ??????
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

	// ????????? ??????/????????? ?????? ??????
	@RequestMapping(value = "/ERP/infoUpdate.do", method = RequestMethod.POST)
	public String infoUpdate(EMP emp) {
		emp.setEmpPwd(bcryptPasswordEncoder.encode(emp.getEmpPwd()));
		erpService.infoUpdate(emp);
		return "redirect:/ERP/empManage.do";
	}

	// ????????? ??????/????????? ?????? ??????
	@PostMapping("/ERP/infoDelete.do")
	public String infoDelete(EMP emp, RedirectAttributes redirectAttr) {

		String empId = emp.getEmpId();
		try {
			int result = erpService.updateEmpDelete(empId);
			redirectAttr.addFlashAttribute("msg", "????????? ?????????????????????.");

		} catch (Exception e) {
			redirectAttr.addFlashAttribute("msg", "????????? ?????????????????????. ?????? ??? ?????? ?????????????????????");
		}

		return "redirect:/ERP/empManage.do";

	}

	// ????????? ??????/????????? ??????
	@RequestMapping(value = "/ERP/EmpEnroll.do", method = RequestMethod.POST)
	public String EmpEnroll(RedirectAttributes redirectAttr, EMP emp) {

		emp.setEmpPwd(bcryptPasswordEncoder.encode(emp.getEmpPwd()));
		int result = erpService.insertEmp(emp);
		String msg = result > 0 ? "?????? ??????" : "?????? ??????";
		redirectAttr.addFlashAttribute("msg", msg);
		return "redirect:/ERP/empManage.do";
	}

	// ???????????? ?????? ?????? (ajax)
	@RequestMapping("/ERP/checkIdDuplicate.do")
	@ResponseBody
	public Map<String, Object> checkIdDuplicate(@RequestParam("empId") String empId) {
		Map<String, Object> map = new HashMap<>();

		boolean isAvailable = erpService.selectOneEmp(empId) == null;
		map.put("empId", empId);
		map.put("isAvailable", isAvailable);
		return map;
	}

	// ?????? ??????
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
		map.put("msg", result > 0 ? "?????? ?????? ??????" : "?????? ?????? ??????");
		return map;
	}

	// ????????? ?????? ?????? POST
	@RequestMapping(value = "/ERP/productEnroll.do", method = RequestMethod.POST)
	public String productEnroll(Product product, @RequestParam("upFile") MultipartFile[] upFiles,
			@RequestParam(value = "content", defaultValue = "????????? ????????? ?????????.") String content,
			@RequestParam("imgDir") String imgDir, HttpServletRequest request, RedirectAttributes redirectAttr)
			throws Exception {
		try {
			// Content??? img?????? -> ?????? ????????? ??????
			if (!content.equals("????????? ????????? ?????????.")) {
				String repCont = content.replaceAll("temp", imgDir);
				product.setContent(repCont);
			} else {
				product.setContent(content);
			}

			// ???????????? ????????? ????????? ??????
			List<ProductMainImages> mainImgList = new ArrayList<>();
			String saveDirectory = request.getServletContext().getRealPath("/resources/upload/mainimages");

			for (MultipartFile upFile : upFiles) {

				// ????????? ???????????? ?????? ????????? ??????
				if (upFile.isEmpty()) {
					// ????????? ???????????? ????????? ???????????? ????????? ???????????? ?????? ?????? ?????????????????????.
					throw new Exception("????????? ????????? ?????????.");
				}
				// ????????? ???????????? ????????? ??????
				else {
					// 1.1 ?????????(renamdFilename) ??????
					String renamedFilename = Utils.getRenamedFileName(upFile.getOriginalFilename());

					// 1.2 ?????????(RAM)??? ?????????????????? ?????? -> ?????? ????????? ???????????? ?????? tranferTo
					File dest = new File(saveDirectory, renamedFilename);
					upFile.transferTo(dest);

					// 1.3 ProductMainImages?????? ??????
					ProductMainImages mainImgs = new ProductMainImages();
					mainImgs.setOriginalFilename(upFile.getOriginalFilename());
					mainImgs.setRenamedFilename(renamedFilename);
					mainImgList.add(mainImgs);

				}

			}

			// Product????????? MainImages????????? Setting
			product.setPmiList(mainImgList);

			// ProductImage ?????? ?????? ??????
			String tempDir = request.getServletContext().getRealPath("/resources/upload/temp");
			// ProductImage ?????? ??????
			String realDir = request.getServletContext().getRealPath("/resources/upload/" + imgDir);
			File folder1 = new File(tempDir);
			File folder2 = new File(realDir);

			List<String> productImages = new ArrayList<>();
			// Content??? Image????????? ?????? ?????? (temp????????? ????????? ??????????????? ??????)
			if (folder1.listFiles().length > 0) {
				// productImage?????? ?????? ??? DB??? ??????
				productImages = FileUtils.getFileName(folder1);
				product.setProductImagesName(productImages);
			}

			// DB??? Product insert
			int result = erpService.productEnroll(product);

			// product?????? ???, file?????? ?????? -> DB??? image????????? ????????? fileDir?????????
			if (result > 0) {
				// folder1??? ?????? -> folder2??? ??????
				FileUtils.fileCopy(folder1, folder2);
				// folder1??? ?????? ??????
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "?????? ?????? ??????");
			} else {
				// folder1??? ?????? ??????
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "?????? ?????? ??????");
			}

			return "redirect:/ERP/searchInfo.do";

		} catch (Exception e) {
			e.printStackTrace();
			redirectAttr.addFlashAttribute("msg", "????????? ?????? ??????, ?????? ??? ?????? ??????????????????!");
			return "redirect:/ERP/searchInfo.do";
		}
	}

	// ????????? ???????????? | ??????????????? ???????????? ?????? ??? ?????? ??????
	@RequestMapping(value = "/ERP/fileDelMethod.do", method = RequestMethod.GET)
	public String fileDelete(HttpServletRequest request) {
		// ?????? ??????
		String tempDir = request.getServletContext().getRealPath("/resources/upload/temp");
		File folder1 = new File(tempDir);
		FileUtils.fileDelete(folder1.toString());

		return "redirect:/ERP/searchInfo.do";

	}

	// ????????? ???????????? ??????
	@RequestMapping(value = "/ERP/productUpdate.do", method = RequestMethod.POST)
	public String productUpdate(Product product, @RequestParam("upFile") MultipartFile[] upFiles,
			@RequestParam("fileChange") int fileChange, @RequestParam("productImageNo") String[] productImageNos,
			@RequestParam(value = "content", defaultValue = "????????? ????????? ?????????") String content,
			@RequestParam("imgDir") String imgDir, RedirectAttributes redirectAttr, HttpServletRequest request)
			throws Exception {

		try {
			// Content??? img?????? -> ?????? ????????? ??????
			if (!content.equals("????????? ????????? ?????????.")) {
				String repCont = content.replaceAll("temp", imgDir);
				product.setContent(repCont);
			} else {
				product.setContent(content);
			}

			// fileChange?????? 1?????? ????????? ????????? ????????????
			if (fileChange > 0) {
				// DB??? ?????????????????? ???????????? ????????????
				List<ProductMainImages> storedMainImgs = erpService.selectProductMainImages(product.getProductNo());
				// ????????? ???????????? ???????????? ????????? ?????? ??????
				String mainDirectory = request.getServletContext().getRealPath("/resources/upload/mainimages/");

				// ????????? ?????? ??????
				for (ProductMainImages smi : storedMainImgs) {
					boolean result = new File(mainDirectory, smi.getRenamedFilename()).delete();
					log.debug("result = {}", result);
				}

				// ?????? ????????? ?????? ??????
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

			// ?????? ????????? ????????? ????????? ??????
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
				// ???????????? ?????? ??? -> ?????? ????????? ?????? ????????? reDir
				FileUtils.fileCopy(folder1, folder2);
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "?????? ?????? ??????");

				return "redirect:/ERP/searchInfo.do";

			} else {
				// ???????????? ?????? ??? -> temp ?????? ?????? ?????? ??????, ?????? ????????? reDir
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "?????? ?????? ??????, ?????? ??? ?????? ?????????????????????!");
				return "redirect:/ERP/searchInfo.do";
			}

		} catch (Exception e) {
			e.printStackTrace();
			redirectAttr.addFlashAttribute("msg", "?????? ?????? ??????, ?????? ??? ?????? ?????????????????????!");
			return "redirect:/ERP/searchInfo.do";
		}

	}

	// ????????? ???????????? -> enabled 1??? ????????????
	@RequestMapping(value = "/ERP/productDelete.do", method = RequestMethod.GET)
	public String productDelete(@RequestParam("productNo") String productNo, HttpServletRequest request,
			RedirectAttributes redirectAttr) {

		try {
			int result = erpService.UpdateProductToDelete(productNo);
			redirectAttr.addFlashAttribute("msg", "?????? ???????????? ????????? ?????????????????????.");
		} catch (Exception e) {
			log.error("?????? ?????? ???????????? ??????");
			redirectAttr.addFlashAttribute("msg", "?????? ????????? ?????????????????????.");
		}

		return "redirect:/ERP/searchInfo.do";
	}

	// ?????? ??????
	@RequestMapping("/ERP/appRequest.do")
	public String appRequest(@RequestParam("requestNo") int requestNo, RedirectAttributes redirectAttr) {

		int result = erpService.updateRequestToApp(requestNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "?????? ??????");
		} else {
			redirectAttr.addFlashAttribute("msg", "?????? ??????");
		}

		return "redirect:/ERP/ProductRequestList.do";
	}

	// ?????? ??????
	@RequestMapping("/ERP/refRequest.do")
	public String refRequest(@RequestParam("requestNo") int requestNo, RedirectAttributes redirectAttr) {

		int result = erpService.updateRequestToRef(requestNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "??????????????? ?????????????????????.");
		} else {
			redirectAttr.addFlashAttribute("msg", "?????? ????????? ?????????????????????. ?????? ?????????????????????.");
		}
		return "redirect:/ERP/ProductRequestList.do";
	}

	// ?????? ?????? ??????
	@RequestMapping("/ERP/appReceive.do")
	public String appReceive(@RequestParam("receiveNo") int receiveNo, RedirectAttributes redirectAttr) {

		// ?????? ?????? ?????? update??????
		int result = erpService.updateReceiveToApp(receiveNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "?????? ?????? ??????????????? ?????????????????????.");
		} else {
			redirectAttr.addFlashAttribute("msg", "?????? ????????? ?????????????????????. ?????? ?????????????????????.");
		}

		return "redirect:/ERP/ProductReceive.do";
	}

	// ?????? ?????? ??????
	@RequestMapping("/ERP/refReceive.do")
	public String refReceive(@RequestParam("receiveNo") int receiveNo, RedirectAttributes redirectAttr) {

		// ?????? ?????? ?????? update??????
		int result = erpService.updateReceiveToref(receiveNo);
		if (result > 0) {
			redirectAttr.addFlashAttribute("msg", "?????? ?????? ??????????????? ?????????????????????.");
		} else {
			redirectAttr.addFlashAttribute("msg", "?????? ????????? ?????????????????????. ?????? ?????????????????????.");
		}

		return "redirect:/ERP/ProductReceive.do";
	}

	// ????????? ?????? ?????? ?????? (ajax)
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

	// ????????? ???????????? ????????? ?????? (ajax)
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

	// EMP ?????????
	@RequestMapping("/ERP/vitalEMP.do")
	public String vitalEmp(@RequestParam("empId") String empId, RedirectAttributes redirectAttr) {

		try {
			int result = erpService.vitalEmp(empId);
			redirectAttr.addFlashAttribute("msg", "?????? ??????/???????????? ????????? ???????????????.");

		} catch (Exception e) {
			redirectAttr.addFlashAttribute("msg", "?????? ??????/????????? ???????????? ?????????????????????. ?????? ??? ?????? ?????????????????????");
		}

		return "redirect:/ERP/empManage.do";
	}

	// ?????? ????????? ????????? ??? ????????? ?????? ??????
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
			redirectAttr.addFlashAttribute("msg", "???????????? ??????????????? ??????????????????.");
		}
		return location;
	}

	// ???????????? ????????????
	@RequestMapping("/ERP/logout.do")
	public String empLogout(SessionStatus sessionStatus) {
		if (!sessionStatus.isComplete()) {
			sessionStatus.setComplete();

		}
		return "redirect:/";
	}

	// ?????? ????????? ??? ??????
	@PostMapping("/ERP/empBoardCkEnroll.do")
	public String empBoardCKEnroll(RedirectAttributes redirectAttr, EmpBoard empBoard, EMP emp,
			@RequestParam(value = "content", defaultValue = "????????? ????????? ?????????") String content,
			@RequestParam("imgDir") String imgDir, HttpServletRequest request, Model model,
			@RequestParam("upFile") MultipartFile[] upFiles) throws IllegalStateException, IOException {

		if (!content.equals("????????? ????????? ?????????.")) {
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
		// ProductImage ?????? ??????
		String realDir = request.getServletContext().getRealPath("/resources/upload/" + imgDir);
		File folder1 = new File(tempDir);
		File folder2 = new File(realDir);

		// file?????? ?????? -> DB??? image????????? ????????? fileDir?????????
		if (result > 0) {
			// folder1??? ?????? -> folder2??? ??????
			FileUtils.fileCopy(folder1, folder2);
			// folder1??? ?????? ??????
			FileUtils.fileDelete(folder1.toString());
			redirectAttr.addFlashAttribute("msg", "????????? ?????? ??????");
		} else {
			// folder1??? ?????? ??????
			FileUtils.fileDelete(folder1.toString());
			redirectAttr.addFlashAttribute("msg", "????????? ?????? ??????");
		}

		return "redirect:/ERP/EmpBoardList.do";
	}

	// ?????? ????????? ?????? ??????
	@PostMapping("/ERP/empReplyEnroll.do")
	public String replyEnroll(EmpBoardReply boardReply, ModelAndView mav, RedirectAttributes redirectAttributes) {

		log.debug("boardReply= {}", boardReply);
		int result = erpService.boardReply(boardReply);
		log.debug("result = {}", result);

		log.debug("boardNo = {}", boardReply.getBoardNo());
		return "redirect:/ERP/EmpBoardDetail.do?no=" + boardReply.getBoardNo();
	}

	// ?????? ????????????
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

	// ?????? empBoard Reply ???????????? (ajax)
	@GetMapping("/ERP/empReplyList.do")
	@ResponseBody
	public List<EmpBoardReply> empReplyList(Model model, @RequestParam("boardNo") int boardNo) {

		List<EmpBoardReply> list = erpService.replyList(boardNo);
		return list;
	}

	// ?????? ??????
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

	// ?????? ??????
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

	// ????????? ??????????????? ???????????? (ajax)
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

	// ????????? ????????? ??????
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

	// ????????? ????????? ??????
	@PostMapping("/ERP/empBoardCkUpdate.do")
	public String empCKBoardUpdate(EmpBoard empBoard, @RequestParam("upFile") MultipartFile[] upFiles,
			@RequestParam("fileChange") int fileChange, HttpServletRequest request)
			throws IllegalStateException, IOException {

		log.debug("empBoard= {}", empBoard);
		if (fileChange > 0) {
			List<EmpBoardImage> imageList = erpService.selectBoardImage(empBoard.getBoardNo());
			String mainDirectory = request.getServletContext().getRealPath("/resources/upload/empBoard/");

			// ????????? ?????? ??????
			for (EmpBoardImage image : imageList) {
				boolean result = new File(mainDirectory, image.getRenamedFilename()).delete();
				log.debug("result = {}", result);
			}

			// ?????? ????????? ?????? ??????
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

	// ?????? ??? ?????? (ajax)
	@ResponseBody
	@PostMapping("/ERP/productResale.do")
	public Map<String, Object> productResale(@RequestParam("productNo") int productNo) {

		int result = erpService.productResale(productNo);
		Map<String, Object> map = new HashMap<>();
		String msg = result > 0 ? "??????" : "??????";
		map.put("msg", msg);
		return map;
	}

	// ?????? ????????? ?????? ?????? (ajax)
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
			map.put("msg", "????????? ?????? ??????, ?????? ??? ?????? ????????? ?????????");
			return new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
		}
	}
	
	@ExceptionHandler({Exception.class}) 
	public String error(Exception e) { 
		log.error("exception = {}", e);
		return "common/error"; 
	}
}
