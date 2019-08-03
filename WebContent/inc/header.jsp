<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="Top">
	<div class="tops"></div>
	<div class=" block header_bg" style="margin-bottom:0px;">
		<div class="top_nav_header">
			<div class="top_nav">
				<div class="block">
					<div class="f_l left_login">
						<script type="text/javascript" src="js/transport.js"></script>
						<script type="text/javascript" src="js/utils.js"></script>
						<font id="ECS_MEMBERZONE">
							欢迎光临本店，
							<c:if test="${ loginUser == null }">
								<a href="login.jsp">登录</a>
								<a href="register.jsp">注册</a>
							</c:if>
							<c:if test="${ loginUser != null }">
								${loginUser.nickname }
								<a href="user?method=logOut">退出/切换账号</a>
							</c:if>
						</font>
					</div>
					<ul class="top_bav_l">
						<li class="top_sc">&nbsp;&nbsp;<a href="favorite?method=query"
							>收藏夹</a></li>
							<c:if test="${ AdminUser == null }">
								<li class="top_sc">&nbsp;&nbsp;<a href="favorite?method=query"
							>关注我们</a></li>
							</c:if>
							<c:if test="${ AdminUser != null }">
								<li class="top_sc">&nbsp;&nbsp;<a href="admin?method=query"
							>后台管理</a></li>
							</c:if>
						
					</ul>
					<div class="header_r">
						<a href="orders?method=query">我的订单</a>
						<a href="goods?method=query">商品列表</a>
					</div>
				</div>
			</div>
		</div>
		<div class="clear_f"></div>
		<div class="header_top logo_wrap clearfix">
			<a class="logo_new" href="javascript:;">
				<img src="themes/ecmoban_jumei/images/logo.gif" />
			</a>
			<div class="ser_n">
				<form id="searchForm" class="searchBox clearfix" name="searchForm"
					onsubmit="return false;" method="get" action="">
					<span class="ipt1"><input name="keywords"
						placeholder="请输入您想购买的商品" type="text" id="keyword" value=""
						class="searchKey" /></span> <span class="ipt2"><input
						type="submit" name="imageField" onclick="location='goods?method=query&name=' + keyword.value;" class="fm_hd_btm_shbx_bttn"
						value="搜  索"></span>
				</form>
				<div class="clear_f"></div>
				<ul class="searchType none_f"></ul>
			</div>
			<ul class="cart_info">
				<li id="ECS_CARTINFO">
					<div class="top_cart">
						<img src="themes/ecmoban_jumei/images/cart.gif" /> <span
							class="carts_num none_f"><a href="cart?method=query" title="查看购物车"  id="Zero"></a></span>
						<a href="cart?method=query" class="shopborder">去购物车结算</a>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>
<div style="clear:both"></div>
<div class="menu_box clearfix">
	<div id="category" class="block" style="width:840px">
		<a href="index.jsp" id="indexA">首页</a>
		<!-- <a href="javascript:;">化妆品</a>
		<a href="javascript:;">鞋包配饰</a>
		<a href="javascript:;">居家母婴</a>
		<a href="javascript:;">服饰内衣</a>
		<a href="javascript:;">团购商品</a> -->
		<!-- 动态生产商品类别 -->
	</div>
<script type="text/javascript">

	

	// 页面加载完成时执行的函数
	jQuery(function($) {
		// 发送ajax请求，到后台获取商品类别信息
		$.ajax({
			url: "goods?method=queryCategory",
			// 后台返回的结果都是字符串类型，需要将字符串转换成数组或对象
			// 才可以使用，因此需要指定dataType为json
			dataType: "json",
			success: function(data) {
				// [{id:1,name:手机数码}, {id:2, name:电脑办公},...]
				for( var i = 0; i < data.length; i++ ) {
					// 使用jQuery函数来创建标签
					$("<a cid='"+data[i].id
					+"' href='javascript:;'>"
					+data[i].name+"</a>")
					
					// 给超链接绑定事件，用于类别的查询
					.click(function() {
						var cid = $(this).attr("cid");
						// location表示地址栏对象，给其赋值表示页面跳转
						location = "goods?method=query&cid=" + cid;
					})
					
					// 将创建好的超链接添加到id为category的元素中
					.appendTo("#category");
				}
				// 获取cid等于商品的类别id的超链接中的文本值
				var cName = $("a[cid=${goods.cid}]").text();
				// 更新到商品详情页的商品类别
				$("#cName").text( cName );
				
				
				// 当前类别添加背景
				// ${param.cid} 表示要获取cid参数
				// 获取cid属性的值为${param.cid}的超链接
				$("a[cid=${param.cid}]")
				// 添加背景样式
				.attr("class", "cur");
				
				// 如果cid的值为空，则选中首页
				if ( "${param.cid}" == "" ) {
					$("#indexA").attr("class", "cur");
				}
			}
		});
		
		$.ajax({
			url: "goods?method=queryNum",
					dataType:"json",
			success:function(data){
				 
				if(data != "no"){
				$("#Zero").text(data);
				}else{
					$("#Zero").text(0);
				}
				
			}
		});
		
		
	});
	
</script>
	
</div>
<link href="themes/ecmoban_qq/images/qq.css" rel="stylesheet" type="text/css" />
<div class="QQbox" id="divQQbox" style="width:170px;">
	<div class="Qlist" id="divOnline" onmouseout="hideMsgBox(event);"
		style="display: none; " onmouseover="OnlineOver();">
		<div class="t"></div>
		<div class="infobox">
			我们营业的时间<br>9:00-18:00
		</div>
		<div class="con">
			<ul>
				<li><a href="javascript:;" target="_blank"><img
						src="images/button_old_41.gif" height="16" border="0" alt="QQ" />&nbsp;&nbsp;666666666</a></li>
				<li><a href="javascript:;" target="_blank"><img
						src="images/button_old_41.gif" height="16" border="0" alt="QQ" />&nbsp;&nbsp;888888888</a></li>
				<li><a href="javascript:;" target="_blank"><img
						src="images/button_old_41.gif" height="16" border="0" alt="QQ" />&nbsp;&nbsp;999999999</a></li>
				<li>服务热线: 88888888</li>
			</ul>
		</div>
		<div class="b"></div>
	</div>
	<div id="divMenu" onmouseover="OnlineOver();" style="display: block; ">
		<img src="themes/ecmoban_qq/images/qq_1.gif" class="press" alt="在线咨询">
	</div>
	<script type="text/javascript">
		//初始化主菜单
		function sw_nav(obj, tag) {
			var DisSub = document.getElementById("DisSub_" + obj);
			var HandleLI = document.getElementById("HandleLI_" + obj);
			if (tag == 1) {
				DisSub.style.display = "block";
			} else {
				DisSub.style.display = "none";
			}
		}
	</script>
</div>