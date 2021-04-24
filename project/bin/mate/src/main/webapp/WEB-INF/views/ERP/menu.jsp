<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<link rel="stylesheet"
	href="${ pageContext.request.contextPath }/resources/css/loginForm.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
	integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
	integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
	crossorigin="anonymous"></script>
<style>

</style>
<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>

<div class="container">
	<div id="buy" class="tab-pane fade active show in">
		<div class="col-md-15">
		    <div class="form-area">
			    <div class="text-center" style="width: 20%; height: 50%; float:none; margin:10 auto">
			    	<table id="purchaseLog-table" class="table table-bordered ">
			    		<tr>
					    	<th	>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }'">
								  <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>쇼핑몰
								</button>
					    	</th>
					    	<th>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }/ERP/erpMain.do';">
								  <span class="glyphicon glyphicon-wrench" aria-hidden="true"></span>ERP
								</button>
					    	</th>
			    		</tr>
		    		</table>
			    </div>
    		</div>
		</div>
	</div>
</div>
     
<jsp:include page="/WEB-INF/views/common/footerS.jsp"/>		
		
