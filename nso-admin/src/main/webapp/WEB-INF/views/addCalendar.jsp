<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>
<link href="resources/css/select2.min.css" rel="stylesheet"/>


<script>
    var app = angular.module("app", []);
    app.controller("addCalendarCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.calendar = {};
        $scope.calendar.persons = [];
        $scope.calendar.personsIds = [];
        $scope.currentCalendarId = 0;
        $scope.selectedPersonId = 0;

        if (absUrl.split("?")[1]) {
            $scope.currentCalendarId = absUrl.split("?")[1].split("=")[1];
        }

        $scope.types = [];
        $scope.persons = [];
        $scope.documents = [];
        $scope.documentTypes = [];

        if ($scope.currentCalendarId > 0) {
            function getCalendar(res) {
                $scope.calendar = res.data;
                $scope.calendar.calendarTypeId = $scope.calendar.calendarType.id;
                console.log(res.data);
            }

            ajaxCall($http, "calendar/get-calendar", angular.toJson({'id': $scope.currentCalendarId}), getCalendar);

        } else {
            $scope.calendar = {'id': $scope.currentCalendarId, 'calendarTypeId': 1};
        }

        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };


        $scope.addCalendar = function () {
            $scope.calendar.eventDate = $('#eventDate').val();
            $scope.calendar.endDate = $('#endDate').val();
            if (isEmptyValue($scope.calendar.name)) {
                Modal.info('Enter Name');
                return;
            }
            if (isEmptyValue($scope.calendar.calendarTypeId)) {
                Modal.info('Enter Calendar Type');
                return;
            }

            ajaxCall($http, "calendar/add-calendar", angular.toJson($scope.calendar), function (res) {
                window.location = "calendar";
            });
        };

        $scope.changeEventType = function () {
            function getEventTypesSuccess(res) {
                $scope.types = res.data;
            }

            ajaxCall($http, "misc/get-event-types", {applicationTypeId: $scope.event.applicationTypeId}, getEventTypesSuccess);
        };

        function getEventsSuccess(res) {
            $scope.persons = res.data;
        }

        ajaxCall($http, "event/get-persons", {}, getEventsSuccess);


        $scope.person = {};

        function getCalendarTypes(res) {
            $scope.calendarTypes = res.data;
        }

        ajaxCall($http, "misc/get-calendar-types", null, getCalendarTypes);


        $scope.addPersonItem = function () {
            $scope.selectedPersonId = $(".js-example-basic-single option:selected").val();
            var selected = $filter('filter')($scope.persons, {id: parseInt($scope.selectedPersonId)}, true);
            $scope.calendar.persons.push(selected[0]);
            $scope.calendar.personsIds.push(selected[0].id);
        };


        $scope.deletePersonItem = function (index) {
            Modal.confirm("You need to confirm this operation", function () {
                $scope.selected = $scope.calendar.persons[index];
                $scope.calendar.persons.splice($scope.calendar.persons.indexOf($scope.selected), 1);
                Modal.hide();
            })
        };

        $scope.open = function (name) {
            if (name.indexOf('.pdf') >= 0) {
                window.open('file/draw/' + name + '/');
            } else {
                window.open('file/download/' + name + '/');
            }
        };


        $scope.filterPerson = function (searchTerm) {
            if (searchTerm) {
                return function (s) {
                    return (s.firstName.indexOf(searchTerm) > -1 || s.lastName.indexOf(searchTerm) > -1 || s.personalNumber.indexOf(searchTerm) > -1);
                }
            }
        };
    })
    ;

</script>

<div ng-controller="addCalendarCtrl" id="eventControllerId">
    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>New Event
                        <small>Add Calendar Event</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">New Event</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">

                            <div>
                                <form class="form-horizontal col-md-10">
                                    <div class="form-group col-sm-8">
                                        <label>Event</label>
                                        <input type="text" ng-model="calendar.name"
                                               class="form-control input-sm">
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label>Event type</label>
                                        <select class="form-control input-sm" ng-model="calendar.calendarTypeId">
                                            <option ng-repeat="is in calendarTypes" value="{{is.id}}">{{is.name}}
                                            </option>
                                        </select>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label>Location of the event</label>
                                        <input type="text" ng-model="calendar.location"
                                               class="form-control input-sm">
                                    </div>
                                    <div class="form-group col-sm-8" id="test">
                                        <label>Start Date</label>
                                        <input type="text" id="eventDate" ng-model="calendar.eventDate"
                                               class="form-control input-sm">
                                    </div>
                                    <div class="form-group col-sm-8" id="test">
                                        <label>End Date</label>
                                        <input type="text" id="endDate" ng-model="calendar.endDate"
                                               class="form-control input-sm">
                                    </div>
                                    <div class="col-sm-8 row">
                                        <div class="form-group col-sm-6">
                                            <label>I quarter</label>
                                            <input type="number" ng-model="calendar.first"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-sm-6">
                                            <label>II quarter</label>
                                            <input type="number" ng-model="calendar.second"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-sm-6">
                                            <label>III quarter</label>
                                            <input type="number" ng-model="calendar.third"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-sm-6">
                                            <label>IV quarter</label>
                                            <input type="number" ng-model="calendar.fourth"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label>Participants</label>
                                        <input type="text" ng-model="calendar.participant"
                                               class="form-control input-sm">
                                    </div>

                                    <%-- მონაწილეების დამატება იყო რეესტრიდან ამომაღებინეს 05.06.2018
                                    <div class="col-sm-8">
                                        <label class="control-label">აირჩიეთ *</label>
                                        <div class="row clearfix">
                                            <div class="col-sm-9" id="calendar-select">
                                                <select class="form-control js-example-basic-single m-t-10"
                                                        ng-model="selectedPersonId">
                                                    <option ng-repeat="t in persons" value="{{t.id}}">{{t.firstName}}
                                                        {{t.lastName}} ({{t.personalNumber}})
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-sm-2">
                                                <button class="btn btn-primary btn-icon btn-round m-l-10" type="button"
                                                        ng-click="addPersonItem()">
                                                    <i class="zmdi zmdi-plus"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-11">
                                        <table class="table table-striped table-hover">
                                            <tr>
                                                <th>მონაწილე</th>
                                                <th>პირადი ნომერი</th>
                                                <th></th>
                                            </tr>
                                            <tr ng-repeat="x in calendar.persons">
                                                <td>
                                                    <a class="m-r-10" ng-click="open(x.imageUrl);">
                                                        <img src="file/draw/{{x.optimizedImageUrl}}/"
                                                             class="rounded-circle avatar"
                                                             style="height: 50px; width: 50px;"
                                                        >
                                                    </a> {{ x.firstName}} {{ x.lastName}}
                                                </td>
                                                <td>{{ x.personalNumber}}</td>
                                                <td>
                                                    <button type="button" class="btn btn-sm btn-icon btn-neutral"
                                                            ng-click="deletePersonItem($index);">
                                                        <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>--%>

                                    <div class="form-group col-sm-8">
                                        <br/><br/>
                                        <button type="button" class="btn btn-primary btn-xs" ng-click="addCalendar()">
                                            Save
                                        </button>
                                    </div>
                                    <div class="form-group"><br/><br/></div>
                                </form>
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
<script src="resources/js/select2.min.js"></script>
<script>
    $(document).ready(function () {

        $('.js-example-basic-single').select2();

        $('#eventDate').datepicker({
            format: 'dd/mm/yyyy'
        });
        $('#endDate').datepicker({
            format: 'dd/mm/yyyy'
        });
    });
</script>