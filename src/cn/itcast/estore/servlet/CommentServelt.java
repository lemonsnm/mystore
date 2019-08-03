package cn.itcast.estore.servlet;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import com.google.gson.Gson;

import cn.itcast.estore.entity.Cart;
import cn.itcast.estore.entity.Category;
import cn.itcast.estore.entity.Comment;
import cn.itcast.estore.entity.Favorite;
import cn.itcast.estore.entity.Goods;
import cn.itcast.estore.entity.User;
import cn.itcast.estore.utils.JDBCUtils;
import javafx.scene.chart.PieChart.Data;


@SuppressWarnings("all")
// 需要在路径前书写"/"，表示项目根目录
@WebServlet("/comments")
// cart?method=xxx
public class CommentServelt extends BaseServlet {
	
		//添加评论
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
			//获取评论信息
			  //等级
			String level = req.getParameter("comment_rank");
			  //评论内容
			String comments = req.getParameter("content");
			//输入的验证码
			String isCaptcha = req.getParameter("captcha");
			//获取正确验证码
			String code = (String)req.getSession().getAttribute("code");
		
			if(!((isCaptcha+"").toLowerCase()).equals((code+"").toLowerCase())){
				//重定向商品详细页面
				resp.sendRedirect("goods?method=queryById&id=" + gid);
				return ;
			}
			
			//评论时间
			Date createtime = new Date();
			// 生成随机32位评论号
			String id = UUID.randomUUID().toString().replace("-", "").toUpperCase();
			//插入评论
			QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
			String sql = "insert into comment values(?,?,?,?,?,?)";
			qr.update(sql,id,gid,uid,level,comments,createtime);
			
			//重定向商品详细页面
			resp.sendRedirect("goods?method=queryById&id=" + gid);
			
		}

}
