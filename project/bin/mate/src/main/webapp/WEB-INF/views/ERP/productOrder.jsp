<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
function orderModal(){

	$("#modelTest").modal({backdrop: 'static', keyboard: false});
	
}
</script>

<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
</head>
  	<body onload="orderModal()">
		<section>
			
			<div class="modal" id="modelTest" tabindex="-1">
			  <div class="modal-dialog">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title">발주</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      	<form action="${pageContext.request.contextPath}/ERP/productOrder.do">
			      <div class="modal-body">
			      
			      	
			      		<p>제조사 : ${ product.manufacturerId }</p>
			      		<p>현재수량 : ${ product.stock eq 0 ? '재고가 없습니다' : product.stock }</p>
			      		<p>상품번호 : ${ product.productNo }</p>
			      		<p>지점 아이디 ${ product.branchEmp }</p>
			      		<p>요청수량 : <input type="number" name="stock" id="order" required="required"/></p>
			      		<input type="hidden" name="branchEmp" value="${ product.branchEmp }"/>
			      		<input type="hidden" name="empId" value="${ product.manufacturerId }"/>
			      		<input type="hidden" name="productNo" value="${ product.productNo }"/>
			      		
			      </div>
				<div class="modal-footer">
				   <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="history.go(-1)">뒤로가기</button>
					<button type="submit" class="btn btn-primary">발주 하기</button>
				</div>
			      	</form>
			    </div>
			  </div>
			</div>
					
		</section>
	</body>
</html>