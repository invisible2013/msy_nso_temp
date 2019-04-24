<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header2.jsp" %>

<script>

    var app = angular.module("app", ["ui.bootstrap"]);
    app.controller("homeCtrl", function ($scope, $http, $filter) {
        $scope.currentUserId = 0;
        $scope.years = [];
        $scope.events = [];
        $scope.search = [];
        $scope.start = 0;
        $scope.limit = 40;
        $scope.size = 0;
        var currentYear = new Date().getFullYear();
        for (var a = 2016; a <= currentYear; a++) {
            $scope.years.push({id: a, name: a});
        }

        $scope.search = {offset: $scope.start, limit: $scope.limit};
        function getEventsSuccessFirst(res) {
            getEventsSuccess(res);
            $scope.search.year = currentYear;
        }

        function getEventsSuccess(res) {
            $scope.events = $scope.events.concat(res.data);
            $scope.size = res.data.length;
        }

        ajaxCall($http, "event/get-events-by", angular.toJson({
            year: currentYear,
            offset: $scope.start,
            limit: $scope.limit
        }), getEventsSuccessFirst);

        function getSuccessAccountant(res) {
            $scope.accountant = res.data;
        }

        $scope.userGroupRequest = {userGroupId: 5};
        ajaxCall($http, "event/get-group-users", angular.toJson($scope.userGroupRequest), getSuccessAccountant);
        function getPersonTypes(res) {
            $scope.personTypes = res.data;
        }

        ajaxCall($http, "misc/get-person-types", null, getPersonTypes);

        function getUser(res) {
            $scope.current = res.userData;
            $scope.currentUserId = $scope.current.id;
        }

        ajaxCall($http, "get-user", {}, getUser);

        function getUsersBySupervisor(res) {
            $scope.federations = res.data;
        }
        ajaxCall($http, "users/get-users-by-supervisor", null, getUsersBySupervisor);


        $scope.loadMore = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            ajaxCall($http, "event/get-events-by", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.loadAll = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            $scope.search.limit = 1000000;
            ajaxCall($http, "event/get-events-by", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.searchChange = function () {
            $scope.search.offset = $scope.start;
            $scope.search.limit = $scope.limit;
            $scope.events = [];
            ajaxCall($http, "event/get-events-by", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.userTypes = [{'id': 3, 'name': 'კურატორი'}, {'id': 5, 'name': 'ბუღალტერი'}];
        $scope.changeUserTypes = function () {
            function getSuccessUsers(res) {
                $scope.users = res.data;
            }

            $scope.userGroupRequest = {userGroupId: $scope.selectedUserType};
            ajaxCall($http, "event/get-group-users", angular.toJson($scope.userGroupRequest), getSuccessUsers);
        };
        $scope.selectedUserType = 3;
        $scope.changeUserTypes();
        $scope.getCategory = function (id) {
            return $filter('filter')($scope.personTypes, {id: id}, true)[0].name;
        };
        $scope.editEvent = function (eventId) {
            window.location = "newRequest?type=details&eventId=" + eventId;
        };
        $scope.sendDocument = function (eventId) {
            //window.location = "new-request?type=report&eventId=" + eventId;
            window.location = "documents?eventId=" + eventId;
        };
        $scope.sendEvent = function (eventId) {
            if (confirm("დარწმუნებული ხართ რომ გსურთ გაგზავნა?")) {
                $scope.eventSendRequest = {eventId: eventId};
                ajaxCall($http, "event/send-event", angular.toJson($scope.eventSendRequest), reload);
            }
        };
        $scope.infoEvent = function (eventKey) {
            window.open("detailInfo?Id=" + eventKey, "_blank");
        };
        $scope.accountantEvent = function () {
            ajaxCall($http, "event/dispatch-event-accountant", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.dispatchEvent = function () {
            ajaxCall($http, "event/dispatch-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.processEvent = function () {
            ajaxCall($http, "event/process-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.addAmountEvent = function () {
            ajaxCall($http, "event/add-amount-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.addIdNumberEvent = function () {
            ajaxCall($http, "event/add-idNumber-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.addRegNumberEvent = function () {
            ajaxCall($http, "event/add-regNumber-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.rejectEvent = function () {
            ajaxCall($http, "event/reject-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.returnEvent = function () {
            ajaxCall($http, "event/return-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.approveEvent = function () {
            ajaxCall($http, "event/approve-event", angular.toJson($scope.targetEventRequest), reload);
        };

        $scope.approveFirstEvent = function () {
            ajaxCall($http, "event/approve-first-event", angular.toJson($scope.targetEventRequest), reload);
        };
        $scope.rejectFirstEvent = function () {
            ajaxCall($http, "event/reject-first-event", angular.toJson($scope.targetEventRequest), reload);
        };

        $scope.blockEvent = function (itemId) {
            if (confirm("დაადასტურეთ ოპერაცია")) {
                $scope.targetEventRequest = {};
                $scope.targetEventRequest.eventId = itemId;
                ajaxCall($http, "event/return-event", angular.toJson($scope.targetEventRequest), reload);
            }
        };

        $scope.selectEvent = function (eventId) {
            $scope.targetEventRequest = {eventId: eventId};
        };
        $scope.detailEvent = function (eventId) {
            function getEvent(res) {
                console.log(res.data);
                $scope.detailInfo = res.data;
                $scope.persons = res.data.persons;
                $scope.documents = res.data.documents;
            }

            ajaxCall($http, "event/get-event", angular.toJson({'eventId': eventId}), getEvent);
            function getEventHistory(res) {
                $scope.history = res.data;
            }

            ajaxCall($http, "event/get-event-history", angular.toJson({'eventId': eventId}), getEventHistory);
        };
        $scope.closeEvent = function (eventId) {
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ დასრულება?", function () {
                ajaxCall($http, "event/close-event", angular.toJson({'eventId': eventId}), function () {
                    Modal.info('ღონისძიების განხილვა დასრულდა წარმატებით');
                    location.reload();
                });
            })
        };
        $scope.deleteEvent = function (id) {
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ წაშლა?", function () {
                if (id != undefined) {
                    ajaxCall($http, "event/delete-event", angular.toJson({'eventId': id}), reload);
                }
            })
        };
        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };


    })
    ;
</script>

<div ng-controller="homeCtrl">

    <div class="modal fade" id="addIdNumberModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="addIdNumberLabel">Add Id Number</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <label class="control-label">Id Number</label>
                            <div class="form-group">
                                <input type="text" class="form-control input-sm"
                                       ng-model="targetEventRequest.idNumber">
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary waves-effect"
                            ng-click="addIdNumberEvent()">Send
                    </button>
                    <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addRegNumberModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="addRegNumberLabel">Add Registration Number</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <label>Registration Number</label>
                            <div class="form-group">
                                <input type="text" class="form-control input-sm"
                                       ng-model="targetEventRequest.registrationNumber">
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addRegNumberEvent()">Send
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="approveFirstModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title">Accept</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <label>Note</label>
                            <div class="form-group">
                                    <textarea class="form-control input-group-sm" rows="2"
                                              ng-model="targetEventRequest.note"></textarea>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" ng-click="approveFirstEvent()">Send</button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="rejectModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title">Reject</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <label>Note</label>
                            <div class="form-group">
                                    <textarea class="form-control input-group-sm" rows="2"
                                              ng-model="targetEventRequest.note"></textarea>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" ng-click="rejectFirstEvent()">Send</button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="approveModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="approveModalLabel">Accept</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <label>Note</label>
                            <div class="form-group">
                                    <textarea class="form-control input-group-sm" rows="2"
                                              ng-model="targetEventRequest.note"></textarea>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" ng-click="approveEvent()">Send</button>
                </div>
            </div>
        </div>
    </div>


    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Applications
                        <small>Information</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Applications</li>
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
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <select class="form-control" ng-model="search.federationId"
                                                ng-change="searchChange()">
                                            <option ng-repeat="is in federations" value="{{is.id}}">{{is.name}}</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
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
                            </div>
                            <table class="table table-hover" id="requestList">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>N</th>
                                    <th>Federation</th>
                                    <th>Type</th>
                                    <th>Event</th>
                                    <th>Budget</th>
                                    <th>Responsible Person</th>
                                    <th>Start Date</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr ng-repeat="i in events">
                                    <th><span
                                            ng-class="{'badge badge-danger': (i.lastStatus.id == 1 || i.lastStatus.id == 4 || i.lastStatus.id == 9 || i.blocked == true),'badge badge-success': (i.lastStatus.id < 9 && i.lastStatus.id >= 6),'badge badge-warning': ((i.lastStatus.id >= 2 && i.lastStatus.id < 6) || i.lastStatus.id > 9)}">{{$index + 1}}</span>
                                    </th>
                                    <td>{{i.lastStatusDate}}</td>
                                    <td style="min-width: 100px; font-weight: bold;">{{i.idNumber}}</td>
                                    <td>{{i.senderUser.name}}</td>
                                    <td>{{i.applicationType.name}}</td>
                                    <td>{{i.eventName}}</td>
                                    <td>{{i.budget}}</td>
                                    <td>{{i.responsiblePerson}}</td>
                                    <td>{{i.startDate}}</td>
                                    <td><span
                                            ng-class="{'badge badge-danger': (i.lastStatus.id == 4 || i.lastStatus.id == 9)}"> {{i.lastStatus.description}}</span>
                                    </td>
                                    <td style="min-width: 163px; width: auto;">
                                        <button
                                                class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="infoEvent(i.key)"
                                                title="Detail Info">
                                            <i class="zmdi zmdi-info"></i></button>
                                        <span ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
                                            <button ng-show="(i.lastStatus.id == 1 || i.lastStatus.id == 14) && i.iteration == 1"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Edit"
                                                    ng-click="editEvent(i.id)">
                                                <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                            </button>
                                            <button ng-show="i.lastStatus.id == 1 || i.lastStatus.id == 14"
                                                    type="button" class="btn btn-icon btn-sm btn-neutral-purple"
                                                    title="Send"
                                                    ng-click="sendEvent(i.id)">
                                                <i class="zmdi zmdi-mail-send"></i>
                                            </button>
                                            <button ng-show="i.lastStatus.id == 4 || i.lastStatus.id == 13 || (i.lastStatus.id == 4 && i.iteration==2)"
                                                    type="button"
                                                    class="btn btn-icon btn-sm btn-neutral-purple"
                                                    title="Send Report"
                                                    ng-click="sendDocument(i.id)">
                                                <i class="zmdi zmdi-file"></i>
                                            </button>
                                            <button ng-show="i.lastStatus.id == 1" type="button"
                                                    class="btn btn-icon btn-neutral btn-sm"
                                                    ng-click="deleteEvent(i.id)">
                                                <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.SUPERVISOR.getName())%>">
                                             <button ng-show="i.lastStatus.id == 3 && i.supervisorId == currentUserId"
                                                     type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                     title="Accept" data-toggle="modal"
                                                     data-target="#approveFirstModal"
                                                     ng-click="selectEvent(i.id)">
                                                <i class="zmdi zmdi-check-circle"></i>
                                            </button>
                                            <button ng-show="(i.lastStatus.id == 3 || i.lastStatus.id == 15)&& i.supervisorId == currentUserId"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    title="Reject" data-toggle="modal"
                                                    data-target="#rejectModal"
                                                    ng-click="selectEvent(i.id)">
                                                <i class="zmdi zmdi-minus-circle"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.ACCOUNTANT.getName())%>"></span>
                                        <span ng-show="<%=hasPermissions(request, Groups.CHANCELLERY.getName())%>">
                                            <button ng-show="i.lastStatus.id == 2"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Add Id Number" data-toggle="modal"
                                                    data-target="#addIdNumberModal"
                                                    ng-click="selectEvent(i.id)">
                                                <i class="zmdi zmdi-check-circle-u"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.CHANCELLERY.getName())%>">
                                            <button ng-show="i.lastStatus.id == 7 || i.lastStatus.id == 6"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Add Registration Number" data-toggle="modal"
                                                    data-target="#addRegNumberModal"
                                                    ng-click="selectEvent(i.id)">
                                                <i class="zmdi zmdi-check-circle-u"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="(i.iteration == 1 && (i.lastStatus.stage == 11 || i.lastStatus.stage == 12
                                            || (i.lastStatus.stage == 9 && i.lastUserId == currentUserId)))"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Accept"
                                                    data-toggle="modal"
                                                    data-target="#approveModal"
                                                    ng-click="selectEvent(i.id)">
                                                <i class="zmdi zmdi-check"></i>
                                            </button>
                                        </span>

                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                        <button ng-show="i.lastStatus.id == 5"
                                                type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                title="Accept" data-toggle="modal"
                                                data-target="#approveFirstModal"
                                                ng-click="selectEvent(i.id)">
                                            <i class="zmdi zmdi-check-circle"></i>
                                        </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                        <button ng-show="(i.lastStatus.id == 5)"
                                                type="button" class="btn btn-sm btn-icon btn-neutral"
                                                title="Reject" data-toggle="modal"
                                                data-target="#rejectModal"
                                                ng-click="selectEvent(i.id)">
                                            <i class="zmdi zmdi-minus-circle"></i>
                                        </button>
                                        </span>

                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="i.lastStatus.id == 13"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    title="Block"
                                                    ng-click="blockEvent(i.id)">
                                                 <i class="zmdi zmdi-minus-circle"></i>
                                            </button>
                                        </span>

                                    </td>
                                </tr>
                                </tbody>
                            </table>

                            <div class="col-md-12">
                                <br/>
                                <input type="button" ng-show="size>=limit" class="btn btn-primary btn-xs"
                                       value="Load More"
                                       ng-click="loadMore();">
                                <input type="button" ng-show="size>=limit" class="btn btn-primary btn-xs"
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