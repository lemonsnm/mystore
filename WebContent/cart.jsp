x<%@ page contentType="text/html; charset=UTF-8"%>
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
					当前位置: <a href="index.jsp">首页</a><code>&gt;</code>我的购物车
				</div>
			</div>
			<div class="blank"></div>
			<div class="box">
				<div class="box_1">
					<div class="userCenterBox boxCenterList clearfix"
						style="_height:1%;">
						<h5><span>我的购物车</span></h5>
						<table width="100%" align="center" border="0" cellpadding="5"
							cellspacing="1" bgcolor="#dddddd">
							<tr>
								<th bgcolor="#ffffff">商品名称</th>
								<th bgcolor="#ffffff">市场价</th>
								<th bgcolor="#ffffff">本店价</th>
								<th bgcolor="#ffffff">购买数量</th>
								<th bgcolor="#ffffff">小计</th>
								<th bgcolor="#ffffff" width="160px">操作</th>
							</tr>
							<!-- 声明变量和计算总金额和节省金额 -->
							<c:set var="sum" value="0"/>
							<c:set var="save" value="0"/>
							<c:forEach items="${cList}" var="c">
							<c:set var="sum" value="${sum + c.goods.estoreprice * c.buynum}"/>
							<c:set var="save" value="${save + (c.goods.marketprice-c.goods.estoreprice) * c.buynum}"/>
							<c:set var="xj" value="${c.goods.estoreprice*c.buynum }"/>
								<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
							<tr>
								<td bgcolor="#ffffff" align="center" style="width:300px;">
									<!-- 商品图片 -->
									<a href="javascript:;" target="_blank">
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
									<!-- 添加属性，保存想要的值 -->
									<input value="${c.buynum}" class="cartInput" 
									gid="${c.gid }"
									estoreprice="${c.goods.estoreprice }"
									marketprice="${c.goods.marketprice }"/>
								</td>
								<!-- 小计  添加自定义标记xiaoji-->
								<td xiaoji align="center" bgcolor="#ffffff">
								 <fmt:formatNumber value="${xj}" pattern="0.00" /> 
								元
								</td>
								<td align="center" bgcolor="#ffffff">
									<a href="javascript:;" class="f6" del="${c.gid}">删除</a>
								</td>
							</tr>
							</c:forEach>
							<!-- 遍历购物车内容结束 -->
							<tr>
							<!-- 保留小数标签  fmt-->
	
								<td colspan="6" style="text-align:right;padding-right:10px;font-size:25px;">
									购物金额小计&nbsp;<font color="red" id="sum">
									<fmt:formatNumber value="${sum }" pattern="0.00" />
									</font>元，
									共为您节省了&nbsp;<font color="red" id="save">
									<fmt:formatNumber value="${save }" pattern="0.00" />
									</font>元
									<!-- oredes传递标记 用来查询 跳转到指定页面 -->
									<a href="cart?method=query&target=orders"><input value="去结算" type="button" class="btn" /></a>
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
			
		//计算总金额和节省金额
		function updSumAndSave(){
			var sum = 0;
			
			// 包含xiaoji属性的td元素
			$("td[xiaoji]").each(function() {
				// parseFloat将字符串转换为数字 
				sum += parseFloat( $(this).text() );
			});
			// toFixed(2)表示保留2位小数
			$("#sum").text(sum.toFixed(2));
			
			// 所有的输入框，在输入框标签上
			// 包含商品的市场价、商城价和购买数量
			var save = 0;
			$("input.cartInput").each(function() {
				var mp = $(this).attr("marketprice");
				var ep = $(this).attr("estoreprice");
				var num = this.value;
				save += (mp - ep) * num;
			});
			// toFixed(2)表示保留2位小数
			$("#save").text(save.toFixed(2));
		}
		
		/* 删除某条购物信息 */
		//选择含有del属性的a标签
		$("a[del]").click(function() {
			//var gid = $(this).attr("del");
			/* //测试绑定事件
			alert("点击"); */
			
			//获取del属性的值
			var gid = $(this).attr("del");
		/* 	//测试获取del的值gid
			alert(gid); */
		
			if(confirm("确定删除吗？")){
			 /* 	//采用页面刷新，用户体验不好
			location="cart?method=del&gid=" + gid;  */
			
			//采用Ajax部分页面刷新技术 
			//获取要删除的行 距离删除最近的tr标签
			var $tr = $(this).closest("tr");
			$.ajax({
				url:"cart?method=delAjax&gid=" + gid,
				success:function(data){
					
					if(data == "ok"){
						$tr.remove();//删除行
						// 计算总金额和节省金额 封装方法
						updSumAndSave();
					}else {//未登录 则去登录
						location = "login.jsp";
					}
				}
			});
			
			//显示购物车数量
			var s = $("#Zero").text();
			$("#Zero").text(s - 1)
			
			}
		});
		
		/* 输出购物车 */
		// 选取页面中class属性为cartInput的input元素
		$("input.cartInput")
		// 当值发生改变，并且失去焦点时触发，注意区分和离焦事件blur的区别
		.change(function(){
			/* //测试绑定事件
			alert("改变"); */
			
			//获取自己增加的属性gid
			//获取该商品gid
			var gid = $(this).attr("gid");
			//获取购买数量
			var buynum = this.value;
			//获取本店价格
			var estoreprice = $(this).attr("estoreprice");
			// 要更新的td：当前输入框的父元素的下一个元素
			//需要更新小计金额，小计金额在当前this的父类的下一个标签
			var $xj = $(this).parent().next();
			
		/* 	//页面刷新，用户体验不是很好
			location = "cart?method=changeNum&gid=" + gid + "&buynum=" + this.value; */
			
			//利用Ajax部分页面刷新功能，提高用户体验
			$.ajax({
				url: "cart?method=changeNumAjax&gid=" + gid + "&buynum=" + buynum,
				// 执行成功之后，需要对页面进行修改	
				success: function(data) {
					if ( data == "ok" ) {
						// 需要对页面中的小计金额、总金额、节省金额这些地方做修改
						var xiaoji = buynum * estoreprice;
						$xj.text( xiaoji + "元" );
						//计算总金额与节省金额
						updSumAndSave();
					}
					// "unlogin" 未登陆，使用location进行页面的跳转
					else {
						location = "login.jsp";
					}
				}
			});
			
			
		});
		
	});
	</script>
</body>
</html>
