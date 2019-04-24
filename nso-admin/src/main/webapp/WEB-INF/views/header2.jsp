<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="permission.jsp" %>
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

    boolean hasSupervisor(HttpServletRequest httpServletRequest) {
        User user = (User) httpServletRequest.getSession().getAttribute(AuthInterceptor.CURRENT_USER);
        UserDTO u = (UserDTO) user.getUserData();
        return (u.getSupervisorId() != null && u.getSupervisorId() != 0);
    }
%>


<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <base href="${pageContext.request.contextPath}/"/>
    <link rel="shortcut icon" href="resources/imgs/faviconnew.ico">
    <link rel="stylesheet" href="resources/css/style.css">


    <%-- <script type="text/javascript" src="resources/js/bootstrap.min.js"></script>--%>

    <script type="text/javascript" src="resources/js/jquery-1.9.1.js"></script>

    <%--   <link rel="stylesheet" href="resources/css/jquery-ui.css"/>
       <script type="text/javascript" src="resources/js/jquery-ui.js"></script>--%>

    <script type="text/javascript" src="resources/js/angular.min.js"></script>
    <script type="text/javascript" src="resources/js/ui-bootstrap-0.14.3.js"></script>

    <script type="text/javascript" src="resources/js/global_error_handler.js"></script>
    <script type="text/javascript" src="resources/js/global_util.js"></script>
    <script type="text/javascript" src="resources/js/misc.js"></script>
    <script type="text/javascript" src="resources/js/chart/Chart.min.js"></script>
    <script type="text/javascript" src="resources/js/chart/angular-chart.js"></script>
    <script type="text/javascript" src="resources/js/Modal.js"></script>

    <link rel="stylesheet" href="resources/assets/plugins/bootstrap/css/bootstrap.min.css">

    <link href="resources/assets/plugins/bootstrap-material-datetimepicker/css/bootstrap-material-datetimepicker.css"
          rel="stylesheet">
    <%--    <link rel="stylesheet" href="resources/assets/plugins/bootstrap-select/css/bootstrap-select.css">--%>
    <!-- Custom Css -->
    <link rel="stylesheet" href="resources/assets/css/main2.css">
    <link rel="stylesheet" href="resources/assets/css/color_skins.css">


    <script>
        menuCtrl = function ($scope, $http) {
            function getUser(res) {
                $scope.currentUser = res.data;

                if ($scope.currentUser.supervisorId) {
                    function getSupervisor(res) {
                        $scope.supervisor = res.data;
                    }

                    ajaxCall($http, "users/get-user-by-id?userId=" + $scope.currentUser.supervisorId, {}, getSupervisor);
                }
            }

            ajaxCall($http, "users/get-user", {}, getUser);

            $scope.open = function (name) {
                if (name.indexOf('.pdf') >= 0 || name.indexOf('.jpg') >= 0 || name.indexOf('.png') >= 0) {
                    window.open('file/draw/' + name + '/');
                } else {
                    window.open('file/download/' + name + '/');
                }
            };
        };
    </script>
</head>

<body ng-app="app" class="theme-purple">
<!-- Page Loader -->
<div class="page-loader-wrapper">
    <div class="loader">
        <div class="m-t-30"><img class="zmdi-hc-spin" src="resources/assets/images/logo.svg" width="48" height="48"
                                 alt="NSO"></div>
        <p>Please wait...</p>
    </div>
</div>

<!-- Overlay For Sidebars -->
<div class="overlay"></div>

