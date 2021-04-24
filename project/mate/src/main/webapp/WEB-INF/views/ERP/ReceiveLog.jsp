<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerE.jsp">
	<jsp:param value="MATE-ERP" name="headTitle"/>
</jsp:include>
<script>
	$(function() {

		$("#searchIO").click(function() {

			var formData = $("#searchFrm").serialize();
			var monthday = $("#monthday").val();
			console.log(monthday);
			console.log(formData);
		});
	})
</script>
</head>
<body>
	<div class="container">
		<h2>입출고 현황</h2>
		<div class="nevigate">
		<div id="buy" class="tab-pane fade active show in">
			<div class="col-md-15">
				<div class="form-area">
					<form id="searchFrm" method="GET" action="${pageContext.request.contextPath }/ERP/ReceiveLog.do">
						<c:if test="${not empty loginEmp  && loginEmp.empId eq 'admin' }">
							<select name="empName" id="empName_">
								<option value="" disabled="disabled" selected="selected">
									지점을 선택하세요
								</option>
								<option value="" ${ SempName eq '' ? 'selected="selected"' : '' }>
									전체
								</option>
								<c:forEach items="${ empList }" var="e">
									<option value="${e.empName}" ${ e.empName eq SempName ? 'selected="selected"' : ''}>
										${ e.empName }
									</option>
								</c:forEach>
							</select>
						</c:if>
						<select id="ioStatus_" name="ioStatus">
							<option value="" disabled="disabled" selected="selected">
								카테고리를 선택하세요</option>
							<option value="" ${ ioStaus eq '' ? 'selected="selected"' : '' }>전체</option>
							<option value="I" ${ ioStatus eq 'I' ? 'selected="selected"' : ''}>입고</option>
							<option value="O" ${ ioStatus eq 'O' ? 'selected="selected"' : ''}>출고</option>
						</select> <input type="date" name="monthday" id="monthday" value="${ monthday != null ? monthday: '' }" />
						<button type="submit" class="btn btn-default" id="searchIO">검색</button>
					</form>

					<table id="purchaseLog-table" class="table">
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
										<td><fmt:formatDate value="${ io.ioDate }"
												pattern="yyyy-MM-dd" /></td>
										<td>${ io.manufacturerName }</td>

									</tr>
								</c:forEach>
							</c:if>
						</tfoot>

					</table>
				</div>
			</div>	
			<!-- 페이징 바 -->
			<nav aria-label="..." style="text-align: center;">
				<div class="pageBar">
					<ul class="pagination">
						<c:if test="${not empty pageBar }">
								<li>${ pageBar }</li>
						</c:if>
					</ul>
				</div>
			</nav>
			</div>
		</div>	
	</div>

</body>


</html>