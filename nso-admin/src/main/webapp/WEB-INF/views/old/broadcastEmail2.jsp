<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>
<script>
    $(document).ready(function () {
        $('[data-toggle="tooltip"]').tooltip();
    });
</script>
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
                Modal.info('შეიყვანეთ ტექსტი');
                return;
            }
            if (isEmptyValue($scope.mail.recipients)) {
                Modal.info('აირჩიეთ ფედერაციები');
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
            }).success(function (data) {
                $("#beArea").removeClass("loading-mask");
                Modal.info("SMS გაიგზავნა წარმატებით", function () {
                    location.reload();
                })
            }).error(function (data, status, headers, config) {
                $("#beArea").removeClass("loading-mask");
                location.reload();
            });

            $("#beArea").addClass("loading-mask");
        };

        $scope.sendMail = function () {
            if (isEmptyValue($scope.mail.title)) {
                Modal.info('შეიყვანეთ სათაური');
                return;
            }
            if (isEmptyValue($scope.mail.body)) {
                Modal.info('შეიყვანეთ ტექსტი');
                return;
            }
            if (isEmptyValue($scope.mail.recipients)) {
                Modal.info('აირჩიეთ ფედერაციები');
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
            }).success(function (data) {
                $("#beArea").removeClass("loading-mask");
                Modal.info("იმეილი გაიგზავნა წარმატებით", function () {
                    location.reload();
                })
            }).error(function (data, status, headers, config) {
                $("#beArea").removeClass("loading-mask");
                location.reload();
            });
            $("#beArea").addClass('loading-mask');
        };

    });

</script>
<div class="col-md-12" ng-controller="feedBackCtrl" id="beArea">
    <br/>
    <form class="form-horizontal" id="feedbackForm">

        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab" data-toggle="tab">ელ-ფოსტა</a>
            </li>
            <li role="presentation"><a href="#profile" aria-controls="profile" role="tab" data-toggle="tab">სმს
                შეტყობინება</a></li>
        </ul>


        <div class="tab-content">
            <br/>
            <div role="tabpanel" class="tab-pane active" id="home">
                <br/>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-2">სათაური</label>
                    <div class="col-sm-10">
                        <input type="text" id="title" ng-model="mail.title" class="form-control input-sm">
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-2">ტექსტი</label>
                    <div class="col-sm-10">
                        <textarea rows="5" class="form-control" ng-model="mail.body"></textarea>
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-2">ფედერაციები</label>
                    <div class="col-sm-10">
                        <select class="form-control input-sm" multiple ng-model="mail.recipients"
                                style="min-height: 300px;">
                            <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-2">დოკუმენტი</label>
                    <div class="col-sm-10">
                        <input type="file" id="documentId" name="file" class="form-control input-sm upload-file">
                    </div>
                </div>
                <div class="col-sm-8" ng-show="documents.length>0">
                    <table class="table table-striped table-hover">
                        <tr>
                            <th>ID</th>
                            <th>ფაილი</th>
                            <th></th>
                        </tr>
                        <tr ng-repeat="d in documents">
                            <td>{{$index + 1}}</td>
                            <td>{{d.name}}</td>
                            <td>
                                <button type="button" class="btn btn-xs" ng-click="deleteDocument($index);">
                                    <span class="glyphicon glyphicon-remove"></span>
                                </button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="form-group col-sm-8 text-right">
                    <div class="col-sm-12">
                        <button type="button" class="btn btn-primary btn-xs" ng-click="sendMail()">გაგზავნა</button>
                    </div>
                </div>
            </div>

            <div role="tabpanel" class="tab-pane" id="profile">
                <br/>

                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-2">ტექსტი</label>
                    <div class="col-sm-10">
                        <textarea rows="5" class="form-control" ng-model="mail.body"></textarea>
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-2">ფედერაციები</label>
                    <div class="col-sm-10">
                        <select class="form-control input-sm" multiple ng-model="mail.recipients"
                                style="min-height: 300px;">
                            <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
                        </select>
                    </div>
                </div>
                <div class="col-sm-8" ng-show="documents.length>0">
                    <table class="table table-striped table-hover">
                        <tr>
                            <th>ID</th>
                            <th>ფაილი</th>
                            <th></th>
                        </tr>
                        <tr ng-repeat="d in documents">
                            <td>{{$index + 1}}</td>
                            <td>{{d.name}}</td>
                            <td>
                                <button type="button" class="btn btn-xs" ng-click="deleteDocument($index);">
                                    <span class="glyphicon glyphicon-remove"></span>
                                </button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="form-group col-sm-8 text-right">
                    <div class="col-sm-12">
                        <button type="button" class="btn btn-primary btn-xs" ng-click="sendSms()">გაგზავნა
                        </button>
                    </div>
                </div>
            </div>

        </div>

    </form>
</div>

<%@include file="footer.jsp" %>