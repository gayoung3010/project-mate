package com.kh.mate.erp.model.service;

import java.util.List;
import java.util.Map;

import com.kh.mate.common.Pagebar;
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

public interface ErpService {

	int insertEmp(EMP emp);

	EMP selectOneEmp(String empId);

	List<Product> searchInfo(Map<String, Object> map);

	List<EMP> empList();

	Product orderProduct(Map<String, Object> map);

	int productEnroll(Product product);

	Product selectProductOne(int productNo);

	List<ProductMainImages> selectProductMainImages(int i);

	int productUpdate(Product product);

	int productDelete(String productNo);

	List<ProductImages> selectProductImages(String productNo);

	int productOrder(Map<String, Object> param);

	EmpBoard selectOneEmpBoard(int no, boolean hasRead);

	List<EmpBoardReply> replyList(int boardNo);

	int boardReply(EmpBoardReply boardReply);

	int deleteReply(int boardReplyNo);

	int infoUpdate(EMP emp);

	int infoDelete(Map<String, Object> map);

	int updateReply(Map<String, Object> map);

	int insertEmpBoard(EmpBoard empBoard);

	EmpBoardImage empBoardFileDownload(int boardImageNo);

	List<Product> erpProductList();

	List<EmpBoard> searchBoard(Pagebar pb);
	
	int getSearchContents(Pagebar pb);

	List<IoLog> ioLogList();

	List<Product> productList();

	List<Receive> receiveList();

	List<RequestLog> requestList();

	EmpBoard selectEmpStock(Map<String, Object> map);

	List<RequestLog> selectRequestList(String empId);

	int updateRequestToApp(int requestNo);

	int updateRequestToRef(int requestNo);

	List<Receive> selectReceiveList(String empId);

	int updateReceiveToApp(int receiveNo);

	int updateReceiveToref(int receiveNo);

	int empBoardDelete(int boardNo);

	EmpBoard selectOneEmpBoard(int boardNo);

	List<EmpBoardImage> selectBoardImage(int boardNo);

	int empBoardUpdate(EmpBoard empBoard);

	int countProduct(Map<String, Object> map);

	List<Product> selectAll();

	List<Integer> productCompare(EMP emp);

	int mStockInsert(Map<String, Object> map);

	int stockTranslate(Map<String, Object> map);

	List<RequestLog> selectEmpRequest(String empId);


	List<Map<String, Object>> ioLogMapList(Map<String, Object> param);

	List<Map<String, Object>> empNameList(EMP emp);

	List<String> yearList();

	List<Map<String, Object>> StockLogMapList(Pagebar pb);

	List<Map<String, Object>> selectRequestMapList(Pagebar pb);

	List<Map<String, Object>> ioEmpList(Pagebar pb);

	int UpdateProductToDelete(String productNo);

	//발주검사
	List<Product> proLogList(Map<String, Object> map);

	int updateEmpDelete(String empId);


	int vitalEmp(String empId);

	int productResale(int productNo);

	List<Map<String, Object>> empList(Pagebar pb);

	List<EMP> empList(Map<String, Object> param);

	List<Map<String, Object>> selectRequestMapList(Map<String, Object> param);

	List<Map<String, Object>> StockLogMapList(Map<String, String> param);

	List<Map<String, Object>> getProductList(Pagebar pb);
	

}	
