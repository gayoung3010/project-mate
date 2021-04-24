package com.kh.mate.erp.model.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.mate.common.Pagebar;
import com.kh.mate.erp.model.dao.ErpDAO;
import com.kh.mate.erp.model.vo.EMP;
import com.kh.mate.erp.model.vo.EmpBoard;
import com.kh.mate.erp.model.vo.EmpBoardImage;
import com.kh.mate.erp.model.vo.EmpBoardReply;
import com.kh.mate.log.vo.IoLog;
import com.kh.mate.log.vo.Receive;
import com.kh.mate.log.vo.RequestLog;
import com.kh.mate.product.model.vo.Product;
import com.kh.mate.product.model.vo.ProductImages;
import com.kh.mate.product.model.vo.ProductMainImages;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ErpServiceImpl implements ErpService {

	

	@Autowired
	private ErpDAO erpDAO;

	@Override
	public int insertEmp(EMP emp) {
		return erpDAO.insertEmp(emp);
	}

	@Override
	public EMP selectOneEmp(String empId) {
		return erpDAO.selectOneEmp(empId);
	}

	@Override
	public int infoUpdate(EMP emp) {
		return erpDAO.infoUpdate(emp);
	}

	@Override
	public int infoDelete(Map<String, Object> map) {
		return erpDAO.infoDelete(map);
	}

	@Override
	public List<Product> searchInfo(Map<String, Object> map) {
		return erpDAO.searchInfo(map);
	}

	@Override
	public List<EMP> empList() {
		return erpDAO.empList();
	}

	@Override
	public Product orderProduct(Map<String, Object> map) {

		Product product = erpDAO.orderProduct(map);

//		product.setEId(erpDAO.findEmpid(product.getProductNo()));

		return product;
	}

	@Override
	public int productOrder(Map<String, Object> param) {
		return erpDAO.productOrder(param);
	}

	// 김종완

	@Override
	public int productEnroll(Product product) {

		int result = erpDAO.productEnroll(product);

		// MainImages가 추가되어있다면 실행될 메소드
		if (product.getPmiList() != null) {
			for (ProductMainImages mainImg : product.getPmiList()) {

				mainImg.setProductNo(product.getProductNo());
				result = erpDAO.productMainImagesEnroll(mainImg);
			}
		}

		// ImagesName도 추가
		if (product.getProductImagesName() != null) {
			List<String> imagesName = product.getProductImagesName();
			String str = "";
			for (int i = 0; i < imagesName.size(); i++) {
				str += imagesName.get(i);
				if (i != (imagesName.size() - 1)) {
					str += ",";
				}
			}
			log.debug("str = {}", str);

			ProductImages pigs = new ProductImages(0, str, product.getProductNo());
			result = erpDAO.productImageEnroll(pigs);
		}

		return result;
	}

	@Override
	public int vitalEmp(String empId) {
		return erpDAO.vitalEmp(empId);
	}

	@Override
	public int updateEmpDelete(String empId) {
		return erpDAO.updateEmpDelete(empId);
	}

	@Override
	public Product selectProductOne(int productNo) {
		return erpDAO.selectProductOne(productNo);
	}

	@Override
	public List<ProductMainImages> selectProductMainImages(int productNo) {
		return erpDAO.selectProductMainImages(productNo);
	}

	@Override
	public List<ProductImages> selectProductImages(String productNo) {
		return erpDAO.selectProductImages(productNo);
	}

	@Override
	public int productUpdate(Product product) {
		int result = erpDAO.productUpdate(product);

		// productMainImage 수정 여부 확인 후 진행
		if (result > 0 && product.getPmiList() != null) {
			// 기존 섬네일 이미지 삭제
			result = erpDAO.productMainImagesDelete(String.valueOf(product.getProductNo()));
			// 업데이트된 이미지 새로 등록
			for (ProductMainImages mainImg : product.getPmiList()) {
				mainImg.setProductNo(product.getProductNo());
				result = erpDAO.productMainImagesEnroll(mainImg);
			}

		}

		// productImage 수정 여부 확인 후 진행
		if (product.getProductImagesName() != null) {
			List<String> imagesName = product.getProductImagesName();
			String str = "";
			for (int i = 0; i < imagesName.size(); i++) {
				str += imagesName.get(i);
				if (i != (imagesName.size() - 1)) {
					str += ",";
				}
			}
			log.debug("str = {}", str);

			ProductImages pigs = new ProductImages(0, str, product.getProductNo());
			result = erpDAO.productImageEnroll(pigs);
		}

		log.debug("result@service = {}", result);
		return result;
	}

	@Override
	public int productDelete(String productNo) {
		// productTable 데이터 삭제
		int result = erpDAO.productDelete(productNo);
		log.debug("result@service1 = {}", result);
		return result;
	}

	@Override
	public List<RequestLog> selectRequestList(String empId) {
		List<RequestLog> requestLogList = erpDAO.selectRequsestList(empId);
		return requestLogList;
	}

	@Override
	public int updateRequestToApp(int requestNo) {
		return erpDAO.updateRequestToApp(requestNo);
	}

	@Override
	public int updateRequestToRef(int requestNo) {
		return erpDAO.updateRequestToRef(requestNo);
	}

	@Override
	public List<Receive> selectReceiveList(String empId) {
		return erpDAO.selectReceiveList(empId);
	}

	@Override
	public int updateReceiveToApp(int receiveNo) {
		return erpDAO.updateReceiveToApp(receiveNo);
	}

	@Override
	public int updateReceiveToref(int receiveNo) {
		return erpDAO.updateReceiveToRef(receiveNo);
	}
	
	@Override
	public List<RequestLog> selectEmpRequest(String empId) {
		return erpDAO.selectEmpRequest(empId);
	}
	
	@Override
	public List<Map<String, Object>> StockLogMapList(Pagebar pb) {
		int totalContents = erpDAO.stockTotalCount(pb);
		pb.setTotalContents(totalContents);
		return erpDAO.StockLogMapList(pb);
	}
	
	@Override
	public List<Map<String, Object>> StockLogMapList(Map<String, String> param) {
		return erpDAO.StockLogMapList(param);
	}
	
	@Override
	public List<Map<String, Object>> selectRequestMapList(Pagebar pb) {
		
		int totalContents = erpDAO.requestCount(pb);
		pb.setTotalContents(totalContents);
		return erpDAO.selectRequestMapList(pb);
	}
	
	@Override
	public int UpdateProductToDelete(String productNo) {
		return erpDAO.UpdateProductToDelete(productNo);
	}
	
	

	// 호근 emp 게시판 추가

	@Override
	public List<Map<String, Object>> selectRequestMapList(Map<String, Object> param) {
		return erpDAO.selectRequestMapList(param);
	}




	@Override
	public EmpBoard selectOneEmpBoard(int no, boolean hasRead) {
		int result = 0;
		if (hasRead == false) {
			result = erpDAO.increaseReadCount(no);
		}

		return erpDAO.selectOneEmpBoard(no);
	}

	@Override
	public List<EmpBoardReply> replyList(int boardNo) {
		return erpDAO.replyList(boardNo);
	}

	@Override
	public int boardReply(EmpBoardReply boardReply) {
		return erpDAO.boardReply(boardReply);
	}

	@Override
	public int deleteReply(int boardReplyNo) {
		return erpDAO.deleteReply(boardReplyNo);
	}

	@Override
	public int updateReply(Map<String, Object> map) {

		return erpDAO.updateReply(map);
	}

	@Override
	public int insertEmpBoard(EmpBoard empBoard) {
		int result = erpDAO.inserEmpBoard(empBoard);

		if (empBoard.getEmpBoardImageList() != null) {

			for (EmpBoardImage empBoardImage : empBoard.getEmpBoardImageList()) {

				empBoardImage.setBoardNo(empBoard.getBoardNo());
				result = erpDAO.inserEmpBoardImage(empBoardImage);

			}

		}

		if (empBoard.getCategory().equals("req")) {
			log.debug("호출은 되냐?");
			empBoard.setBoardNo(empBoard.getBoardNo());
			result = erpDAO.insertRequestStock(empBoard);

		}
		return result;
	}

	public List<IoLog> ioLogList() {
		return erpDAO.ioLogList();
	}

	@Override
	public List<Map<String, Object>> ioLogMapList(Map<String, Object> param) {
		return erpDAO.ioLogMapList(param);
	}

	@Override
	public List<Product> productList() {
		return erpDAO.productList();
	}

	@Override
	public List<Receive> receiveList() {
		return erpDAO.receiveList();
	}

	@Override
	public List<RequestLog> requestList() {
		return erpDAO.requestList();
	}

	@Override
	public EmpBoardImage empBoardFileDownload(int boardImageNo) {
		return erpDAO.empBoardFileDownload(boardImageNo);
	}

	@Override
	public List<Product> erpProductList() {
		return erpDAO.erpProductList();
	}

	@Override
	public List<EmpBoard> searchBoard(Pagebar pb) {
		return erpDAO.searchBoard(pb);
	}

	@Override
	public int getSearchContents(Pagebar pb) {

		int totalContents = erpDAO.getSearchContents(pb);

		return totalContents;
	}

	// 김찬희 페이징작업
	@Override
	public int countProduct(Map<String, Object> map) {
		return erpDAO.countProduct(map);
	}

	// 누락상품검사
	@Override
	public List<Product> selectAll() {
		return erpDAO.selectAll();
	}

	@Override
	public List<Integer> productCompare(EMP emp) {
		return erpDAO.productCompare(emp);
	}

	// 누락재고상품 추가
	@Override
	public int mStockInsert(Map<String, Object> map) {
		return erpDAO.mStockInsert(map);
	}

	@Override
	public EmpBoard selectEmpStock(Map<String, Object> map) {
		return erpDAO.selectEmpStock(map);
	}

	@Override
	public int empBoardDelete(int boardNo) {
		return erpDAO.empBoardDelete(boardNo);
	}

	@Override
	public EmpBoard selectOneEmpBoard(int boardNo) {
		return erpDAO.selectOneEmpBoard(boardNo);
	}

	@Override
	public List<EmpBoardImage> selectBoardImage(int boardNo) {
		return erpDAO.selectBoardImage(boardNo);
	}

	@Override
	public int empBoardUpdate(EmpBoard empBoard) {
		int result = erpDAO.empBoardUpdate(empBoard);

		// productMainImage 수정 여부 확인 후 진행
		if (result > 0 && empBoard.getEmpBoardImageList() != null) {
			// 기존 섬네일 이미지 삭제
			result = erpDAO.empBoardFileDelete(empBoard.getBoardNo());
			// 업데이트된 이미지 새로 등록
			for (EmpBoardImage updateImages : empBoard.getEmpBoardImageList()) {
				updateImages.setBoardNo(empBoard.getBoardNo());
				result = erpDAO.empBoardFileUpdate(updateImages);
			}

		}

		if (empBoard.getCategory().equals("req")) {
			empBoard.setBoardNo(empBoard.getBoardNo());
			result = erpDAO.insertRequestStock(empBoard);
		}
		log.debug("result@service = {}", result);
		return result;
	}

	@Override
	public int stockTranslate(Map<String, Object> map) {
		int result = 0;
		EmpBoard empBoard = erpDAO.selectOneEmpBoard(map);

		if (empBoard.getEnabled() == 0) {

			result = erpDAO.updateTranStock(map);
			result = erpDAO.updateStock(map);
			result = erpDAO.updateStockInfo(map);
			result = erpDAO.updateEnabled(map);

		}

		log.debug("result = {}", result);

		return result;
	}

	@Override
	public List<Map<String, Object>> empNameList(EMP emp) {
		return erpDAO.empNameList(emp);
	}


	@Override
	public List<String> yearList() {
		return erpDAO.yearList();
	}

	@Override
	public List<Map<String, Object>> ioEmpList(Pagebar pb) {
		int totalCount = erpDAO.coutnIOEmp(pb);
		pb.setTotalContents(totalCount);
		return erpDAO.ioEmpList(pb);
	}

	@Override
	public List<Product> proLogList(Map<String, Object> map) {
		return erpDAO.proLogList(map);
	}

	@Override
	public int productResale(int productNo) {
		return erpDAO.productResale(productNo);
	}
	
	@Override
	public List<Map<String, Object>> empList(Pagebar pb) {
		int totalContents = erpDAO.countEMP(pb);
		pb.setTotalContents(totalContents);
		List<Map<String, Object>> list = erpDAO.empList(pb);
		return list;
	}
	
	@Override
	public List<EMP> empList(Map<String, Object> param) {
		return erpDAO.empList(param);
	}

	@Override
	public List<Map<String, Object>> getProductList(Pagebar pb) {
		
		int totalContents = erpDAO.getProductTotalContents(pb);
		pb.setTotalContents(totalContents);
		return erpDAO.getProductList(pb);
	}
	

}
