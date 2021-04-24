<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>
<div class="container">
	<div id="buy" class="tab-pane fade active show in">
		<div class="col-md-15">
		    <div class="form-area">
		    	<div class="text-center" style="width: 40%; height: 50%; float:none; margin:10 auto">
			    	<table id="purchaseLog-table" class="table table-bordered ">
				    	<tr>
	 				    <!-- 로그인된 관리자 상태가 지점일 경우 -->
				    	<c:if test="${loginEmp.status ne 2 }">
				    		<th>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }/ERP/empManage.do';">
								  <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>지점/업체 관리
								</button>
				    		</th>
							<th>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }/ERP/searchInfo.do';">
								  <span class="glyphicon glyphicon-gift" aria-hidden="true"></span>상품 관리
								</button>
				    		</th>
					    	<th>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }/ERP/ProductReceive.do';">
								  <span class="glyphicon glyphicon-save" aria-hidden="true"></span>입고 관리
								</button>
					    	</th>
				    	</c:if>
				    	<!-- 로그인된 관리자 상태가 제조사일 경우 -->
				    	<c:if test="${loginEmp.status eq 2 }">
					    	<th>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }/ERP/ProductRequestList.do';">
								  <span class="glyphicon glyphicon-save" aria-hidden="true"></span>발주 관리
								</button>
					    	</th>
				    	</c:if>
	
				    	</tr>
				    	<tr>
	   				    	<!-- 로그인된 관리자 상태가 지점일 경우 -->
				    		<c:if test="${loginEmp.status ne 2 }">
				    		<th>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }/ERP/EmpDetail.do';">
								  <span class="glyphicon glyphicon-stats" aria-hidden="true"></span>현황 조회
								</button>
				    		</th>
				    		</c:if>
					    	<th>
					    	<!-- 호근 게시판 url 수정함 -->
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath }/ERP/EmpBoardList.do';">
								  <span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>게시판
								</button>
					    	</th>	
				    		<th>
						    	<button type="button" 
						    			class="btn btn-default btn-lg"
						    			onclick="location.href='${ pageContext.request.contextPath}/ERP/logout.do'">
								  <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>로그아웃
								</button>
				    		</th>
				    	</tr>
				    </table>
				</div>
    		</div>
		</div>
	</div>
</div> 	
<jsp:include page="/WEB-INF/views/common/footerE.jsp"/>		
  </body>
</html>
