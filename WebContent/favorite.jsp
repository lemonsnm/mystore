<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>我的购物车</title>
<%@include file="inc/common_head.jsp"%>
</head>
<body>
	<%@include file="inc/header.jsp"%>
	<div class="block table">
		<div class="AreaR">
			<div class="block box">
				<div class="blank"></div>
				<div id="ur_here">
					当前位置: <a href="index.jsp">首页</a><code>&gt;</code>我的收藏夹
				</div>
			</div>
			<div class="blank"></div>
			<div class="box">
				<div class="box_1">
					<div class="userCenterBox boxCenterList clearfix"
						style="_height:1%;">
						<h5><span>我的收藏夹</span></h5>
						<table width="100%" align="center" border="0" cellpadding="5"
							cellspacing="1" bgcolor="#dddddd">
							<tr>
								<th bgcolor="#ffffff">商品名称</th>
								<th bgcolor="#ffffff">市场价</th>
								<th bgcolor="#ffffff">本店价</th>
								<th bgcolor="#ffffff" width="300px">操作</th>
							</tr>
							<c:forEach items="${fList}" var="c">
							<tr>
								<td bgcolor="#ffffff" align="center" style="width:300px;">
									<!-- 商品图片 -->
									<a href="goods?method=queryById&id=${c.gid}" target="_self">
										<img style="width:80px; height:80px;"
										src="${c.goods.imgurl}"
										border="0" title="${c.goods.name} " />
									</a><br />
									<!-- 商品名称 -->
									<a href="javascript:;" target="_blank" class="f6">${c.goods.name}</a>
								</td>
								<td align="center" bgcolor="#ffffff">${c.goods.marketprice}元</td>
								<td align="center" bgcolor="#ffffff">${c.goods.estoreprice}元</td>
							
		
								<td align="center" bgcolor="#ffffff">
								<a href="javascript:;" class="f6" id="addCart"
								 num = "1" gid="${c.gid}">加入购物车</a>
									<a href="javascript:;" class="f6" del="${c.gid}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;删除</a>
								</td>
							</tr>
							</c:forEach>
							<!-- 遍历购物车内容结束 -->
							<tr>
							<!-- 保留小数标签  fmt-->
							<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
								<td colspan="6" style="text-align:right;padding-right:10px;font-size:25px;">
									<a href="cart?method=query"><input value="去购物车" type="button" class="btn" /></a>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="blank"></div>
		<div class="blank5"></div>
	</div>
	<%@include file="inc/footer.jsp"%>
	<script>
	jQuery(function($){
		
		
		/* 删除某条购物信息 */
		//选择含有del属性的a标签
		$("a[del]").click(function() {
			/*  //测试绑定事件
			alert("点击");  */
			
			//获取del属性的值
			var gid = $(this).attr("del");
        	/* //测试获取del的值gid
			alert(gid);  */
		
			if(confirm("确定删除吗？")){
		 	
			/* 	//采用页面刷新，用户体验不好
			location="favorite?method=del&gid=" + gid; */  
			
			//采用Ajax部分页面刷新技术 
			//获取要删除的行 距离删除最近的tr标签
			 var $tr = $(this).closest("tr");
			$.ajax({
				url:"favorite?method=delAjax&gid=" + gid,
				success:function(data){
					
					if(data == "ok"){
						$tr.remove();//删除行
					}else {//未登录 则去登录
						location = "login.jsp";
					}
				}
			}); 
			
			}
		});
	
		//加入购物车
		$("a[gid]").click(function() {
			/* 	//测试点击事件的绑定
				alert("点击"); */ 
				var gid = $(this).attr("gid");
				
				location="cart?method=add&gid=" + gid +"&buynum="+1;
			});
		
		
	});
	</script>
</body>
</html>
