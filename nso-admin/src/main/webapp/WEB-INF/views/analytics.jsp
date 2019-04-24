<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>

<script type="text/javascript" src="resources/js/chart/Chart.min.js"></script>
<script type="text/javascript" src="resources/js/chart/angular-chart.js"></script>
<script>
    var ssc;


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
        $scope.totalAmount = 0;
        $scope.totalEvent = 0;
        $scope.totalFederation = 0;

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


        function getTypes(res) {
            $scope.eventTypes = res.data;
        }

        ajaxCall($http, "misc/get-event-types", {applicationTypeId: 0}, getTypes);

        function getUser(res) {
            $scope.searchFederation.federations = [res.userData.id];
            function getUsers(res) {
                $scope.federations = res.data;
            }

            if (res.userData.usersGroup.id == 3) {
                ajaxCall($http, "users/get-users-by-supervisor", null, getUsers);
            } else {
                ajaxCall($http, "users/get-users-by-group", {groupId: 4}, getUsers);
            }
        }

        ajaxCall($http, "get-user", {}, getUser);

        $scope.getReport = function (isFederation) {

            function getSuccessReport(res) {
                console.log(res.data);
                $scope.results = res.data;
                $scope.labels = [];
                $scope.data = [];
                $scope.details = [];
                $scope.totalFederation = $scope.results.length;
                angular.forEach($scope.results, function (value, key) {
                    $scope.labels.push(value.federationName);
                    $scope.data.push(value.sum);
                    $scope.totalAmount = $scope.totalAmount + value.sum;
                    $scope.totalEvent = $scope.totalEvent + value.eventsCount;
                });
            }

            if (isFederation) {
                $scope.search.startDate = $('#fromDate2').val();
                $scope.search.endDate = $('#toDate2').val();
                if (!$scope.searchFederation.federations) {
                    Modal.info("Please, Choose one or more federation");
                    return;
                }
                ajaxCall($http, "reporting/report1", $scope.searchFederation, getSuccessReport);
            } else {
                $scope.search.startDate = $('#fromDate').val();
                $scope.search.endDate = $('#toDate').val();
                if (!$scope.search.federations) {
                    Modal.info("Please, Choose one or more federation");
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


<div ng-controller="requestCtrl">
    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>NSO Analytics
                        <small>Sport event reports</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">NSO Analytics</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">

                            <div class="row col-md-12">
                                <div class="col-md-5"
                                     ng-show="<%=(hasPermissions(request, Groups.MANAGER.getName())||hasPermissions(request, Groups.SUPERVISOR.getName())|| hasPermissions(request, Groups.ADMIN.getName()))%>">
                                    <div class="form-group col-md-12">
                                        <label class="control-label">Federations</label>
                                        <select class="form-control input-sm" multiple ng-model="search.federations"
                                                style="min-height: 200px;">
                                            <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-12">
                                        <label class="control-label">Event Type</label>
                                        <select class="form-control input-sm" multiple ng-model="search.eventTypes"
                                                style="min-height: 200px;">
                                            <option ng-repeat="s in eventTypes" value="{{s.id}}">{{s.name}}</option>
                                        </select>
                                    </div>
                                    <div class="row col-md-12">
                                        <div class="form-group col-md-6">
                                            <label class="control-label">Start Date</label>
                                            <input type="text" id="fromDate" ng-model="search.startDate"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label class="control-label">End Date</label>
                                            <input type="text" id="toDate" ng-model="search.endDate"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <button class="btn btn-primary" ng-click="getReport()">
                                            Search
                                        </button>
                                        <button class="btn btn-info" ng-click="refresh()">Clear</button>

                                    </div>
                                </div>
                                <div class="col-md-5"
                                     ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
                                    <div class="form-group col-md-12">
                                        <label class="control-label">Event Type</label>
                                        <select class="form-control input-sm" multiple
                                                ng-model="searchFederation.eventTypes"
                                                style="min-height: 200px;">
                                            <option ng-repeat="s in eventTypes" value="{{s.id}}">{{s.name}}</option>
                                        </select>
                                    </div>
                                    <div class="row col-md-12">
                                        <div class="form-group col-sm-6">
                                            <label class="control-label">Start Date</label>
                                            <input type="text" id="fromDate2" ng-model="searchFederation.startDate"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-sm-6">
                                            <label class="control-label">End Date</label>
                                            <input type="text" id="toDate2" ng-model="searchFederation.endDate"
                                                   class="form-control input-sm">

                                        </div>
                                        <div class="col-md-12">
                                            <button class="btn btn-primary"
                                                    ng-click="getReport(true)">
                                                Search
                                            </button>
                                            <button class="btn btn-info" ng-click="refresh()">
                                                Clear
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <br/>
                                <div class="col-md-7">
                                    <div class="col-md-12">
                                        <br/>
                                        <br/>
                                        <br/>
                                        <div class="row clearfix">
                                            <div class="col-lg-4 col-md-6 col-sm-12">
                                                <div class="card info-box-2 l-seagreen">
                                                    <div class="body">
                                                        <div class="m-t-5">
                                                            <span><i class="material-icons text-warning">assessment</i></span>
                                                        </div>
                                                        <div class="content col-12">
                                                            <div class="text">Total Amount:</div>
                                                            <div class="number">{{totalAmount| number:2}}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-4 col-md-6 col-sm-12">
                                                <div class="card info-box-2 l-parpl">
                                                    <div class="body">
                                                        <div class="m-t-5">
                                                            <span><i
                                                                    class="material-icons text-success">event</i></span>
                                                        </div>
                                                        <div class="content col-12">
                                                            <div class="text">Total Event:</div>
                                                            <div class="number">{{totalEvent}}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-4 col-md-6 col-sm-12">
                                                <div class="card info-box-2 l-blue">
                                                    <div class="body">
                                                        <div class="m-t-5">
                                                            <span><i class="material-icons text-danger">share</i></span>
                                                        </div>
                                                        <div class="content col-12">
                                                            <div class="text">Total Federation:</div>
                                                            <div class="number">{{totalFederation}}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <canvas id="pie" class="chart chart-pie" chart-click="testClick"
                                            chart-data="data" chart-series="labels" chart-labels="labels"
                                            chart-options="options">
                                    </canvas>


                                    <div class="col-md-12">
                                        <br/>
                                        <br/>
                                        <br/>
                                        <table class="table table-striped table-hover" id="requestList"
                                               ng-show="details.length>0">
                                            <tr>
                                                <th>ID</th>
                                                <th>Sport</th>
                                                <th>Name</th>
                                                <th>Budget</th>
                                            </tr>
                                            <tr ng-repeat="d in details">
                                                <td>{{$index + 1}}</td>
                                                <td>{{d.eventTypeName}}</td>
                                                <td>{{d.eventName}}</td>
                                                <td>{{d.budget | number:2}}</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>


<%@include file="footer2.jsp" %>

<script src="resources/assets/js/pages/widgets/infobox/infobox-1.js"></script>
<script src="resources/assets/js/pages/cards/basic.js"></script>

<script type="text/javascript" src="resources/js/bootstrap-datepicker.min.js"></script>
<script>
    $(document).ready(function () {

        $('#fromDate').datepicker({
            format: 'dd/mm/yyyy'
        });
        $('#toDate').datepicker({
            format: 'dd/mm/yyyy'
        });
        $('#fromDate2').datepicker({
            format: 'dd/mm/yyyy'
        });
        $('#toDate2').datepicker({
            format: 'dd/mm/yyyy'
        });
    });
</script>