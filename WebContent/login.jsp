<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>登录</title>
<%@include file="inc/common_head.jsp"%>
</head>
<body>
	<%@include file="inc/header.jsp"%>
	<div class="block block1">
		<div class="blank"></div>
		<div class="usBox clearfix">
			<div class="usBox_1">
				<div class="login_tab">
					<ul>
						<li class="active">用户登录</li>
						<li onclick="location.href='register.jsp';">
							<a href="javascript:;">用户注册</a>
						</li>
					</ul>
				</div>
				<form name="formLogin" action="user?method=login" method="post"
					onSubmit="return userLogin()">
					<table width="100%" border="0" align="left" cellpadding="3"
						cellspacing="5">
						<tr>
							<td width="70px" class="justify">用户名</td>
							<!-- 读取cookie中数据 -->
							<td>
								<input placeholder="请输入手机号" name="username" 
								value="${ cookie.telephone.value }"
									class="inputBg" onkeyup="is_registered(this.value, true);"  />
								<span style="color:#FF0000" id="username_notice"></span>
							</td>
						</tr>
						<tr>
							<td class="justify">密码</td>
							<td>
								<input name="password" placeholder="请输入密码" type="password" 
									class="inputBg" onkeyup="check_password(this.value, true);" />
								<span style="color:#FF0000" id="password_notice"></span>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="checkbox" value="1" name="remember" id="remember" />
								<label for="remember">记住用户名</label>
								<a href="login2.jsp">使用短信验证码登录</a>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<a href="javascript:;">
									<input id="regBtn" value="立  即  登  录" 
										type="submit" class="us_Submit_reg"/>
								</a>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<a href="javascript:;" onclick="location='register.jsp'">
									<input id="loginBtn" value="没有账号？立即注册" 
										type="button" class="us_Submit_log" />
								</a>
							</td>
						</tr>
					</table>
				</form>
				<div class="blank"></div>
			</div>
		</div>
		<%@include file="inc/footer.jsp"%>
</body>
</html>