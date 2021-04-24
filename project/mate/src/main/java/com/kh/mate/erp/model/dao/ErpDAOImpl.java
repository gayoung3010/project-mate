package com.kh.mate.erp.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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

@Repository
public class ErpDAOImpl implements ErpDAO {


	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public EMP selectOneEmp(String empId) {
		return sqlSession.selectOne("emp.selectOneEmp", empId);
	}

	@Override
	public int insertEmp(EMP emp) {
		return sqlSession.insert("emp.insertEmp", emp);
	}

	@Override
	public int infoUpdate(EMP emp) {
		return sqlSession.update("emp.infoUpdate", emp);
	}

	@Override
	public int infoDelete(Map<String, Object> map) {
		return sqlSession.delete("emp.infoDelete", map);
	}

	@Override
	public List<Product> searchInfo(Map<String, Object> map) {
		return sqlSession.selectList("erp.searchInfo",map);
	}
	
	@Override
		public List<EMP> empList() {
			return sqlSession.selectList("emp.empList");
		}
	@Override
	public List<IoLog> ioLogList() {
		return sqlSession.selectList("emp.ioLogList");
	}

	@Override
	public List<Product> productList() {
		return sqlSession.selectList("emp.productList");
	}

	@Override
	public List<Receive> receiveList() {
		return sqlSession.selectList("emp.receiveList");
	}

	@Override
	public List<RequestLog> requestList() {
		return sqlSession.selectList("emp.requestList");
	}

	@Override
	public Product orderProduct(Map<String, Object> map) {
		return sqlSession.selectOne("erp.orderProduct",map);
	}
	
	@Override
	public String findEmpid(int productNo) {
		return sqlSession.selectOne("erp.findEmpid",productNo);
	}

	
	
	@Override
	public int productOrder(Map<String, Object> param) {
		return sqlSession.insert("erp.productOrder", param);
	}
	

  
  //김종완

	@Override
	public int productEnroll(Product product) {
		return sqlSession.insert("erp.productEnroll", product);
	}

	@Override
	public int vitalEmp(String empId) {
		return sqlSession.update("emp.vitalEmp", empId);
	}

	@Override
	public int UpdateProductToDelete(String productNo) {
		return sqlSession.update("erp.UpdateProductToDelete", productNo);
	}

	@Override
	public int productImageEnroll(ProductImages pigs) {
		return sqlSession.insert("erp.productImageEnroll", pigs);
	}

	@Override
	public Product selectProductOne(int productNo) {
		return sqlSession.selectOne("erp.selectProductOne", productNo);
	}

	@Override
	public List<ProductMainImages> selectProductMainImages(int productNo) {
		return sqlSession.selectList("erp.selectProductMainImages", productNo);
	}
	
	@Override
	public List<ProductImages> selectProductImages(String productNo) {
		return sqlSession.selectList("erp.selectProductImages", productNo);
	}

	@Override
	public int productMainImagesEnroll(ProductMainImages mainImg) {
		return sqlSession.insert("erp.productMainImagesEnroll", mainImg);
	}

	@Override
	public int productUpdate(Product product) {
		return sqlSession.update("erp.productUpdate", product);
	}

	@Override
	public int productMainImagesDelete(String productNo) {
		return sqlSession.delete("erp.productMainImagesDelete", productNo);
	}

	@Override
	public int productDelete(String productNo) {
		return sqlSession.delete("erp.productDelete", Integer.parseInt(productNo));
	}


	@Override
	public int productImagesDelete(String productNo) {
		return sqlSession.delete("erp.productImagesDelete", productNo);
	}

	@Override
	public List<RequestLog> selectRequsestList(String empId) {
		return sqlSession.selectList("erp.selectRequsestList", empId);
	}
	
	@Override
	public int updateRequestToApp(int requestNo) {
		return sqlSession.update("erp.updateRequestToApp", requestNo);
	}

