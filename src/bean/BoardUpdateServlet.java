package bean;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class BoardUpdateServlet
 */
@WebServlet("/boardUpdate")
public class BoardUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		
		BoardMgr bMgr = new BoardMgr();
		BoardBean bean = (BoardBean)session.getAttribute("bean");
		//String nowPage = request.getParameter("nowPage");
		
		BoardBean upBean = new BoardBean();
		upBean.setNum(Integer.parseInt(request.getParameter("num")));
		upBean.setName(request.getParameter("name"));
		upBean.setSubject(request.getParameter("subject"));
		upBean.setContent(request.getParameter("content"));
		upBean.setPass(request.getParameter("pass"));
		upBean.setIp(request.getParameter("ip"));
		
		String upPass = upBean.getPass();
		String inPass = bean.getPass();
		if(upPass.equals(inPass)) {
			bMgr.updateBoard(upBean);
			int nowPage = Integer.parseInt(request.getParameter("nowPage"));
			String url = "index.jsp?article=./board/read.jsp&num="
					+ upBean.getNum() +"&nowPage="+ nowPage;
			response.sendRedirect(url);
		} else {
			out.println("<script>");
			out.println("alert('�Է��Ͻ� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.');");
			out.println("history.back();");
			out.println("</script>");
		}
	}

}
