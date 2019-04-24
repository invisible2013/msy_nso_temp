<!DOCTYPE html>

<%@ page pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/style.css"/>
<link rel="stylesheet" href="resources/css/bootstrap-yeti.min.css"/>
<link rel="stylesheet" href="resources/css/jquery-ui.css"/>
<script type="text/javascript" src="resources/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="resources/js/jquery-ui.js"></script>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<script type="text/javascript" src="resources/js/angular.min.js"></script>
<script type="text/javascript" src="resources/js/global_util.js"></script>
<script type="text/javascript" src="resources/js/global_error_handler.js"></script>
<script type="text/javascript" src="resources/js/misc.js"></script>
<script type="text/javascript" src="resources/js/Modal.js"></script>

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
                    Modal.info('არასწორი ერთჯერადი კოდი');
                }

                function sLogin(res) {
                    if (res == 'false') {
                        Modal.info('არასწორი ერთჯერადი კოდი');
                    } else {
                        window.location.reload();
                    }
                }

                ajaxCall($http, "login?uri=" + $scope.uri + "&email=" + $scope.user.email + "&password=" + $scope.user.password + "&pincode=" + $scope.user.pincode, null, sLogin, erLogin, "loginFormId");
            } else {
                function successLogin(res) {
                    if (res == 'true') {
                        $scope.twoStep = true;
                    }
                }

                function errorLogin(res) {
                    Modal.info('არასწორი მომხმარებელი ან პაროლი');
                }

                ajaxCall($http, "login?uri=" + $scope.uri + "&email=" + $scope.user.email + "&password=" + $scope.user.password, null, successLogin, errorLogin, "loginFormId");
            }
        };
    });

</script>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>ავტორიზაცია</title>
</head>
<body class="auth_bg" ng-app="app">
<div class="container" data-role="none" ng-controller="loginCtrl">
    <div class="row">
        <div class="col-md-12">
            <br/>
            <div class="row">
                <div class="col-md-12">
                    <div class="center-block" id="logo"></div>
                    <div class="center-block" id="slogan"></div>
                </div>
            </div>
            <div class="row  ">
                <div class="col-md-4 col-md-offset-4">
                    <form id="loginFormId">
                        <div class="row">
                            <br/>
                            <div class="col-md-10 col-md-offset-1">
                                <div class="form-group" id="UserNameGroup">
                                    <input type="text" id="username" name="email" ng-model="user.email"
                                           class="form-control input-sm" placeholder="მომხმარებელი"/>
                                </div>
                                <div class="form-group" id="PasswordGroup">
                                    <input type="password" id="password" name="password" ng-model="user.password"
                                           class="form-control input-sm" placeholder="პაროლი"/>
                                </div>
                                <div class="form-group" id="PinCodeGroup" ng-show="twoStep">
                                    <input type="text" id="pincode" name="password" ng-model="user.pincode"
                                           class="form-control input-sm" placeholder="ერთჯერადი კოდი"/>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <input type="submit" id="auth" class="btn btn-primary btn-xs" ng-click="login()"
                                   value="ავტორიზაცია"/>
                        </div>
                        <br/>
                        <div class="form-group text-center">
                            <a href="resources/imgs/GeoAnathem.mp3" target="_blank">ჩამოტვირთეთ საქართველოს ჰიმნი</a>
                        </div>
                        <div class="form-group text-center">
                            <a href="resources/imgs/GeoFlag.png" target="_blank">ჩამოტვირთეთ საქართველოს დროშა</a>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