	@Override
	public int updateRequestToRef(int requestNo) {
		return sqlSession.update("erp.updateRequestToRef", requestNo);
	}
	
	@Override
	public List<Receive> selectReceiveList(String empId) {
		return sqlSession.selectList("erp.selectReceiveList", empId);
	}
	
	@Override
	public int updateReceiveToApp(int receiveNo) {
		return sqlSession.update("erp.updateReceiveToApp", receiveNo);
	}
	
	@Override
	public int updateReceiveToRef(int receiveNo) {
		return sqlSession.update("erp.updateReceiveToRef", receiveNo);
	}
	
	@Override
	public List<RequestLog> selectEmpRequest(String empId) {
		return sqlSession.selectList("erp.selectEmpRequest", empId);
	}
	
	@Override
	public List<Map<String, Object>> StockLogMapList(Map<String,String> param) {
		return sqlSession.selectList("erp.StockLogMapList", param);
	}
	
	@Override
	public List<Map<String, Object>> selectRequestMapList(Map<String, Object> temp) {
		return sqlSession.selectList("erp.selectRequestMapList", temp);
	}

	@Override
	public int updateEmpDelete(String empId) {
		return sqlSession.update("emp.updateEmpDelete", empId);
	}
	
	//호근 추가


	

	



	

	@Override
	public EmpBoard selectOneEmpBoard(int no) {
		return sqlSession.selectOne("erpBoard.selectOneEmpBoard",no);
	}

	@Override
	public List<EmpBoardReply> replyList(int boardNo) {
		return sqlSession.selectList("erpBoard.selectReplyList", boardNo);
	}

	@Override
	public int boardReply(EmpBoardReply boardReply) {
		return sqlSession.insert("erpBoard.insertBoardReply", boardReply);
	}

	@Override
	public int deleteReply(int boardReplyNo) {
		return sqlSession.delete("erpBoard.deleteReply", boardReplyNo);
	}

	@Override
	public int updateReply(Map<String, Object> map) {
		return sqlSession.update("erpBoard.updateReply", map);
	}

	@Override
	public int inserEmpBoard(EmpBoard empBoard) {
		return sqlSession.insert("erpBoard.insertEmpBoard", empBoard);
	}

	@Override
	public int inserEmpBoardImage(EmpBoardImage empBoardImage) {
		return sqlSession.insert("erpBoard.insertEmpBoardImage", empBoardImage);
	}

	@Override
	public EmpBoardImage empBoardFileDownload(int boardImageNo) {
		return sqlSession.selectOne("erpBoard.empBoardFileDownload", boardImageNo);
	}

	@Override
	public List<Product> erpProductList() {
		return sqlSession.selectList("erpBoard.erpProductList");
	}

	@Override
	public int insertRequestStock(EmpBoard empBoard) {
		return sqlSession.insert("erpBoard.insertRequestStock", empBoard);
	}

	@Override
	public int increaseReadCount(int no) {
		return sqlSession.update("erpBoard.increaseReadCount", no);
	}

	
	//김찬희 페이징작업
	@Override
	public int countProduct(Map<String, Object> map) {
		return sqlSession.selectOne("erp.countProduct",map);
	}
	//누락상품검사
	
	@Override
	public List<Product> selectAll() {
		return sqlSession.selectList("erp.selectAll");
	}

	@Override
	public List<Integer> productCompare(EMP emp) {
		return sqlSession.selectList("erp.productCompare",emp);
	}

	//누락재고상품추가
	@Override
	public int mStockInsert(Map<String, Object> map) {
		return sqlSession.insert("erp.mStockInsert",map);
	}

	
	
	
	
	

	@Override
	public EmpBoard selectEmpStock(Map<String, Object> map) {
		return sqlSession.selectOne("erpBoard.selectEmpStock", map);
	}

	@Override
	public int empBoardDelete(int boardNo) {
		return sqlSession.delete("erpBoard.empBoardDelete", boardNo);
	}

