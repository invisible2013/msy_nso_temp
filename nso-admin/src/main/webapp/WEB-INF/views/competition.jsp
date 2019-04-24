<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header2.jsp" %>

<script>

    var app = angular.module("app", ["ui.bootstrap"]);
    app.factory('Excel', function ($window) {
        var uri = 'data:application/vnd.ms-excel;base64,',
            template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head>' +
                '</head><body><table>{table}</table></body></html>',
            base64 = function (s) {
                return $window.btoa(unescape(encodeURIComponent(s)));
            },
            format = function (s, c) {
                return s.replace(/{(\w+)}/g, function (m, p) {
                    return c[p];
                })
            };
        return {
            tableToExcel: function (tableId, worksheetName) {
                var table = $(tableId),
                    ctx = {worksheet: worksheetName, table: table.html()},
                    href = uri + base64(format(template, ctx));
                return href;
            }
        };
    });

    app.controller("messageCtrl", function ($scope, $http, $filter, Excel, $timeout) {
        $scope.currentUserId = 0;
        $scope.years = [];
        $scope.events = [];
        $scope.search = [];
        $scope.federations = {};
        $scope.start = 0;
        $scope.limit = 40;
        $scope.size = 0;
        $scope.selectedFederationId = 0;

        var currentYear = new Date().getFullYear();
        for (var a = 2016; a <= currentYear; a++) {
            $scope.years.push({id: a, name: a});
        }

        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };

        $scope.exportToExcel = function (tableId) { //
            $scope.exportHref = Excel.tableToExcel(tableId, 'events');
            $timeout(function () {
                window.open($scope.exportHref);
            }, 100); // trigger download
        }

        $scope.search = {offset: $scope.start, limit: $scope.limit};
        function getEventsSuccessFirst(res) {
            getEventsSuccess(res);
            //$scope.search.year = currentYear;
        }

        function getEventsSuccess(res) {
            $scope.events = $scope.events.concat(res.data);
            $scope.size = res.data.length;
        }


        ajaxCall($http, "competition/get-competitions", angular.toJson({
            statusId: 1
        }), getEventsSuccessFirst);


        function getUser(res) {
            $scope.current = res.userData;
            $scope.currentUserId = $scope.current.id;
        }

        ajaxCall($http, "get-user", {}, getUser);

        function getUsersByGroup(res) {
            $scope.federations = res.data;
        }

        ajaxCall($http, "users/get-users-by-group", {groupId: 4}, getUsersByGroup);

        function getUsersByManager(res) {
            $scope.managerFederations = res.data;
        }
        ajaxCall($http, "users/get-users-by-manager", null, getUsersByManager);


        $scope.loadMore = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            ajaxCall($http, "competition/get-competitions", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.loadAll = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            $scope.search.limit = 1000000;
            ajaxCall($http, "competition/get-competitions", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.searchChange = function () {
            $scope.search.federationId = $scope.selectedFederationId;
            $scope.search.offset = $scope.start;
            $scope.search.limit = $scope.limit;
            $scope.events = [];
            ajaxCall($http, "competition/get-competitions", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };


        $scope.infoEvent = function (eventKey) {
            window.open("detailInfo?Id=" + eventKey, "_blank");
        };


        $scope.selectEvent = function (messageId) {
            $scope.targetEventRequest = {messageId: messageId};
        };
        $scope.detailMessage = function (message) {
            $scope.detailInfo = message;

        };




        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };

        $scope.addCalendarRequest = function () {
            window.location = "addCompetition";
        };

        $scope.editEvent = function (itemId) {
            window.location = "addCompetition?itemId=" + itemId;
        };

        $scope.selectEvent = function (itemId) {
            $scope.targetRequest = {id: itemId};
        };

    });
</script>

<div ng-controller="messageCtrl" id="beArea">

    <div class="modal fade" id="infoModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title">Detail Information</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <table class="table table-striped col-md-12">
                                <tr>
                                    <th class="">Federation :</th>
                                    <td>{{detailInfo.federationUser.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Competition :</th>
                                    <td>{{detailInfo.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Category :</th>
                                    <td>{{detailInfo.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Create Date :</th>
                                    <td>{{detailInfo.createDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">Date of competitions :</th>
                                    <td>{{detailInfo.competitionDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">Sender Federation :</th>
                                    <td>{{detailInfo.senderUser.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Location :</th>
                                    <td>{{detailInfo.location}}</td>
                                </tr>
                                <tr>
                                    <th class="">Number of Teams :</th>
                                    <td>{{detailInfo.groupQuantity}}</td>
                                </tr>
                                <tr>
                                    <th class="">Professional / amateur :</th>
                                    <td>{{detailInfo.professional}}</td>
                                </tr>
                                <tr>
                                    <th class="">Sport/Discipline :</th>
                                    <td>{{detailInfo.discipline}}</td>
                                </tr>

                            </table>
                            <div class="col-sm-12" ng-show="detailInfo.competitionPersons.length > 0">
                                <h4><b>Participants</b></h4>
                                <hr>
                                <table class="table table-striped">
                                    <tr>
                                        <th>#</th>
                                        <th>Name</th>
                                        <th>Personal Number</th>
                                        <th>Position</th>
                                    </tr>
                                    <tr ng-repeat="h in detailInfo.competitionPersons">
                                        <td>{{$index + 1}}</td>
                                        <td>{{h.person.firstName}} {{h.person.lastName}}</td>
                                        <td>{{h.person.personalNumber}}</td>
                                        <td>{{h.person.position}}</td>
                                    </tr>
                                </table>
                                <div class="form-group"><br/></div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="rejectModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title">Block</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <label>შენიშვნა</label>
                            <div class="form-group">
                                    <textarea class="form-control input-group-sm" rows="2"
                                              ng-model="targetRequest.note"></textarea>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" ng-click="blockEvent()">Send</button>
                </div>
            </div>
        </div>
    </div>


    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Competitions
                        <small>Competitions</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <%if (hasPermissions(request, Groups.FEDERATION_MANAGER.getName())) {%>
                    <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10" type="button"
                            ng-click="addCalendarRequest()">
                        <i class="zmdi zmdi-plus"></i>
                    </button>
                    <%}%>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Competitions</li>
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
                                <%if (hasPermissions(request, Groups.ADMIN.getName())) {%>
                                <div class="col-md-2">
                                    <div class="form-group" style="margin-top:8px;">
                                        <select class="form-control input-sm" ng-model="selectedFederationId"
                                                ng-change="searchChange()">
                                            <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
                                        </select>
                                    </div>
                                </div>
                                <%}%>
                                <%if (hasPermissions(request, Groups.FEDERATION_MANAGER.getName())) {%>
                                <div class="col-md-2">
                                    <div class="form-group" style="margin-top:8px;">
                                        <select class="form-control input-sm" ng-model="selectedFederationId"
                                                ng-change="searchChange()">
                                            <option ng-repeat="f in managerFederations" value="{{f.id}}">{{f.name}}</option>
                                        </select>
                                    </div>
                                </div>
                                <%}%>
                                <div class="col-md-4">
                                    <div class="form-group" style="margin-top:8px;">
                                        <input type="text" class="form-control"
                                               ng-model="search.fullText">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <button class="btn btn-raised btn-primary btn-round waves-effect m-l-20"
                                                ng-click="searchChange()">Search
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group text-right">
                                        <button class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="exportToExcel('#requestList')"
                                                title="Download Excel">
                                            <i class="zmdi zmdi-download"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <table class="table" id="requestList">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Federation</th>
                                    <th>Competition</th>
                                    <th>Category</th>
                                    <th>Date of competition</th>
                                    <th>Location</th>
                                    <th>Number of Teams</th>
                                    <th>Professional / amateur</th>
                                    <th>Sport/Discipline</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr ng-repeat="i in events">
                                    <th><span>{{$index + 1}}</span></th>
                                    <td>{{i.federationUser.name}}</td>
                                    <td>{{i.name}}</td>
                                    <td>{{i.category}}</td>
                                    <td>{{i.competitionDate}}</td>
                                    <td>{{i.location}}</td>
                                    <td>{{i.groupQuantity}}</td>
                                    <td>{{i.professional}}</td>
                                    <td>{{i.discipline}}</td>
                                    <td style="min-width: 127px; width: auto;">
                                        <button
                                                class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="detailMessage(i)"
                                                data-toggle="modal" data-target="#infoModal"
                                                title="Detail Info">
                                            <i class="zmdi zmdi-info"></i></button>
                                        <span ng-show="<%=hasPermissions(request, Groups.FEDERATION_MANAGER.getName())%>">
                                            <button type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Edit"
                                                    ng-click="editEvent(i.id)">
                                                 <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                            </button>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>

                            <div class="col-md-12">
                                <br/>
                                <input type="button" ng-show="size2>=limit" class="btn btn-primary btn-xs"
                                       value="Load More"
                                       ng-click="loadMore2();">
                                <input type="button" ng-show="size2>=limit" class="btn btn-primary btn-xs"
                                       value="Load All"
                                       ng-click="loadAll2();">
                            </div>


                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>


</div>

<%@include file="footer2.jsp" %>