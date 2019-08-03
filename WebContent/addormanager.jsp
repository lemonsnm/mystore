<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en">

<head>
    <%@include file="inc/common_head.jsp"%>
</head>
<body>
<%@include file="inc/header.jsp" %>
<div style="width:350px;margin:0 aotu;text-align:right;">
	<div class="result-tip">
		<i class="icon-success"></i> 已成功新增商品
	</div>
	
	<div>
		<input onclick="location.href='admin?method=addAndUpdate';"
		type="button" value="继续增加" class="btn2" />&nbsp;&nbsp;&nbsp;
		
		<input onclick="location.href='admin?method=query';" 
		type="button" value="去后台管理" class="btn" />
	</div>
</div>
<%@include file="inc/footer.jsp" %>
</body>
</html>