	@Override
	public List<EmpBoardImage> selectBoardImage(int boardNo) {
		return sqlSession.selectList("erpBoard.selectOneBoardImage", boardNo);
	}

	@Override
	public int empBoardUpdate(EmpBoard empBoard) {
		return sqlSession.update("erpBoard.empBoardUpdate", empBoard);
	}

	@Override
	public int empBoardFileDelete(int boardNo) {
		return sqlSession.delete("erpBoard.empBoardFileDelete", boardNo);
	}

	@Override
	public int empBoardFileUpdate(EmpBoardImage updateImages) {
		return sqlSession.update("erpBoard.empBoardFileUpdate", updateImages);
	}

	@Override
	public EmpBoard selectOneEmpBoard(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("erpBoard.selectOneEmpBoard",map);
	}

	@Override
	public int updateEnabled(Map<String, Object> map) {
		return sqlSession.update("erpBoard.enabledUpdate",map);
	}

	@Override
	public int updateTranStock(Map<String, Object> map) {
		return sqlSession.update("erpBoard.updateTranStock", map);
	}

	@Override
	public int updateStock(Map<String, Object> map) {
		return sqlSession.update("erpBoard.updateStock",map);
	}

	@Override
	public int updateStockInfo(Map<String, Object> map) {
		return sqlSession.update("erpBoard.updateStockInfo",map);
	}

	@Override
	public List<Map<String, Object>> ioLogMapList(Map<String, Object> param) {
		return sqlSession.selectList("emp.ioLogMapList", param);
	}

	@Override
	public List<Map<String, Object>> empNameList(EMP emp) {
		return sqlSession.selectList("emp.empNameList", emp);
	}

	@Override
	public List<String> yearList() {
		return sqlSession.selectList("emp.yearList");
	}

	//발주검사
	@Override
	public List<Product> proLogList(Map<String, Object> map) {
		return sqlSession.selectList("erp.proLogList",map);
	}

	@Override
	public int productResale(int productNo) {
		return sqlSession.update("erp.productResale", productNo);
	}

	@Override
	public List<Map<String, Object>> getProductList(Pagebar pb) {
		return sqlSession.selectList("emp.getProductList", pb);
	}

	@Override
	public int getProductTotalContents(Pagebar pb) {
		return sqlSession.selectOne("emp.getProductTotalContents", pb);
	}
	@Override
	public List<Map<String, Object>> selectRequestMapList(Pagebar pb) {
		return sqlSession.selectList("erp.selectRequestPage", pb);
	}
	@Override
	public int requestCount(Pagebar pb) {
		return sqlSession.selectOne("erp.requestCount", pb);
	}

	@Override
	public List<Map<String, Object>> StockLogMapList(Pagebar pb) {
		return sqlSession.selectList("erp.StockLogMapListCount", pb);
	}

	@Override
	public int stockTotalCount(Pagebar pb) {
		return sqlSession.selectOne("erp.StockCount", pb);
	}

	@Override
	public List<EmpBoard> searchBoard(Pagebar pb) {
		
		return sqlSession.selectList("erpBoard.searchBoard", pb);
	}

	@Override
	public int getSearchContents(Pagebar pb) {
		return sqlSession.selectOne("erpBoard.searchContents", pb);
	}

	@Override
	public List<Map<String, Object>> ioEmpList(Pagebar pb) {
		return sqlSession.selectList("erpBoard.ioEmpList", pb);
	}

	@Override
	public int coutnIOEmp(Pagebar pb) {
		return sqlSession.selectOne("erpBoard.countIOEMP", pb);
	}
	@Override
	public List<Map<String, Object>> empList(Pagebar pb) {
		return sqlSession.selectList("emp.erpSearchList", pb);
	}

	@Override
	public int countEMP(Pagebar pb) {
		return sqlSession.selectOne("emp.countEMP", pb);
	}

	@Override
	public List<EMP> empList(Map<String, Object> param) {
		return sqlSession.selectList("emp.erpParamList",param);
	}

}
