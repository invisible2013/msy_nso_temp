<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>

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
            $scope.search.offset = $scope.start;
            $scope.search.limit = $scope.limit;
            $scope.events = [];
            ajaxCall($http, "event/get-history-events-by", angular.toJson($scope.search), getSuccessEvent, null, "requestList");
        };
        $scope.returnEvent = function (itemId) {
            Modal.confirm("დაადასტურეთ ოპერაცია", function () {
                $scope.targetEventRequest = {};
                $scope.targetEventRequest.eventId = itemId;
                ajaxCall($http, "event/return-event", angular.toJson($scope.targetEventRequest), reload);
            })
        };
    });
</script>

<div class="col-md-12" ng-controller="homeCtrl">
    <%@include file="../detail.jsp" %>
    <br/>
    <div class="modal fade bs-example-modal-md" id="addIdNumberModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="addIdNumberLabel">ანგარიშის ნომრის მინიჭება</h4>
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
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addIdNumberEvent()">გაგზავნა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="form-group col-sm-2">
            <label class="control-label">წელი</label>
            <select class="form-control input-sm" ng-model="search.year" ng-change="searchChange()">
                <option ng-repeat="is in years" value="{{is.id}}">{{is.name}}</option>
            </select>
        </div>
    </div>
    <table class="table table-striped table-hover" id="requestList">
        <tr>
            <th>ID</th>
            <th>N1</th>
            <th>N2</th>
            <th>ფედერაცია</th>
            <th>ტიპი</th>
            <th>ღონისძიება</th>
            <th>ბიუჯეტი</th>
            <th>დაწყ/დასრ თარიღი</th>
            <th>გადაწყვეტილება</th>
            <th></th>
        </tr>
        <tr ng-repeat="i in events">
            <td><span
                    ng-class="{'label label-danger': (i.eventDecision.id == 2),'label label-success': (i.eventDecision.id == 1)}">{{$index + 1}}</span>
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
                <a href="detailInfo?Id={{i.key}}" target="_blank" class="btn btn-xs btn-default"
                   title="დეტალური ინფორმაცია"><span
                        class="glyphicon glyphicon-info-sign"></span></a>
                <%--<button ng-show="<%out.print(userDTO.getUsersGroup().getName().equals(Groups.CHANCELLERY.getName()));%>"
                        type="button" class="btn btn-xs"
                        title="ნომრის მინიჭება" data-toggle="modal" data-target="#addIdNumberModal"
                        ng-click="selectEvent(i.id)">
                    <span class="glyphicon glyphicon-ok-circle"></span>
                </button>--%>
                <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                    <button ng-show="i.eventDecision.id==1"
                            type="button" class="btn btn-xs btn-danger"
                            title="დაბრუნება"
                            ng-click="returnEvent(i.id)">
                        <span class="glyphicon glyphicon-backward"></span>
                    დაბრუნება
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
<%@include file="footer.jsp" %>
