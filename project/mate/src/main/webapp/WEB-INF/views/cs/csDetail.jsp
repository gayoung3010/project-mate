<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/common/headerS.jsp">
	<jsp:param value="MATE-고객센터-${ cs.title }" name="headTitle" />
</jsp:include>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<style>
div#board-container {
	width: 400px;
}

input, button, textarea {
	margin-bottom: 15px;
}

button {
	overflow: hidden;
}
/* 부트스트랩 : 파일라벨명 정렬*/
div#board-container label.custom-file-label {
	text-align: left;
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
.replyList-container{
	max-height: 331px;
	overflow-y: scroll;
}
.reply-th{
	position:sticky; 
	top:0; 
	background:rgb(13,58,97); 
	color:white;
}
</style>

<div class="search-div">
	<c:if test="${ loginMember.memberId eq cs.memberId || loginMember.memberId eq 'admin' }">
		<button type="button" class="btn chk-label"
			onclick="deleteCs(${ cs.csNo });">삭제</button>
	</c:if>
</div>
<div class="content-div">

	<div id="cs-container" class="mx-auto text-center">
		<input type="text" class="form-control" placeholder="제목" name="csTitle"
			id="title" value="${ cs.title }" readonly required> <input
			type="text" class="form-control" name="memberId"
			value="${ cs.memberId }" readonly required>
	
		<c:if test="${ not empty csImage }">
			<button type="button" class="btn btn-outline-success btn-block"
				onclick="fileDownload(${ cs.csNo });">첨부파일 - ${ csImage.originalFilename }
			</button>
		</c:if>

		<textarea class="form-control" name="content" placeholder="내용" readonly
			required>${ cs.content }</textarea>
		<input type="datetime-local" class="form-control" name="regDate"
			value='<fmt:formatDate value="${ cs.regDate }" pattern="yyyy-MM-dd'T'HH:mm"/>'
			readonly>
	</div>

	<form action="${ pageContext.request.contextPath }/cs/deleteCs.do"
		method="POST" id="deleteFrm">
		<input type="hidden" name="csNo" id="hidden-no" />
	</form>
	<div></div>
	<hr />
	<div class="replyList-container"></div>
	<div id="reply-container">
		<form action="${ pageContext.request.contextPath }/cs/csReplyEnroll.do"
			method="POST">
			<div class="form-group">
				<input type="hidden" name="memberId"
					value="${ loginMember.memberId != null ? loginMember.memberId : 'ㅋㅋㅋ'}" />
			</div>
			<div class="form-group">
				<input type="hidden" name="csNo" id="csNo" value="${ cs.csNo }" />
			</div>
			<div class="form-group">
				<textarea rows="3" cols="30" id="content_" name="content"
					class="form-control" aria-describedby="basic-addon1"
					placeholder="댓글을 입력하세요." required></textarea>
			</div>
			<div class="button-group">
				<input type="submit" class="btn btn-primary" value="등록하기" />
			</div>
		</form>
	</div>
</div>



<script>
	function fileDownload(csNo){
		location.href = "${ pageContext.request.contextPath }/cs/fileDownload.do?csNo=" + csNo;
	}
	
	function deleteCs(csNo){
		if(confirm("정말 삭제 하시겠습니까?") == false) return;
		$("#hidden-no").val(csNo);
		$("#deleteFrm").submit();
	}
	$(document).ready(function(){
	    csReplyList(); 
	});	
	function csReplyList(){
	    var csNo = $("#csNo").val();
	    var loginMember = '${loginMember.memberId}';
	     console.log(csNo);
	    $.ajax({
	        url : "${ pageContext.request.contextPath}/cs/csReplyList.do",
	        method: 'get',
	        dataType: 'json',
	        contentType: "application/json; charset=utf-8;",
	        data :  {"csNo" :csNo},
	        success : function(data){
	            var html ='<table id="tbl-cs-reply" class="table table-striped table-hover">'
			        	+'<tr>'
						+'<th class="reply-th" style="width: 5%;">번호</th>'
						+'<th class="reply-th" style="width: 60%;">답변</th>'
						+'<th class="reply-th" style="width: 20%;">작성일</th>'
						+'<th class="reply-th" style="width: 10%;">작성자</th>'
						+'<th class="reply-th" style="width: 5%;"></th>'
						+'</tr>'; 
	      		 console.log(data);
	      		 var vs = 1;
	      		 var thAdmin = 'style="background-color: rgba(164, 80, 68, 0.2);';
	            $.each(data, function(key, value){   
	            		html += '<tr ';
	            		if(value.memberId == 'admin') html += thAdmin;
	            		html += ' data-no="'+ value.csNo+'" >';         
		       		 	html += '<th>'+ vs++ +'</th>';
		            	html += "<th>" + value.content + "</th>";
		            	html += '<th>'+ moment(value.regDate).format("YY/MM/DD HH:mm:ss")+'</th>';
		            	html += '<th>'+ value.memberId +'</th>'; 
		            	
		     			if(value.memberId == '${loginMember.memberId}')
			     			html += '<td><input type="button" value="삭제" onclick="csReplyDelete('+value.csReplyNo+');"/></td>';
			     		else html += '<td></td>';
		     			html += '</tr>';
	            });
	            html += '</table>';
	          $(".replyList-container").html(html);  
	        
	        }
	    });
	}

	function csReplyDelete(csReplyNo) {
		var csReplyNo = csReplyNo;

		$.ajax({
			url : "${ pageContext.request.contextPath }/cs/csReplyDelete.do",
			method : "POST",
			dataType: 'json',
			data : {
				"csReplyNo" : csReplyNo
			},
			success : function(data){
				console.log(data);
				if(data.isAvailable) {
					alert("삭제 되었습니다.");
					location.reload();
				}
			},
			error : function(xhr, status ,err){
				console.log(xhr);
				console.log(status);
				console.log(err);
			}	
		});
	}
	$(function(){
		
	    $("th").parent().css("background", "rgba(164, 80, 68, 0.2)");
	});
</script>

