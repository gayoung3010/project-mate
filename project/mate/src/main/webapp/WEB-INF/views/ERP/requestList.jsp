<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerE.jsp">
	<jsp:param value="MATE-ERP" name="headTitle"/>
</jsp:include>
<c:if test="${not empty msg }">
	<script>
		alert("${msg}");
	</script>
</c:if>

<!-- CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

<!-- jQuery and JS bundle w/ Popper.js -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

<table class="table">
  <thead class="thead-dark">
    <tr>
      <th scope="col">#</th>
      <th scope="col">상품명</th>
      <th scope="col">카테고리</th>
      <th scope="col">가격</th>
      <th scope="col">요청 수량</th>
      <th scope="col">요청 지점명</th>
      <th scope="col">발주 상태</th>
      <th scope="col">발주 승인</th>
      <th scope="col">발주 거부</th>
    </tr>
  </thead>
  <tbody>
  	<!-- 발주 요청이 있을 경우 -->
  	<c:if test="${ not empty list }">
  		<c:forEach items="${list}" var="request" varStatus="vs">
 	 	<tr>
  			<td>${vs.count}</td>
  			<td>${request.productName}</td>
  			<td>${request.category}</td>
  			<td>${request.price}</td>
  			<td>${request.amount}</td>
  			<td>${request.empId}</td>
  			<td>
  				${request.confirm eq 0 ? '발주 요청' : '발주 거부'}
  			</td>
  			<td>
  				<button type="button" onclick="appRequest(${request.requestNo})">발주 승인</button>
  			</td>
  			<td>
  				<button type="button" onclick="refRequest(${request.requestNo})">발주 거부</button>
  			</td>
  		</tr>
  		</c:forEach>
  	</c:if>
  	
  	<!-- 발주 요청이 없을 경우  -->
  	<c:if test="${ empty list }">
  		<td rowspan="8">발주 요청이 없습니다.</td>
  	</c:if>
  </tbody>
</table>

<script>
function appRequest(no){
	console.log(no);
	var confirm_val = confirm("상품을 발주하시겠습니까?");

	if(confirm_val){
		location.href="${pageContext.request.contextPath}/ERP/appRequest.do?requestNo="+no;
	}
	else{
		return false;
	}
}

function refRequest(no){
	console.log(no);
	var confirm_val = confirm("발주 요청을 취소하시곘습니까?");

	if(confirm_val){
		location.href="${pageContext.request.contextPath}/ERP/refRequest.do?requestNo="+no;
	}
	else{
		return false;
	}
}

</script>

<jsp:include page="/WEB-INF/views/common/footerE.jsp"/>