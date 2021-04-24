package com.kh.mate.erp.model.dao;

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

public interface ErpDAO {

	int insertEmp(EMP emp);

	EMP selectOneEmp(String empId);

	List<Product> searchInfo(Map<String, Object> map);

	List<EMP> empList();

	Product orderProduct(Map<String, Object> map);

	int productEnroll(Product product);

	int productImageEnroll(ProductImages pigs);

	Product selectProductOne(int productNo);

	List<ProductMainImages> selectProductMainImages(int productNo);


	int productMainImagesEnroll(ProductMainImages mainImg);

	int productUpdate(Product product);

	int productMainImagesDelete(String productNo);

	int productDelete(String productNo);

	List<ProductImages> selectProductImages(String productNo);

	int productImagesDelete(String productNo);

	String findEmpid(int productNo);

	int productOrder(Map<String, Object> param);
	
	
	EmpBoard selectOneEmpBoard(int no);


	List<EmpBoardReply> replyList(int boardNo);

	int boardReply(EmpBoardReply boardReply);

	int deleteReply(int boardReplyNo);

	int infoUpdate(EMP emp);

	int infoDelete(Map<String, Object> map);

	int updateReply(Map<String, Object> map);


	int inserEmpBoard(EmpBoard empBoard);

	int inserEmpBoardImage(EmpBoardImage empBoardImage);

	EmpBoardImage empBoardFileDownload(int boardImageNo);

	List<Product> erpProductList();

	int insertRequestStock(EmpBoard empBoard);

	int increaseReadCount(int no);

	List<EmpBoard> searchBoard(Pagebar pb);
	
	int getSearchContents(Pagebar pb);


	List<IoLog> ioLogList();

	List<Product> productList();

	List<Receive> receiveList();

	List<RequestLog> requestList();

	EmpBoard selectEmpStock(Map<String, Object> map);
	
	List<RequestLog> selectRequsestList(String empId);

	int updateRequestToApp(int requestNo);

	int updateRequestToRef(int requestNo);

	List<Receive> selectReceiveList(String empId);

	int updateReceiveToApp(int receiveNo);

	int updateReceiveToRef(int receiveNo);


	int empBoardDelete(int boardNo);

	List<EmpBoardImage> selectBoardImage(int boardNo);

	int empBoardUpdate(EmpBoard empBoard);

	int empBoardFileDelete(int boardNo);

	int empBoardFileUpdate(EmpBoardImage updateImages);

	int countProduct(Map<String, Object> map);

	List<Product> selectAll();

	List<Integer> productCompare(EMP emp);

	int mStockInsert(Map<String, Object> map);

	EmpBoard selectOneEmpBoard(Map<String, Object> map);

	int updateEnabled(Map<String, Object> map);

	int updateTranStock(Map<String, Object> map);

	int updateStock(Map<String, Object> map);

	int updateStockInfo(Map<String, Object> map);

	List<RequestLog> selectEmpRequest(String empId);


	List<Map<String, Object>> ioLogMapList(Map<String, Object> param);

	List<Map<String, Object>> empNameList(EMP emp);

	List<String> yearList();

	List<Map<String, Object>> StockLogMapList(Pagebar pb);

	List<Map<String, Object>> selectRequestMapList(Pagebar pb);

	List<Map<String, Object>> ioEmpList(Pagebar pb);
	

	int UpdateProductToDelete(String productNo);

	List<Product> proLogList(Map<String, Object> map);

	int updateEmpDelete(String empId);


	int vitalEmp(String empId);

	int productResale(int productNo);

	List<Map<String, Object>> empList(Pagebar pb);

	int countEMP(Pagebar pb);

	List<EMP> empList(Map<String, Object> param);

	int coutnIOEmp(Pagebar pb);

	int requestCount(Pagebar pb);

	List<Map<String, Object>> selectRequestMapList(Map<String, Object> param);

	List<Map<String, Object>> StockLogMapList(Map<String, String> param);

	int stockTotalCount(Pagebar pb);

	List<Map<String, Object>> getProductList(Pagebar pb);

	int getProductTotalContents(Pagebar pb);


}
