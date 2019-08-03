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
import cn.itcast.estore.entity.Favorite;
import cn.itcast.estore.entity.Goods;
import cn.itcast.estore.entity.User;
import cn.itcast.estore.utils.JDBCUtils;


@SuppressWarnings("all")
// 需要在路径前书写"/"，表示项目根目录
@WebServlet("/favorite")
// cart?method=xxx
public class FavoriteServelt extends BaseServlet {
	

	 //删除收藏夹中某条记录 ： Ajax局部页面刷新  增加用户体验
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
		String sql = "delete from favorite where gid=? and uid=?";
		qr.update(sql, req.getParameter("gid"), user.getId());
		
		//响应一个表示登陆的字符串，例如："ok"
		resp.getWriter().write("ok");
	}
	
	        //删除收藏夹中某条记录 ： 页面刷新
	public void del(HttpServletRequest req, HttpServletResponse resp) throws Exception {
			User user = (User)req.getSession().getAttribute("loginUser");
			// 如果没有登录，则强制性跳转到登录页面
			if ( user == null ) {
				resp.sendRedirect("login.jsp");
				return ;
			}
			
			String gid = req.getParameter("gid");
			QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
			String sql = "delete from favorite where uid=? and gid=?";				
			qr.update(sql,user.getId(), gid);
				
			//重新查询即可
			//转发至购物车页面
			resp.sendRedirect("favorite?method=query");
	}
	
	//查询 显示用户收藏夹
	public void query(HttpServletRequest req, HttpServletResponse resp) throws Exception {

		//获取登录用户信息
		User user = (User)req.getSession().getAttribute("loginUser");
		//如果没有登录，去登录
		if(user == null){
			//重定向到登录页面
			resp.sendRedirect("login.jsp");
			return ;
		}
		
		//如果登录了 查询当前用户的收藏夹
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from favorite where uid=?";
		// 查询当前用户的所有购买信息，但是不包含商品的详细信息，只有商品ID
		List<Favorite> fList = qr.query(sql, new BeanListHandler<>(Favorite.class),user.getId());
		//遍历集合 查询商品的详细信息
		for (Favorite favorite : fList) {
			sql = "select * from goods where id = ?";
			Goods goods = qr.query(sql, new BeanHandler<>(Goods.class),favorite.getGid());
			//把收藏的商品信息存放在该favorite的goods中
			favorite.setGoods(goods);
		}
		// 将集合保存到request中，然后转发到favorite.jsp展示数据
		//这里发送数据到页面 需要转发：
		//先保存
		req.setAttribute("fList", fList);
		//再转发
		req.getRequestDispatcher("favorite.jsp").forward(req, resp);
		
	}
	
		//收藏夹
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
			
			//获取商品id
			Integer gid = Integer.parseInt(req.getParameter("gid"));
			//获取用户id
			Integer uid = user.getId();
			
			//先查询是否已经购买过当前商品，如果存在购买记录，则修改购买数量
			//否则新增一条购买信息
			QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
			String sql = "select * from favorite where uid=? and gid=?";
			Cart cart = qr.query(sql, new BeanHandler<>(Cart.class),uid,gid);
			//没有收藏，新增收藏记录
			if(cart == null){
				sql = "insert into favorite values(?,?)";
				//新增时，注意对应数据库中的字段顺序插入gid，uid，buynum
				qr.update(sql,gid,uid);
			}//有收藏，不做处理
			
			//重定向商品详细页面
			resp.sendRedirect("goods?method=queryById&id=" + gid);
			
		}

}