<!-- Top Bar -->
<nav class="navbar p-l-5 p-r-5">
    <ul class="nav navbar-nav navbar-left">
        <li>
            <div class="navbar-header p-t-15">
                <a href="javascript:void(0);" class="bars"></a>
                <a class="navbar-brand" href="home"><img src="resources/assets/images/logo2.svg" width="30"
                                                         alt="Nso"><span class="m-l-10">NSO</span></a>
            </div>
        </li>
        <li><a href="javascript:void(0);" class="ls-toggle-btn" data-close="true"><i class="zmdi zmdi-swap"></i></a>
        </li>
        <li><a><span class="badge bg-info">Spent money :  <%=getUserBudget(request)%></span></a></li>

        <li class="hidden-sm-down">
            <%--<div class="input-group">
                <input type="text" class="form-control" placeholder="ძიება...">
                <span class="input-group-addon">
                    <i class="zmdi zmdi-search"></i>
                </span>
            </div>--%>
        </li>
        <li class="float-right">
            <a>
                {{$scope.currentUser.name}}
            </a>
            <a href="javascript:void(0);" class="fullscreen hidden-sm-down" data-provide="fullscreen" data-close="true"><i
                    class="zmdi zmdi-fullscreen"></i></a>
            <a href="logout" class="mega-menu" data-close="true"><i class="zmdi zmdi-power"></i></a>
            <%-- <a href="javascript:void(0);" class="js-right-sidebar" data-close="true"><i
                     class="zmdi zmdi-settings zmdi-hc-spin"></i></a>--%>
        </li>
    </ul>
</nav>

<!-- Left Sidebar -->
<aside id="leftsidebar" class="sidebar" ng-controller="menuCtrl">
    <ul class="nav nav-tabs">
        <li class="nav-item">
            <a class="nav-link active" data-toggle="tab" href="#dashboard"><i class="zmdi zmdi-home m-r-5"></i>NSO</a>
        </li>
        <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
        <li class="nav-item" ng-show="currentUser.supervisorId!=0 && currentUser.supervisorId">
            <a class="nav-link" data-toggle="tab" href="#user"><i class="zmdi zmdi-account m-r-5"></i>Supervisor</a>
        </li>
        <%}%>
    </ul>
    <div class="tab-content">
        <div class="tab-pane stretchRight active" id="dashboard">
            <div class="menu">
                <ul class="list">

                    <li>
                        <div class="user-info">
                            <div class="image"><a class=" waves-effect waves-block"
                                                  ng-click="open(currentUser.url);"><img
                                    src="file/draw/{{currentUser.url}}/"
                                    alt="User"></a></div>
                            <div class="detail">
                                <h4>{{currentUser.name}}</h4>
                                <%--<small>{{currentUser.name}}</small>--%>
                            </div>
                        </div>
                    </li>


                    <li class="header">Home</li>
                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) && !isBlockedToCreateNewRequest(request)) {%>
                    <li><a id="hideShowNew" href="newRequest?type=details&eventId=0"><i
                            class="zmdi zmdi-plus"></i><span>New Application</span></a></li>

                    <%}%>

                    <li><a href="home"><i class="zmdi zmdi-home"></i><span>Applications</span></a></li>

                    <li><a href="history"><i class="zmdi zmdi-assignment"></i><span>Archived Applications</span> </a></li>

                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName()) || hasPermissions(request, Groups.CHANCELLERY.getName())) {%>
                    <li><a href="message"><i class="zmdi zmdi-comments"></i><span>Chancellery</span></a></li>
                    <%}%>

                    <%if (hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName()) || hasPermissions(request, Groups.CHANCELLERY.getName())) {%>
                    <li><a href="broadcastEmails"><i class="zmdi zmdi-email"></i><span>Communication</span> </a></li>
                    <%}%>


                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())
                            || hasPermissions(request, Groups.CHANCELLERY.getName()) || hasPermissions(request, Groups.SUPERVISOR.getName())
                            ) {%>
                    <li><a href="calendar"><i class="zmdi zmdi-calendar"></i><span>NSO Calendar</span> </a>
                    </li>
                    <%}%>

                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())) {%>
                    <li><a href="soas"><i class="zmdi zmdi-calendar"></i><span>NSO Report</span> </a>
                    </li>
                    <%}%>

                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.SUPERVISOR.getName()) || hasPermissions(request, Groups.MANAGER.getName())) {%>
                    <li><a href="analytics"><i class="zmdi zmdi-chart"></i><span>NSO Analytics</span> </a></li>
                    <%}%>

                    <%if (hasPermissions(request, Groups.FEDERATION_MANAGER.getName()) || hasPermissions(request, Groups.ADMIN.getName())) {%>
                    <li><a href="competition"><i class="zmdi zmdi-chart"></i><span>Competitions </span> </a></li>
                    <%}%>
                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.FEDERATION_MANAGER.getName()) || hasPermissions(request, Groups.ADMIN.getName())) {%>
                    <li><a href="championship"><i class="zmdi zmdi-chart"></i><span>Championships </span> </a></li>
                    <%}%>

                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.FEDERATION_MANAGER.getName()) || hasPermissions(request, Groups.MANAGER.getName()) || hasPermissions(request, Groups.ADMIN.getName())) {%>
                    <li><a href="personal"><i class="zmdi zmdi-swap-alt"></i><span>Database</span> </a></li>
                    <%}%>

                    <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                    <li><a href="feedback"><i class="zmdi zmdi-email"></i><span>Write to us</span></a></li>
                    <%}%>

                    <%if (hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())) {%>
                    <li><a href="documentsUpload"><i class="zmdi zmdi-file"></i><span>Documents</span> </a>
                    </li>
                    <%}%>
                    <%if (hasPermissions(request, Groups.FEDERATION.getName()) || hasPermissions(request, Groups.CHANCELLERY.getName())|| hasPermissions(request, Groups.SUPERVISOR.getName())) {%>
                    <li><a href="documentsView"><i class="zmdi zmdi-file"></i><span>Documents</span> </a>
                    </li>
                    <%}%>
                    <%if (hasPermissions(request, Groups.ADMIN.getName())) {%>
                    <li><a href="user"><i class="zmdi zmdi-account"></i><span>Users</span> </a>
                    </li>
                    <%}%>
                </ul>
            </div>
        </div>
        <div class="tab-pane stretchLeft" id="user">
            <div class="menu">
                <ul class="list">
                    <li>
                        <div class="user-info m-b-20 p-b-15">
                            <div class="image"><a href="profile.html" ng-click="open(supervisor.url);">
                                <img src="file/draw/{{supervisor.url}}/" alt="Image"></a>
                            </div>
                            <div class="detail">
                                <h4>{{supervisor.name}}</h4>
                                <small>{{supervisor.usersGroup.description}}</small>
                            </div>
                            <p></p>
                            <%--<a title="facebook" href="#"><i class="zmdi zmdi-facebook"></i></a>
                            <a title="twitter" href="#"><i class="zmdi zmdi-twitter"></i></a>
                            <a title="instagram" href="#"><i class="zmdi zmdi-instagram"></i></a>--%>
                            <p class="text-muted">{{supervisor.address}}</p>
                            <%-- <div class="row">
                                 <div class="col-4">
                                     <h5 class="m-b-5">852</h5>
                                     <small>Following</small>
                                 </div>
                                 <div class="col-4">
                                     <h5 class="m-b-5">13k</h5>
                                     <small>Followers</small>
                                 </div>
                                 <div class="col-4">
                                     <h5 class="m-b-5">234</h5>
                                     <small>Post</small>
                                 </div>
                             </div>--%>
                        </div>
                    </li>
                    <li>
                        <small class="text-muted">Email:</small>
                        <p>{{supervisor.email}}</p>
                        <hr>
                        <small class="text-muted">Phone:</small>
                        <p>{{supervisor.phone}}</p>
                        <hr>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</aside>

