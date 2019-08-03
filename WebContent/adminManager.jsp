<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>后台管理</title>
<%@include file="inc/common_head.jsp"%>
</head>
<body>
	<%@include file="inc/header.jsp"%>
	<div class="block table">
		<div class="AreaR">
			<div class="block box">
				<div class="blank"></div>
				<div id="ur_here" style="display:inline-block">
					当前位置: <a href="index.jsp">首页</a><code>&gt;</code>后台管理
				</div>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<div id="ur_here" align="right" style="display:inline-block">
						<td colspan="6" style="text-align:right;padding-right:10px;font-size:25px;">
					<a><input value="添加商品" type="button" class="btn" id="addGoods"/></a>
				</td>
				</div>
			</div>
			<div class="blank"></div>
			<div class="box">
				<div class="box_1">
					<div class="userCenterBox boxCenterList clearfix"
						style="_height:1%;">
						<h5><span>后台管理</span></h5>
						<table width="100%" align="center" border="0" cellpadding="5"
							cellspacing="1" bgcolor="#dddddd">
							<tr>
								<th bgcolor="#ffffff">商品名称</th>
								<th bgcolor="#ffffff">市场价</th>
								<th bgcolor="#ffffff">本店价</th>
								<th bgcolor="#ffffff" width="300px">操作</th>
							</tr>
							<c:forEach items="${gList}" var="g">
							<tr>
								<td bgcolor="#ffffff" align="center" style="width:300px;">
									<!-- 商品图片 -->
									<a href="goods?method=queryById&id=${g.id}" target="_self">
										<img style="width:80px; height:80px;"
										src="${g.imgurl}"
										border="0" title="${g.name} " />
									</a><br />
									<!-- 商品名称 -->
									<a href="javascript:;" target="_blank" class="f6">${g.name}</a>
								</td>
								<td align="center" bgcolor="#ffffff">${g.marketprice}元</td>
								<td align="center" bgcolor="#ffffff">${g.estoreprice}元</td>
							
		
								<td align="center" bgcolor="#ffffff">
								<a href="admin?method=updateGoods&id=${g.id}" class="f6" id="addCart"
								 num = "1" gid="${g.id}">修改</a>
									<a href="javascript:;" class="f6" del="${g.id}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;删除</a>
								</td>
							</tr>
							</c:forEach>
							<!-- 遍历购物车内容结束 -->
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
			var id = $(this).attr("del");
        	 //测试获取del的值gid
			/* alert(id);  */ 
		
			if(confirm("确定删除吗？")){
		 	
			/* 	//采用页面刷新，用户体验不好
			location="favorite?method=del&gid=" + gid; */  
			
			//采用Ajax部分页面刷新技术 
			//获取要删除的行 距离删除最近的tr标签
			 var $tr = $(this).closest("tr");
			$.ajax({
				url:"admin?method=delAjax&id=" + id,
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
		
		//添加商品
		$("#addGoods").click(function(){
			location="admin?method=addAndUpdate";
		});
		
		
	});
	</script>
</body>
</html>
