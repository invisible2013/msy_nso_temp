<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header2.jsp" %>

<script>
    var app = angular.module("app", []);
    app.controller("feedBackCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.feedback = {};
        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };
        $scope.sendFeedback = function () {
            if (isEmptyValue($scope.feedback.title)) {
                alert('Enter Title');
                return;
            }
            if (isEmptyValue($scope.feedback.text)) {
                alert('Enter Text');
                return;
            }
            function successFeedback(res) {
                if (res) {
                    alert("Feedback sent successfully");
                    location.reload();
                }
            }

            ajaxCall($http, "feedback/send-feedback", angular.toJson($scope.feedback), successFeedback, null, "fArea");
        };

    });

</script>

<div ng-controller="feedBackCtrl">
    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Connect to admin
                        <small>Federation is able to connect to admin through this system</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">

                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Write to us</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">

                            <form class="form-horizontal" id="feedbackForm">
                                <ul class="nav nav-tabs" role="tablist">
                                    <li class="nav-item active">
                                        <a class="nav-link active" href="#home" role="tab"
                                           data-toggle="tab">Email</a>
                                    </li>
                                </ul>

                                <div class="tab-content">
                                    <br/>
                                    <div class="tab-pane active" id="home">
                                        <br/>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">Title</label>
                                            <div class="col-sm-9">
                                                <input type="text" id="title" ng-model="feedback.title"
                                                       class="form-control input-sm">
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">Text</label>
                                            <div class="col-sm-9">
                                                <textarea rows="5" class="form-control"
                                                          ng-model="feedback.text"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <div class="col-sm-12">
                                                <button type="button" class="btn btn-primary btn-xs"
                                                        ng-click="sendFeedback()">Send
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>


                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>


<%@include file="footer2.jsp" %>