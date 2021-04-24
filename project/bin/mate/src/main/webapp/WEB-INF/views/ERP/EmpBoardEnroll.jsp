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
				var file = $(this).prop('files')[0];
				//console.log("this = " + $(this).val()); //선택된 파일이 this로 넘어옴
				//console.log(file);
				//console.log($(this).prop('files')); // 0:File, length:1 배열로 파일의 정보 넘어옴
				var $label = $(this).next(".custom-file-label");

				if(file == undefined){
					$label.html("파일을 선택하세요");		
				}else{
					$label.html(file.name);
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


		<form action="${ pageContext.request.contextPath }/ERP/empBoardCkEnroll.do"
			  method="POST"
			  id="erpBoardFrm"
			  enctype="multipart/form-data">
			   <div class="form-group">
			   	<input type="text" name="title"  id="title_" />
			   	<input type="hidden" name="empId"  id="empId_" value="${loginEmp.empId }" readOnly/>
			   	<input type="hidden" name="empName"  id="empName" value="${loginEmp.empName}" readOnly/>
			   </div>
			   <div class="form-group">
			   	<select class="form-control" name="category" id="category_">
				  <option selected="selected" disabled>카테고리를 선택하세요</option>
				  <option value="ntc">공지</option>
				  <option value="req">요청</option>
				  <option value="adv">홍보</option>
				  <option value="def">일반</option>
				  <option value="evt">이벤트</option>
				</select>
			   </div>
			   <div class="product" id="productList"></div>
			  <div class="custom-file">
			  	<input type="file" class="custom-file-input" name="upFile" id="upFile1">
     			<label class="custom-file-label" for="upFile1">파일을 선택하세요</label>
			  </div>
			   <div class="custom-file">
			     <input type="file" class="custom-file-input" name="upFile" id="upFile1">
			     <label class="custom-file-label" for="upFile1">파일을 선택하세요</label>
			   </div>
			  <div class="form-group">
			  	<textarea name="content" id="content_">
			  	</textarea>
			  </div>
				
			 <div class="button-gruop">
			 	<input type="submit"  value="등록하기"/>
			 	<input type="button"  value="취소" onclick="revoke();"/>
			 </div>
		</form>

 <!--호근 푸터 처리  -->
<jsp:include page="/WEB-INF/views/common/footerE.jsp" />