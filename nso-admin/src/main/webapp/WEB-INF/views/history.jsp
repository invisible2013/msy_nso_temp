<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>

<script>
    var app = angular.module("app", []);
    app.controller("homeCtrl", function ($scope, $http, $filter) {
        $scope.events = [];
        $scope.years = [];
        $scope.search = [];
        $scope.start = 0;
        $scope.limit = 40;
        $scope.size = 0;
        var currentYear = new Date().getFullYear();
        for (var a = 2016; a <= currentYear; a++) {
            $scope.years.push({id: a, name: a});
        }
        $scope.search = {offset: $scope.start, limit: $scope.limit};
        function getSuccessEventFirst(res) {
            getSuccessEvent(res);
            $scope.search.year = currentYear;
        }

        function getSuccessEvent(res) {
            $scope.events = $scope.events.concat(res.data);
            $scope.size = res.data.length;
        }

        ajaxCall($http, "event/get-history-events-by", angular.toJson({
            year: currentYear,
            offset: $scope.start,
            limit: $scope.limit
        }), getSuccessEventFirst);
        $scope.detailEvent = function (eventId) {
            function getEvent(res) {
                $scope.detailInfo = res.data;
                $scope.persons = res.data.persons;
                $scope.documents = res.data.documents;
            }

            ajaxCall($http, "event/get-event", {eventId: eventId}, getEvent);
            function getEventHistory(res) {
                $scope.history = res.data;
            }

            ajaxCall($http, "event/get-event-history", {eventId: eventId}, getEventHistory);
        };
        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };
        $scope.selectEvent = function (eventId) {
            $scope.targetEventRequest = {eventId: eventId};
        };
        $scope.addIdNumberEvent = function () {
            ajaxCall($http, "event/add-regNumber-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.loadMore = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            ajaxCall($http, "event/get-history-events-by", angular.toJson($scope.search), getSuccessEvent, null, "requestList");
        };
        $scope.loadAll = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            $scope.search.limit = 1000000;
            ajaxCall($http, "event/get-history-events-by", angular.toJson($scope.search), getSuccessEvent, null, "requestList");
        };
        $scope.searchChange = function () {
            $scope.search.registeredDate = getDateStringById("registeredDate");
            $scope.search.offset = $scope.start;
            $scope.search.limit = $scope.limit;
            $scope.events = [];
            ajaxCall($http, "event/get-history-events-by", angular.toJson($scope.search), getSuccessEvent, null, "requestList");
        };
        $scope.returnEvent = function (itemId) {
            if (("You need to confirm this operation")) {
                $scope.targetEventRequest = {};
                $scope.targetEventRequest.eventId = itemId;
                ajaxCall($http, "event/return-event", angular.toJson($scope.targetEventRequest), reload);
            }
        };
        $scope.infoEvent = function (eventKey) {
            window.open("detailInfo?Id=" + eventKey, "_blank");
        };
    });
</script>

<div ng-controller="homeCtrl">
    <%@include file="detail.jsp" %>
    <br/>

    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Archived applications
                        <small>Information</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Archived applications</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">

                            <div class="row">
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <select class="form-control" ng-model="search.year"
                                                ng-change="searchChange()">
                                            <option ng-repeat="is in years" value="{{is.id}}">{{is.name}}</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group" >
                                        <input type="text" class="form-control"
                                               ng-model="search.fullText">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group" >
                                        <input type="text" id="registeredDate" ng-model="search.registeredDate"
                                               class="form-control input-sm" placeholder="Registration Date">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <button class="btn btn-raised btn-primary btn-round waves-effect m-l-20"
                                                ng-click="searchChange()">Search
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <table class="table table-hover" id="requestList">
                                <tr>
                                    <th>ID</th>
                                    <th>N1</th>
                                    <th>N2</th>
                                    <th>Federation</th>
                                    <th>Type</th>
                                    <th>Event</th>
                                    <th>Budget</th>
                                    <th>StartDate/EndDate</th>
                                    <th>Decision</th>
                                    <th></th>
                                </tr>
                                <tr ng-repeat="i in events">
                                    <td><span
                                            ng-class="{'badge badge-danger': (i.eventDecision.id == 2),'badge badge-success': (i.eventDecision.id == 1)}">{{$index + 1}}</span>
                                    </td>
                                    <td style="min-width: 100px;">
                                        <span><b>{{ i.idNumber}}</b></span>
                                    </td>
                                    <td style="min-width: 100px;">
                                        <span><b>{{ i.registrationNumber}}</b></span>
                                    </td>
                                    <td>{{i.senderUser.name}}</td>
                                    <td>{{i.applicationType.name}}</td>
                                    <td style="max-width: 200px;">{{i.eventName.substring(0,200)}}<span
                                            ng-show="i.eventName.length>200">..</span></td>
                                    <td>{{i.budget}}</td>
                                    <td>{{i.startDate}}-{{i.endDate}}</td>
                                    <td>{{i.eventDecision.name}}</td>
                                    <td style="min-width: 153px;">
                                        <button
                                                class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="infoEvent(i.key)"
                                                title="Detail Info">
                                            <i class="zmdi zmdi-info"></i></button>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="i.eventDecision.id==1"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    title="Return Back"
                                                    ng-click="returnEvent(i.id)">
                                                <i class="zmdi zmdi-arrow-back"></i>
                                        </button>
                                        </span>

                                    </td>
                                </tr>
                            </table>
                            <div class="col-md-12">
                                <br/>
                                <input type="button" ng-show="size>=limit" class="btn btn-primary"
                                       value="Load More"
                                       ng-click="loadMore();">
                                <input type="button" ng-show="size>=limit" class="btn btn-primary"
                                       value="Load All"
                                       ng-click="loadAll();">
                            </div>


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
        $('#registeredDate').datepicker({
            dateFormat: 'dd-mm-yy',
            changeMonth: true,
            changeYear: true
        });

    });
</script>