<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<!DOCTYPE html>
<html lang="ko">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="${ pageContext.request.contextPath }/resources/ckeditor/ckeditor.js"></script>
<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<style>
.btn-custom {
  background-color: hsl(0, 0%, 16%) !important;
  background-repeat: repeat-x;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#5b5b5b", endColorstr="#282828");
  background-image: -khtml-gradient(linear, left top, left bottom, from(#5b5b5b), to(#282828));
  background-image: -moz-linear-gradient(top, #5b5b5b, #282828);
  background-image: -ms-linear-gradient(top, #5b5b5b, #282828);
  background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #5b5b5b), color-stop(100%, #282828));
  background-image: -webkit-linear-gradient(top, #5b5b5b, #282828);
  background-image: -o-linear-gradient(top, #5b5b5b, #282828);
  background-image: linear-gradient(#5b5b5b, #282828);
  border-color: #282828 #282828 hsl(0, 0%, 11%);
  color: #fff !important;
  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.33);
  -webkit-font-smoothing: antialiased;
}
</style>
<!-- 호근 헤더 처리-->
<title>게시판</title>
<script>
$(document).ready(function(){
    replyList(); //페이지 로딩시 댓글 목록 출력 
});

	function replyList(){
	    var boardNo = $("#boardNo").val();
	     
	     console.log(boardNo);
	    $.ajax({
	        url : "${ pageContext.request.contextPath}/ERP/empReplyList.do",
	        method: 'get',
	        dataType: 'json',
	        contentType: "application/json; charset=utf-8;",
	        data :  {"boardNo" :boardNo},
	        success : function(data){
	            var html =''; 
	            var loginEmp = '${loginEmp.empId}';
	         /*    console.log(data); */
           	   var html ='<table id="tbl-cs-reply" class="table table-striped table-hover">'
		        	+'<tr>'
					+'<th>번호</th>'
					+'<th>답변</th>'
					+'<th>작성일</th>'
					+'<th>작성자</th>'
			    if( loginEmp == '${loginEmp.empId}' || loginEmp == 'admin'){ 
					html  += '<th>수정 / 삭제</th>';

				}
					+'</tr>'; 
      			 console.log(data);
		      		 var vs = 1;
		      		 
		            $.each(data, function(key, value){   
		            		html +=  '<tr data-no="'+ value.csNo+'" >';         
			       		 	html += '<th>'+ vs++ +'</th>';
			            	html += "<th>" + value.content + "</th>";
			            	html += '<th>'+ moment(value.regDate).format("YYYY-MM-DD")+'</th>';
			            	html += '<th>'+ value.empName +'</th>'; 
			          	  if( loginEmp == value.empId || loginEmp =='admin'){
			            	html += '<th><a onclick="replyUpdate('+ value.boardReplyNo +',\''+ value.content + '\');" class="btn btn-primary"> 수정 </a>';
			            	html += '<a onclick="replyDelete('+ value.boardReplyNo +');" class="btn btn-default"> 삭제 </a> </div><th>';
				     
				            }	
			            	html += '</tr>';
		            });
		       
	            $(".replyList").html(html);
	        }
	    });
	}

	
		function replyUpdate(boardReplyNo, content){
					var boardReplyNo = boardReplyNo;
					var content = content;	
					var html = "";
					console.log(boardReplyNo);
					console.log(content);
					html += '<div class="input-group">';
					html += '<input type="text" class="form-control" name="replyContent_'+boardReplyNo+'" value="'+content+'"/>';
					html += '<span class="input-group-btn"><button class="btn btn-default" type="button" onclick="replyUpdateReal('+boardReplyNo+');">수정</button> </span>';
					html += '</div>';
				    
				    $('.replyContent'+ boardReplyNo ).html(html);


		}

		function replyUpdateReal(boardReplyNo){
				console.log(boardReplyNo);
				var updateContent = $('[name=replyContent_'+boardReplyNo+']').val();
				console.log(updateContent);
				$.ajax({
					url : "${ pageContext.request.contextPath}/ERP/replyUpdateReal.do",
					method : "POST",
					dataType : "json",
					data : {
						"boardReplyNo" : boardReplyNo,
						"content" : updateContent
					},
					success : function(data){
						console.log(data);
						if(data.isAvailable){
							replyList(boardNo);
						}
					},
					error : function(xhr, status, err){
						console.log(xhr);
						console.log(status);
						console.log(err);
					}
				});
		};

	function replyDelete(boardReplyNo) {
		var boardReplyNo = boardReplyNo;
	/* 	console.log(boardReplyNo); */

		$.ajax({
			url : "${ pageContext.request.contextPath }/ERP/erpBoardReply.do",
			method : "POST",
			dataType: 'json',
			data : {
				"boardReplyNo" : boardReplyNo
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


	function fileDownload(no){
		location.href= "${ pageContext.request.contextPath}/ERP/fileDownload.do?no=" + no;
	};

	function StockTranslate(productNo, amount, empId){
		var $transEmpId = '${ loginEmp.empId}';
		var $transStock = ('${ loginEmpStock.stock}' >= amount) ? amount : '${ loginEmpStock.stock}' ;
		var $boardNo = '${ empBoard.boardNo}';
		var $enabled = '${ empBoard.enabled }';
		var stock = {
				productNo : productNo,
				amount : amount,
				empId : empId,
				transEmpId : $transEmpId, 
				transStock : $transStock,
				boardNo : $boardNo
			};


		console.log(stock);
		
		if(stock.amount > stock.transStock){
			alert("수량이 적습니다.");
			return;
		}

		if($enabled == 1){
			alert("이미 처리 되었습니다.");
			return;
		}
		
 	$.ajax({

			 url : "${ pageContext.request.contextPath }/ERP/StockTranslate",
			 method : "get",
			 dataType : "json",
			 data : stock,
			 success : function(data){
					console.log(data);
					var result = data.isAvailable;
					if( result == true){                
		                alert("재고 처리를 했습니다.");
		                                           
		            } 
			},
			error : function(xhr, err, status){
					console.log(xhr, err, status);
			}

		}); 
		
	}
	
</script>
<jsp:include page="/WEB-INF/views/common/headerE.jsp" />
<div class="container">
	<div id="board-container" class="mx-auto text-center">
		<input type="text" class="form-control" placeholder="번호" name="boardNo" id="boardNo" value="${empBoard.boardNo }"  readonly>
		<input type="text" class="form-control" placeholder="카테고리" name="category" id="category"    value="${empBoard.category  == 'ntc' ? '공지사항'  : empBoard.category eq 'req' ? '요청' : empBoard.category eq 'adv' ? '광고' : empBoard.category eq 'def' ? '일반' : empBoard.category eq 'evt' ? '이벤트' : ''}"  readonly>
		
		<input type="text" class="form-control" placeholder="제목" name="title" id="title"  value="${empBoard.empName }"  readonly>
		<input type="text" class="form-control" name="memberId" value="${ empBoard.empId }" readonly>
		 <div class="form-group">
			<c:forEach items="${ empBoard.empBoardImageList }" var="empBoard">	
				<button type="button" 
						class="btn btn-outline-success btn-block"
						onclick="fileDownload(${ empBoard.boardImageNo });">
				 	첨부파일 - ${ empBoard.originalFilename != null ? empBoard.originalFilename : "파일명" }
				</button>
			</c:forEach>
		 </div>
	    <div class="row" name="content" >
	    <c:if test="${ empBoard.category eq 'req' }">
	     <div class="form-label-group col-sm-6">
			<input type="text"  class="form-control" style="width:200px; height:50px;  float:right;" name="productName" id="productName_" value="${ empBoard.productName }" readonly/>
		</div>	
	     <div class="form-label-group col-sm-6">
			<input type="text"  class="form-control"style="width:200px; height:50px;"name="stock" id="stock_" value="${ empBoard.amount }" readonly/>
		</div>
		</c:if>
		<br />
	    		  ${ empBoard.content != null  ? empBoard.content : '내용'}
	    </div>
		</div>
		<!-- 요청 상품에 재고가 있을 때만  -->
		<c:if test="${loginEmpStock.empId eq loginEmp.empId && empBoard.category eq 'req' }">
				<a href="#" class="btn btn-custom" role="button">${ loginEmpStock.empName }</a>
				<a href="#" class="btn btn-custom" role="button">${ loginEmpStock.productName }</a>
				<a href="#" class="btn btn-custom" role="button">재고 수  : ${ loginEmpStock.stock }</a>
				<button type="button" class="btn btn-warning" onclick="StockTranslate('${ empBoard.productNo }' ,'${ empBoard.amount}', '${empBoard.empId }');"> 보내기 </button>
		</c:if>
		
		<c:if test="${ empBoard.empId eq loginEmp.empId }" >		
			<button class="btn btn-default" type="button" onclick="return goEmpBoardUpdate('${ empBoard.boardNo}')">수정</button>
			<button class="btn btn-default" type="button"  onclick="return delBoard('${ empBoard.boardNo}');">삭제</button>
		</c:if>
		<!--댓글 폼 -->
		<div id="reply-container">
			<form action="${ pageContext.request.contextPath }/ERP/empReplyEnroll.do" method="POST">
				<div class="form-group">				
					<input type="hidden" name="empId" value="${ loginEmp.empId != null ? loginEmp.empId : '왜널인데?'}" />
				</div>
				<div class="form-group">
					<input type="hidden" name="boardNo" value="${ empBoard.boardNo }" />
				</div>
				<div class="form-group">
					<textarea rows = "3" cols = "30" id = "content_" name = "content" class="form-control" aria-describedby="basic-addon1" placeholder="댓글을 입력하세요."></textarea>
				</div>
				<div class="form-label-group col-sm-6">
					<input type="submit" class="btn btn-primary" value="등록하기" />
				</div>
			</form>
			 <div class="replyList" col="5"></div>
		</div>
</div>
<script>

function goEmpBoardList(){                
    location.href = "${ pageContext.request.contextPath }/ERP/EmpBoardList.do";
}
	function delBoard(boardNo){
		console.log(boardNo);
		var $boardNo = boardNo;

		$.ajax({
			url : "${ pageContext.request.contextPath}/ERP/boardDelete.do",
			method:"POST",
			dataType : "json",
			data : {
				"boardNo" : $boardNo},
			cache   : false,
            async   : true,
			success : function(data) {
				console.log(data);
				var result = data.result;
				if(result == "1"){                
	                alert("게시글 삭제를 성공하였습니다.");                             
	            } else {                
	                alert("게시글 삭제를 실패하였습니다.");    
	                return;
	            }
					
			},
			error : function(xhr, status, err){
				console.log(xhr);
				console.log(status);
				console.log(err);
			}
			
		});

	}

		 function goEmpBoardUpdate(boardNo){
		        
		        var boardNo =  boardNo;
		        console.log(boardNo);
		        location.href = "${ pageContext.request.contextPath}/ERP/empBoardUpdate.do?boardNo="+ boardNo;
		   }
</script>
		
<jsp:include page="/WEB-INF/views/common/footerE.jsp" />