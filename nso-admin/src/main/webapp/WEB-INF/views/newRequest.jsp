<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>
<link href="resources/css/select2.min.css" rel="stylesheet"/>


<script>
    var app = angular.module("app", []);
    app.controller("eventCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.event = {};
        $scope.currentEventId = 0;
        $scope.type = "details";
        $scope.isReport = false;
        $scope.eventTypes = [{'id': 1, 'name': "Application"}, {'id': 2, 'name': "Other Application"}];
        if (absUrl.split("?")[1]) {
            if (absUrl.split("?")[1].split("&")[1]) {
                $scope.currentEventId = absUrl.split("?")[1].split("&")[1].split("=")[1];
                $scope.type = absUrl.split("?")[1].split("&")[0].split("=")[1];
            }
        }
        if ($scope.type == "report") {
            isReport = true;
            $scope.type = "documents";
        }
        if ($scope.type) {
            $('.nav li a.active').removeClass('active');
            $('.nav li#' + $scope.type + ' a').addClass('active');
        }
        $scope.types = [];
        $scope.persons = [];
        $scope.documents = [];
        $scope.documentTypes = [];

        if ($scope.currentEventId > 0) {
            function getEvent(res) {
                $scope.event = res.data;
                $scope.event.applicationTypeId = $scope.event.applicationType.id;
                $scope.eventTypeId = res.data.eventType.id;
                $scope.changeEventType();
                $scope.persons = res.data.persons;
                $scope.documents = res.data.documents;

                console.log(res.data);
                function getEventDocumentTypes(res) {
                    $scope.documentTypes = res.data;
                }

                ajaxCall($http, "misc/get-document-types", {eventTypeId: $scope.event.eventTypeId}, getEventDocumentTypes);
            }

            ajaxCall($http, "event/get-event", angular.toJson({'eventId': $scope.currentEventId}), getEvent);

        } else {
            $scope.event = {'id': $scope.currentEventId, 'applicationTypeId': 1};
            function getEventTypes(res) {
                $scope.types = res.data;
            }

            ajaxCall($http, "misc/get-event-types?", {applicationTypeId: 1}, getEventTypes);
        }

        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };

        $scope.tpFilter = function (item) {
            if ($scope.isReport) {
                return (item.id == 5 || item.id == 7);
            }
            return true;
        };
        $scope.typeFilter = function (item) {
            if ($scope.isReport) {
                return (item.type.id == 5 || item.type.id == 7);
            }
            return true;
        };

        $scope.DocumentFilter = function () {
            if ($scope.documents.length > 0) {
                return false;
            }
            return true;
        };

        $scope.addEvent = function () {
            $scope.event.startDate = $('#startDate').val();
            $scope.event.endDate = $('#endDate').val();
            $scope.event.reportDeliveryDate = $('#deliveryDate').val();
            if (isEmptyValue($scope.event.eventName)) {
                Modal.info('Enter Event Name');
                return;
            }
            if (isEmptyValue($scope.event.eventTypeId)) {
                Modal.info('Enter Event Type');
                return;
            }
            if ($scope.event.applicationTypeId == 1) {
                if (isEmptyValue($scope.event.eventDescription)) {
                    Modal.info('Enter Description');
                    return;
                }
                if (isEmptyValue($scope.event.purpose)) {
                    Modal.info('Enter Goals/Tasks');
                    return;
                }
                if (isEmptyValue($scope.event.expectedResult)) {
                    Modal.info('Enter Results');
                    return;
                }

                if (isEmptyValue($scope.event.startDate)) {
                    Modal.info('Enter Start Date');
                    return;
                }
                if (isEmptyValue($scope.event.endDate)) {
                    Modal.info('Enter End Date');
                    return;
                }
                if (isEmptyValue($scope.event.reportDeliveryDate)) {
                    Modal.info('Enter deadline of Report');
                    return;
                }
                if (isEmptyValue($scope.event.budget) || isNaN($scope.event.budget)) {
                    Modal.info('Enter Budget, check format');
                    return;
                }
                if (isEmptyValue($scope.event.responsiblePerson)) {
                    Modal.info('Enter Responsible Person');
                    return;
                }
                if (isEmptyValue($scope.event.responsiblePersonPosition)) {
                    Modal.info('Enter Responsible Person Position');
                    return;
                }
            }
            if ($scope.event.applicationTypeId == 2) {
                if (isEmptyValue($scope.event.budget) || isNaN($scope.event.budget)) {
                    Modal.info('Enter Budget');
                    return;
                }
            }
            $scope.event.senderUserId = 0;

            ajaxCall($http, "event/create-event", angular.toJson($scope.event), function (res) {
                if ($scope.event.applicationTypeId == 1) {
                    window.location = "newRequest?type=details&eventId=" + res.data.id;
                } else {
                    window.location = "newRequest?type=documents&eventId=" + res.data.id;
                }
            });
        };

        $scope.changeEventType = function () {
            function getEventTypesSuccess(res) {
                $scope.types = res.data;
            }

            ajaxCall($http, "misc/get-event-types", {applicationTypeId: $scope.event.applicationTypeId}, getEventTypesSuccess);
        };

        //============START PERSON ACTIONS========================

        $scope.categories = [];
        $scope.personTypes = [];
        $scope.person = {'eventId': $scope.currentEventId, 'type': 1};

        function getPersonTypes(res) {
            $scope.personTypes = res.data;
            $scope.changePersonType();
        }

        ajaxCall($http, "misc/get-person-types", null, getPersonTypes);

        $scope.changePersonType = function () {
            $scope.personList = [];
            $scope.person.personId = "";
            function getPersonsByType(res) {
                $scope.personList = res.data;
            }

            ajaxCall($http, "event/get-person-list-by-type", {typeId: $scope.person.type}, getPersonsByType);
        };

        $scope.addPersonItem2 = function () {
            $scope.person.personId = parseInt($('#personId').val());
            if (isEmptyValue($scope.person.personId)) {
                Modal.info('Choose Participant');
                return;
            }
            ajaxCall($http, "event/add-event-person", angular.toJson($scope.person), reload);
        };

        $scope.addPersonItem = function () {
            if (isEmptyValue($scope.person.personalNumber)) {
                Modal.info('Enter Personal Number');
                return;
            }
            if (isEmptyValue($scope.person.firstName)) {
                Modal.info('Enter Firstname');
                return;
            }
            if (isEmptyValue($scope.person.lastName)) {
                Modal.info('Enter Lastname');
                return;
            }
            if (isEmptyValue($scope.person.birthDate)) {
                Modal.info('Enter Date of birth');
                return;
            }
            var file = $('#personDocumentId')[0].files[0];
            $scope.person.typeId = $scope.person.type;
            function addPersonSuccess(res) {
                console.log(res.data);
                var personId = res.data.personId;
                if (file != undefined) {
                    var oMyForm = new FormData();
                    oMyForm.append("personId", personId);
                    oMyForm.append("file", file);
                    $.ajax({
                        url: 'event/add-person-image',
                        data: oMyForm,
                        dataType: 'text',
                        processData: false,
                        contentType: false,
                        type: 'POST',
                        success: function (data) {
                            location.reload();
                        }
                    }).success(function (data) {
                        location.reload();
                    }).error(function (data, status, headers, config) {
                        location.reload();
                    });
                } else {
                    location.reload();
                }
            }

            ajaxCall($http, "event/add-person", angular.toJson($scope.person), addPersonSuccess);
        };

        $scope.editPersonItem = function (id, index) {
            $('#personDocumentId').val('');
            if (id != undefined) {
                var selected = $filter('filter')($scope.persons, {id: id}, true);
                $scope.person = selected[0];
            } else {
                $scope.person = $scope.persons[index];
            }
        };

        $scope.getCategory = function (id) {
            var selected = $filter('filter')($scope.personTypes, {id: id}, true)[0];
            if (selected != undefined) {
                return selected.name;
            }
        };

        $scope.deletePersonItem = function (id, index) {
            Modal.confirm("You need to confirm this operation", function () {
                if (id != undefined) {
                    ajaxCall($http, "event/delete-event-person", angular.toJson({'eventPersonId': id}), reload);
                } else {
                    $scope.selected = $scope.persons[index];
                    $scope.persons.splice($scope.persons.indexOf($scope.selected), 1);
                }
            })
        };

        $scope.deleteEventDocument = function (id, index) {
            Modal.confirm("You need to confirm this operation", function () {
                if (id != undefined) {
                    ajaxCall($http, "event/delete-event-document", angular.toJson({'documentId': id}), reload);
                } else {
                    $scope.selected = $scope.persons[index];
                    $scope.persons.splice($scope.persons.indexOf($scope.selected), 1);
                }
            })
        };

        $scope.searchPerson = function () {
            var request = {};
            request.personalNumber = $scope.person.personalNumber;
            function searchPersonSuccess(res) {
                console.log(res);
                var person = res.data;
                $scope.person.firstName = person.firstName;
                $scope.person.birthDate = person.birthDate;
                $scope.person.lastName = person.lastName;
                $scope.person.weightCategory = person.weightCategory;
                $scope.person.position = person.position;
                $scope.person.club = person.club;
                $scope.person.city = person.city;
                $scope.person.trainer = person.trainer;
                $scope.person.category = person.category;
            }

            ajaxCall($http, "event/find-person", angular.toJson(request), searchPersonSuccess);
        };

        // =============END PERSON ACTIONS==========================


        //============START DOCUMENT ACTIONS========================
        $scope.document = {'eventId': $scope.currentEventId};

        $scope.addDocument = function () {
            if (!$scope.document.typeId) {
                Modal.info('Choose Document Type');
                return;
            }
            /*if ($('#documentId')[0].files[0].name.indexOf('djvu') == -1) {
             Modal.info('დოკუმენტი უნდა იყოს მხოლოდ djvu  ფორმატში');
             return;
             }*/
            $("#eventControllerId").addClass('loading-mask');
            var oMyForm = new FormData();
            oMyForm.append("eventId", $scope.document.eventId);
            oMyForm.append("typeId", $scope.document.typeId);
            oMyForm.append("file", $('#documentId')[0].files[0]);
            $.ajax({
                url: 'event/add-document',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',

                success: function (data) {
                    $("#eventControllerId").removeClass('loading-mask');
                    location.reload();
                },
                error: function (data, status, headers, config) {
                    $("#eventControllerId").removeClass('loading-mask');
                    location.reload();
                }

            });
        };

        $scope.reportDocument = function () {
            Modal.confirm("დარწმუნებული ხართ რომ ყველა დოკუმენტი ატვირთეთ და გსურთ გაგზავნა?", function () {
                ajaxCall($http, "event/report-event", angular.toJson({'eventId': $scope.currentEventId}), function () {
                    window.location = "home";
                });
            })
        };

        $scope.open = function (name) {
            if (name.indexOf('.pdf') >= 0 || name.indexOf('.png') >= 0 || name.indexOf('.jpg') >= 0 || name.indexOf('.jpeg') >= 0) {
                window.open('file/draw/' + name + '/');
            } else {
                window.open('file/download/' + name + '/');
            }
        };

        //=============END DOCUMENT ACTIONS==========================


        $scope.filterPerson = function (searchTerm) {
            if (searchTerm) {
                return function (s) {
                    return (s.firstName.indexOf(searchTerm) > -1 || s.lastName.indexOf(searchTerm) > -1 || s.personalNumber.indexOf(searchTerm) > -1);
                }
            }
        };

        $scope.close = function () {
            window.location = "home";
        };

    });

