<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<link rel="stylesheet"
	href="${ pageContext.request.contextPath }/resources/css/loginForm.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
	integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
	integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
	crossorigin="anonymous">
</script>

<script>
$(function(){
	
$("#searchIO").click(function(){

	var formData = $("#searchFrm").serialize();
	var monthday = $("#monthday").val();
	console.log(monthday);
	console.log(formData);
});
})

</script>
<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>
</head>
	<body>  
		<div class="container">
		<h2>입출고 현황</h2>
			<div id="buy" class="tab-pane fade active show in">
				<div class="col-md-15">
				    <div class="form-area">  
						<table id="purchaseLog-table" class="table">
							<thead>
							<form id="searchFrm" method="get" action="${pageContext.request.contextPath }/ERP/ReceiveLog.do">
								<tr>
									<th>
										<input type="date" name="monthday" id="monthday" value="${ monthday != null ? monthday: '' }"/>
									</th>
									<th>
				  						<button type="submit" class="btn btn-default"  id="searchIO">검색</button>
									</th>
			  					</tr>
							</form>
			  				
			  					</thead>
			  					<tbody class="thead-dark">						
									<tr>
										<th>번호</th>
										<th>지점명</th>
										<th>상품번호</th>
										<th>상품명</th>
										<th>수량</th>
										<th>입/출고 분류</th>
										<th>입출고 날짜</th>
										<th>제조사명</th>
									</tr>
								</tbody>
						
								<tfoot>
									<c:if test="${ not empty ioList }">
										<c:forEach items="${ ioList }" var="io" varStatus="vs">
											<tr>
												<td>${ io.ioNo }</td>
												<td>${ io.empName }</td>
												<td>${ io.productNo }</td>
												<td>${ io.productName }</td>
												<td>${ io.amount }</td>
												<td>${ io.status eq 'I' ?"입고" :"출고"}</td>
												<td><fmt:formatDate value="${ io.ioDate }" pattern="yyyy-MM-dd"/></td>
												<td>${ io.manufacturerName }</td>
										
											</tr>
										</c:forEach>
									</c:if>
								</tfoot>
						
							</table>
						</div>
					</div>
				</div>
			</div>						
	</body>
	
	
</html>