<%@page import="com.kh.mate.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/common/headerS.jsp"/>

<style>
#btn-add{
	position: relative;
}
tr[data-no]{
	cursor: pointer;
}
.notice{
	background-color: blue;
}
.chk-label{
	background-color: rgba(54,54,54,0.2);
	color: white;
	margin: 0;
}
.chk-label:hover{
	background-color: rgba(54,54,54,0.6);
	color: white;
}
.chk-label:active{
	background-color: rgb(164,80,68);
	color: white;
}
.chk-label.active{
	background-color: rgb(164,80,68);
	color: white;
}
</style>
	
<script>

$(function(){
	$("input:checkbox[id='csMyListFrm']").change(function() {
	    	console.log($(this).val());
	    	var checked = $(this);
	    	var memberId = $(this).val();
	    	var $frm = $("#csMyListFrm");
		if(this.checked){
				$frm.submit();
				$("input:checkbox[id='csMyListFrm']").prop("checked", true);
		}else{
			location.href="${ pageContext.request.contextPath}/cs/cs.do";
		}
				
	
	});

});
</script>

<div class="search-div">
	<form id="csMyListFrm" 
    	  action="${pageContext.request.contextPath}/cs/cs.do" 
    	  class="form-inline" 
    	  method="get"> 
    	<div class="btn-group-toggle btn-group" data-toggle="buttons">
	   	  	<label for="csMyListFrm" class="btn chk-label ${ loginMember.memberId eq memberId ? 'active' : '' }">
				<input type="checkbox" name="memberId" id="csMyListFrm" value="${ loginMember.memberId != null ? loginMember.memberId : '' }" ${ loginMember.memberId eq memberId ? 'checked' : '' }/>
				내 글 보기
			</label>
			<input type="button" value="글쓰기" id="btn-add" class="btn chk-label" onclick="goInsertCs();"/>
		</div>
    </form>
</div>
<div class="content-div">
	<form id="csDeleteFrm" 
		  	  action="${ pageContext.request.contextPath }/cs/deleteCs.do" 
		  	  method="POST">
		<input type="hidden" name="csNo" />
		</form>
		
	
	<div id="buy" class="tab-pane fade active show in">
			<div class="col-md-15">
			    <div class="form-area">  
					<table id="tbl-cs" class="table table-striped table-hover">
						<thead class="thead-dark">
	<tr>
		<th>번호</th>
		<th>분류</th>
		<th>제목</th>
		<th>작성자</th>
		<th>작성일</th>
		<th>첨부파일</th>	
	</tr>
	</thead>
	 <c:forEach items="${ list }" var="cs">
		<tr class="${ cs.notice eq 1 ? 'notice' : '' }" data-no="${ cs.csNo }">
		<td>${ cs.csNo }</td>
		<td>${ cs.notice == 0 ? '일반 문의' : '공지사항' }</td>
		<td>
		<c:if test="${ cs.isReply eq '0' }">
		${ cs.secret eq 1 ? '----------비밀글 입니다.--------' : cs.title }
		</c:if>
		<c:if test="${ cs.isReply eq '1' }">
			${ cs.secret eq 1 ? '----------비밀글 입니다.--------' : cs.title  } [답변완료]
		</c:if>
		</td>
		<td class="csMemberId">${ cs.memberId }</td>
		<td><fmt:formatDate value="${ cs.regDate }" pattern="yy/MM/dd"/></td>
		<td class="secret" style="display:none;">${ cs.secret }</td>
		<td>
			<c:if test="${ not empty cs.renamedFilename }">
				<img src="${ pageContext.request.contextPath }/resources/images/file.png" style="width : 16px;"/>
			</c:if> 
		</td>
		<c:if test="${ loginMember.memberId eq cs.memberId ||  loginMember.memberId eq 'admin' }">
			<td>
			<button type="button" class="btn btn-outline-secondary" onclick="updateDev(${ dev.no });">삭제</button>
			</td>
		</c:if>
	</tr>
	</c:forEach>
	</table>
	</div>
	</div>
	</div>


		<nav aria-label="..." style="text-align: center;">
			<div class="pageBar">
				<ul class="pagination">
				<c:if test="${not empty pageBar }">
				<c:forEach items="${ pageBar }" var="p">
					<li>
					  	${ p }
					</li>
				</c:forEach>
				</c:if>
				</ul>
			</div>
		</nav>
</div>
	
	

<jsp:include page="/WEB-INF/views/common/footerS.jsp"></jsp:include>
	
  	

<script>
function goInsertCs(){
	location.href = "${pageContext.request.contextPath}/cs/insertCs.do";
}
function deleteCs(csNo){
	if(confirm("정말 삭제하시겠습니까?") == false)
		return;
	var $frm = $("#csDeleteFrm");
	$frm.find("[name=csNo]").val(csNo);
	$frm.submit();
}
$(function(){
	$("tr[data-no]").click(function(){
		var csNo = $(this).attr("data-no");
		var memberId = $(this).find(".csMemberId").text();
		var secret = $(this).find(".secret").text();
		var loginMember = '${ loginMember.memberId}';

		console.log(secret);
		console.log(memberId);
		console.log(loginMember);
	
		if(secret == '1' && loginMember != 'admin' && loginMember != memberId  ){
		
			alert("비밀글 입니다. 본인만 확인 할 수 있다.");
			return;
		}

		location.href = "${ pageContext.request.contextPath }/cs/csDetail.do?csNo=" + csNo; 
	
	
		
	});
});

</script>