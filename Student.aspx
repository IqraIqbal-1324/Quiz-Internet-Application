<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Student.aspx.cs" Inherits="IADLAB08_QuizApplication.Student" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Student Quiz</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #eef4f8, #f8fafc);
        }

        .page-wrapper {
            display: flex;
            justify-content: center;
            padding: 40px 20px;
        }

        .container {
            width: 100%;
            max-width: 1000px;
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        h2 {
            text-align: center;
            color: #1f3a5f;
            margin-top: 0;
        }

        h3 {
            color: #1f3a5f;
            margin-top: 25px;
            border-bottom: 2px solid #7fb3d5;
            padding-bottom: 8px;
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

        .welcome {
            color: green;
            font-weight: bold;
        }

        label {
            font-weight: 600;
            color: #34495e;
        }

        select {
            width: 100%;
            height: 42px;
            padding: 9px 12px;
            border-radius: 8px;
            border: 1px solid #b9c8d3;
            margin-top: 7px;
            margin-bottom: 14px;
            box-sizing: border-box;
            font-size: 15px;
            background: white;
        }

        .btn {
            background: #2e86c1;
            color: white;
            border: none;
            padding: 10px 22px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn:hover {
            background: #21618c;
        }

        .quiz-box {
            border: 1px solid #d9e4ec;
            padding: 18px;
            border-radius: 10px;
            background: #f9fcff;
            margin-top: 15px;
        }

        .result-box {
            background: #ecf9f0;
            border: 1px solid #2ecc71;
            padding: 20px;
            border-radius: 10px;
            margin-top: 22px;
        }

        .message {
            display: block;
            text-align: center;
            margin-top: 18px;
            font-weight: bold;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 14px;
        }

        th {
            background: #2c3e50;
            color: white;
            padding: 11px;
            text-align: left;
        }

        td {
            padding: 10px;
            border-bottom: 1px solid #e5e9ef;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

<div class="page-wrapper">
<div class="container">

    <h2>Student Quiz</h2>

    <div class="topbar">
        <asp:Label ID="lblWelcome" runat="server" CssClass="welcome"></asp:Label>

        <asp:Button ID="btnLogout" runat="server" Text="Logout"
            CssClass="btn" OnClick="btnLogout_Click" />
    </div>

    <label>Choose Subject</label>
    <asp:DropDownList ID="ddlSubject" runat="server">
        <asp:ListItem Text="C#" Value="C#"></asp:ListItem>
        <asp:ListItem Text="ASP.NET" Value="ASP.NET"></asp:ListItem>
        <asp:ListItem Text="SQL" Value="SQL"></asp:ListItem>
        <asp:ListItem Text="HTML" Value="HTML"></asp:ListItem>
    </asp:DropDownList>

    <asp:Button ID="btnStartQuiz" runat="server" Text="Start Quiz"
        CssClass="btn" OnClick="btnStartQuiz_Click" />

    <asp:Panel ID="pnlQuiz" runat="server" Visible="false">

        <h3>Quiz Questions</h3>

        <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
            <ItemTemplate>
                <div class="quiz-box">

                    <b><%# Container.ItemIndex + 1 %>. <%# Eval("QuestionText") %></b>

                    <asp:HiddenField ID="hfQuestionID" runat="server" Value='<%# Eval("QuestionID") %>' />
                    <asp:HiddenField ID="hfCorrectOption" runat="server" Value='<%# Eval("CorrectOption") %>' />

                    <asp:HiddenField ID="hfOptionA" runat="server" Value='<%# Eval("OptionA") %>' />
                    <asp:HiddenField ID="hfOptionB" runat="server" Value='<%# Eval("OptionB") %>' />
                    <asp:HiddenField ID="hfOptionC" runat="server" Value='<%# Eval("OptionC") %>' />
                    <asp:HiddenField ID="hfOptionD" runat="server" Value='<%# Eval("OptionD") %>' />

                    <br /><br />
                    <asp:RadioButtonList ID="rblOptions" runat="server"></asp:RadioButtonList>

                </div>
            </ItemTemplate>
        </asp:Repeater>

        <br />

        <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz"
            CssClass="btn" OnClick="btnSubmitQuiz_Click" />

    </asp:Panel>

    <asp:Label ID="lblResult" runat="server" CssClass="message"></asp:Label>

    <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="result-box">

        <h3>Quiz Result</h3>

        <asp:Label ID="lblScoreDetails" runat="server"></asp:Label>

        <br /><br />

        <asp:GridView ID="gvReview" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                <asp:BoundField DataField="SelectedOption" HeaderText="Your Answer" />
                <asp:BoundField DataField="CorrectOption" HeaderText="Correct Answer" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>

    </asp:Panel>

</div>
</div>

</form>
</body>
</html>