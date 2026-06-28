<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="IADLAB08_QuizApplication.Admin" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Dashboard</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #eef4f8, #f8fafc);
            color: #1f2d3d;
        }

        .container {
            width: 92%;
            max-width: 1250px;
            margin: 28px auto;
            background: #ffffff;
            padding: 28px 34px;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(44, 62, 80, 0.12);
        }

        h2 {
            text-align: center;
            margin: 0;
            color: #1f3a5f;
            font-size: 32px;
        }

        h3 {
            margin-top: 0;
            margin-bottom: 18px;
            color: #1f3a5f;
            font-size: 22px;
            border-bottom: 2px solid #7fb3d5;
            padding-bottom: 10px;
        }

        .welcome {
            display: block;
            text-align: center;
            color: #1e8449;
            font-weight: bold;
            margin: 8px 0 22px;
            font-size: 17px;
        }

        .topbar {
            background: #f4f8fb;
            border: 1px solid #d8e6ef;
            padding: 14px 18px;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .box {
            border: 1px solid #d9e4ec;
            padding: 24px;
            border-radius: 14px;
            background: #fbfdff;
            margin-bottom: 26px;
        }

        .row {
            display: flex;
            gap: 18px;
            align-items: end;
            flex-wrap: wrap;
        }

        .col {
            flex: 1;
            min-width: 220px;
        }

        label {
            font-weight: 600;
            color: #34495e;
        }

        input[type="text"], input[type="password"], select {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #b9c8d3;
            border-radius: 9px;
            box-sizing: border-box;
            margin-top: 7px;
            font-size: 15px;
            background: white;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #2e86c1;
            box-shadow: 0 0 0 3px rgba(46, 134, 193, 0.12);
        }

        .btn {
            background: #2e86c1;
            color: white;
            border: none;
            padding: 11px 24px;
            border-radius: 9px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
        }

        .btn:hover {
            background: #21618c;
        }

        .btn-delete {
            background: #c0392b;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-delete:hover {
            background: #922b21;
        }

        .message {
            display: block;
            text-align: center;
            font-weight: bold;
            margin-top: 14px;
        }

        .grid {
            width: 100%;
            margin-top: 14px;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .grid th {
            background: #2c3e50;
            color: white;
            padding: 13px;
            text-align: left;
        }

        .grid td {
            padding: 12px 13px;
            border-bottom: 1px solid #e5e9ef;
        }

        .grid tr:nth-child(even) {
            background: #f7fafc;
        }

        .grid tr:hover {
            background: #edf6fb;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

<div class="container">

    <h2>Admin Dashboard</h2>
    <asp:Label ID="lblWelcome" runat="server" CssClass="welcome"></asp:Label>

    <div class="topbar">
        <strong>Quiz Application Control Panel</strong>
        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn" OnClick="btnLogout_Click" />
    </div>

    <div class="box">
        <h3>Add New User</h3>

        <div class="row">
            <div class="col">
                <label>Username:</label>
                <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
            </div>

            <div class="col">
                <label>Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
            </div>

            <div class="col">
                <label>Role:</label>
                <asp:DropDownList ID="ddlRole" runat="server">
                    <asp:ListItem Text="Teacher" Value="Teacher"></asp:ListItem>
                    <asp:ListItem Text="Student" Value="Student"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col" style="flex:0.45;">
                <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn" OnClick="btnAddUser_Click" />
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
    </div>

    <div class="box">
        <h3>Manage Teachers and Students</h3>

        <asp:GridView ID="gvUsers" runat="server"
            AutoGenerateColumns="False"
            CssClass="grid"
            DataKeyNames="UserID"
            OnRowDeleting="gvUsers_RowDeleting">

            <Columns>
                <asp:BoundField DataField="UserID" HeaderText="User ID" />
                <asp:BoundField DataField="Username" HeaderText="Username" />
                <asp:BoundField DataField="Role" HeaderText="Role" />

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete"
                            CommandName="Delete"
                            CssClass="btn-delete"
                            OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <div class="box">
        <h3>All Student Results</h3>

        <asp:GridView ID="gvResults" runat="server" CssClass="grid" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="Username" HeaderText="Student" />
                <asp:BoundField DataField="Title" HeaderText="Quiz" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:BoundField DataField="TotalMarks" HeaderText="Total Marks" />
                <asp:BoundField DataField="AttemptDate" HeaderText="Date" />
            </Columns>
        </asp:GridView>
    </div>

    <div class="box">
        <h3>Student Wise Statistics</h3>

        <label>Select Student:</label>
        <asp:DropDownList ID="ddlStudents" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStudents_SelectedIndexChanged"></asp:DropDownList>

        <br /><br />

        <asp:Label ID="lblStudentStats" runat="server" Font-Bold="true"></asp:Label>

        <asp:GridView ID="gvStudentStats" runat="server" CssClass="grid" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="Title" HeaderText="Quiz" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:BoundField DataField="TotalMarks" HeaderText="Total Marks" />
                <asp:BoundField DataField="AttemptDate" HeaderText="Date" />
            </Columns>
        </asp:GridView>
    </div>

</div>

</form>
</body>
</html>