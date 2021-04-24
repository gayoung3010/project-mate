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
<style>
/* .form-area{
	height: 650px;
	overflow:scroll;
} */
.thead-dark th{
	position: sticky;
    top : 0;
}

</style>	 

<script>
$(function(){
	$("#searchFrm").submit(function(){
		var $frm = $("#searchFrm");
		var $status =  $frm.find("[name=category]:checked");
		var status = "";
		$.each($status,function(i, ct){
			category += $(ct).val();
			if(i != $category.length-1) category += ",";
		});
		if(status != null) loc += "&status=" + status;
	
	});
	
	$("[name=status]").change(function(){
		var $chks = $("[name=status]");
		var cnt = 0;
		$chks.each(function(i, chk){
			if($(chk).is(":checked") == true) cnt++;
		});
		if(cnt == 2) $("#status-all").prop("checked", true);
		else $("#status-all").prop("checked", false);
	});

	$("#status-all").change(function(){
		var $chks = $("[name=status]");
		if($(this).is(":checked")) {
			$chks.each(function(i, chk){
				$(chk).prop("checked", true);
			});
		}
		else{
			$chks.each(function(i, chk){
				$(chk).prop("checked", false);
			});
		}
	});

	<c:if test="${ status ne '1' && status ne '2'}">
		$("#status-all").click();
	</c:if>
});

</script> 
</head>
	<body>
<div class="container">
	<h2>지점/제조사 관리</h2>
<div class="nevigate">
	<div id="buy" class="tab-pane fade active show in">
		<div class="col-md-15">
		    <div class="form-area">  
		    	<form id="searchFrm" method="GET" action="${pageContext.request.contextPath }/ERP/empManage.do">
						<div class="form-group">
							<input id="status-all" type="checkbox"  name='' value="" ${ status eq '' ? 'checked' :''}/>전체
							<input type="checkbox"  name='status' value="1"${ status eq '1' ? 'checked' :''}/>지점
							<input type="checkbox"  name='status' value="2"${ status eq '2' ? 'checked' :''}/> 제조사
						</div>
						<select id="searchType" name="searchType">
							<option value="" disabled="disabled" selected="selected">분류</option>
							<option value="emp_id" ${ searchType eq 'emp_id' ? 'selected="selected"' :''} >아이디</option>
							<option value="emp_name" ${ searchType eq 'emp_id' ? 'selected="selected"' :''}>이름</option>
						</select> 
						<input type="text" name="searchKeyword" value="${ searchKeyword != null ? searchKeyword :''}" />
						<button type="submit" class="btn btn-default" id="searchIO">검색</button>
					</form>
				<table id="purchaseLog-table" class="table">
				<thead class="thead-dark">
					<tr>
						<th scope="col">계정명</th>
						<th scope="col">사업명</th>
						<th scope="col">주소</th>
						<th scope="col">연락처</th>
						<th scope="col">등록일</th>
						<th scope="col">상태</th>
						<th></th>
						<th>
							<button type="button" 
									onclick="location.href='${ pageContext.request.contextPath }/ERP/EmpEnroll.do';">생성하기
							</button>
						</th>
					</tr>
				</thead>
					<c:if test="${ not empty list }">
						<c:forEach items="${ list }" var="emp">
						<c:if test="${emp.status ne 0 }">
						<tr>
							<td>${ emp.empId }</td>
							<td><a href="${ pageContext.request.contextPath }/ERP/empInfoDetail.do?empId=${ emp.empId }">${ emp.empName }</a></td>
							<td>${ emp.empAddr2 }</td>
							<td>${ emp.empPhone }</td>
							<td><fmt:formatDate value="${ emp.empEnrollDate }" pattern="yyyy년MM월dd일"/></td>				
							<td>
								<c:if test="${ emp.status == 0}">관리자
								</c:if>
								<c:if test="${ emp.status == 1}">지점
								</c:if>
								<c:if test="${ emp.status == 2}">제조사
								</c:if>
							</td>
							<td>
								<c:if test="${emp.status eq 1 && emp.enabled eq 0 }">
									운영중
								</c:if>
								<c:if test="${emp.status eq 1 && emp.enabled eq 1 }">
									<button type="button" onclick="vitalEMP('${emp.empId}');">매장 활성화</button>
								</c:if>
								<c:if test="${emp.status eq 2 && emp.enabled eq 0 }">
									거래중
								</c:if>
								<c:if test="${emp.status eq 2 && emp.enabled eq 1 }">
									<button type="button" onclick="vitalEMP('${emp.empId}');">거래 활성화</button>
								</c:if>
							</td>		
						</tr>
						</c:if>
						</c:forEach>
						</c:if>
						<!-- 상품이 없을 경우 -->
						<c:if test="${ empty list }">
							<tr>
								<td colspan="6">목록이 존재하지 않습니다.</td>
							</tr>
						</c:if>	
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
<script>
function vitalEMP(empId){

	location.href="${pageContext.request.contextPath}/ERP/vitalEMP.do?empId="+empId;

}

</script>
</body>
</html>