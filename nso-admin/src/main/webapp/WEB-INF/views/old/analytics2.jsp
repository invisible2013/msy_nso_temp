<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>
<script>
    var ssc;
    $(document).ready(function () {

        $('#fromDate').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true
        });
        $('#toDate').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true
        });
        $('#fromDate2').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true
        });
        $('#toDate2').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true
        });
    });

    var app = angular.module("app", ['chart.js']);
    app.controller("requestCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        ssc = $scope;
        $scope.search = {};
        $scope.searchFederation = {};
        $scope.eventTypes = [];
        $scope.federations = [];
        $scope.labels = [];
        $scope.data = [];
        $scope.results = [];
        $scope.details = [];
        var currentDate = Date();

        function getFormattedDate(date) {
            var stringDate = "";
            if (date) {
                var cur = new Date(date);
                var day = cur.getDate() < 10 ? "0" + cur.getDate() : cur.getDate();
                var month = cur.getMonth() < 10 ? "0" + parseInt(cur.getMonth() + 1) : parseInt(cur.getMonth() + 1);
                stringDate = day + "/" + month + "/" + cur.getFullYear();
            }
            return stringDate;
        }

        $scope.search.startDate = getFormattedDate(currentDate);
        $scope.search.endDate = getFormattedDate(currentDate);
        $scope.searchFederation.startDate = getFormattedDate(currentDate);
        $scope.searchFederation.endDate = getFormattedDate(currentDate);
        function getUsers(res) {
            $scope.federations = res.data;
        }

        ajaxCall($http, "users/get-users-by-group", {groupId: 4}, getUsers);

        function getTypes(res) {
            $scope.eventTypes = res.data;
        }

        ajaxCall($http, "misc/get-event-types", {applicationTypeId: 0}, getTypes);

        function getUser(res) {
            $scope.searchFederation.federations = [res.userData.id];
        }

        ajaxCall($http, "get-user", {}, getUser);

        $scope.getReport = function (isFederation) {
            function getSuccessReport(res) {
                $scope.results = res.data;
                $scope.labels = [];
                $scope.data = [];
                $scope.details = [];
                angular.forEach($scope.results, function (value, key) {
                    $scope.labels.push(value.federationName);
                    $scope.data.push(value.sum);
                });
            }

            if (isFederation) {
                if (!$scope.searchFederation.federations) {
                    Modal.info("გთხოვთ აირჩიოთ ერთი ან რამდენიმე ფედერაცია");
                    return;
                }
                ajaxCall($http, "reporting/report1", $scope.searchFederation, getSuccessReport);
            } else {
                if (!$scope.search.federations) {
                    Modal.info("გთხოვთ აირჩიოთ ერთი ან რამდენიმე ფედერაცია");
                    return;
                }
                ajaxCall($http, "reporting/report1", $scope.search, getSuccessReport, null, "analyticsPanel");
            }
        };

        $scope.refresh = function () {
            reload();
        };

        $scope.testClick = function (res) {
            if (res.length > 0) {
                var selected = $filter('filter')($scope.results, {federationName: res[0]._view.label}, true);
                $scope.details = selected[0].details;
                $scope.$apply();
            }
        };

    });
</script>


<div class="col-md-12" ng-controller="requestCtrl" id="analyticsPanel">
    <br/>
    <div class="row col-md-5"
         ng-show="<%=(hasPermissions(request, Groups.MANAGER.getName())|| hasPermissions(request, Groups.ADMIN.getName()))%>">
        <div class="form-group row">
            <label class="control-label">ფედერაციები</label>
            <select class="form-control input-sm" multiple ng-model="search.federations"
                    style="min-height: 200px;">
                <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
            </select>
        </div>
        <div class="form-group row">
            <label class="control-label">ღონისძიების ტიპი</label>
            <select class="form-control input-sm" multiple ng-model="search.eventTypes"
                    style="min-height: 200px;">
                <option ng-repeat="s in eventTypes" value="{{s.id}}">{{s.name}}</option>
            </select>
        </div>
        <div class="row">
            <div class="form-group col-md-6 row">
                <label class="control-label">საიდან</label>
                <input type="text" id="fromDate" ng-model="search.startDate" class="form-control input-sm">
            </div>
            <div class="form-group col-md-6">
                <label class="control-label">სადამდე</label>
                <input type="text" id="toDate" ng-model="search.endDate" class="form-control input-sm">
            </div>
        </div>
        <div class="row">
            <button class="btn btn-primary btn-sm right text-right" ng-click="getReport()">
                ძებნა
            </button>
            <button class="btn btn-sm text-right" ng-click="refresh()">გასუფთავება</button>

        </div>
    </div>
    <div class="row col-md-5" ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
        <div class="form-group col-sm-12">
            <label class="control-label">ღონისძიების ტიპი</label>
            <select class="form-control input-sm" multiple ng-model="searchFederation.eventTypes"
                    style="min-height: 250px;">
                <option ng-repeat="s in eventTypes" value="{{s.id}}">{{s.name}}</option>
            </select>
        </div>
        <div class="row col-md-12">
            <div class="form-group col-sm-6">
                <label class="control-label">საიდან</label>
                <input type="text" id="fromDate2" ng-model="searchFederation.startDate" class="form-control input-sm">
            </div>
            <div class="form-group col-sm-6">
                <label class="control-label">სადამდე</label>
                <input type="text" id="toDate2" ng-model="searchFederation.endDate" class="form-control input-sm">

            </div>
            <div class="col-md-12">
                <button class="btn btn-primary btn-sm" style="margin-top: 20px;" ng-click="getReport(true)">
                    ძებნა
                </button>
                <button class="btn btn-sm" style="margin-top: 20px;" ng-click="refresh()">გასუფთავება</button>
            </div>
        </div>
    </div>
    <br/>
    <div class="col-md-7">
        <canvas id="pie" class="chart chart-pie" chart-click="testClick"
                chart-data="data" chart-series="labels" chart-labels="labels" chart-options="options">
        </canvas>

        <div class="col-md-12">
            <br/>
            <br/>
            <br/>
            <table class="table table-striped table-hover" id="requestList" ng-show="details.length>0">
                <tr>
                    <th>ID</th>
                    <th>სახეობა</th>
                    <th>დასახელება</th>
                    <th>ბიუჯეტი</th>
                </tr>
                <tr ng-repeat="d in details">
                    <td>{{$index + 1}}</td>
                    <td>{{d.eventTypeName}}</td>
                    <td>{{d.eventName}}</td>
                    <td>{{d.budget}}</td>
                </tr>
            </table>
        </div>
    </div>


</div>
<p></p>
<p></p>
<p></p>
<p></p>
<p></p>
<p></p>
<%@include file="footer.jsp" %>
