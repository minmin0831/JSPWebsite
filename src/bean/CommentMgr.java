package bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class CommentMgr {
	private DBConnectionMgr pool = new DBConnectionMgr();
	
	public CommentMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public void deleteComment(HttpServletRequest request) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = pool.getConnection();
			
			String sql = "DELETE FROM tblcomment WHERE comNum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(request.getParameter("comNum")));
			pstmt.executeUpdate();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt);
		}
	}//public void deleteComment(HttpServletRequest request)
	
	public CommentBean getComment(int comNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CommentBean bean = new CommentBean();
		
		try {
			con = pool.getConnection();
			
			String sql = "SELECT * FROM tblComment WHERE comNum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, comNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bean.setComNum(rs.getInt("comNum"));
				bean.setComContent(rs.getString("comContent"));
				bean.setListNum(rs.getInt("listNum"));
				bean.setRef(rs.getInt("ref"));
				bean.setPos(rs.getInt("pos"));
				bean.setId(rs.getString("id"));
				bean.setComDate(rs.getString("comDate"));
			}
			
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return bean;
	}//public CommentBean getComment(int comNum)
	
	public Vector<CommentBean> getCommentList(int num){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector<CommentBean> vlist = new Vector<CommentBean>();
		
		try {
			con = pool.getConnection();
			
			String sql = "SELECT * FROM tblComment WHERE listNum = ? "
					+ "ORDER BY ref ASC, pos DESC";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				CommentBean bean = new CommentBean();
				bean.setComNum(rs.getInt("comNum"));
				bean.setComContent(rs.getString("comContent"));
				bean.setListNum(rs.getInt("listNum"));
				bean.setRef(rs.getInt("ref"));
				bean.setPos(rs.getInt("pos"));
				bean.setId(rs.getString("id"));
				bean.setComDate(rs.getString("comDate"));
				vlist.add(bean);
			}
			
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}//public Vector<CommentBean> getCommentList(int num)
	
	public void insertComment(HttpServletRequest request) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			
			String sql = null;
			int ref = 0;
			if(request.getParameter("ref") == null) {
				sql = "SELECT MAX(comNum) FROM tblComment";
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					ref = rs.getInt(1) + 1;
				}
			} else {
				ref = Integer.parseInt(request.getParameter("ref"));
				sql = "UPDATE tblComment SET pos = pos + 1 WHERE ref = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.executeUpdate();
			}//if(request.getParameter("ref") == null)
			
			sql = "INSERT tblComment"
					+ "(comContent, listNum, ref, pos, id, comDate) "
					+ "VALUES(?, ?, ?, 0, ?, NOW())";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, request.getParameter("comContent"));
			pstmt.setInt(2, Integer.parseInt(request.getParameter("listNum")));
			pstmt.setInt(3, ref);
			pstmt.setString(4, request.getParameter("id"));
			pstmt.executeUpdate();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt);
		}
	}//public void insertComment(HttpServletRequest request)
	
	public void updateComment(HttpServletRequest request) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = pool.getConnection();
			
			String sql = "UPDATE tblcomment SET comContent = ? WHERE comNum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, request.getParameter("comContent"));
			pstmt.setInt(2, Integer.parseInt(request.getParameter("comNum")));
			pstmt.executeUpdate();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con, pstmt);
		}
	}//public void updateComment(HttpServletRequest request)
}
