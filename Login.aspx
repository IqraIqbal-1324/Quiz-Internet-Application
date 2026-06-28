<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="IADLAB08_QuizApplication.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #eef4f8, #f8fafc);
        }

        .wrapper {
            width: 100%;
            display: flex;
            justify-content: center;
            margin-top: 90px;
        }

        .login-box {
            background: white;
            padding: 35px 40px;
            border-radius: 14px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
            width: 360px;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #1f3a5f;
        }

        label {
            font-weight: 600;
            color: #34495e;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 11px;
            margin-top: 6px;
            margin-bottom: 16px;
            border: 1px solid #b9c8d3;
            border-radius: 8px;
            font-size: 14px;
        }

        input:focus {
            outline: none;
            border-color: #2e86c1;
            box-shadow: 0 0 0 3px rgba(46,134,193,0.15);
        }

        .btn {
            width: 100%;
            background: #2e86c1;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
        }

        .btn:hover {
            background: #21618c;
        }

        .message {
            text-align: center;
            margin-top: 12px;
            color: red;
            font-weight: bold;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <div class="wrapper">

        <div class="login-box">

            <h2>Quiz System Login</h2>

            <label>Username</label>
            <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>

            <label>Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>

            <asp:Button ID="btnLogin" runat="server" Text="Login"
                CssClass="btn" OnClick="btnLogin_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>

        </div>

    </div>

</form>

</body>
</html>