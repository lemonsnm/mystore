package cn.itcast.estore.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;

import cn.itcast.estore.entity.User;
import cn.itcast.estore.utils.JDBCUtils;

/**
 * servlet模块化
 * @author lemonSun
 *
 * 2019年6月16日下午11:07:37
 */
@SuppressWarnings("all")
//需要在路径前书写"/"，表示项目根目录
@WebServlet("/user")
//user?method=register
//user?method=login
public class UserServlet extends BaseServlet{
	
	
	    //判断验证码是否正确
		public void checkSMSCode(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
			// 获取要发送的验证码
			String smsCode1 = req.getParameter("smsCode");
			//获取短信给的正确验证码 已经保存在Session中
			String smsCode2 = (String)req.getSession().getAttribute("smsCode");
			
			if ( (smsCode1+"").equals(smsCode2) ) { //验证码输入正确 返回true
				resp.getWriter().write("true");
			} else {  //验证码输入正确 返回false
				resp.getWriter().write("false");   
			}
		}


	//判断手机号是否被注册
public void checkTel(HttpServletRequest request,HttpServletResponse response) throws IOException {
	    
		//获取前台输入的手机号
		String tel = request.getParameter("tel");
		//查询是否被注册
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		//sql 查询语句
		String sql = "select * from user where telephone=?";
		try {//查询
			User user = qr.query(sql,new BeanHandler<>(User.class),tel);
			//判断是否被注册
			if(user == null){//没有被注册
				
				//返回的前端数据 ok
				response.getWriter().write("ok");
			}
		
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	
	//短信登录 获取验证码
	public void getCode(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 获取要发送的手机号码
		String tel = req.getParameter("tel");
		// 生成6位随机数字作为验证码
		// 0.55645452211254
		double random = Math.random();
		String code = (random+"").substring(2, 8);
		System.out.println(code+"========================");
		// 将短信验证码保存到session中，后续需要判断是否正确
		req.getSession().setAttribute("loginCode", code);
		
		/*DefaultProfile profile = DefaultProfile.getProfile("default", "LTAIrW7ypMKEftb8", "RhdKQ5ppMPcSHu2GbGaOX3FVAwdTgd");
        IAcsClient client = new DefaultAcsClient(profile);

        CommonRequest request = new CommonRequest();
        request.setMethod(MethodType.POST);
        request.setDomain("dysmsapi.aliyuncs.com");
        request.setVersion("2017-05-25");
        request.setAction("SendSms");
        request.putQueryParameter("PhoneNumbers", tel);
        request.putQueryParameter("SignName", "学院商城");
        request.putQueryParameter("TemplateCode", "SMS_167961732");
        request.putQueryParameter("TemplateParam", "{\"code\": \""+code+"\"}");
        try {
            CommonResponse response = client.getCommonResponse(request);
            System.out.println(response.getData());
        } catch (ServerException e) {
            e.printStackTrace();
        } catch (ClientException e) {
            e.printStackTrace();
        }*/
	}
	
	//短信验证码登录
	public void login2(HttpServletRequest request,HttpServletResponse response) throws IOException {
	    
		//获取用户输入的验证码
		String password = request.getParameter("password");
		//获取正确验证码
		String loginCode = (String)request.getSession().getAttribute("loginCode");
		//防止空指针异常  判断验证码是否输入正确
		if(!(password+"").equals(loginCode)){ //如果输入不正确
			response.getWriter().write(
					"<script>alert('手机号或密码错误'); history.go(-1);</script>");
			return ;
		}
		
		// 获取手机号码
		String username = (String)request.getParameter("username");
		System.out.println("username:"+username);
		
		//编写sql
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from user where telephone=?";
		
		try {
			//查询
			User user = qr.query(sql, new BeanHandler<>(User.class),username);
			System.out.println("user:"+user);
			if(user == null){ //查不到
				response.getWriter().write(
						"<script>alert('手机号或验证码错误'); history.go(-1);</script>");
				return;
			}
				//将用户对象保存到session中，方便后续获取用户信息及判断是否登录
				request.getSession().setAttribute("loginUser", user);
				
				// 记住用户名
				String remember = request.getParameter("remember");
				
				// 复选框和单选按钮，没有勾选的情况下，获取的值为null
				if ( remember != null ) {
					Cookie c = new Cookie("telephone", username);
					// 设置存活时间，单位是秒
					c.setMaxAge(999999999);
					// 必须将cookie添加到响应对象中，浏览器才会保存这个数据
					response.addCookie(c);
				}
				// 删除cookie
				else { //不记住用户名
					Cookie c = new Cookie("telephone", "");//设置null值
					// 设置存活时间，单位是秒
					c.setMaxAge(0);
					// 必须将cookie添加到响应对象中，浏览器才会保存这个数据
					response.addCookie(c);
				}
				
				//登录成功 重定向到首页
				response.sendRedirect("index.jsp");
			
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
	
	//登录
	public void login(HttpServletRequest request,HttpServletResponse response) throws IOException {
	    
		//获取手机号码和密码
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		
		//编写sql
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from user where telephone = ? and password = ?";
		
		try {
			//查询
			User user = qr.query(sql, new BeanHandler<>(User.class),username,password);
			
			if(user == null){ //查不到
				response.getWriter().write(
						"<script>alert('手机号或密码错误'); history.go(-1);</script>");
				return;
			}else{
				
				//判断是否为管理员登录
				if((username+"").equals("admin") && (password+"").equals("admin")){
					//将管理员对象保存到session中，方便后续获取管理员权限
					request.getSession().setAttribute("AdminUser", user);
				}else{//不是管理员 设置为空
					request.getSession().setAttribute("AdminUser", null);
				}
				
				//将用户对象保存到session中，方便后续获取用户信息及判断是否登录
				request.getSession().setAttribute("loginUser", user);
				
				// 记住用户名
				String remember = request.getParameter("remember");
				
				// 复选框和单选按钮，没有勾选的情况下，获取的值为null
				if ( remember != null ) {
					Cookie c = new Cookie("telephone", username);
					// 设置存活时间，单位是秒
					c.setMaxAge(999999999);
					// 必须将cookie添加到响应对象中，浏览器才会保存这个数据
					response.addCookie(c);
				}
				// 删除cookie
				else {
					Cookie c = new Cookie("telephone", "");
					// 设置存活时间，单位是秒
					c.setMaxAge(0);
					// 必须将cookie添加到响应对象中，浏览器才会保存这个数据
					response.addCookie(c);
				}
				
				//登录成功 重定向到首页
				response.sendRedirect("index.jsp");
				
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	
	//退出登录/或切换账号
	public void logOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 将用户数据从session中移除掉即可
		request.getSession().removeAttribute("loginUser");
		response.sendRedirect("login.jsp");
	}
	
	//发送手机注册验证码
	public void sendSMS(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		// 1、获取要发送的手机号码
		String tel = req.getParameter("tel");
		// 2、生成6位随机数字作为验证码
		double random = Math.random();//随机生成0-1的数，例如： 0.55645452211254
		//(random + "")强制转换为String类型  生成随机六位数
		String code = (random + "").substring(2, 8); 
		System.out.println(code+"========================");//控制台打印，模仿短信验证码
		// 3、将短信验证码保存到session中，后续需要判断是否正确
		req.getSession().setAttribute("smsCode", code);
		
	}
	
	//用户注册
	public void register(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String nickname = request.getParameter("nickname");
		String password = request.getParameter("password");
		String telephone = request.getParameter("telephone");
		
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "insert into user values(null,?,?,?)";
		try {
			qr.update(sql, password, nickname, telephone);
			
			
			response.sendRedirect("login.jsp");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
}
