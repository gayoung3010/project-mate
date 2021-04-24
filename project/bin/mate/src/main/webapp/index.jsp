<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="${ pageContext.request.contextPath }/resources/css/index.css" />

<jsp:include page="/WEB-INF/views/common/headerS.jsp"/>
<style>

.blur-div{
	display: inline-block;
	width: 160px;
	height: 110px;
	position: absolute;
}
.main-div{
	display: inline-block;
	width: 500px;
	height: 320px;
	border: 20px solid white;
	position: absolute;
	bottom: 38vh;
	left: 230px;
	
}
.first-div{
	left: 50px;
	bottom: 63vh;
	filter: blur(5px) grayscale(80%);
}
.first-div:hover, .second-div:hover, .third-div:hover{
	filter: blur(0px);
}
.second-div, .third-div{
	bottom: 41vh;
	filter: blur(5px) grayscale(80%);
}
.second-div{
	right: 205px;
}
.third-div{
	right: 15px;
}
.img-none{
	display:none;
}
.bestImgs{
	max-width: 100%;
	min-width: 100%;
	height: 100%;
}

#best-p{
	position: absolute;
	bottom: 27vh;
	right: 170px;
	width: 27vw;
	font-family: 'UhBeeSe_hyun';
	font-weight: bold;
}
.best-div:hover{
	cursor: pointer;
}

</style>
<script>
$(function(){
	$.ajax({
		url: "${pageContext.request.contextPath}/product/getBest.do",
		method: "get",
		dataType: "json",
		success:function(data){
			$(data).each(function(i, map){
				console.log(map);
				var html = "<div class='img-div img-none' id='bestImg-" + i + "'>";
				html += '<img class="bestImgs" data-id="'+map.productNo+'" src="${pageContext.request.contextPath}/resources/upload/mainimages/' + map.renamedFilename + '" alt="" />';
				html += "</div>";
				console.log(html);
				$(".content-div").after(html);
			});
			startPlayM(data.length);
			startPlay1(data.length);
			startPlay2(data.length);
			startPlay3(data.length);
		},
		error: function(xhr, status, err){
			console.log(xhr, status, err);
		}
	});
});
var startPlayM = function(i){
	var cnt = 1;
	$(".main-div").html($("#bestImg-"+ (cnt-1)).html());
	playM = setInterval(function() {
		$(".main-div").html($("#bestImg-"+cnt).html());
		if(cnt < i-1)cnt++;
		else cnt = 0;
	}, 5000);
}
var startPlay1 = function(i){
	var cnt = 0;
	$(".first-div").html($("#bestImg-"+ (i-1)).html());
	play1 = setInterval(function() {
		$(".first-div").html($("#bestImg-"+cnt).html());
		if(cnt < i-1)cnt++;
		else cnt = 0;
	}, 5000);
}
var startPlay2 = function(i){
	var cnt = 2;
	$(".second-div").html($("#bestImg-"+ (cnt-1)).html());
	play2 = setInterval(function() {
		$(".second-div").html($("#bestImg-"+cnt).html());
		if(cnt < i-1)cnt++;
		else cnt = 0;
	}, 5000);
}
var startPlay3 = function(i){
	var cnt = 3;
	$(".third-div").html($("#bestImg-"+ (cnt-1)).html());
	play3 = setInterval(function() {
		$(".third-div").html($("#bestImg-"+cnt).html());
		if(cnt < i-1)cnt++;
		else cnt = 0;
	}, 5000);
}
var stopPlay = function() {
	clearInterval(playM);
	clearInterval(play1);
	clearInterval(play2);
	clearInterval(play3);
};
$(function(){
	$(".best-div").hover(function(){
		console.log("stop");
		stopPlay();
	},function(){
		console.log("start");
		startPlayM(15);
		startPlay1(15);
		startPlay2(15);
		startPlay3(15);
	});

	$(".best-div").click(function(){
		var productNo = $(this).find("img").data("id");
		//console.log(productNo);
		location.href = '${pageContext.request.contextPath}/product/productDetail.do?productNo='+productNo;
	});
});

</script>
<div class="search-div"></div>

<div class="content-div">
	<div class="blur-div first-div best-div"></div>
	<div class="main-div best-div"></div>
	<div class="blur-div second-div best-div"></div>
	<div class="blur-div third-div best-div"></div>
</div>


<p id="best-p"><────────── BEST 5 ───────────</p>
<br />
<jsp:include page="/WEB-INF/views/common/footerS.jsp"></jsp:include>

