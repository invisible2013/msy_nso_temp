<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>
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
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ გაგზავნა?", function () {
                $scope.eventSendRequest = {eventId: eventId};
                ajaxCall($http, "event/send-event", angular.toJson($scope.eventSendRequest), reload);
            })
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

        $scope.blockEvent = function (itemId) {
            Modal.confirm("დაადასტურეთ ოპერაცია", function () {
                $scope.targetEventRequest = {};
                $scope.targetEventRequest.eventId = itemId;
                ajaxCall($http, "event/return-event", angular.toJson($scope.targetEventRequest), reload);
            })
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


    });
</script>

<div class="col-md-12" ng-controller="homeCtrl">

    <div class="modal fade bs-example-modal-md" id="addIdNumberModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="addIdNumberLabel">განაცხადის ნომრის მინიჭება</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">განაცხადის ნომერი</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-sm"
                                           ng-model="targetEventRequest.idNumber">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addIdNumberEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="addRegNumberModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="addRegNumberLabel">ანგარიშის ნომრის მინიჭება</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">ანგარიშის ნომერი</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-sm"
                                           ng-model="targetEventRequest.registrationNumber">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addRegNumberEvent()">გაგზავნა
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="dispatchModal" tabindex="-1" role="dialog"
         aria-labelledby="dispatchModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="dispatchModalLabel">გადანაწილება</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">ადრესატი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="selectedUserType"
                                            ng-change="changeUserTypes()">
                                        <!--<option  value="1">nino</option>-->
                                        <option ng-repeat="t in userTypes" value="{{t.id}}">{{t.name}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" ng-show="selectedUserType == 3">
                                <label class="control-label col-sm-3">მომხმარებელი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="targetEventRequest.supervisorId">
                                        <option ng-repeat="u in users" value="{{u.id}}">{{u.name}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" ng-show="selectedUserType == 5">
                                <label class="control-label col-sm-3">მომხმარებელი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="targetEventRequest.accountantId">
                                        <option ng-repeat="u in users" value="{{u.id}}">{{u.name}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">შენიშვნა</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control input-sm" rows="5"
                                              ng-model="targetEventRequest.note"></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="dispatchEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="accountantModal" tabindex="-1" role="dialog"
         aria-labelledby="accountantModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="accountantModalLabel">ბუღალტერთან გაგზავნა</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">ბუღალტერი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="targetEventRequest.accountantId">
                                        <option ng-repeat="u in accountant" value="{{u.id}}">{{u.name}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">შენიშვნა</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control input-sm" rows="5"
                                              ng-model="targetEventRequest.note"></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="accountantEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="processModal" tabindex="-1" role="dialog"
         aria-labelledby="processModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="processModalLabel">შესრულება</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">შენიშვნა</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control input-sm" rows="5"
                                              ng-model="targetEventRequest.note"></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="processEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="addAmountModal" tabindex="-1" role="dialog"
         aria-labelledby="addAmountModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="amountModalLabel">თანხის დამატება</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">თანხა</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-sm"
                                           ng-model="targetEventRequest.amount">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addAmountEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="rejectModal" tabindex="-1" role="dialog"
         aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="rejectModalLabel">უარი</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">შენიშვნა</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control input-sm" rows="5"
                                              ng-model="targetEventRequest.note"></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="rejectEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="returnModal" tabindex="-1" role="dialog"
         aria-labelledby="returnModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="returnModalLabel">უკან დაბრუნება</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">შენიშვნა</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control input-sm" rows="5"
                                              ng-model="targetEventRequest.note"></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="returnEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="approveModal" tabindex="-1" role="dialog"
         aria-labelledby="approveModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="approveModalLabel">დასტური</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3">შენიშვნა</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control input-sm" rows="5"
                                              ng-model="targetEventRequest.note"></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="approveEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <%@include file="../detail.jsp" %>

    <br/>
    <div>
    </div>
    <div class="row">
        <div class="form-group col-sm-2">
            <label class="control-label">წელი</label>
            <select class="form-control input-sm" ng-model="search.year" ng-change="searchChange()">
                <option ng-repeat="is in years" value="{{is.id}}">{{is.name}}</option>
            </select>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label">საძიებო სიტყვა</label>
            <input type="text" class="form-control input-sm"
                   ng-model="search.fullText">
        </div>
        <div class="form-group col-sm-2">
            <button class="btn btn-primary btn-xs" style="margin-top: 21px;" ng-click="searchChange()">ძებნა</button>
        </div>
    </div>
    <table class="table table-striped table-hover" id="requestList">
        <tr>
            <th>ID</th>
            <th>თარიღი</th>
            <th>N</th>
            <th>ფედერაცია</th>
            <th>ტიპი</th>
            <th>ღონისძიება</th>
            <th>ბიუჯეტი</th>
            <th>პასუხისმგებელი პირი</th>
            <th>დაწყების თარიღი</th>
            <th>სტატუსი</th>
            <th></th>
        </tr>
        <tr ng-repeat="i in events">
            <td><span
                    ng-class="{'label label-danger': (i.lastStatus.id == 1 || i.lastStatus.id == 4 || i.lastStatus.id == 9 || i.blocked == true),'label label-success': (i.lastStatus.id < 9 && i.lastStatus.id >= 6),'label label-warning': ((i.lastStatus.id >= 2 && i.lastStatus.id < 6) || i.lastStatus.id > 9)}">{{$index + 1}}</span>
            </td>
            <td>{{i.lastStatusDate}}</td>
            <td style="min-width: 100px; font-weight: bold;">{{i.idNumber}}</td>
            <td>{{i.senderUser.name}}</td>
            <td>{{i.applicationType.name}}</td>
            <td>{{i.eventName}}</td>
            <td>{{i.budget}}</td>
            <td>{{i.responsiblePerson}}</td>
            <td>{{i.startDate}}</td>
            <td><span ng-class="{'label label-danger': (i.lastStatus.id == 4 || i.lastStatus.id == 9)}"> {{i.lastStatus.description}}</span>
            </td>
            <td style="min-width: 160px; width: auto;">
                <a href="detailInfo?Id={{i.key}}" target="_blank" class="btn btn-xs btn-default"
                   title="დეტალური ინფორმაცია"><span
                        class="glyphicon glyphicon-info-sign"></span></a>
                <span ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
                    <button ng-show="(i.lastStatus.id == 1) && i.iteration == 1"
                            type="button" class="btn btn-xs" title="რედაქტირება" ng-click="editEvent(i.id)">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>
                    <button ng-show="i.lastStatus.id == 1"
                            type="button" class="btn btn-xs" title="გაგზავნა"
                            ng-click="sendEvent(i.id)">
                        <span class="glyphicon glyphicon-send"></span>
                    </button>
                    <button ng-show="i.lastStatus.id == 4 || i.lastStatus.id == 13 || (i.lastStatus.id == 4 && i.iteration==2)"
                            type="button"
                            class="btn btn-xs" title="ანგარიშის გაგზავნა"
                            ng-click="sendDocument(i.id)">
                        <span class="glyphicon glyphicon-file"></span>
                    </button>
                    <button ng-show="i.lastStatus.id == 1" type="button" class="btn btn-xs"
                            ng-click="deleteEvent(i.id)">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </span>
                <span ng-show="<%=hasPermissions(request, Groups.SUPERVISOR.getName())%>">
                </span>
                <span ng-show="<%=hasPermissions(request, Groups.ACCOUNTANT.getName())%>">
                </span>
                <span ng-show="<%=hasPermissions(request, Groups.CHANCELLERY.getName())%>">
                    <button ng-show="i.lastStatus.id == 2"
                            type="button" class="btn btn-xs"
                            title="ნომრის მინიჭება" data-toggle="modal" data-target="#addIdNumberModal"
                            ng-click="selectEvent(i.id)">
                        <span class="glyphicon glyphicon-ok-circle"></span>
                    </button>
                </span>
                <span ng-show="<%=hasPermissions(request, Groups.CHANCELLERY.getName())%>">
                    <button ng-show="i.lastStatus.id == 7 || i.lastStatus.id == 6"
                            type="button" class="btn btn-xs"
                            title="ანგარიშის ნომრის მინიჭება" data-toggle="modal" data-target="#addRegNumberModal"
                            ng-click="selectEvent(i.id)">
                        <span class="glyphicon glyphicon-ok-circle"></span>
                    </button>
                </span>
                <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                    <button ng-show="(i.iteration == 1 && (i.lastStatus.stage == 5
                    || i.lastStatus.stage == 11 || i.lastStatus.stage == 12
                    || (i.lastStatus.stage == 9 && i.lastUserId == currentUserId)))"
                            type="button" class="btn btn-xs" title="თანხმობა" data-toggle="modal"
                            data-target="#approveModal"
                            ng-click="selectEvent(i.id)">
                        <span class="glyphicon glyphicon-ok"></span>
                    </button>
                </span>
                <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                    <button ng-show="i.lastStatus.id == 13"
                            type="button" class="btn btn-xs btn-danger"
                            title="დაბლოკვა"
                            ng-click="blockEvent(i.id)">
                        <span class="glyphicon glyphicon-backward"></span>
                    დაბლოკვა
                    </button>
                    </span>

            </td>
        </tr>
    </table>
    <div class="col-md-12">
        <br/>
        <input type="button" ng-show="size>=limit" class="btn btn-primary btn-xs"
               value="მეტის ჩატვირთვა"
               ng-click="loadMore();">
        <input type="button" ng-show="size>=limit" class="btn btn-primary btn-xs"
               value="ყველას ჩატვირთვა"
               ng-click="loadAll();">
        <br/>
        <br/>
        <br/>
        <br/>
    </div>
</div>
<br/>
<%@include file="footer.jsp" %>
