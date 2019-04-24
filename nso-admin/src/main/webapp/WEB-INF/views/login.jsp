<!DOCTYPE html>

<%@ page pageEncoding="UTF-8" %>

<script type="text/javascript" src="resources/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="resources/js/angular.min.js"></script>
<script type="text/javascript" src="resources/js/global_util.js"></script>
<script type="text/javascript" src="resources/js/global_error_handler.js"></script>
<script type="text/javascript" src="resources/js/misc.js"></script>
<script type="text/javascript" src="resources/js/Modal.js"></script>

<link rel="stylesheet" href="resources/assets/plugins/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="resources/assets/css/main.css">
<link rel="stylesheet" href="resources/assets/css/authentication.css">
<link rel="stylesheet" href="resources/assets/css/color_skins.css">

<script type="text/javascript">
    var app = angular.module("app", []);
    app.controller("loginCtrl", function ($scope, $http, $location) {
        var absUrl = $location.absUrl();
        $scope.uri = "";
        if (absUrl.split("?")[1]) {
            $scope.uri = absUrl.split("?")[1].split("=")[1];
        }
        $scope.user = [];
        $scope.twoStep = false;
        $scope.login = function () {
            if ($scope.twoStep) {
                function erLogin(res) {
                    Modal.info('Invalid code');
                }

                function sLogin(res) {
                    if (res == 'false') {
                        Modal.info('Invalid code');
                    } else {
                        window.location.reload();
                    }
                }

                ajaxCall($http, "login?uri=" + $scope.uri + "&email=" + $scope.user.email + "&password=" + $scope.user.password + "&pincode=" + $scope.user.pincode, null, sLogin, erLogin, "loginFormId");
            } else {
                function successLogin(res) {
                    if (res == 'true') {
                        $scope.twoStep = true;
                    } else if (res == 'home') {
                        window.location.reload();
                    }
                }

                function errorLogin(res) {
                    Modal.info('Invalid username or password');
                }

                ajaxCall($http, "login?uri=" + $scope.uri + "&email=" + $scope.user.email + "&password=" + $scope.user.password, null, successLogin, errorLogin, "loginFormId");
            }
        };
    });

</script>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Authorization</title>
</head>

<body class="theme-purple authentication sidebar-collapse" ng-app="app">
<div ng-controller="loginCtrl">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg fixed-top navbar-transparent">
        <div class="container">
            <div class="navbar-translate n_logo">
                <a class="navbar-brand" href="javascript:void(0);" title="" target="_blank">NSO</a>
                <button class="navbar-toggler" type="button">
                    <span class="navbar-toggler-bar bar1"></span>
                    <span class="navbar-toggler-bar bar2"></span>
                    <span class="navbar-toggler-bar bar3"></span>
                </button>
            </div>
            <div class="navbar-collapse">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="resources/imgs/GeoFlag.png" target="_blank"><i
                                class="zmdi zmdi-flag zmdi-hc-fw"></i> Flag</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="resources/imgs/GeoAnathem.mp3" target="_blank"><i
                                class="zmdi zmdi-collection-music zmdi-hc-fw"></i> National anthem</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <!-- End Navbar -->
    <div class="page-header">
        <div class="page-header-image" style="background-image:url(resources/assets/images/login2.png)"></div>
        <div class="container">
            <div class="col-md-12 content-center">
                <div class="card-plain">
                    <form class="form" id="loginFormId">
                        <div class="header">
                            <div class="logo-container">
                                <img src="resources/assets/images/logo2.svg" alt="">
                            </div>
                            <h5>Log Into NSO</h5>
                        </div>
                        <div class="content">
                            <div class="input-group input-lg">
                                <input type="text" class="form-control" placeholder="Username"
                                       ng-model="user.email">
                                <span class="input-group-addon">
                                <i class="zmdi zmdi-account-circle"></i>
                            </span>
                            </div>
                            <div class="input-group input-lg">
                                <input type="password" placeholder="Password" class="form-control"
                                       ng-model="user.password"/>
                                <span class="input-group-addon">
                                <i class="zmdi zmdi-lock"></i>
                            </span>
                            </div>
                            <div class="input-group input-lg" ng-show="twoStep">
                                <input type="text" placeholder="code" class="form-control" ng-model="user.pincode"/>
                                <span class="input-group-addon">
                                <i class="zmdi zmdi-code-smartphone"></i>
                            </span>
                            </div>
                        </div>
                        <div class="footer text-center">
                            <button class="btn btn-primary btn-round btn-lg btn-block " ng-click="login()">Log In
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
        <footer class="footer">
            <div class="container">

                <div class="copyright">
                    &copy;
                    <script>
                        document.write(new Date().getFullYear())
                    </script>
                    ,
                    <span>Created by <a href="http://www.mes.gov.ge/" target="_blank">Ministry of Education, Science, Culture And Sport of Georgia</a></span>
                </div>
            </div>
        </footer>
    </div>
</div>
<!-- Jquery Core Js -->
<script src="resources/assets/bundles/libscripts.bundle.js"></script>
<script src="resources/assets/bundles/vendorscripts.bundle.js"></script> <!-- Lib Scripts Plugin Js -->

<script>
    $(".navbar-toggler").on('click', function () {
        $("html").toggleClass("nav-open");
    });
    //=============================================================================
    $('.form-control').on("focus", function () {
        $(this).parent('.input-group').addClass("input-group-focus");
    }).on("blur", function () {
        $(this).parent(".input-group").removeClass("input-group-focus");
    });
</script>
</body>
</html>
