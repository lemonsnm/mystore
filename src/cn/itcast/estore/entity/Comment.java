package cn.itcast.estore.entity;

import java.util.Date;

import javafx.scene.chart.PieChart.Data;

/**
 * 商品评论
 * @author lemonSun
 *
 * 2019年6月23日下午7:03:57
 */
public class Comment {
	
	//商品id
	private Integer gid;
	
	//用户id
	private Integer uid;

	//评论等级 等级 1，2，3，4，5级
	private Integer level;
	
	//评论内容
	private String comments;
	
	//评论用户昵称  
	private String nickname; 
	
	//评论时间
	private Date createtime;

	public Integer getUid() {
		return uid;
	}
	public void setUid(Integer uid) {
		this.uid = uid;
	}
	public Integer getGid() {
		return gid;
	}
	public void setGid(Integer gid) {
		this.gid = gid;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	
	
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	
	
	
	public Date getCreatetime() {
		return createtime;
	}
	public void setCreatetime(Date createtime) {
		this.createtime = createtime;
	}
	@Override
	public String toString() {
		return "Comment [gid=" + gid + ", uid=" + uid + ", level=" + level + ", comments=" + comments + ", nickname="
				+ nickname + ", createtime=" + createtime + "]";
	}


}
