<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>

<script>
    var app = angular.module("app", []);
    app.controller("feedBackCtrl", function ($scope, $http, $filter, $location) {
        $scope.mail = {};
        $scope.federations = [];
        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };

        function getUsers(res) {
            $scope.federations = res.data;
        }

        ajaxCall($http, "users/get-users-by-group", {groupId: 4}, getUsers);

        $scope.sendSms = function () {
            if (isEmptyValue($scope.mail.body)) {
                Modal.info('Enter Text');
                return;
            }
            if (isEmptyValue($scope.mail.recipients)) {
                Modal.info('Choose Federations');
                return;
            }

            $scope.mail.sendBy = "sms";
            var data = angular.toJson($scope.mail).toString();

            var oMyForm = new FormData();
            oMyForm.append("data", data);
            $.ajax({
                url: 'broadcast-email/send-broadcast-email',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    $("#beArea").removeClass("loading-mask");
                    Modal.info("SMS sent successfully", function () {
                        location.reload();
                    })
                },
                error: function (data, status, headers, config) {
                    $("#beArea").removeClass("loading-mask");
                    location.reload();
                }
            });

            $("#beArea").addClass("loading-mask");
        };

        $scope.sendMail = function () {
            if (isEmptyValue($scope.mail.title)) {
                Modal.info('Enter Title');
                return;
            }
            if (isEmptyValue($scope.mail.body)) {
                Modal.info('Enter Text');
                return;
            }
            if (isEmptyValue($scope.mail.recipients)) {
                Modal.info('Choose Federations');
                return;
            }

            var data = angular.toJson($scope.mail).toString();

            var oMyForm = new FormData();
            oMyForm.append("data", data);
            oMyForm.append("files", $('#documentId')[0].files[0]);
            $.ajax({
                url: 'broadcast-email/send-broadcast-email',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    $("#beArea").removeClass("loading-mask");
                    Modal.info("Email sent successfully", function () {
                        location.reload();
                    })
                },
                error: function (data, status, headers, config) {
                    $("#beArea").removeClass("loading-mask");
                    location.reload();
                }
            });
            $("#beArea").addClass('loading-mask');
        };

        $scope.sendMessage = function () {
            if (isEmptyValue($scope.mail.title)) {
                Modal.info('Enter Title');
                return;
            }
            if (isEmptyValue($scope.mail.body)) {
                Modal.info('Enter Text');
                return;
            }
            if (isEmptyValue($scope.mail.recipients)) {
                Modal.info('Choose Federations');
                return;
            }
            $scope.mail.dueDate = $('#dueDate').val();

            var data = angular.toJson($scope.mail).toString();

            var oMyForm = new FormData();
            oMyForm.append("data", data);
            oMyForm.append("files", $('#documentId2')[0].files[0]);

            $.ajax({
                url: 'message/send-message',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    $("#beArea").removeClass("loading-mask");
                    Modal.info("Email sent successfully", function () {
                        location.reload();
                    })
                },
                error: function (data, status, headers, config) {
                    $("#beArea").removeClass("loading-mask");
                    location.reload();
                }
            });
            $("#beArea").addClass('loading-mask');
        }

    });