<!-- Right Sidebar -->
<aside id="rightsidebar" class="right-sidebar">
    <ul class="nav nav-tabs">
        <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#setting"><i
                class="zmdi zmdi-settings zmdi-hc-spin"></i></a></li>
        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#chat"><i class="zmdi zmdi-comments"></i></a>
        </li>
        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#activity">Activity</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane slideRight active" id="setting">
            <div class="slim_scroll">
                <div class="card">
                    <h6>General Settings</h6>
                    <ul class="setting-list list-unstyled">
                        <li>
                            <div class="checkbox">
                                <input id="checkbox1" type="checkbox">
                                <label for="checkbox1">Report Panel Usage</label>
                            </div>
                        </li>
                        <li>
                            <div class="checkbox">
                                <input id="checkbox2" type="checkbox" checked="">
                                <label for="checkbox2">Email Redirect</label>
                            </div>
                        </li>
                        <li>
                            <div class="checkbox">
                                <input id="checkbox3" type="checkbox" checked="">
                                <label for="checkbox3">Notifications</label>
                            </div>
                        </li>
                        <li>
                            <div class="checkbox">
                                <input id="checkbox4" type="checkbox" checked="">
                                <label for="checkbox4">Auto Updates</label>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="card">
                    <h6>Skins</h6>
                    <ul class="choose-skin list-unstyled">
                        <li data-theme="purple" class="active">
                            <div class="purple"></div>
                        </li>
                        <li data-theme="blue">
                            <div class="blue"></div>
                        </li>
                        <li data-theme="cyan">
                            <div class="cyan"></div>
                        </li>
                        <li data-theme="green">
                            <div class="green"></div>
                        </li>
                        <li data-theme="orange">
                            <div class="orange"></div>
                        </li>
                        <li data-theme="blush">
                            <div class="blush"></div>
                        </li>
                    </ul>
                </div>
                <div class="card">
                    <h6>Account Settings</h6>
                    <ul class="setting-list list-unstyled">
                        <li>
                            <div class="checkbox">
                                <input id="checkbox5" type="checkbox" checked="">
                                <label for="checkbox5">Offline</label>
                            </div>
                        </li>
                        <li>
                            <div class="checkbox">
                                <input id="checkbox6" type="checkbox" checked="">
                                <label for="checkbox6">Location Permission</label>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="card theme-light-dark">
                    <h6>Left Menu</h6>
                    <button class="t-light btn btn-default btn-simple btn-round btn-block">Light</button>
                    <button class="t-dark btn btn-default btn-round btn-block">Dark</button>
                    <button class="m_img_btn btn btn-primary btn-round btn-block">Sidebar Image</button>
                </div>
                <div class="card">
                    <h6>Information Summary</h6>
                    <div class="row m-b-20">
                        <div class="col-7">
                            <small class="displayblock">MEMORY USAGE</small>
                            <h5 class="m-b-0 h6">512</h5>
                        </div>
                        <div class="col-5">
                            <div class="sparkline" data-type="bar" data-width="97%" data-height="25px"
                                 data-bar-Width="5" data-bar-Spacing="3" data-bar-Color="#00ced1">8,7,9,5,6,4,6,8
                            </div>
                        </div>
                    </div>
                    <div class="row m-b-20">
                        <div class="col-7">
                            <small class="displayblock">CPU USAGE</small>
                            <h5 class="m-b-0 h6">90%</h5>
                        </div>
                        <div class="col-5">
                            <div class="sparkline" data-type="bar" data-width="97%" data-height="25px"
                                 data-bar-Width="5" data-bar-Spacing="3" data-bar-Color="#F15F79">6,5,8,2,6,4,6,4
                            </div>
                        </div>
                    </div>
                    <div class="row m-b-20">
                        <div class="col-7">
                            <small class="displayblock">DAILY TRAFFIC</small>
                            <h5 class="m-b-0 h6">25 142</h5>
                        </div>
                        <div class="col-5">
                            <div class="sparkline" data-type="bar" data-width="97%" data-height="25px"
                                 data-bar-Width="5" data-bar-Spacing="3" data-bar-Color="#78b83e">7,5,8,7,4,2,6,5
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-7">
                            <small class="displayblock">DISK USAGE</small>
                            <h5 class="m-b-0 h6">60.10%</h5>
                        </div>
                        <div class="col-5">
                            <div class="sparkline" data-type="bar" data-width="97%" data-height="25px"
                                 data-bar-Width="5" data-bar-Spacing="3" data-bar-Color="#457fca">7,5,2,5,6,7,6,4
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="tab-pane right_chat stretchLeft" id="chat">
            <div class="slim_scroll">
                <div class="card">
                    <div class="search">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="ძიება...">
                            <span class="input-group-addon">
                                <i class="zmdi zmdi-search"></i>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <h6>Recent</h6>
                    <ul class="list-unstyled">
                        <li class="online">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar4.jpg" alt="">
                                    <div class="media-body">
                                        <span class="name">Sophia</span>
                                        <span class="message">There are many variations of passages of Lorem Ipsum available</span>
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="online">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar5.jpg" alt="">
                                    <div class="media-body">
                                        <span class="name">Grayson</span>
                                        <span class="message">All the Lorem Ipsum generators on the</span>
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar2.jpg" alt="">
                                    <div class="media-body">
                                        <span class="name">Isabella</span>
                                        <span class="message">Contrary to popular belief, Lorem Ipsum</span>
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="me">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar1.jpg" alt="">
                                    <div class="media-body">
                                        <span class="name">John</span>
                                        <span class="message">It is a long established fact that a reader</span>
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="online">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar3.jpg" alt="">
                                    <div class="media-body">
                                        <span class="name">Alexander</span>
                                        <span class="message">Richard McClintock, a Latin professor</span>
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="card">
                    <h6>Contacts</h6>
                    <ul class="list-unstyled">
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar10.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar6.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar7.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar8.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar9.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="online inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar5.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar4.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar3.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="online inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar2.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="offline inlineblock">
                            <a href="javascript:void(0);">
                                <div class="media">
                                    <img class="media-object " src="resources/assets/images/xs/avatar1.jpg" alt="">
                                    <div class="media-body">
                                        <span class="badge badge-outline status"></span>
                                    </div>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="tab-pane slideLeft" id="activity">
            <div class="slim_scroll">
                <div class="card user_activity">
                    <h6>Recent Activity</h6>
                    <div class="streamline b-accent">
                        <div class="sl-item">
                            <img class="user rounded-circle" src="resources/assets/images/xs/avatar4.jpg" alt="">
                            <div class="sl-content">
                                <h5 class="m-b-0">Admin Birthday</h5>
                                <small>Jan 21 <a href="javascript:void(0);" class="text-info">Sophia</a>.</small>
                            </div>
                        </div>
                        <div class="sl-item">
                            <img class="user rounded-circle" src="resources/assets/images/xs/avatar5.jpg" alt="">
                            <div class="sl-content">
                                <h5 class="m-b-0">Add New Contact</h5>
                                <small>30min ago <a href="javascript:void(0);">Alexander</a>.</small>
                                <small><strong>P:</strong> +264-625-2323</small>
                                <small><strong>E:</strong> maryamamiri@gmail.com</small>
                            </div>
                        </div>
                        <div class="sl-item">
                            <img class="user rounded-circle" src="resources/assets/images/xs/avatar6.jpg" alt="">
                            <div class="sl-content">
                                <h5 class="m-b-0">Code Change</h5>
                                <small>Today <a href="javascript:void(0);">Grayson</a>.</small>
                                <small>The standard chunk of Lorem Ipsum used since the 1500s is reproduced</small>
                            </div>
                        </div>
                        <div class="sl-item">
                            <img class="user rounded-circle" src="resources/assets/images/xs/avatar7.jpg" alt="">
                            <div class="sl-content">
                                <h5 class="m-b-0">New Email</h5>
                                <small>45min ago <a href="javascript:void(0);" class="text-info">Fidel Tonn</a>.</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <h6>Recent Attachments</h6>
                    <ul class="list-unstyled activity">
                        <li>
                            <a href="javascript:void(0)">
                                <i class="zmdi zmdi-collection-pdf l-blush"></i>
                                <div class="info">
                                    <h4>info_258.pdf</h4>
                                    <small>2MB</small>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <i class="zmdi zmdi-collection-text l-amber"></i>
                                <div class="info">
                                    <h4>newdoc_214.doc</h4>
                                    <small>900KB</small>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <i class="zmdi zmdi-image l-parpl"></i>
                                <div class="info">
                                    <h4>MG_4145.jpg</h4>
                                    <small>5.6MB</small>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <i class="zmdi zmdi-image l-parpl"></i>
                                <div class="info">
                                    <h4>MG_4100.jpg</h4>
                                    <small>5MB</small>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <i class="zmdi zmdi-collection-text l-amber"></i>
                                <div class="info">
                                    <h4>Reports_end.doc</h4>
                                    <small>780KB</small>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">
                                <i class="zmdi zmdi-videocam l-turquoise"></i>
                                <div class="info">
                                    <h4>movie2018.MKV</h4>
                                    <small>750MB</small>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</aside>





