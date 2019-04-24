<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="../permission.jsp" %>
<%@page import="ge.koaladev.msy.nso.core.dto.objects.UserDTO" %>
<%@ page import="ge.koaladev.msy.nso.core.services.EventService" %>
<%@ page import="ge.koaladev.msy.nso.core.services.UsersService" %>
<%@ page import="ge.koaladev.msy.nso.database.model.Groups" %>
<%@ page import="org.springframework.beans.factory.annotation.Autowired" %>
<%@ page import="org.springframework.web.context.support.SpringBeanAutowiringSupport" %>
<%@ page import="java.util.Calendar" %>
<!DOCTYPE html>

<%!
    public void jspInit() {
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletConfig().getServletContext());
    }

    @Autowired
    private UsersService usersService;

    @Autowired
    private EventService eventService;

    double getUserBudget(HttpServletRequest httpServletRequest) {
        Calendar calendar = Calendar.getInstance();
        User user = (User) httpServletRequest.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return usersService.getUserBudgetByYear(u.getId(), calendar.get(Calendar.YEAR));
    }

    boolean isBlockedToCreateNewRequest(HttpServletRequest httpServletRequest) {
        User user = (User) httpServletRequest.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return eventService.checkIsBlockedEvent(u.getId());
    }
%>


<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <base href="${pageContext.request.contextPath}/"/>
    <link rel="stylesheet" href="resources/css/bootstrap-yeti.min.css"/>
    <link rel="stylesheet" href="resources/css/jquery-ui.css"/>
    <link rel="stylesheet" href="resources/css/style.css">
    <link rel="shortcut icon" href="resources/imgs/favicon.ico">
    <script type="text/javascript" src="resources/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="resources/js/jquery-ui.js"></script>
    <script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="resources/js/angular.min.js"></script>
    <script type="text/javascript" src="resources/js/ui-bootstrap-0.14.3.js"></script>
    <script type="text/javascript" src="resources/js/global_error_handler.js"></script>
    <script type="text/javascript" src="resources/js/global_util.js"></script>
    <script type="text/javascript" src="resources/js/misc.js"></script>
    <script type="text/javascript" src="resources/js/chart/Chart.min.js"></script>
    <script type="text/javascript" src="resources/js/chart/angular-chart.js"></script>
    <script type="text/javascript" src="resources/js/Modal.js"></script>
    <script>

        $(document).ready(function () {
            var url = window.location;
            $('.list-group a').filter(function () {
                return this.href.indexOf(url.pathname) > -1;
            }).addClass('active');
            if (url.pathname.indexOf("newRequest") > -1) {
                $('#selected_item').text("ახალი ღონისძიება");
            } else if (url.pathname.indexOf("users") > -1) {
                $('#selected_item').text("მომხმარებლები");
            } else if (url.pathname.indexOf("documents") > -1) {
                $('#selected_item').text("ანგარიშის დოკუმენტი");
            } else if (url.pathname.indexOf("feedback") > -1) {
                $('#selected_item').text("კავშირი ადმინისტრატორთან");
            } else if (url.pathname.indexOf("broadcast") > -1) {
                $('#selected_item').text("კავშირი ფედერაციებთან");
            } else if (url.pathname.indexOf("analytics") > -1) {
                $('#selected_item').text("NSO ანალიტიკა");
            }
        });
        menuCtrl = function ($scope, $http) {

        };
    </script>

</head>
<body ng-app="app">
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="row" ng-controller="menuCtrl">
                <div class="navbar navbar-inverse">
                    <div class="navbar-header ">
                        <a class="navbar-brand" href="home">NSO v.2.1.4</a>
                    </div>
                    <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                    <div class="col-md-4"><a class="navbar-brand">მიმდინარე წლის ხარჯი:
                        <span ng-cloak><%=getUserBudget(request)%></span></a>
                    </div>

                    <%}%>
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav navbar-right">
                            <li><a class="pull-right">
                                <%
                                    User user = (User) request.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
                                    UserDTO userDTO = (UserDTO) user.getUserData();
                                    out.print(userDTO.getName());
                                %>
                            </a></li>
                            <li><a href="logout">გასვლა</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-2 left-menu">
            <div class="row border-bottom-gray">
                <div class="col-md-12">
                    <h4><span class="glyphicon "></span> მენიუ</h4>
                </div>
            </div>
            <br/>
            <div class="row">
                <div class="list-group">
                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) && !isBlockedToCreateNewRequest(request)) {%>
                    <a id="hideShowNew" href="newRequest?type=details&eventId=0"
                       class="list-group-item"> ახალი ღონისძიება</a>

                    <%}%>

                    <a href="home" class="list-group-item">
                        ღონისძიებები</a>
                    <a href="history" class="list-group-item">ისტორია</a>
                    <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                    <a href="feedback" class="list-group-item"> მოგვწერეთ</a>
                    <%}%>

                    <%if (hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())|| hasPermissions(request, Groups.CHANCELLERY.getName())) {%>
                    <a href="broadcastEmail" class="list-group-item">კავშირი ფედერაციებთან</a>
                    <%}%>

                    <%if (hasPermissions(request, Groups.FEDERATION.getName())||hasPermissions(request, Groups.MANAGER.getName())||hasPermissions(request, Groups.ADMIN.getName())) {%>
                    <a href="personal" class="list-group-item">რეესტრი</a>
                    <%}%>

                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())) {%>
                    <a href="analytics" class="list-group-item"> NSO ანალიტიკა</a>
                    <%}%>

                    <%if (hasPermissions(request, Groups.ADMIN.getName())) {%>
                    <a href="users" class="list-group-item"> მომხმარებლები</a>
                    <%}%>
                </div>
            </div>
        </div>
        <div class="col-md-10">
            <div class="row border-bottom-gray">
                <div class="col-md-12">
                    <h4 id="selected_item">ღონისძიებები</h4>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">



