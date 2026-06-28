<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Teacher.aspx.cs" Inherits="IADLAB08_QuizApplication.Teacher" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Teacher Dashboard</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .container {
            width: 80%;
            margin: 30px auto;
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.15);
        }

        h2, h3 {
            text-align: center;
            color: #2c3e50;
        }

        .welcome {
            display: block;
            text-align: center;
            color: green;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            font-weight: bold;
            display: block;
            margin-bottom: 6px;
        }

        input[type="text"], textarea, select {
            width: 100%;
            padding: 9px;
            border: 1px solid #bbb;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .row {
            display: flex;
            gap: 20px;
        }

        .col {
            flex: 1;
        }

        .btn {
            background: #2980b9;
            color: white;
            border: none;
            padding: 10px 22px;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 5px;
        }

        .btn:hover {
            background: #1f6391;
        }

        .btn-delete {
            background: #c0392b;
            color: white;
            border: none;
            padding: 7px 14px;
            border-radius: 5px;
            cursor: pointer;
        }

        .message {
            display: block;
            text-align: center;
            margin-top: 15px;
            font-weight: bold;
        }

        .grid {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }

        .grid th {
            background: #2c3e50;
            color: white;
            padding: 10px;
        }

        .grid td {
            padding: 9px;
            border: 1px solid #ddd;
        }

        hr {
            margin: 30px 0;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <div class="container">

        <h2>Teacher Dashboard</h2>
        <asp:Label ID="lblWelcome" runat="server" CssClass="welcome"></asp:Label>
        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn" OnClick="btnLogout_Click" />
        <br /><br />
        <h3>Add Question</h3>

        <div class="form-group">
            <span class="form-label">Subject</span>
            <asp:DropDownList ID="ddlSubject" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSubject_SelectedIndexChanged">
                <asp:ListItem Text="C#" Value="C#"></asp:ListItem>
                <asp:ListItem Text="ASP.NET" Value="ASP.NET"></asp:ListItem>
                <asp:ListItem Text="SQL" Value="SQL"></asp:ListItem>
                <asp:ListItem Text="HTML" Value="HTML"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <span class="form-label">Question Statement</span>
            <asp:TextBox ID="txtQuestion" runat="server" TextMode="MultiLine" Rows="4"></asp:TextBox>
        </div>

        <div class="row">
            <div class="col form-group">
                <span class="form-label">Option A</span>
                <asp:TextBox ID="txtOptionA" runat="server"></asp:TextBox>
            </div>

            <div class="col form-group">
                <span class="form-label">Option B</span>
                <asp:TextBox ID="txtOptionB" runat="server"></asp:TextBox>
            </div>
        </div>

        <div class="row">
            <div class="col form-group">
                <span class="form-label">Option C</span>
                <asp:TextBox ID="txtOptionC" runat="server"></asp:TextBox>
            </div>

            <div class="col form-group">
                <span class="form-label">Option D</span>
                <asp:TextBox ID="txtOptionD" runat="server"></asp:TextBox>
            </div>
        </div>

        <div class="row">
            <div class="col form-group">
                <span class="form-label">Correct Option</span>
                <asp:DropDownList ID="ddlCorrectOption" runat="server">
                    <asp:ListItem Text="A" Value="A"></asp:ListItem>
                    <asp:ListItem Text="B" Value="B"></asp:ListItem>
                    <asp:ListItem Text="C" Value="C"></asp:ListItem>
                    <asp:ListItem Text="D" Value="D"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col form-group">
                <span class="form-label">Difficulty Level</span>
                <asp:DropDownList ID="ddlDifficulty" runat="server">
                    <asp:ListItem Text="Easy" Value="Easy"></asp:ListItem>
                    <asp:ListItem Text="Medium" Value="Medium"></asp:ListItem>
                    <asp:ListItem Text="Hard" Value="Hard"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="btn" OnClick="btnAddQuestion_Click" />

        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>

        <hr />

        <h3>Questions for Selected Subject</h3>

        <asp:GridView ID="gvQuestions" runat="server"
            AutoGenerateColumns="False"
            CssClass="grid"
            DataKeyNames="QuestionID"
            OnRowDeleting="gvQuestions_RowDeleting">

            <Columns>
                <asp:BoundField DataField="QuestionID" HeaderText="ID" />
                <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                <asp:BoundField DataField="OptionA" HeaderText="A" />
                <asp:BoundField DataField="OptionB" HeaderText="B" />
                <asp:BoundField DataField="OptionC" HeaderText="C" />
                <asp:BoundField DataField="OptionD" HeaderText="D" />
                <asp:BoundField DataField="CorrectOption" HeaderText="Correct" />
                <asp:BoundField DataField="DifficultyLevel" HeaderText="Difficulty" />

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete"
                            CommandName="Delete"
                            CssClass="btn-delete"
                            OnClientClick="return confirm('Are you sure you want to delete this question?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

    </div>

</form>
</body>
</html>