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

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<!-- 호근 헤더 처리-->
<title>emp게시판</title>
<style>
.review-modal{
	display:none;
	position:fixed; 
	width:100%; height:100%;
	top:0; left:0; 
	background:rgba(0,0,0,0.3);
	z-index: 1001;
}

.review-modal-section{
	position:fixed;
	top:50%; left:50%;
	transform: translate(-50%,-50%);
	background:white;
	min-width: 170px;
	width: 50%;
	border-radius: 25px;
}

.modal-close{
	display:block;
	position:absolute;
	width:30px; height:30px;
	border-radius:50%; 
	border: 3px solid #000;
	text-align:center; 
	line-height: 30px;
	text-decoration:none;
	color:#000; font-size:20px; 
	font-weight: bold;
	right:10px; top:10px;
}

.review-modal-head{
	padding: 1%; 
	background-color : gold;
	border: 1px solid #000;
	min-height: 45px;
	border-radius: 25px 25px 0px 0px;
	
}
.review-modal-body{
	padding: 3%;
}
.review-modal-footer{
	padding: 1%;
	text-align: right;
}
[name=score]{
	display: none;
}
.modal-submit{
	margin-right: 3%;
}
.modal-cancel{
}
.score-img{
	height: 20px;
	weith: 20px;
}
.score-img-a{
	display: none;
}
.score-img:hover{
	cursor: pointer;
	background-color: yellow;
}
#review-comments{
	resize: none;
	width: 100%;
}
.changeColor {
background-color: #bff0ff;
}

</style>
<script>

$(function(){

	CKEDITOR.replace("content",{
		filebrowserUploadUrl : "${ pageContext.request.contextPath }/ERP/empBoardimageFileUpload.do"
	});


	$("[name=upFile]").on("change", function(){
		var $valid = $("[name=fileChange]");
		var file = $(this).prop('files')[0];
		//console.log("this = " + $(this).val()); //선택된 파일이 this로 넘어옴
		//console.log(file);
		//console.log($(this).prop('files')); // 0:File, length:1 배열로 파일의 정보 넘어옴
		var $label = $(this).next(".custom-file-label");

		if(file == undefined){
			$label.html("파일을 선택해 주세요");
			$valid.val(0);	
		}else{
			$label.html(file.name);
			$valid.val(1);
		}
			
	});
		
		

		$('#category_').change(function() {
			var state = $('#category_ option:selected').val();
		
			if ( state == 'req' ) {
				//ajax 
				$("#review-modal").fadeIn(300);

				$.ajax({
					url: "${ pageContext.request.contextPath}/ERP/productList.do",
					method:"get",
					dataType: "json",
					success: function(data){
						/* console.log(data); */
						displayProductList(data);
					},
					error: function(xhr, status, err){
						console.log(xhr);
						console.log(status);
						console.log(err);
					}

				});
			} else {
				$('.productLayer').hide();
			}
		});

	$("#reqButton").click(function(){
		console.log("reqButton");
		var $frm = $("#requestStockFrm");
		var $confirm = confirm("재고 요청을 하시겠습니까?");
		if($confirm == true){
			$frm.submit();		
		}else{
			alert("취소되었습니다.");
			closeReviewModal();
		}	
		
	});
		
				
});


function displayProductList(data){
  console.log(data.productList);
	var $productList = $("#productList");
	var html = '<select class="form-control" name="productNo" id="productNo_">';		
	   
	var p = data.productList;
	if( p.length > 0 ){
		for(var i in p){
			/* console.log(p); */
			var m = p[i];
			html += "<option value="+ m.productNo+">" + m.productName+ "</option>";
					
		} 
	}
	html += "</select>"
	html += '<input type="number" name="amount" placeholder="상품 수량을 입력하세요" />';
	$productList.html(html);

	
}

function closeReviewModal(){
	$("#review-modal").fadeOut(300);

}


function revoke(){
	var reCofrim = confirm("정말로 취소하시겠습니까?");
	if(reCofrim)
		history.go(-1);
}


$('#category_').change(function() {
	var state = $('#category_ option:selected').val();
	if ( state == 'req' ) {
		console.log("??");
		$("#review-modal").fadeIn(300)
	} else {
		$('.productLayer').hide();
	}
});

	
	
</script>
<jsp:include page="/WEB-INF/views/common/headerE.jsp" />


<div class="container">
	<div id="board-container" class="mx-auto text-center">
		<div>
		<form action="${ pageContext.request.contextPath }/ERP/empBoardCkUpdate.do"
		  method="POST"
		  id="erpBoardFrm"
		  enctype="multipart/form-data">
		 
			<input type="text" class="form-control" placeholder="번호" name="boardNo" id="boardNo" value="${empBoard.boardNo }"  readonly>
		   <div class="form-group">
			   	<select class="form-control" name="category" id="category_">
				  <option value="ntc" selected="${empBoard.category eq 'ntc' ?'selected' : '' }">공지</option>
				  <option value="req" selected="${empBoard.category eq 'req' ?'selected' : '' }">요청</option>
				  <option value="adv" selected="${empBoard.category eq 'adv' ?'selected' : '' }">홍보</option>
				  <option value="def" selected="${empBoard.category eq 'def' ?'selected' : '' }">일반</option>
				  <option value="evt" selected="${empBoard.category eq 'evt' ?'selected' : '' }">이벤트</option>
				</select>
		   </div>
		   <div class="product" id="productList"></div>
			<c:if test="${ empBoard.category eq 'req' }">
				<input type="text" name="productName" id="productName_" value="${ empBoard.productName }" />
				<input type="text" name="stock" id="stock_" value="${ empBoard.amount }" />
			</c:if>
			<input type="text" class="form-control" placeholder="제목" name="title" id="title"  value="${empBoard.title }" >
			<input type="text" class="form-control" name="empName" value="${ empBoard.empName }" readonly>
			 <div class="form-group">
				<c:forEach items="${ empBoard.empBoardImageList }" var="empBoard" varStatus="vs">	
					  <div class="custom-file">
					    <input type="file" class="custom-file-input" name="upFile" id="upFile${ vs.count}" >
					    <label class="custom-file-label" for="upFile${ vs.count}">첨부파일 - ${ empBoard.originalFilename != null ? empBoard.originalFilename : "파일명" }</label>
					  </div>
				</c:forEach>
				 <input type="hidden" name="fileChange" value="0" />
			</div>
			 <textarea class="form-control" name="content" 
		    		  placeholder="내용" >
		    		  ${ empBoard.content != null  ? empBoard.content : '내용'}
		     </textarea>   
		    <div class="button-gruop">
			 	<input type="submit"  value="수정하기"/>
			 	<input type="button"  value="취소" onclick="revoke();"/>
			 </div>
	 </form>	
			 </div>
		 
		</div>
	 </div>
 <!--호근 푸터 처리  -->
<jsp:include page="/WEB-INF/views/common/footerE.jsp" />