</script>
<div ng-controller="feedBackCtrl" id="beArea">
    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Communication
                        <small>You can email or send sms to the sport organisations</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Communication</li>
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
                                    <li class="nav-item">
                                        <a class="nav-link active" href="#home" data-toggle="tab"><i
                                                class="zmdi zmdi-email"></i> Email</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#profile" data-toggle="tab"><i
                                                class="zmdi zmdi-comments zmdi-hc-fw"></i> Sms</a></li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#outbox" data-toggle="tab"><i
                                                class="zmdi zmdi-comments zmdi-hc-fw"></i> outbox</a></li>
                                </ul>


                                <div class="tab-content">
                                    <br/>
                                    <div class="tab-pane active" id="home">
                                        <br/>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-2">Title</label>
                                            <div class="col-sm-10">
                                                <input type="text" id="title" ng-model="mail.title"
                                                       class="form-control input-sm">
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-2">Text</label>
                                            <div class="col-sm-10">
                                                <textarea rows="3" class="form-control" ng-model="mail.body"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-2">Federations</label>
                                            <div class="col-sm-10">
                                                <select class="" multiple ng-model="mail.recipients"
                                                        style="min-height: 300px;">
                                                    <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-2">Document</label>
                                            <div class="col-sm-10">
                                                <input type="file" id="documentId" name="file"
                                                       class="form-control input-sm upload-file">
                                            </div>
                                        </div>
                                        <div class="col-sm-8" ng-show="documents.length>0">
                                            <table class="table table-striped table-hover">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>File</th>
                                                    <th></th>
                                                </tr>
                                                <tr ng-repeat="d in documents">
                                                    <td>{{$index + 1}}</td>
                                                    <td>{{d.name}}</td>
                                                    <td>
                                                        <button type="button" class="btn btn-xs"
                                                                ng-click="deleteDocument($index);">
                                                            <span class="glyphicon glyphicon-remove"></span>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <div class="col-sm-12">
                                                <button type="button" class="btn btn-primary btn-xs"
                                                        ng-click="sendMail()">Send
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="tab-pane" id="profile">
                                        <br/>

                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-2">Text</label>
                                            <div class="col-sm-10">
                                                <textarea rows="5" class="form-control" ng-model="mail.body"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-2">Federations</label>
                                            <div class="col-sm-10">
                                                <select class="" multiple ng-model="mail.recipients"
                                                        style="min-height: 300px;">
                                                    <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-8" ng-show="documents.length>0">
                                            <table class="table table-striped table-hover">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>File</th>
                                                    <th></th>
                                                </tr>
                                                <tr ng-repeat="d in documents">
                                                    <td>{{$index + 1}}</td>
                                                    <td>{{d.name}}</td>
                                                    <td>
                                                        <button type="button" class="btn btn-xs"
                                                                ng-click="deleteDocument($index);">
                                                            <span class="glyphicon glyphicon-remove"></span>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <div class="col-sm-12">
                                                <button type="button" class="btn btn-primary btn-xs"
                                                        ng-click="sendSms()">Send
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="tab-pane" id="outbox">
                                        <br/>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">Number</label>
                                            <div class="col-sm-10">
                                                <input type="text" ng-model="mail.number" class="form-control input-sm">
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">Dedline</label>
                                            <div class="col-sm-10">
                                                <input type="text" id="dueDate" ng-model="mail.dueDate"
                                                       class="form-control input-sm">
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">Title</label>
                                            <div class="col-sm-10">
                                                <input type="text" ng-model="mail.title" class="form-control input-sm">
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">Text</label>
                                            <div class="col-sm-10">
                                                <textarea rows="3" class="form-control" ng-model="mail.body"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">Federations</label>
                                            <div class="col-sm-10">
                                                <select class="" multiple ng-model="mail.recipients"
                                                        style="min-height: 300px;">
                                                    <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label class="control-label col-sm-3">File</label>
                                            <div class="col-sm-10">
                                                <input type="file" id="documentId2" name="file"
                                                       class="form-control input-sm upload-file">
                                            </div>
                                        </div>
                                        <div class="col-sm-8" ng-show="documents.length>0">
                                            <table class="table table-striped table-hover">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>File</th>
                                                    <th></th>
                                                </tr>
                                                <tr ng-repeat="d in documents">
                                                    <td>{{$index + 1}}</td>
                                                    <td>{{d.name}}</td>
                                                    <td>
                                                        <button type="button" class="btn btn-xs"
                                                                ng-click="deleteDocument($index);">
                                                            <span class="glyphicon glyphicon-remove"></span>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <div class="col-sm-12">
                                                <button type="button" class="btn btn-primary btn-xs"
                                                        ng-click="sendMessage()">Sent
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

<script type="text/javascript" src="resources/js/bootstrap-datepicker.min.js"></script>
<script>
    $(document).ready(function () {

        $('#dueDate').datepicker({
            format: 'dd/mm/yyyy'
        });
    });
</script>

