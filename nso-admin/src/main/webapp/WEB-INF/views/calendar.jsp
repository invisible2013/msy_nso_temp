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
        $scope.limit = 10;
        $scope.size = 0;
        $scope.selectedFederationId = 0;
        $scope.multi = false;

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

        $scope.search = {offset: $scope.start, limit: $scope.limit, statusId: 1};
        function getEventsSuccessFirst(res) {
            getEventsSuccess(res);
            //$scope.search.year = currentYear;
        }

        function getEventsSuccess(res) {
            $scope.events = $scope.events.concat(res.data);
            angular.forEach($scope.events, function (value, key) {
                value.checked = false;
            });
            $scope.size = res.data.length;
        }


        ajaxCall($http, "calendar/get-calendars", angular.toJson($scope.search), getEventsSuccessFirst);

        $scope.changeAllCalendar = function () {
            if ($scope.allCalendar) {
                angular.forEach($scope.events, function (value, key) {
                    value.checked = true;
                });
            } else {
                angular.forEach($scope.events, function (value, key) {
                    value.checked = false;
                });
            }
        }

        function getUser(res) {
            $scope.current = res.userData;
            $scope.currentUserId = $scope.current.id;
        }

        ajaxCall($http, "get-user", {}, getUser);

        function getUsersByGroup(res) {
            $scope.federations = res.data;
        }

        ajaxCall($http, "users/get-users-by-group", {groupId: 4}, getUsersByGroup);


        $scope.loadMore = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            ajaxCall($http, "calendar/get-calendars", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.loadAll = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            $scope.search.limit = 1000000;
            ajaxCall($http, "calendar/get-calendars", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.searchChange = function () {
            $scope.search.federationId = $scope.selectedFederationId;
            $scope.search.offset = $scope.start;
            $scope.search.limit = $scope.limit;
            $scope.events = [];
            ajaxCall($http, "calendar/get-calendars", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };


        $scope.infoEvent = function (eventKey) {
            window.open("detailInfo?Id=" + eventKey, "_blank");
        };


        $scope.selectEvent = function (messageId) {
            $scope.targetEventRequest = {messageId: messageId};
        };
        $scope.selectMultiEvent = function () {
            $scope.multi = true;
        };
        $scope.detailMessage = function (message) {
            $scope.detailInfo = message;

        };

        $scope.closeEvent = function (eventId) {
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ დასრულება?", function () {
                ajaxCall($http, "event/close-event", angular.toJson({'eventId': eventId}), function () {
                    Modal.info('ღონისძიების განხილვა დასრულდა წარმატებით');
                    location.reload();
                });
            })
        };

        $scope.sendResponseMessage = function () {
            if (isEmptyValue($scope.targetEventRequest.note)) {
                Modal.info('შეიყვანეთ პასუხი');
                return;
            }

            var data = angular.toJson($scope.targetEventRequest).toString();

            var oMyForm = new FormData();
            oMyForm.append("data", data);
            oMyForm.append("files", $('#documentId')[0].files[0]);

            $.ajax({
                url: 'message/response-message',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    $("#beArea").removeClass("loading-mask");
                    Modal.info("The operation completed successfully", function () {
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

        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };

        $scope.addCalendarRequest = function () {
            window.location = "addCalendar";
        };

        $scope.editEvent = function (itemId) {
            window.location = "addCalendar?itemId=" + itemId;
        };

        $scope.selectEvent = function (itemId) {
            $scope.targetRequest = {id: itemId};
        };

        $scope.blockEvent = function (itemId) {
            if ($scope.multi) {
                angular.forEach($scope.events, function (value, key) {
                    if ((value.calendarStatus.id == 1 || value.calendarStatus.id == 4) && value.checked) {
                        $scope.targetRequest.id = value.id;
                        ajaxCall($http, "calendar/block-event", angular.toJson($scope.targetRequest), null);
                    }
                });
                reload();
            } else {
                ajaxCall($http, "calendar/block-event", angular.toJson($scope.targetRequest), reload);
            }
        };

        $scope.unblockEvent = function (itemId) {
            if (confirm("You need to confirm this operation")) {
                $scope.targetRequest = {id: itemId};
                ajaxCall($http, "calendar/unblock-event", angular.toJson($scope.targetRequest), reload);
            }
        };

        $scope.sendEvent = function (itemId) {
            if (confirm("You need to confirm this operation")) {
                $scope.targetRequest = {id: itemId};
                ajaxCall($http, "calendar/send-event", angular.toJson($scope.targetRequest), reload);
            }
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
                                    <th class="">Create Date:</th>
                                    <td>{{detailInfo.createDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">Start Date :</th>
                                    <td>{{detailInfo.eventDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">End Date :</th>
                                    <td>{{detailInfo.endDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">Sender Federation :</th>
                                    <td>{{detailInfo.senderUser.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Title :</th>
                                    <td>{{detailInfo.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Location :</th>
                                    <td>{{detailInfo.location}}</td>
                                </tr>
                                <tr>
                                    <th class="">Status :</th>
                                    <td>{{detailInfo.calendarStatus.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Note :</th>
                                    <td>{{detailInfo.note}}</td>
                                </tr>
                                <tr>
                                    <th class="">Participants :</th>
                                    <td>{{detailInfo.participant}}</td>
                                </tr>
                                <tr>
                                    <table class="table col-md-12">
                                        <tr>
                                            <th class="">I quarter</th>
                                            <th class="">II quarter</th>
                                            <th class="">III quarter</th>
                                            <th class="">IV quarter</th>
                                            <th class="">Total</th>
                                        </tr>
                                        <tr>
                                            <td>{{detailInfo.first}}</td>
                                            <td>{{detailInfo.second}}</td>
                                            <td>{{detailInfo.third}}</td>
                                            <td>{{detailInfo.fourth}}</td>
                                            <td>
                                                {{detailInfo.first+detailInfo.second+detailInfo.third+detailInfo.fourth}}
                                            </td>
                                        </tr>
                                    </table>
                                </tr>
                            </table>
                            <div class="col-sm-12" ng-show="detailInfo.calendarPersons.length > 0">
                                <h4><b>Participants</b></h4>
                                <hr>
                                <table class="table table-striped">
                                    <tr>
                                        <th>#</th>
                                        <th>Name</th>
                                        <th>Personal Number</th>
                                        <th>Position</th>
                                    </tr>
                                    <tr ng-repeat="h in detailInfo.calendarPersons">
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
                            <label>Note</label>
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
                    <h2>Calendar
                        <small>Event Calendar</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                    <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10" type="button"
                            ng-click="addCalendarRequest()">
                        <i class="zmdi zmdi-plus"></i>
                    </button>
                    <%}%>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Calendar</li>
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
                                <%if (hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())) {%>
                                <div class="col-md-2">
                                    <div class="form-group" style="margin-top:8px;">
                                        <select class="form-control input-sm" ng-model="selectedFederationId"
                                                ng-change="searchChange()">
                                            <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
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
                                <div class="clear"></div>
                                <div class="col-md-2" ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                    <div class="form-group">
                                        <label class="form-check-label"><input type="checkbox" class="form-check-input"
                                                                               ng-model="allCalendar"
                                                                               ng-change="changeAllCalendar()">
                                            All</label>
                                    </div>
                                </div>
                                <div class="col-md-3" ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                    <div class="form-group">
                                        <button class="btn btn-round waves-effect bg-red"
                                                data-toggle="modal"
                                                data-target="#rejectModal"
                                                ng-click="selectMultiEvent()">Block
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <table class="table" id="requestList">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Federation</th>
                                    <th>Event</th>
                                    <th>StartDate/EndDate</th>
                                    <th>Location</th>
                                    <th>EventType</th>
                                    <th>Status</th>
                                    <th>Participants</th>
                                    <th>1</th>
                                    <th>2</th>
                                    <th>3</th>
                                    <th>4</th>
                                    <th>All</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr ng-repeat="i in events"
                                    ng-class="{'xl-pink': (i.calendarStatus.id == 2),'xl-seagreen': (i.calendarStatus.id == 3)}">
                                    <th>
                                        <span ng-show="i.calendarStatus.id == 1 || i.calendarStatus.id == 4">
                                        <input type="checkbox" id="allCalendar" ng-checked="allCalendar"
                                               ng-model="i.checked">
                                            </span>
                                        <span>{{$index + 1}}</span>
                                    </th>
                                    <td>{{i.senderUser.name}}</td>
                                    <td>{{i.name}}</td>
                                    <td>{{i.eventDate}}-{{i.endDate}}</td>
                                    <td>{{i.location}}</td>
                                    <td>{{i.calendarType.name}}</td>
                                    <td>
                                        <span ng-class="{'badge badge-danger': (i.calendarStatus.id == 2),'badge badge-success': (i.calendarStatus.id == 3)}">
                                        {{i.calendarStatus.name}}</span></td>
                                    <td>{{i.participant}}</td>
                                    <td>{{i.first}}</td>
                                    <td>{{i.second}}</td>
                                    <td>{{i.third}}</td>
                                    <td>{{i.fourth}}</td>
                                    <td>{{i.first+i.second+i.third+i.fourth}}</td>
                                    <td style="min-width: 127px; width: auto;">
                                        <button
                                                class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="detailMessage(i)"
                                                data-toggle="modal" data-target="#infoModal"
                                                title="Detail Info">
                                            <i class="zmdi zmdi-info"></i></button>
                                        <span ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
                                            <button ng-show="i.calendarStatus.id == 1 ||i.calendarStatus.id == 2"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Edit"
                                                    ng-click="editEvent(i.id)">
                                                 <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="i.calendarStatus.id == 1 || i.calendarStatus.id == 4"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Approve"
                                                    ng-click="sendEvent(i.id)">
                                                 <i class="zmdi zmdi-check"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="i.calendarStatus.id == 1 || i.calendarStatus.id == 4"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    title="Block" data-toggle="modal"
                                                    data-target="#rejectModal"
                                                    ng-click="selectEvent(i.id)">
                                                 <i class="zmdi zmdi-block"></i>
                                            </button>
                                        </span>
                                        <%--<span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="i.calendarStatus.id == 2"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    title="ბლოკის მოხსნა"
                                                    ng-click="unblockEvent(i.id)">
                                                 <i class="zmdi zmdi-arrow-back"></i>
                                            </button>
                                        </span>--%>


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