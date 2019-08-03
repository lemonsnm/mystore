package cn.itcast.estore.entity;

/**
 * 收藏夹表
 * 
 * @author lemonSun
 *
 *         2019年6月13日下午4:39:24
 */
public class Favorite {
	private Integer uid;
	private Integer gid;
	
	
	/*
	 * 收藏项和商品的关系？
	 * 收藏项 ===> 商品      1:1
	 * 商品 ====> 收藏项  1:n
	 * 当前是收藏项对象，因此可以在该对象中添加商品对象的引用
	 */
	private Goods goods;
	
	public Goods getGoods() {
		return goods;
	}

	public void setGoods(Goods goods) {
		this.goods = goods;
	}

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

	@Override
	public String toString() {
		return "Favorite [uid=" + uid + ", gid=" + gid + ", goods=" + goods + "]";
	}


	

}
