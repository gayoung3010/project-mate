<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerS.jsp">
	<jsp:param value="MATE-멤버 관리" name="headTitle"/>
</jsp:include>

<style>
div#search-member_id {
	display: inline-block;
}

div#search-member_name {
	display: none;
}

div#search-gender {
	display: none;
}
</style>
<c:if test="${ searchType == null }">
	<style>
div#search-member_id {
	display: inline-block;
}

div#search-member_name {
	display: none;
}

div#search-gender {
	display: none;
}
</style>
</c:if>
<c:if test="${ searchType == 'member_id' }">
	<style>
div#search-member_id {
	display: inline-block;
}

div#search-member_name {
	display: none;
}

div#search-gender {
	display: none;
}
</style>
</c:if>
<c:if test="${ searchType == 'member_name' }">
	<style>
div#search-member_id {
	display: none;
}

div#search-member_name {
	display: inline-block;
}

div#search-gender {
	display: none;
}
</style>
</c:if>
<c:if test="${ searchType == 'gender' }">
	<style>
div#search-title {
	display: none;
}

div#search-emp_name {
	display: none;
}

div#search-category {
	display: inline-block;
}


</style>
</c:if>
<style>


th {
	position: sticky;
	top: 0;
	background-color: white;
}

.search-select {
	background: none;
	border: none;
	min-width: 170px;
	max-width: 170px;
	min-height: 100%;
	max-height: 100%;
	font-size: 50px;
	border-bottom: 10px solid rgba(54, 54, 54, 0.6);
	border-radius: 0 0 0 10%;
	color: rgba(54, 54, 54, 0.8);
	font-family: 'CookieRunOTF-Bold';
	margin: 0;
	padding:0;
}

.search-input{
	background: none;
	border: none;
	min-width: 500px;
	max-width: 500px;
	min-height: 100%;
	max-height: 100%;
	font-size: 50px;
	border-bottom: 10px solid rgba(54, 54, 54, 0.6);
	border-radius: 0 0 10% 0;
	color: rgba(54, 54, 54, 0.8);
	font-family: 'CookieRunOTF-Bold';
	margin: 0;
	padding:0;
}
.search-sec{
	width: 100%;
	text-align: left;
}

.chk-label{
	background-color: rgba(54,54,54,0.2);
	color: white;
	margin: 0;
	height: 60px;
	text-align: center;
}
.chk-label>*{
	top:auto;
	bottom: auto;
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
.chk-label span{
	position: relative;
    top: 30%;
}
.chk-label[type=submit]{
	background-color: rgba(54,54,54,0.8);
}
.chk-label[type=submit]:active{
	background-color: rgb(13,58,97, 0.8);
}
</style>
<title>회원관리</title>
<script>
	$(function() {

		$("#searchType").change(
				function() {
					console.log($(this).val());

					var type = $(this).val();
					console.log(type);
					$(".search-type-div").hide().filter("#search-" + type).css(
							"display", "inline-block");

				});

	});

	function memberDelete(memberId) {

		var $confirm = confirm("정말로 삭제 하시겠습니까?");
		if ($confirm) {
			console.log(memberId);
			$
					.ajax({
						url : "${ pageContext.request.contextPath}/member/adminMemberDelete.do",
						method : 'post',
						dataType : "json",
						data : {
							"memberId" : memberId
						},
						success : function(data) {
							var result = data.result;
							if (result == "1") {
								alert("회원 삭제를 성공하였습니다.");
								location.href = "${ pageContext.request.contextPath }/member/MemberList.do";
							}
						},
						error : function(xhr, status, err) {
							console.log(xhr);
							console.log(status);
							console.log(err);
						}

					});

		}

	}

	<c:if test="${searchType eq 'gender'}">
	$(function() {
		$("#search-member_id").css("display", "none");
		$("#search-member_name").css("display", "none");
		$("#search-gender").css("display", "inline-block");

	});
	</c:if>
</script>

<div class="search-div">
	<section class="search-sec">
		<select class="search-select" name="searchType" id="searchType">
			<option value="member_id"
				${ searchType == 'member_id' ? 'selected' : ''}>아이디</option>
			<option value="member_name"
				${ searchType == 'member_name' ? 'selected' : ''}>이름</option>
			<option value="gender" ${ searchType == 'gender' ? 'selected' : ''}>성별</option>
		</select>


		<div id="search-member_id" class="search-type-div">
			<form
				action="${ pageContext.request.contextPath}/member/MemberList.do"
				method="get">
				<input type="hidden" name="searchType" value="member_id" /> <input
					type="text" name="searchKeyword" class="search-input"
					placeholder="입력하세요!"
					value="${ searchType eq 'member_id' ? searchKeyword : ''}" />
				<button type="submit" class="btn chk-label">검색</button>
			</form>
		</div>
		<div id="search-member_name" class="search-type-div">
			<form
				action="${ pageContext.request.contextPath}/member/MemberList.do"
				method="get">
				<input type="hidden" name="searchType" value="member_name" /> <input
					type="text" name="searchKeyword" class="search-input"
					placeholder="입력하세요!"
					value="${ searchType eq 'member_name' ? searchKeyword : ''}" />
				<button type="submit" class="btn chk-label">검색</button>
			</form>
		</div>
		<div id="search-gender" class="search-type-div">
			<form
				action="${ pageContext.request.contextPath}/member/MemberList.do"
				method="get">
				<input type="hidden" name="searchType" value="gender" /> 
				<div class="btn-group-toggle btn-group" data-toggle="buttons">
					<label for="gender-M" class="btn chk-label ${ searchKeyword eq 'M' ? 'active' : ''}">
						<input id="gender-M" type="radio" name="searchKeyword" value="M" ${ searchKeyword eq 'M' ? "checked" : ""}>
						<span>남자</span>
					</label>
					<label for="gender-F" class="btn chk-label ${ searchKeyword eq 'F' ? 'active' : ''}">
						<input id="gender-F"  type="radio" name="searchKeyword" value="F" ${ searchKeyword eq 'F' ? "checked" : ""}>
						<span>여자</span>
					</label>
				</div>
				<button type="submit" class="btn chk-label">검색</button>
			</form>
		</div>
	</section>
</div>

<div class="content-div">
	<table id="tbl-board" class="table table-striped table-hover">
		<tr>
			<th>회원 아이디</th>
			<th>회원 이름</th>
			<th>성별</th>
			<th>핸드폰 번호</th>
			<th>가입일</th>
			<th>삭제</th>
		</tr>
		<c:if test="${ not empty memberList }">
			<c:forEach items="${ memberList }" var="member">
				<tr data-no="${ member.memberId }">
					<td>${ member.memberId }</td>
					<td>${ member.memberName }</td>
					<td>${ member.gender eq 'M' ? '남자' : '여자' }</td>
					<td>${ member.phone }</td>
					<td><fmt:formatDate value="${ member.enrollDate }"
							pattern="yyyy-MM-dd" /></td>
					<td><button type="button" value="회원삭제"
							onclick="memberDelete('${ member.memberId }');">회원삭제</button></td>
				</tr>
			</c:forEach>
		</c:if>
	</table>
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



<jsp:include page="/WEB-INF/views/common/footerS.jsp" />