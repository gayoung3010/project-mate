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
<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>
</head>
	<body>  
		<div class="container">
			<div>
			<h2>발주 관리</h2>
				<div id="buy" class="tab-pane fade active show in">
					<div class="col-md-15">
					    <div class="form-area">
						    <form id="searchFrm" method="POST">  
								<table id="purchaseLog-table" class="table">
									<thead>
											<tr>
												<th>
												  	<select name="manufacturerId" id="manufacturerId">
												    	<option value="" disabled selected id="manufacturerId-default">제조사 선택</option>
													    <c:forEach items="${empList}" var="list">
														    <option value="">전체</option>
														    <c:if test="${list.status eq 2 }">
														    <option value="${list.empId}">${list.empName}</option>
														    </c:if>
													    </c:forEach>
													</select>
												</th>
												<th>
												  	<select name="confirm" id="confirm">
													    <option value="" disabled selected id="confirm-default">발주 현황</option>
													    <option value="">전체</option>
													    <option value="0">처리중</option>
													    <option value="-1">취소</option>
													    <option value="1">처리완료</option>
													</select>
												</th>
												<th>
													<select name="searchType" id="searchType">
												    <option value="" disabled selected id="searchType-default">검색 타입 선택</option>
												    <option value="product_no">상품번호</option>
												    <option value="product_name">상품명</option>
												</select>
												</th>
												<th>
													<select name="branchId" id="branchId">
														<option value="" disabled selected id="branchId-default">지점 선택</option>
														    <option value="">전체</option>
														<c:if test="${loginEmp.status eq 0 }">
														<c:forEach items="${empList}" var="list">
														    <c:if test="${list.status eq 0 }">
														    <option value="${list.empId}">온라인</option>
														    </c:if>
														    <c:if test="${list.status eq 1 }">
														    <option value="${list.empId}">${list.empName}</option>
														    </c:if>
													    </c:forEach>
														</c:if>
														<c:if test="${loginEmp.status eq 1 }">
															<option value="${loginEmp.empId }" selected>${loginEmp.empName }</option>
														</c:if>
													</select>
												</th>
												<th>
												    <input type="text" class="form-control" name="searchKeyword" placeholder="내용을 입력해주세요">
												</th>
												<th>
												  	<button type="button" class="btn btn-default" id="searchRequest">검색</button>
												</th>
												<th>
												  	<button type="button" class="btn btn-default" id="strike">검색어 초기화</button>
												</th>
											</tr>
									</thead>
										<tbody class="thead-dark">
											<tr>
												<th scope="col">발주번호</th>
												<th scope="col">상품명</th>
												<th scope="col">상품 번호</th>
												<th scope="col">제조사</th>
												<th scope="col">발주 요청 지점</th>
												<th scope="col">발주 날짜</th>
												<th scope="col">발주량</th>
												<th scope="col">상태</th>
											</tr>
										</tbody>	
										<tfoot class="requestInfo">
											<c:if test="${ not empty list }">
												<c:forEach items="${ list }" var="request">
													<tr>
														<td>${ request.requestNo }</td>
														<td>${ request.productName }</td>
														<td>${ request.productNo }</td>
														<td>${ request.manufacturerName }</td>
														<td>${ request.branchName }</td>
														<td>${request.requestDate }</td>
														<td>${ request.amount }</td>
														<td>
															<c:if test="${ request.confirm eq 0}">발주 대기</c:if>
															<c:if test="${ request.confirm eq 1}">발주 완료</c:if>
															<c:if test="${ request.confirm eq -1}">발주 취소</c:if>
														</td>
													</tr>
												</c:forEach>
											</c:if>
										</tfoot>
									<c:if test="${ empty list }">

										<tr>
											<td colspan="6">검색결과 없음</td>
										</tr>
									</c:if>
								</table>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
<script>
$("#searchRequest").click(function(){

	var formData = $("#searchFrm").serialize();

	$.ajax({
		url : "${pageContext.request.contextPath}/ERP/searchRequest.do",
		type: "POST",
		data : formData,
		success: function(data) {
			console.log(data);
			displayRequest(data);
			
	    },
	    error: function(error) {
		    alert("상품이 존재하지 않습니다.");
			console.log(error);
		}
	});

	
});

function displayRequest(data){

	var $container = $(".requestInfo");
	var html = "<fmt:setLocale value='ko_kr'/>";

	for(var i in data){
		var m = data[i];
		html += "<tr>"
			+"<td>" + m.requestNo + "</td>"
			+"<td>" + m.productName + "</td>"
			+"<td>" + m.productNo + "</td>"
			+"<td>" + m.manufacturerName + "</td>"
			+"<td>" + m.branchName + "</td>"
			+"<td>" + m.requestDate + "</td>"
			+"<td>" + m.amount + "</td>"
			+'<td>' + (m.confirm == 0 ? "발주 대기" : ( m.confirm == 1 ? "발주완료" : "발주 취소")) + '</td>'
			+"</tr>";
		
	}
	$container.html(html);
}

$("#strike").click(function(){

	$("#manufacturerId-default").prop("selected", true);
	$("#confirm-default").prop("selected", true);
	$("#searchType-default").prop("selected", true);
	$("#branchId-default").prop("selected", true);
	
});

</script>	
</html>