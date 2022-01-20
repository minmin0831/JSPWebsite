package bean;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class BoardMgr {

	private static final String SAVEFOLDER = "C:/Users/mssn8/Desktop/JSP Project/Github/JSPWebsite/WebContent/fileupload"; 
	private static final int MAXSIZE = 5 * 1024 * 1024;
	private static final String ENCTYPE = "utf-8";
	
	private DBConnectionMgr pool = new DBConnectionMgr();
	
	public BoardMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public int getTotalCount() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int totalCount = 0;
		
		try {
			con = pool.getConnection();
			String sql = "SELECT COUNT(num) FROM tblboard";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				totalCount = rs.getInt(1);
			}
			
			rs.close();
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
		
		return totalCount;
	}//public int getTotalCount() 
	
	public Vector<BoardBean> getBoardList(
			String keyField, String keyWord, int start, int end){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		Vector<BoardBean> vlist = new Vector<BoardBean>();
		
		try {
			con = pool.getConnection();
			
			if(keyWord.equals("null") || keyWord.equals("")) {
				String sql = "SELECT * FROM tblboard ORDER BY ref DESC, pos LIMIT ?, ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
			} else {
				String sql = "SELECT * FROM tblboard WHERE "+ keyField +" LIKE ? "
						+ "ORDER BY ref DESC, pos LIMIT ?, ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%"+ keyWord +"%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardBean bean = new BoardBean();
				bean.setNum(rs.getInt("num"));
				bean.setSubject(rs.getString("subject"));
				bean.setName(rs.getString("name"));
				bean.setDepth(rs.getInt("depth"));
				bean.setRegdate(rs.getString("regdate"));
				bean.setCount(rs.getInt("count"));
				vlist.add(bean);
			}
			
			rs.close();
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
		
		return vlist;
	}//public Vector<BoardBean> getBoardList()

	public void insertBoard(HttpServletRequest req) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		MultipartRequest multi = null;
		
		try {
			con = pool.getConnection();
			
			//ref�� num�� �����ϰ� ��ġ��Ű��
			String sql = "SELECT MAX(num) FROM tblboard";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			int ref = 1;
			if(rs.next()) {
				ref = rs.getInt(1) + 1;
			}
			
			
			multi = new MultipartRequest(
					req, SAVEFOLDER, MAXSIZE, ENCTYPE, 
					new DefaultFileRenamePolicy());

			
			String filename = null;
			int filesize = 0;
			if(multi.getFilesystemName("filename") != null) {
				filename = multi.getFilesystemName("filename");
				filesize = (int)multi.getFile("filename").length();
			}
			
			
			String content = multi.getParameter("content");
			if(multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
				content = UtilMgr.replace(content, "<", "&lt");
			}
			
			
			sql = "insert tblBoard(name, subject, content, pos, ref, "
					+ "depth, regdate, pass, ip, count, "
					+ "filename, filesize, id) "
					+ "values(?, ?, ?, 0, ?, "
					+ "0 , now(), ?, ?, 0, "
					+ "?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, multi.getParameter("name"));
			pstmt.setString(2, multi.getParameter("subject"));
			pstmt.setString(3, content);
			pstmt.setInt(4, ref);
			pstmt.setString(5, multi.getParameter("pass"));
			pstmt.setString(6, multi.getParameter("ip"));
			pstmt.setString(7, filename);
			pstmt.setInt(8, filesize);
			pstmt.setString(9, multi.getParameter("id"));
			pstmt.executeUpdate();
			
			rs.close();
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
	}//public void insertBoard
	
	public void upCount(int num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = pool.getConnection();
			String sql = "UPDATE tblBoard SET count = count + 1 WHERE num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
	}//public void upCount(int num)
	
	public BoardBean getBoard(int num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		BoardBean bean = new BoardBean();
		
		try {
			con = pool.getConnection();
			String sql = "SELECT * FROM tblboard WHERE num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				bean.setNum(rs.getInt("num"));
				bean.setName(rs.getString("name"));
				bean.setSubject(rs.getString("subject"));
				bean.setContent(rs.getString("content"));
				bean.setPos(rs.getInt("pos"));
				bean.setRef(rs.getInt("ref"));
				bean.setDepth(rs.getInt("depth"));
				bean.setRegdate(rs.getString("regdate"));
				bean.setPass(rs.getString("pass"));
				bean.setIp(rs.getString("ip"));
				bean.setCount(rs.getInt("count"));
				bean.setFilename(rs.getString("filename"));
				bean.setFilesize(rs.getInt("filesize"));
				bean.setId(rs.getString("id"));
			}
			
			rs.close();
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
		
		return bean;
	}//public BoardBean getBoard(int num)
	
	public void downLoad(HttpServletRequest req, HttpServletResponse res, 
			JspWriter out, PageContext pageContext) {
		
		try {
			req.setCharacterEncoding("utf-8");
			String filename = req.getParameter("filename"); 
			String orgfilename = req.getParameter("filename"); 
			
			InputStream ins = null;
			OutputStream outs = null;
			File file = null;
			boolean skip = false;
			String client = "";
			
			try {
				file = new File(SAVEFOLDER +"/", filename);
				ins = new FileInputStream(file);
			} catch (FileNotFoundException e) {
				skip = true;
			}
			
			client = req.getHeader("User-Agent");
			
			res.reset();
			res.setContentType("application/octet-stream");
			res.setHeader("Content-Description", "JSP Generated Data");
			
			if(!skip) {
				if(client.indexOf("MSIE") != -1) {
					res.setHeader("Content-Disposition", 
							"attachment; filename="
							+ new String(orgfilename.getBytes("KSC5601"),"ISO8859_1"));
				} else {
					orgfilename = new String(orgfilename.getBytes("utf-8"),"iso-8859-1");
					res.setHeader("Content-Disposition", "attachment; filename=\""
							+ orgfilename +"\"");
					res.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
				}
				
				res.setHeader("Content-Length", ""+file.length());
				
				outs = res.getOutputStream();
				byte[] b = new byte[(int)file.length()];
				int leng = 0;
				
				while((leng = ins.read(b)) > 0) {
					outs.write(b, 0, leng);
				}
			} else {
				res.setContentType("text/html; charset=utf-8");
				out.println("<script>alert('������ ã�� �� �����ϴ�'); history.back();</script>");
			}
			
			ins.close();
			outs.close();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
			
			
	}//public void downLoad()

	public void updateBoard(BoardBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = pool.getConnection();
			String sql = "UPDATE tblBoard SET name=?, subject=?, content=?, ip=? where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getName());
			pstmt.setString(2, bean.getSubject());
			pstmt.setString(3, bean.getContent());
			pstmt.setString(4, bean.getIp());
			pstmt.setInt(5, bean.getNum());
			pstmt.executeUpdate();
			
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
	}//public void updateBoard(BoardBean bean)

	public void deleteBoard(int num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			//÷�� ���� ����
			String sql = "SELECT filename FROM tblBoard WHERE num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				String filename = rs.getString("filename");
			
				if(filename != null && !filename.equals("")) {
					String path = SAVEFOLDER +"/"+ filename;
					File file = new File(path);
					if(file.exists()) {
						UtilMgr.delete(path);
					}
				}
			}
			
			//���ڵ� ����
			sql = "DELETE FROM tblBoard WHERE num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
	}//public void deleteBoard(int num)

	public void replyUpBoard(int ref, int pos) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = pool.getConnection();
			String sql = "UPDATE tblBoard SET pos = pos + 1 WHERE ref = ? AND pos > ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, ref);
			pstmt.setInt(2, pos);
			pstmt.executeUpdate();
			
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
	}//public void replyUpBoard(int ref, int pos)
	
	public void replyBoard(BoardBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = pool.getConnection();
			String sql = "INSERT tblBoard(name, subject, content, pos, ref, "
					+ "depth, regdate, pass, ip, count, id) "
					+ "values(?, ?, ?, ?, ?, "
					+ "? , now(), ?, ?, 0, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getName());
			pstmt.setString(2, bean.getSubject());
			pstmt.setString(3, bean.getContent());
			pstmt.setInt(4, bean.getPos() + 1);
			pstmt.setInt(5, bean.getRef());
			pstmt.setInt(6, bean.getDepth() + 1);
			pstmt.setString(7, bean.getPass());
			pstmt.setString(8, bean.getIp());
			pstmt.setString(9, bean.getId());
			pstmt.executeUpdate();
			
			pstmt.close();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(con);
		}
	}//public void replyBoard(BoardBean bean)
}
