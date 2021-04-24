<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<!DOCTYPE html>
<html lang="ko">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">

<title>게시판 목록</title>
<c:if test="${ searchType == null }">
<style>
 	div#search-title {display:inline-block;}
    div#search-emp_name{display:none;} 
    div#search-category{display:none;}
</style>
</c:if>
<c:if test="${ searchType == 'title' }">
<style>
 	div#search-title {display:inline-block;}
    div#search-emp_name{display:none;} 
    div#search-category{display:none;}
</style>
</c:if>
<c:if test="${ searchType == 'emp_name' }">
<style>
 	div#search-title {display:none;}
    div#search-emp_name{display:inline-block;} 
    div#search-category{display:none;}
</style>
</c:if>
<c:if test="${ searchType == 'category' }">
<style>
 	div#search-title {display:none;}
    div#search-emp_name{display:none;} 
    div#search-category{display:inline-block;}
</style>
</c:if>

<script>
$(function(){
	$("tr[data-no]").click(function(){
		var no = $(this).attr("data-no");
		console.log(no);
		location.href = "${ pageContext.request.contextPath }/ERP/EmpBoardDetail.do?no=" + no;
		});
	$("#searchType").change(function(){
		console.log($(this).val());
		
		var type = $(this).val();
		console.log(type);
		$(".search-type").hide().filter("#search-"+type).css("display","inline-block");
		
		
	});
   		
});

		function empBoardEnroll(){
			location.href = "${pageContext.request.contextPath}/ERP/EmpBoardEnroll.do";
		}


</script>
<jsp:include page="/WEB-INF/views/common/headerE.jsp">
	<jsp:param value="MATE-ERP" name="headTitle"/>
</jsp:include>

	<div class="nevigate">
	<input type="button" value="글쓰기" id="btn-add" class="btn btn-outline-success" onclick="empBoardEnroll();"/>
	<table id="tbl-board" class="table table-striped table-hover">
         <tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>카테고리</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
		<c:if test="${ not empty empBoardList }">
		<c:forEach items="${ empBoardList }" var="board">
		<tr data-no="${ board.boardNo }">
				<td>${ board.boardNo }</td> 
				<c:if test="${ board.enabled == 0 }">
					<td id="title"> ${ board.title }</td>
						<td>${ board.empName }</td>	
						<td>${ board.category == 'ntc' ? "공지사항"  : board.category eq 'req' ? '요청' : board.category eq 'adv' ? '홍보' : board.category eq 'def' ? '일반' : board.category eq 'evt' ? '이벤트' : ''}</td> 
						<td><fmt:formatDate value="${ board.regDate }" pattern="yyyy-MM-dd"/></td>
						<td>${ board.readCount }</td>
				</c:if>
				<c:if test="${ board.enabled > 0 }">
					<td><del>${ board.title }</del></td>	
					<td><del>${ board.empName }</del></td>	
					<td><del>${ board.category == 'ntc' ? "공지사항"  : board.category eq 'req' ? '요청' : board.category eq 'adv' ? '홍보' : board.category eq 'def' ? '일반' : board.category eq 'evt' ? '이벤트' : ''}</del></td> 
					<td><del><fmt:formatDate value="${ board.regDate }" pattern="yyyy-MM-dd"/></del></td>
					<td><del>${ board.readCount }</del></td>
				</c:if>
		</tr>
		</c:forEach>
		</c:if>
	</table>
	 
	</div>
	<!-- 게시글 검색 -->
		<div class="form-group row justify-content-center">
			<div class="b-select-wrap col-1 row-2" style="padding-right:10px">
				<select class="form-control b-select" data-live-search="true" name="searchType" id="searchType">
					<option value="title" ${ searchType == 'title' ? 'selected' : ''}>제목</option>
					<option value="emp_name" ${ searchType == 'emp_name' ? 'selected' : ''}>작성자</option>
					<option value="category" ${ searchType == 'category' ? 'selected' : ''}>카테고리</option>
			
				</select>
			</div>
		  <div id="search-title" class="search-type">
	            <form action="${ pageContext.request.contextPath}/ERP/EmpBoardList.do" method="get">
	                <input type="hidden" name="searchType" value="title"/>
	               <div class="input-group">
	                <input type="text" class="form-control" name="searchKeyword"  size="25" placeholder="검색할 제목 입력하세요." value="${ searchType eq 'title' ? searchKeyword : ''}" />             
	                <div class="input-group-btn">
	                <button type="submit"  class="btn btn-sm btn-primary"><i class="glyphicon glyphicon-search"></i></button>			
	           		</div>
	           		</div>
	            </form>	
	        </div>
	        <div id="search-emp_name" class="search-type">
	            <form action="${ pageContext.request.contextPath}/ERP/EmpBoardList.do" method="get">
	                <input type="hidden" name="searchType" value="emp_name"/>
	                  <div class="input-group">
	                <input type="text"class="form-control"  name="searchKeyword" size="25" placeholder="작성자 명을 입력하세요." value="${ searchType eq 'emp_name' ? searchKeyword : ''}"/>
	                 <div class="input-group-btn">
	                <button type="submit"  class="btn btn-sm btn-primary"><i class="glyphicon glyphicon-search"></i></button>			
	                </div>
	                </div>
	            </form>	
	        </div>
			<div id="search-category" class="search-type">
            <form class="navbar-form" role="search" action="${ pageContext.request.contextPath}/ERP/EmpBoardList.do" method="get">      
                <input type="hidden" name="searchType" value="category" />
                 <div class="input-group">
                <input type="radio"  name="searchKeyword" value="" ${ searchKeyword eq '' ? "checked" : ""}> 전체 
                <input type="radio"  name="searchKeyword" value="ntc" ${ searchKeyword eq 'ntc' ? "checked" : ""}> 공지사항 
                <input type="radio"  name="searchKeyword" value="req" ${ searchKeyword eq 'req' ? "checked" : ""}> 요청 
                <input type="radio"   name="searchKeyword" value="adv" ${ searchKeyword eq 'adv' ? "checked" : ""}> 광고 
                <input type="radio"  name="searchKeyword" value="def" ${ searchKeyword eq 'def' ? "checked" : ""}> 일반 
               <div class="input-group-btn">
                <button type="submit" class="btn btn-sm btn-primary"><i class="glyphicon glyphicon-search"></i></button>
                </div>
                </div>
            </form>
        	</div>
		</div>
		       	<!-- 페이징 바 -->
        	<div class="row justify-content-center"">
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


<jsp:include page="/WEB-INF/views/common/footerE.jsp" />