</script>

<div ng-controller="eventCtrl" id="eventControllerId">
    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>New Application
                        <small>Information</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <%-- <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10" type="button">
                         <i class="zmdi zmdi-plus"></i>
                     </button>--%>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">New Application</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">
                            <ul class="nav nav-tabs">
                                <li id="details" role="presentation" class="nav-item">
                                    <a class="nav-link active"
                                       href="newRequest?type=details&eventId={{currentEventId}}">Detail Information</a></li>
                                <li id="persons" role="presentation"
                                    ng-show="currentEventId > 0 && event.applicationTypeId == 1" class="nav-item"><a
                                        class="nav-link"
                                        href="newRequest?type=persons&eventId={{currentEventId}}">Participants</a></li>
                                <li id="documents" role="presentation" ng-show="currentEventId > 0" class="nav-item"><a
                                        class="nav-link"
                                        href="newRequest?type=documents&eventId={{currentEventId}}">Documents</a>
                                </li>
                            </ul>


                            <div ng-show="type == 'details'">
                                <form class="form-horizontal col-md-10">
                                    <div class="form-group col-sm-8">
                                        <label>Application Type</label>
                                        <select class="form-control input-sm" ng-model="event.applicationTypeId"
                                                ng-change="changeEventType()">
                                            <option ng-repeat="et in eventTypes" value="{{et.id}}">{{et.name}}</option>
                                        </select>
                                    </div>

                                    <div class="form-group col-sm-8">
                                        <label>Event</label>
                                        <textarea class="form-control input-sm" ng-model="event.eventName"
                                                  rows="1"></textarea>
                                    </div>

                                    <div class="form-group col-sm-8">
                                        <label>Application Number</label>
                                        <input type="text" id="letterNumber" ng-model="event.letterNumber"
                                               class="form-control input-sm">
                                    </div>
                                    <div ng-show="event.applicationTypeId == 2">
                                        <div class="form-group col-sm-8">
                                            <label>Event Type</label>
                                            <select class="form-control input-sm" ng-model="event.eventTypeId">
                                                <option ng-repeat="is in types" value="{{is.id}}">{{is.name}}</option>
                                            </select>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>Budget</label>
                                            <input type="number" id="budget2" ng-model="event.budget"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div ng-show="event.applicationTypeId == 1">
                                        <div class="form-group col-sm-8">
                                            <label>Description</label>
                                            <textarea class="form-control input-sm" ng-model="event.eventDescription"
                                                      rows="2"></textarea>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>Goals/tasks</label>
                                            <textarea class="form-control input-sm" ng-model="event.purpose"
                                                      rows="2"></textarea>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>Expected results</label>
                                            <textarea class="form-control input-sm" ng-model="event.expectedResult"
                                                      rows="2"></textarea>
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>Event Type</label>
                                            <select class="form-control input-sm" ng-model="event.eventTypeId">
                                                <option ng-repeat="is in types" value="{{is.id}}">{{is.name}}</option>
                                            </select>
                                        </div>
                                        <div class="form-group"><br/></div>
                                        <div class="form-group col-sm-8" id="test">
                                            <label>Start Date</label>
                                            <input type="text" id="startDate" ng-model="event.startDate"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>End Date</label>
                                            <input type="text" name="endDate" id="endDate" ng-model="event.endDate"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>Deadline of report</label>
                                            <input type="text" id="deliveryDate" ng-model="event.reportDeliveryDate"
                                                   class="form-control input-sm" disabled>
                                        </div>
                                        <div class="form-group"><br/></div>

                                        <div class="form-group col-sm-8">
                                            <label>Budget</label>
                                            <input type="number" id="numbersOnly" ng-model="event.budget"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>Responsible person for the event</label>
                                            <input type="text" id="responsiblePerson" ng-model="event.responsiblePerson"
                                                   class="form-control input-sm"
                                                   placeholder="Name">
                                        </div>
                                        <div class="form-group col-sm-8">
                                            <label>Position</label>
                                            <input type="text" id="responsiblePersonPosition"
                                                   ng-model="event.responsiblePersonPosition"
                                                   class="form-control input-sm"
                                                   placeholder="Position">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <br/><br/>
                                        <button type="button" class="btn btn-primary btn-xs" ng-click="addEvent()">
                                            Save
                                        </button>
                                    </div>
                                    <div class="form-group"><br/><br/></div>
                                </form>
                            </div>

                            <div ng-show="type == 'persons'">
                                <br/>
                                <form class="form-horizontal">
                                    <div class="form-group col-sm-6">
                                        <label class="control-label col-sm-12">Participant *</label>
                                        <div class="col-sm-12">
                                            <select class="form-control input-sm" ng-model="person.type"
                                                    ng-change="changePersonType()">
                                                <option ng-repeat="t in personTypes" value="{{t.id}}">{{t.name}}
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                    <%-- <div class="form-group col-sm-8">
                                         <label class="control-label col-sm-3">აირჩიეთ *</label>
                                         <div class="col-sm-9">
                                             <select class="form-control input-sm" ng-model="person.personId">
                                                 <option ng-repeat="t in personList" value="{{t.id}}">{{t.firstName}}
                                                     {{t.lastName}} ({{t.personalNumber}})
                                                 </option>
                                             </select>
                                         </div>
                                     </div>--%>
                                    <div class="form-group col-sm-6">
                                        <label class="control-label col-sm-12">Choose *</label>
                                        <div class="col-sm-12">
                                            <select id="personId" class="form-control  js-example-basic-single"
                                                    ng-model="person.personId">
                                                <option ng-repeat="t in personList" value="{{t.id}}">{{t.firstName}}
                                                    {{t.lastName}} ({{t.personalNumber}})
                                                </option>
                                            </select>
                                        </div>
                                    </div>

                                    <%--<div class="form-group col-sm-8">
                                        <label class="control-label  col-sm-3">პირადი N *</label>
                                        <div class="col-sm-6">
                                            <input type="text" ng-model="person.personalNumber"
                                                   class="form-control input-sm">
                                        </div>
                                        <div class="col-sm-3">
                                            <input id="searchPerson" type="button" class="btn btn-primary btn-xs"
                                                   value="ძებნა"
                                                   ng-click="searchPerson()">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8 ">
                                        <label class="control-label  col-sm-3">სახელი *</label>
                                        <div class="col-sm-9">
                                            <input type="text" ng-model="person.firstName"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8 ">
                                        <label class="control-label  col-sm-3">გვარი *</label>
                                        <div class="col-sm-9">
                                            <input type="text" ng-model="person.lastName" class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">სურათი</label>
                                        <div class="col-sm-9">
                                            <input type="file" id="personDocumentId" name="file"
                                                   class="form-control input-sm upload-file">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">დაბადების თარიღი *</label>
                                        <div class="col-sm-9">
                                            <input type="text" id="birtDate" ng-model="person.birthDate"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label  col-sm-3">სახეობა</label>
                                        <div class="col-sm-9">
                                            <input type="text" id="category" ng-model="person.category"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8 ">
                                        <label class="control-label col-sm-3">წონა/კატეგორია</label>
                                        <div class="col-sm-9">
                                            <input type="text" id="" ng-model="person.weightCategory"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">ქალაქი/რაიონი</label>
                                        <div class="col-xs-9">
                                            <input type="text" id="" ng-model="person.city"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">კლუბი</label>
                                        <div class="col-sm-9">
                                            <input type="text" id="" ng-model="person.club"
                                                   class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">პოზიცია</label>
                                        <div class="col-sm-9">
                                            <input type="text" ng-model="person.position" class="form-control input-sm">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">პირადი მწვრთნელი</label>
                                        <div class="col-sm-9">
                                            <input type="text" ng-model="person.trainer" class="form-control input-sm">
                                        </div>
                                    </div>--%>

                                    <div class="form-group col-sm-8">
                                        <br>
                                        <input id="addPersonItemBtn" type="button" class="btn btn-primary btn-xs"
                                               value="Add"
                                               ng-click="addPersonItem2()">
                                    </div>
                                </form>
                                <div class="col-md-11">
                                    <table class="table table-striped table-hover">
                                        <tr>
                                            <th>Participant</th>
                                            <th>Personal N</th>
                                            <th>DOB</th>
                                            <th>Club</th>
                                            <th>Position</th>
                                            <th>Sport</th>
                                            <th>City/Distirct</th>
                                            <th>Personal Coach</th>
                                            <th>Category</th>
                                            <th></th>
                                        </tr>
                                        <tr ng-repeat="x in persons">
                                            <td>
                                                <a class="m-r-10" ng-click="open(x.imageUrl);">
                                                    <img src="file/draw/{{x.optimizedImageUrl}}/"
                                                         class="rounded-circle avatar"
                                                         style="height: 50px; width: 50px;"
                                                    >
                                                </a> {{ x.firstName}} {{ x.lastName}}( {{getCategory(x.type)}} )
                                            </td>
                                            <td>{{ x.personalNumber}}</td>
                                            <td>{{ x.birthDate| date:'dd/MM/yyyy'}}</td>
                                            <td>{{ x.club}}</td>
                                            <td>{{ x.position}}</td>
                                            <td>{{ x.category}}</td>
                                            <td>{{ x.city}}</td>
                                            <td>{{ x.trainer}}</td>
                                            <td>{{ x.weightCategory}}</td>
                                            <td>
                                                <%--<button type="button" class="btn btn-warning btn-icon btn-sm"
                                                        ng-click="editPersonItem(x.id, $index);">
                                                    <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                                </button>--%>
                                                <button type="button" class="btn btn-sm btn-icon btn-neutral"
                                                        ng-click="deletePersonItem(x.id, $index);">
                                                    <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </table>
                                    <div class="form-group"><br/><br/></div>
                                </div>
                            </div>


                            <div ng-show="type == 'documents'">
                                <br/>
                                <form class="form-horizontal" id="documentForm" ng-show="DocumentFilter()">

                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">Document Type</label>
                                        <div class="col-sm-9">
                                            <select class="form-control input-sm" ng-model="document.typeId">
                                                <option ng-repeat="dt in documentTypes | filter: tpFilter"
                                                        value="{{dt.id}}">{{dt.name}}
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <label class="control-label col-sm-3">File</label>
                                        <div class="col-sm-9">
                                            <input type="file" id="documentId" name="file"
                                                   class="form-control input-sm upload-file">
                                            <input type="hidden" name="eventId" value="{{document.eventId}}">
                                            <input type="hidden" name="typeId" value="{{document.typeId}}">
                                        </div>
                                    </div>
                                    <div class="form-group col-sm-8">
                                        <button type="button" class="btn btn-primary btn-xs"
                                                ng-click="addDocument()">Add
                                        </button>
                                    </div>

                                </form>
                                <div class="col-sm-8">
                                    <table class="table table-striped table-hover">
                                        <tr>
                                            <th>ID</th>
                                            <th>Type</th>
                                            <th>File</th>
                                            <th></th>
                                        </tr>
                                        <tr ng-repeat="d in documents | filter: typeFilter">
                                            <td>{{$index + 1}}</td>
                                            <td>{{ d.type.name}}</td>
                                            <td><a class="btn btn-link text-info"
                                                   ng-click="open(d.name);">{{d.name}}</a></td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-icon btn-neutral"
                                                        ng-click="deleteEventDocument(d.id, $index);">
                                                    <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </table>
                                    <div ng-show="isReport" class="form-group text-right">
                                        <div class="col-sm-12">
                                            <button type="button" class="btn btn-primary"
                                                    ng-click="reportDocument()">Send Report
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-sm-12 text-right">
                                        <button type="button" class="btn btn-default"
                                                ng-click="close()">Close
                                        </button>
                                    </div>
                                    <div class="form-group"><br/><br/></div>

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

<script type="text/javascript" src="resources/js/bootstrap-datepicker.min.js"></script>
<script src="resources/js/select2.min.js"></script>
<script>
    $(document).ready(function () {

        $('.js-example-basic-single').select2();

        $('#deliveryDate').datepicker({
            format: 'dd/mm/yyyy',
            changeMonth: true,
            changeYear: true
        });
        $('#startDate').datepicker({
            format: 'dd/mm/yyyy',
            changeMonth: true,
            changeYear: true
        });

        $('#endDate').datepicker({
            format: 'dd/mm/yyyy',
            changeMonth: true,
            changeYear: true,
            onSelect: function (dateText) {
                $('#deliveryDate').val(addDateDays(dateText, 20));
                $(this).change();
                $('#deliveryDate').change();
            }
        }).on("change", function (dateText) {
            $('#deliveryDate').val(addDateDays($('#endDate').val(), 20));
            $('#deliveryDate').change();
        });

    });
</script>