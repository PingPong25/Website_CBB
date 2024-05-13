<%@page import="java.util.List"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="domain.Cart" %>
<%@ page import="domain.Product" %>
<%@ page import="da.ProductDA" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  
    ProductDA da = new ProductDA();
    DecimalFormat dcf = new DecimalFormat("#.##");
    request.setAttribute("dcf", dcf);
    double totalAmount = 0;
    ArrayList<Cart> cartList = (ArrayList<Cart>) session.getAttribute("cart-list");
    List<Cart> cartProduct = null;
    if (cartList != null) {
        cartProduct = da.getCartProducts(cartList);
        double subtotal = da.getSubtotal(cartList);
        double tax = da.getTaxPrice(cartList, 0.06);
        double ship = da.getShippingPrice(cartList, 0.06);
        double total = da.getTotalPrice(cartList, 0.06);
        totalAmount = total;
        session.setAttribute("totalAmount", total);
        request.setAttribute("cartList", cartList);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("tax", tax);
        request.setAttribute("ship", ship);
        request.setAttribute("total", total);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cart</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="CSS/All.css" rel="stylesheet" type="text/css"/>
    <link href="CSS/managerCss.css" rel="stylesheet" type="text/css"/>
    <style>
        .footer {
            position: fixed;
            bottom: 0;
            width: 100%;
            height: 50px;
            background-color: #f5f5f5;
            text-align: center;
            line-height: 50px;
        }

        table {
            margin: 0 auto;
        }

        table {
            border-collapse: collapse;
            width: 80%;
        }

        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .blue-button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer; 
            border-radius: 5px;
            font-size: 16px;
            margin-left: 70%;
            margin-top: 1%;
        }

        /* Hover effect */
        .blue-button:hover {
            background-color: #0056b3; 
        }

    </style>
</head>
<body>
    <%@ include file="HeaderNFooter/HeaderAfterLogin_Manager.jsp" %>
    <h1 style="text-align:center;">Cart</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Product Description</th>
                <th>Product Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
                <th>Cancel</th>
            </tr>
        </thead>
        <tbody>
            
                
                    <%
                if(cartList != null){
                    for(Cart c:cartProduct){%>
                        <tr>
                            <td><%=c.getPID()%></td>
                            <td><%=c.getName()%></td>
                            <td><%=c.getDesc()%></td>
                            <td><%=da.getProduct(c.getPID()).getPrice()%></td>

                            <td>
                                <a href="ProductQuantity_Emp?action=dec&PID=<%=c.getPID()%>">
                                    <img src="photo/minus.png" alt="Decrement Quantity" style="width: 20px; height: 20px;">
                                </a>
                                <input type="text" name="quantity" value="<%=c.getQuantity()%>" readonly>
                                <a href="ProductQuantity_Emp?action=inc&PID=<%=c.getPID()%>">
                                    <img src="photo/plus.png" alt="Increment Quantity" style="width: 20px; height: 20px;">
                                </a>
                            </td>
                            <td><%=dcf.format(c.getPrice())%></td>
                            <td><a href="RemoveFromCart_Emp?PID=<%=c.getPID()%>">Remove</a></td>
                        </tr>
                    <%}
                }
                    %>

            <tr>
                <td colspan="6" align="left">Subtotal (RM):</td>
                <td>${(subtotal>0)?dcf.format(subtotal):0}</td>
            </tr>
            <tr>
                <td colspan="6" align="left">Sales Tax (RM):</td>
                <td>${(tax>0)?dcf.format(tax):0}</td>
            </tr>
            <tr>
                <td colspan="6" align="left">Shipping Cost (RM):</td>
                <td>${(ship>0)?dcf.format(ship):0}</td>
            </tr>
            <tr>
                <td colspan="6" align="left">Total Price (RM):</td>
                <td>${(total>0)?dcf.format(total):0}</td>
            </tr>
        </tbody>
    </table>
                <form action="CartServlet_Emp" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="total" value="<%=session.getAttribute("totalAmount")%>">
                    <button type="submit" class="blue-button">Proceed to Checkout</button>
                </form>

    <div class="footer">
        <%@ include file= "HeaderNFooter/Footer.jsp"%>
    </div>
</body>
</html>