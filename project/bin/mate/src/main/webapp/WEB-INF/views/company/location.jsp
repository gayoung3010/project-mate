<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5f16f27e7564ae5efd073c689a6db2a9&libraries=services,clusterer,drawing"></script>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<jsp:include page="/WEB-INF/views/common/headerS.jsp"/>
<style>
#map{
	margin-left: 25%;
}
.companyList-select{
	background: none;
	border:none;
	min-width: 350px;
	max-width: 350px;
	min-height: 70px;
	max-height: 70px;
	font-size: 50px;
	border-bottom: 10px solid rgba(54,54,54,0.6);
	border-radius: 10%;
	color: rgba(54,54,54,0.8);
	font-family: 'CookieRunOTF-Bold';
}
</style>
<div class="search-div">
	<div id="company-div">	
		<select class="companyList-select">
			<option value="" selected disabled>지점 선택</option>
			<c:forEach items="${ mapList }" var="company">
				<option value="${ company.empName }">${ company.empName }</option>
			</c:forEach>
		</select>
		<c:forEach items="${ mapList }" var="company">
			<div class="companyList-div" id="${ company.empName }">
				<input type="hidden" name="companyName" id="${ company.empName }" />
				<input type="hidden" name="companyPhone" value="${ company.phone }" />
				<input type="hidden" name="companyAddress" value="${ company.addr2 }" />
				<input type="hidden" name="companyAddressDetail" value="${ company.addr3 }" />
			</div>
		</c:forEach>
	</div>
</div>
<div class="content-div">
	<div id="map" style="width:500px;height:400px;"></div>
</div>

<script>

	$(".companyList-select").change(function(){
		var name = $(this).val();
		var $div = $("#"+name);
		var phone = $div.find("[name=companyPhone]").val();
		var address = $div.find("[name=companyAddress]").val();
		var addressDetail = $div.find("[name=companyAddressDetail]").val();
		
		var container = document.getElementById('map');
		var options = {
			center: new kakao.maps.LatLng(0,0),
			level: 3
		};

		var map = new kakao.maps.Map(container, options);

		var geocoder = new kakao.maps.services.Geocoder();

		geocoder.addressSearch(address, function(result, status) {

		     if (status === kakao.maps.services.Status.OK) {

		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

		        var marker = new kakao.maps.Marker({
		            map: map,
		            position: coords
		        });

		        var infowindow = new kakao.maps.InfoWindow({
		            content: '<div style="width:150px;text-align:center;padding:6px 0;">' + name + '<hr style="margin: 3px;"/>' + addressDetail + '<br />' + phone + '</div>'
		        });
		        infowindow.open(map, marker);

		        map.setCenter(coords);
		    } 
		});  

	});

</script>

<jsp:include page="/WEB-INF/views/common/footerS.jsp"/>