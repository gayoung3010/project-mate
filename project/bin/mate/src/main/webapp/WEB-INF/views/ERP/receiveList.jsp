<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>
<c:if test="${not empty msg }">
	<script>
		alert("${msg}");
	</script>
</c:if>
<style>
.scroll-area{
	height: 650px;
	overflow: auto;
}
.thead-dark th{
	position: sticky;
    top : 0;
}
</style>
	<div class="container">
			<h2>입고 관리</h2>
		<div class="scroll-area">
			<div class="nav">
				<table class="table">
				  <thead class="thead-dark">
				    <tr>
				      <th scope="col">#</th>
				      <th scope="col">상품명</th>
				      <th scope="col">카테고리</th>
				      <th scope="col">가격</th>
				      <th scope="col">제조사</th>
				      <th scope="col">재고</th>
				      <th scope="col">발주량</th>
				      <th scope="col">승인 여부</th>
				      <th scope="col">입고 승인</th>
				      <th scope="col">입고 거부</th>
				    </tr>
				  </thead>
				  
				  <tbody>
				  <!-- 입고 요청이 있을 경우 -->
				  <c:if test="${not empty list }">
					  <c:forEach items="${list}" var="rec" varStatus="vs">
					  	<tr>
					  		<td>${vs.count}</td>
					  		<td>${rec.productName }</td>
					  		<td>${rec.category }</td>
					  		<td>${rec.price }</td>
					  		<td>${rec.manufacturerId }</td>
					  		<td>${rec.stock }</td>
					  		<td>${rec.amount }</td>
					  		<td>${rec.confirm eq 0 ? '승인 대기' : '승인 거부' }</td>
					  		<td>
								<button type="button" onclick="appReceive(${rec.receiveNo});">입고 승인</button>
							</td>
					  		<td>
					  			<button type="button" onclick="refReceive(${rec.receiveNo});">입고 거부</button>
					  		</td>
					  	</tr>
					  </c:forEach>
				  </c:if>
				  <!-- 입고 요청이 없을 경우 -->
					  <c:if test="${empty list }">
						  <tr>
						  	<td rowspan="9">입고 목록이 없습니다.</td>
						  </tr>
					  </c:if> 
				  </tbody>
				</table>
			</div>	
		</div>
	</div>
<script>
function appReceive(no){
	var confirm_val = confirm("해당 상품을 입고처리 하시겠습니까?");

	if(confirm_val){
		location.href="${pageContext.request.contextPath}/ERP/appReceive.do?receiveNo="+no;
	}
	
}
function refReceive(no){
	var confirm_val = confirm("해당 상품 입고처리를 거절하시겠습니까?");

	if(confirm_val){
		location.href="${pageContext.request.contextPath}/ERP/refReceive.do?receiveNo="+no;
	}
	
}

</script>


<jsp:include page="/WEB-INF/views/common/footerE.jsp"/>