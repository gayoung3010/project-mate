<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<script>
$(function(){
	$(".guide").hide();
		
		$("#phone_").blur(function(){
			var $this = $(this);
			var $phoneCheck = parseInt("${ num }");
			console.log($this.val());
			console.log($phoneCheck);
			var $ok = $(".guide.ok");
			var $error = $(".guide.error");
		
			if($this.val() == $phoneCheck){
				$ok.show();
				$error.hide();
		
			}else{
				$error.show();
				$ok.hide();
			}
				
		});

});

var submitAction = function() {
	/* do something with Error */
    return false;
};
$('form').bind('submit', submitAction);

function closed(){	
	window.close();
}

</script>
</head>
<body>

<!-- 휴대폰 인증관련 -->
<form id="register-form"
					action="#" role="form" >
	<h3 class="heading-desc">핸드폰인증</h3>
	<div class="form-group">
		<input type="text" name="phone" id="phone_" tabindex="1" class="form-control" placeholder="인증번호를 입력해주세요" value="">
		
	</div>
	<div class="form-group">
		<div class="row">
			<div class="col-sm-6 col-sm-offset-3">
				<input type="submit"  class="btn btn-lg btn-block purple-bg" value="인증하기"/>
				 <input type="button" class="btn btn-lg btn-block purple-bg" value="창닫기" >
			</div>
		</div>
	</div>			
</form>
			 
</body>
</html>