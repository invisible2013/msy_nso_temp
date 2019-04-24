<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header2.jsp" %>

<script>

    var app = angular.module("app", ["ui.bootstrap"]);
    app.controller("messageCtrl", function ($scope, $http, $filter) {
        $scope.currentUserId = 0;
        $scope.years = [];
        $scope.events = [];
        $scope.search = [];
        $scope.start = 0;
        $scope.limit = 10;
        $scope.size = 0;

        $scope.messages2 = [];
        $scope.search2 = [];
        $scope.start2 = 0;
        $scope.size2 = 0;
        var currentYear = new Date().getFullYear();
        for (var a = 2016; a <= currentYear; a++) {
            $scope.years.push({id: a, name: a});
        }

        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };

        $scope.search = {offset: $scope.start, limit: $scope.limit, statusId: 1};
        $scope.search2 = {offset: $scope.start2, limit: $scope.limit, statusId: 2};
        function getEventsSuccessFirst(res) {
            getEventsSuccess(res);
            //$scope.search.year = currentYear;
        }

        function getEventsSuccess(res) {
            $scope.events = $scope.events.concat(res.data);
            $scope.size = res.data.length;
        }

        function getEventsSuccessSecond(res) {
            $scope.messages2 = $scope.messages2.concat(res.data);
            $scope.size2 = res.data.length;
        }

        ajaxCall($http, "message/get-messages", angular.toJson($scope.search), getEventsSuccessFirst);

        ajaxCall($http, "message/get-messages", angular.toJson($scope.search2), getEventsSuccessSecond);


        function getUser(res) {
            $scope.current = res.userData;
            $scope.currentUserId = $scope.current.id;
        }

        ajaxCall($http, "get-user", {}, getUser);


        $scope.loadMore = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            ajaxCall($http, "message/get-messages", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.loadAll = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            $scope.search.limit = 1000000;
            ajaxCall($http, "message/get-messages", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };

        $scope.searchChange = function () {
            $scope.search.offset = $scope.start;
            $scope.search.limit = $scope.limit;
            $scope.events = [];
            ajaxCall($http, "message/get-messages", angular.toJson($scope.search), getEventsSuccess, null, "requestList");
        };


        $scope.loadMore2 = function () {
            $scope.search2.offset = $scope.search2.offset + $scope.search2.limit;
            ajaxCall($http, "message/get-messages", angular.toJson($scope.search2), getEventsSuccessSecond, null, "requestList2");
        };

        $scope.loadAll2 = function () {
            $scope.search2.offset = $scope.search2.offset + $scope.search2.limit;
            $scope.search2.limit = 1000000;
            ajaxCall($http, "message/get-messages", angular.toJson($scope.search2), getEventsSuccessSecond, null, "requestList2");
        };

        $scope.searchChange2 = function () {
            $scope.search2.offset = $scope.start2;
            $scope.search2.limit = $scope.limit;
            $scope.messages2 = [];
            ajaxCall($http, "message/get-messages", angular.toJson($scope.search2), getEventsSuccessSecond, null, "requestList2");
        };


        $scope.sendDocument = function (eventId) {
            //window.location = "new-request?type=report&eventId=" + eventId;
            window.location = "documents?eventId=" + eventId;
        };
        $scope.sendEvent = function (eventId) {
            if (confirm("You need to confirm this operation")) {
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

        $scope.sendBlockMessage = function (messageId) {
            if (isEmptyValue($scope.targetEventRequest.note)) {
                Modal.info('Please, enter note ');
                return;
            }
            ajaxCall($http, "message/return-message", angular.toJson($scope.targetEventRequest), reload);
        };

        $scope.selectEvent = function (messageId) {
            $scope.targetEventRequest = {messageId: messageId};
        };
        $scope.detailMessage = function (message) {
            $scope.detailInfo = message;
            function getEventHistory(res) {
                $scope.history = res.data;
            }

            ajaxCall($http, "message/get-message-history", angular.toJson({'messageId': message.id}), getEventHistory);
        };
        $scope.closeEvent = function (eventId) {
            Modal.confirm("You need to confirm this operation", function () {
                ajaxCall($http, "event/close-event", angular.toJson({'eventId': eventId}), function () {
                    Modal.info('The operation completed successfully');
                    location.reload();
                });
            })
        };

        $scope.sendResponseMessage = function () {
            if (isEmptyValue($scope.targetEventRequest.note)) {
                Modal.info('Enter Note');
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
                    Modal.info("Response sent successfully", function () {
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

        $scope.open = function (name) {
            if (name.indexOf('.pdf') >= 0 || name.indexOf('.jpg') >= 0 || name.indexOf('.png') >= 0) {
                window.open('file/draw/' + name + '/');
            } else {
                window.open('file/download/' + name + '/');
            }
        };


    })
    ;
</script>

<div ng-controller="messageCtrl" id="beArea">


    <div class="modal fade" id="sendResponseModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="addIdNumberLabel">Send Response</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <div class="form-group col-sm-12">
                                <label class="control-label">Note</label>
                                <textarea rows="3" class="form-control input-sm"
                                          ng-model="targetEventRequest.note"></textarea>
                            </div>
                            <div class="form-group col-sm-12">
                                <label>File</label>
                                <input type="file" id="documentId" name="file"
                                       class="form-control input-sm upload-file">
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary waves-effect"
                            ng-click="sendResponseMessage()">Send
                    </button>
                    <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="blockModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="">Block</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <div class="form-group col-sm-12">
                                <label class="control-label">Note</label>
                                <textarea rows="3" class="form-control input-sm"
                                          ng-model="targetEventRequest.note"></textarea>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary waves-effect"
                            ng-click="sendBlockMessage()">Send
                    </button>
                    <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>


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
                                    <th>Number :</th>
                                    <td>{{detailInfo.number}}</td>
                                </tr>
                                <tr>
                                    <th class="">Create Date :</th>
                                    <td>{{detailInfo.createDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">Sender User :</th>
                                    <td>{{detailInfo.senderUser.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Title :</th>
                                    <td>{{detailInfo.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Description :</th>
                                    <td>{{detailInfo.description}}</td>
                                </tr>
                                <tr>
                                    <th class="">File :</th>
                                    <td><a style="text-decoration: underline; color:#6572b8; cursor: pointer;"
                                           target="_blank"
                                           ng-show="detailInfo.url.length>0" ng-click="open(detailInfo.url);">File</a>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="">Deadline :</th>
                                    <td>{{detailInfo.dueDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">Status :</th>
                                    <td>{{detailInfo.messageStatus.name}}</td>
                                </tr>
                            </table>
                            <div class="col-sm-12" ng-show="history.length > 0">
                                <h4><b>History</b></h4>
                                <hr>
                                <table class="table table-striped">
                                    <tr>
                                        <th>#</th>
                                        <th>Sender User</th>
                                        <th>Receiver</th>
                                        <th>Status</th>
                                        <th>Note</th>
                                        <th>File</th>
                                        <th>Date</th>
                                    </tr>
                                    <tr ng-repeat="h in history">
                                        <td>{{$index + 1}}</td>
                                        <td>{{h.sender.name}}</td>
                                        <td>{{h.recipient.name}}</td>
                                        <td>{{h.messageStatus.description}}</td>
                                        <td>{{h.note}}</td>
                                        <td><a style="text-decoration: underline; color:#6572b8; cursor: pointer;"
                                               target="_blank"
                                               ng-show="h.url.length>0" ng-click="open(h.url);">File</a></td>
                                        <td>{{h.createDate}}</td>
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

    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Notifications
                        <small>New messages, Replied messages</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Notifications</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">


                    <div class="card">
                        <div class="body">
                            <h6>New correspondence</h6>
                            <div class="row">
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
                            </div>
                            <table class="table table-hover" id="requestList">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>N</th>
                                    <th>Sender User</th>
                                    <th>Receiver User</th>
                                    <th>Title</th>
                                    <th>Text</th>
                                    <th>File</th>
                                    <th>Deadline</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr ng-repeat="i in events"
                                    ng-class="{'xl-pink': (i.messageStatus.id == 3),'xl-khaki': (i.messageStatus.id == 1)}">
                                    <th><span
                                            ng-class="{'badge badge-danger': (i.messageStatus.id == 3),'badge badge-warning': (i.messageStatus.id == 1)}">{{$index + 1}}</span>
                                    </th>
                                    <td>{{i.createDate}}</td>
                                    <td style="min-width: 100px; font-weight: bold;">{{i.number}}</td>
                                    <td>{{i.senderUser.name}}</td>
                                    <td>{{i.receiverUser.name}}</td>
                                    <td>{{i.name}}</td>
                                    <td>{{i.description}}</td>
                                    <td><a style="text-decoration: underline; color:#6572b8; cursor: pointer;"
                                           target="_blank"
                                           ng-show="i.url.length>0" ng-click="open(i.url);">File</a></td>
                                    <td>{{i.dueDate}}</td>
                                    <td>{{i.messageStatus.name}}</td>
                                    <td style="min-width: 163px; width: auto;">
                                        <button
                                                class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="detailMessage(i)"
                                                data-toggle="modal" data-target="#infoModal"
                                                title="Detail Info">
                                            <i class="zmdi zmdi-info"></i></button>
                                        <span ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
                                             <button ng-show="i.messageStatus.id == 1 || i.messageStatus.id == 3"
                                                     type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                     title="Send Response" data-toggle="modal"
                                                     data-target="#sendResponseModal"
                                                     ng-click="selectEvent(i.id)">
                                                <i class="zmdi zmdi-check-circle-u"></i>
                                            </button>
                                        </span>

                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName()) || hasPermissions(request, Groups.ADMIN.getName())%>">
                                            <button ng-show="i.messageStatus.id == 1"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    data-toggle="modal" data-target="#blockModal"
                                                    title="Block"
                                                    ng-click="selectEvent(i.id)">
                                                 <i class="zmdi zmdi-block"></i>
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


                    <div class="card">
                        <div class="body">
                            <h6>Performed correspondence</h6>
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group" style="margin-top:8px;">
                                        <input type="text" class="form-control"
                                               ng-model="search2.fullText">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <button class="btn btn-raised btn-primary btn-round waves-effect m-l-20"
                                                ng-click="searchChange2()">Search
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <table class="table table-hover" id="requestList2">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>N</th>
                                    <th>Sender User</th>
                                    <th>Receiver User</th>
                                    <th>Title</th>
                                    <th>Text</th>
                                    <th>File</th>
                                    <th>Deadline</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr ng-repeat="i in messages2" class="xl-seagreen">
                                    <th><span
                                            ng-class="{'badge badge-danger': (i.blocked == true),'badge badge-success': (i.messageStatus.id == 2)}">{{$index + 1}}</span>
                                    </th>
                                    <td>{{i.createDate}}</td>
                                    <td style="min-width: 100px; font-weight: bold;">{{i.number}}</td>
                                    <td>{{i.senderUser.name}}</td>
                                    <td>{{i.receiverUser.name}}</td>
                                    <td>{{i.name}}</td>
                                    <td>{{i.description}}</td>
                                    <td><a style="text-decoration: underline; color:#6572b8; cursor: pointer;"
                                           target="_blank"
                                           ng-show="i.url.length>0" ng-click="open(i.url);">ფაილი</a></td>
                                    <td>{{i.dueDate}}</td>
                                    <td>{{i.messageStatus.name}}</td>
                                    <td style="min-width: 163px; width: auto;">
                                        <button
                                                class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="detailMessage(i)"
                                                data-toggle="modal" data-target="#infoModal"
                                                title="detail info">
                                            <i class="zmdi zmdi-info"></i></button>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName()) || hasPermissions(request, Groups.ADMIN.getName())%>">
                                            <button ng-show="i.messageStatus.id == 2"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    data-toggle="modal" data-target="#blockModal"
                                                    title="Block"
                                                    ng-click="selectEvent(i.id)">
                                                 <i class="zmdi zmdi-block"></i>
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