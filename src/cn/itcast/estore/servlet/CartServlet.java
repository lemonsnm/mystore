package cn.itcast.estore.servlet;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import com.google.gson.Gson;

import cn.itcast.estore.entity.Cart;
import cn.itcast.estore.entity.Category;
import cn.itcast.estore.entity.Goods;
import cn.itcast.estore.entity.User;
import cn.itcast.estore.utils.JDBCUtils;


@SuppressWarnings("all")
// 需要在路径前书写"/"，表示项目根目录
@WebServlet("/cart")
// cart?method=xxx
public class CartServlet extends BaseServlet {
	
	public void delAjax(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		User user = (User)req.getSession().getAttribute("loginUser");
		// 如果没有登录，则强制性跳转到登录页面
		if ( user == null ) {
			// 如果请求的方式为ajax，则不能使用重定向
			// 因为重定向的页面中的内容会作为ajax的响应结果
			// 并不会发生我们预期的跳转动作
			//resp.sendRedirect("login.jsp");
			
			// 可以响应一个表示未登陆的字符串，例如："unlogin"
			resp.getWriter().write("unlogin");
			return ;
		}
		
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "delete from cart where gid=? and uid=?";
		qr.update(sql, req.getParameter("gid"), user.getId());
		
		//响应一个表示登陆的字符串，例如："ok"
		resp.getWriter().write("ok");
	}
	
	
		//删除购物车中某条记录 ： 页面刷新
		public void del(HttpServletRequest req, HttpServletResponse resp) throws Exception {
			User user = (User)req.getSession().getAttribute("loginUser");
			// 如果没有登录，则强制性跳转到登录页面
			if ( user == null ) {
				resp.sendRedirect("login.jsp");
				return ;
			}
			
			String gid = req.getParameter("gid");
			QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
			String sql = "delete from cart where uid=? and gid=?";
			qr.update(sql,user.getId(), gid);
			
			//重新查询即可
			//转发至购物车页面
			resp.sendRedirect("cart?method=query");
		}
	
	//在购物车中，修改购买数量  方法：Ajax部分刷新  用户体验效果好
	public void changeNumAjax(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		User user = (User)req.getSession().getAttribute("loginUser");
		// 如果没有登录，则强制性跳转到登录页面
		if ( user == null ) {
			// 如果请求的方式为ajax，则不能使用重定向
			// 因为重定向的页面中的内容会作为ajax的响应结果
			// 并不会发生我们预期的跳转动作
			//resp.sendRedirect("login.jsp");
			
			// 可以响应一个表示未登陆的字符串，例如："unlogin"
			resp.getWriter().write("unlogin");
			return ;
		}
		
		// 获取商品的id和购买数量
		String gid = req.getParameter("gid");
		String buynum = req.getParameter("buynum");
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "update cart set buynum=? where uid=? and gid=?";
		qr.update(sql, buynum, user.getId(), gid);
		
		// 数据库更新完成之后，重新查询即可
		resp.getWriter().write("ok");
	}
	
	//在购物车中，修改购买数量  方法：页面刷新  用户体验不太好
	public void changeNum(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		User user = (User)req.getSession().getAttribute("loginUser");
		// 如果没有登录，则强制性跳转到登录页面
		if ( user == null ) {
			resp.sendRedirect("login.jsp"); 
			return ;
		}
		
		// 获取商品的id和购买数量
		String gid = req.getParameter("gid");
		String buynum = req.getParameter("buynum");
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "update cart set buynum=? where uid=? and gid=?";
		qr.update(sql, buynum, user.getId(), gid);
		
		// 数据库更新完成之后，重新查询即可
		resp.sendRedirect("cart?method=query");
	}
	
	//查询 显示用户购物车
	public void query(HttpServletRequest req, HttpServletResponse resp) throws Exception {

		//获取登录用户信息
		User user = (User)req.getSession().getAttribute("loginUser");
		//如果没有登录，去登录
		if(user == null){
			//重定向到登录页面
			resp.sendRedirect("login.jsp");
			return ;
		}
		
		//如果登录了 查询当前用户的购物车
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from cart where uid=?";
		// 查询当前用户的所有购买信息，但是不包含商品的详细信息，只有商品ID
		List<Cart> cList = qr.query(sql, new BeanListHandler<>(Cart.class),user.getId());
		//遍历集合 查询商品的详细信息
		for (Cart cart : cList) {
			sql = "select * from goods where id = ?";
			Goods goods = qr.query(sql, new BeanHandler<>(Goods.class),cart.getGid());
			//把商品信息存放在该cart的goods中
			cart.setGoods(goods);
		}
		// 将集合保存到request中，然后转发到cart.jsp展示数据
		//这里发送数据到页面 需要转发：
		//先保存
		req.setAttribute("cList", cList);
		
		//获取strget参数
		String target = req.getParameter("target");
		
		if(target == null){//去购物车
			//再转发 显示购物车
			req.getRequestDispatcher("cart.jsp").forward(req, resp);
		}else{
			//再转发 显示订单
			req.getRequestDispatcher("orders_submit.jsp").forward(req, resp);
		}
		
	}
	
	//加入购物车
		public void add(HttpServletRequest req, HttpServletResponse resp) throws Exception {

			//获取登录用户信息
			User user = (User)req.getSession().getAttribute("loginUser");
			//如果没有登录，去登录
			if(user == null){
				//重定向到登录页面
				resp.sendRedirect("login.jsp");
				return ;
			}
			//如果已经登录
			
			//获取商品id和购买数量
			String gid = req.getParameter("gid");
			String buynum = req.getParameter("buynum");
			//获取用户id
			Integer uid = user.getId();
			
			//先查询是否已经购买过当前商品，如果存在购买记录，则修改购买数量
			//否则新增一条购买信息
			QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
			String sql = "select * from cart where uid=? and gid=?";
			Cart cart = qr.query(sql, new BeanHandler<>(Cart.class),uid,gid);
			//没有购买记录，新增
			if(cart == null){
				sql = "insert into cart values(?,?,?)";
				//新增时，注意对应数据库中的字段顺序插入gid，uid，buynum
				qr.update(sql,gid,uid,buynum);
			}else{ //有购买记录，修改购买数量
				//原本的购买数量
				Integer oldNum = cart.getBuynum();
				//新的购买数量=老购买数量+buynum
				int newNum = oldNum + Integer.parseInt(buynum);
				sql = "update cart set buynum=? where gid=? and uid=?";
				qr.update(sql,newNum,gid,uid);
			}
			//重定向到中间提示页面
			resp.sendRedirect("buyorcart.jsp");
			
		}

}
