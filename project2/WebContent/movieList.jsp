<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%@page import="com.mysql.jdbc.*"%>
<%@page import="java.util.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Showing Results</title>
<!-- DataTables CSS -->
<link rel="stylesheet" type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css">
 
<!-- jQuery -->
<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.2.min.js"></script>
 
<!-- DataTables -->
<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>	

<link rel='stylesheet' href='/project2/styles.css' type='text/css' media='all'/>
<style>
	#ml .container h1{
		display: inline-block;
	 	border: 1px solid #9C9C9C;
		background-color: #EAEAEA;
	}
</style>

</head>
<body>
<div id = "ml">
	<div class = "container">
		<h1 style="color:#17A2B8;">Results</h1>
	</div>
</div>

<table border="2" id = movielist>
<thead>
<tr>
   <th>Title</th>
   <th>Year</th>
   <th>Director</th>
   <th>Genres List</th>
   <th>Stars List</th>
   <th>Movie ID</th>
   <th>Add to Cart</th>
</tr>
</thead>
<tbody>
<%
try
{
	String loginUser = "root";
	String loginPasswd = "MySQLPassword123";
	String loginUrl = "jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false";

	String title = request.getParameter("title");
	String year = request.getParameter("year");
	String director = request.getParameter("director");
	String starName = request.getParameter("starName"); 
	        
	if (title.equals("") && year.equals("") && director.equals("") && starName.equals(""))
	{
		response.sendRedirect("search.html");
		return;
	}
	
	Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
    
    String query = "Select m.id, m.title, m.year, m.director, GROUP_CONCAT(DISTINCT(g.name)) AS genres_list, GROUP_CONCAT(DISTINCT(s.name)) AS stars_list "
    		+ "from movies as m "
    		+ "inner join genres_in_movies as gm on gm.movieId = m.id "
    		+ "inner join genres as g on g.id = gm.genreId "
    		+ "inner join stars_in_movies as sm on m.id = sm.movieId "
    		+ "inner join stars as s on s.id = sm.starId ";
    
    boolean first = true;
    
    if (!title.equals(""))
    {
    	query += "where m.title like ? ";
    	first = false;
    }
    if (!year.equals(""))
    {
    	if (first)
    	{
    		query += "where m.year = ? ";
    		first = false;
    	}
    	else
    	{
    		query += "and m.year = ? ";
    	}
    }
    if (!director.equals(""))
    {
    	if (first)
    	{
    		query += "where m.director like ? ";
    		first = false;
    	}
    	else
    	{
    		query += "and m.director like ? ";
    	}
    }
    if (!starName.equals(""))
    {
    	if (first)
    	{
    		query += "where s.name like ? ";
    		first = false;
    	}
    	else
    	{
    		query += "and s.name like ? ";
    	}
    }
    	        
    query += "group by m.title;"; 
    PreparedStatement statement = dbcon.prepareStatement(query);
    
    int count = 0;
    
    if (!title.equals(""))
    {
    	count++;
    	statement.setString(count, "%" + title + "%");
    }
    
    if (!year.equals(""))
    {
    	count++;
    	statement.setString(count, year);
    }
   
    if (!director.equals(""))
    {
    	count++;
        statement.setString(count, "%" + director + "%");

    }
    
    if (!starName.equals(""))
	{
    	count++;
    	statement.setString(count, "%" + starName + "%");
	}
    
    ResultSet rs = statement.executeQuery();
    
    if (!rs.next())
    {
    	response.getWriter().println("<script type=\"text/javascript\">");
   		response.getWriter().println("alert('There are no movies with this information, please try again.');");
   		response.getWriter().println("location='search.html';");
   		response.getWriter().println("</script>");
    }
   
   rs.beforeFirst();
    
    while (rs.next()){
		String mId = rs.getString("id");
		String mTitle = rs.getString("title");
		String mYear = rs.getString("year");
		String mDirector = rs.getString("director");
		String genres_list = rs.getString("genres_list");
		String stars_list = rs.getString("stars_list");
		%>
		
		<tr>
		<td>
		<%
			String titleLink = "<a href='singlemovie.jsp?title=" + mTitle + "'>" + mTitle + "</a>";
		%>
		 <%=titleLink%>
		</td>
		
		<td>
		<%=mYear %>
		</td>
		
		<td>
		<%=mDirector %>
		</td>
		
		<td>
		<%=genres_list %>
		</td>
		
		<td>
		<%
			String toPrint = "";
			List<String> starsNames = Arrays.asList(stars_list.split("\\s*,\\s*"));
			for (int i = 0; i < starsNames.size(); i++)
			{
				if (i != starsNames.size() - 1)
					toPrint += ("<a href = 'singlestar.jsp?starName=" + starsNames.get(i) + "'> " + starsNames.get(i) + ", </a>");
				else
					toPrint += ("<a href = 'singlestar.jsp?starName=" + starsNames.get(i) + "'> " + starsNames.get(i) + " </a>");
			}
		%>
		<%=toPrint %>
		</td>
		
		<td>
		<%=mId %>
		</td>
		
		<td>
			<form action= "AddToShoppingCart.jsp">
				<input type="hidden" name="movie" value="<%=mTitle %>" />
			 	<input type="submit" value="Add to Cart">
			</form>
		</td>
		
		</tr>
		
<% 
    }
}
catch(InstantiationException | IllegalAccessException | ClassNotFoundException e)
{
	// TODO Auto-generated catch block
	e.printStackTrace();
}
catch (SQLException e)
{
	// TODO Auto-generated catch block
	e.printStackTrace();
}
%>
</tbody>

</table>

<div style="position:relative;float: right;bottom:0px;right:0px;" >
	<a href="index.html" title="back">
	  		<button class="btn btn-light">Back To Main Page</button>
	</a>
	<a href="ShoppingCart" title="Checkout">
	   		<button class="btn btn-light" >Checkout</button>
	</a>
	<a href = "logout.jsp">
		<button class = "btn btn-light">Logout</button>
	</a>
</div>

<script>
       $(function () {
           $('#movielist').dataTable({
        	   "bFilter": false
           });
       });
</script>


</body>

</html>