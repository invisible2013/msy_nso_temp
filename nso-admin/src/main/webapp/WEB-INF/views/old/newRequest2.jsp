<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>
<script>
    $(document).ready(function () {
        $('[data-toggle="tooltip"]').tooltip();
        $('#deliveryDate').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true
        });
        $('#startDate').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true
        });
        $('#endDate').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true,
            onSelect: function (dateText) {
                $('#deliveryDate').val(addDateDays(dateText, 20));
                $(this).change();
                $('#deliveryDate').change();
            }
        });
        $('#birtDate').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true,
            yearRange: '1950:' + new Date()
        });
    });
</script>
<script>
    var app = angular.module("app", []);
    app.controller("eventCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.event = {};
        $scope.currentEventId = 0;
        $scope.type = "details";
        $scope.isReport = false;
        $scope.eventTypes = [{'id': 1, 'name': "ღონისძიება"}, {'id': 2, 'name': "სხვა ღონისძიება"}];
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
            $('.nav li.active').removeClass('active');
            $('.nav li#' + $scope.type).addClass('active');
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
            if (isEmptyValue($scope.event.eventName)) {
                Modal.info('შეიყვანეთ ღონისძიების დასახელება');
                return;
            }
            if (isEmptyValue($scope.event.eventTypeId)) {
                Modal.info('შეიყვანეთ ღონისძიების ტიპი');
                return;
            }
            if ($scope.event.applicationTypeId == 1) {
                if (isEmptyValue($scope.event.eventDescription)) {
                    Modal.info('შეიყვანეთ ღონისძიების აღწერა');
                    return;
                }
                if (isEmptyValue($scope.event.purpose)) {
                    Modal.info('შეიყვანეთ ღონისძიების მიზნები/ამოცანები');
                    return;
                }
                if (isEmptyValue($scope.event.expectedResult)) {
                    Modal.info('შეიყვანეთ ღონისძიების მოსალოდნელი შედეგი');
                    return;
                }

                if (isEmptyValue($scope.event.startDate)) {
                    Modal.info('შეიყვანეთ ღონისძიების დაწყების თარიღი');
                    return;
                }
                if (isEmptyValue($scope.event.endDate)) {
                    Modal.info('შეიყვანეთ ღონისძიების დასრულების თარიღი');
                    return;
                }
                if (isEmptyValue($scope.event.reportDeliveryDate)) {
                    Modal.info('შეიყვანეთ ანგარიშის ჩაბარების თარიღი');
                    return;
                }
                if (isEmptyValue($scope.event.budget)) {
                    Modal.info('შეიყვანეთ ღონისძიების ბიუჯეტი');
                    return;
                }
                if (isEmptyValue($scope.event.responsiblePerson)) {
                    Modal.info('შეიყვანეთ პასუხისმგებელი პირი');
                    return;
                }
                if (isEmptyValue($scope.event.responsiblePersonPosition)) {
                    Modal.info('შეიყვანეთ პასუხისმგებელი პირის თანამდებობა');
                    return;
                }
            }
            if ($scope.event.applicationTypeId == 2) {
                if (isEmptyValue($scope.event.budget)) {
                    Modal.info('შეიყვანეთ ღონისძიების ბიუჯეტი');
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
        }

        ajaxCall($http, "misc/get-person-types", null, getPersonTypes);

        $scope.addPersonItem = function () {
            if (isEmptyValue($scope.person.personalNumber)) {
                Modal.info('შეიყვანეთ მონაწილის პირადი N');
                return;
            }
            if (isEmptyValue($scope.person.firstName)) {
                Modal.info('შეიყვანეთ მონაწილის სახელი');
                return;
            }
            if (isEmptyValue($scope.person.lastName)) {
                Modal.info('შეიყვანეთ მონაწილის გვარი');
                return;
            }
            if (isEmptyValue($scope.person.birthDate)) {
                Modal.info('შეიყვანეთ მონაწილის  დაბადების თარიღი');
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
            return $filter('filter')($scope.personTypes, {id: id}, true)[0].name;
        };

        $scope.deletePersonItem = function (id, index) {
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ წაშლა?", function () {
                if (id != undefined) {
                    ajaxCall($http, "event/delete-event-person", angular.toJson({'eventPersonId': id}), reload);
                } else {
                    $scope.selected = $scope.persons[index];
                    $scope.persons.splice($scope.persons.indexOf($scope.selected), 1);
                }
            })
        };

        $scope.deleteEventDocument = function (id, index) {
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ წაშლა?", function () {
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
                Modal.info('აირჩიეთ დოკუმენტის ტიპი');
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
                type: 'POST'
            }).success(function (data) {
                $("#eventControllerId").removeClass('loading-mask');
                location.reload();
            }).error(function (data, status, headers, config) {
                $("#eventControllerId").removeClass('loading-mask');
                location.reload();
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
            window.open('file/draw/' + name + '/');
        };

        //=============END DOCUMENT ACTIONS==========================

    });

</script>
<div class="col-md-12" ng-controller="eventCtrl" id="eventControllerId">
    <br/>
    <ul class="nav nav-tabs">
        <li id="details" role="presentation" class="active"><a
                href="newRequest?type=details&eventId={{currentEventId}}">დეტალური ინფორმაცია</a></li>
        <li id="persons" role="presentation" ng-show="currentEventId > 0 && event.applicationTypeId == 1"><a
                href="newRequest?type=persons&eventId={{currentEventId}}">მონაწილეები</a></li>
        <li id="documents" role="presentation" ng-show="currentEventId > 0"><a
                href="newRequest?type=documents&eventId={{currentEventId}}">დოკუმენტები</a></li>
    </ul>

    <br/>
    <div ng-show="type == 'details'">
        <form class="form-horizontal">
            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">განაცხადის ტიპი</label>
                <div class="col-sm-9">
                    <select class="form-control input-sm" ng-model="event.applicationTypeId"
                            ng-change="changeEventType()">
                        <option ng-repeat="et in eventTypes" value="{{et.id}}">{{et.name}}</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <button type="button" class="btn btn-default btn-xs" data-toggle="tooltip" data-placement="right"
                        title="აქ ვირჩევთ რა ტიპის განაცხადი გვინდა">
                    <span class="glyphicon glyphicon-question-sign"></span>
                </button>
            </div>

            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">ღონისძიება</label>
                <div class="col-sm-9">
                    <textarea class="form-control input-sm" ng-model="event.eventName" rows="1"></textarea>
                </div>
            </div>
            <div class="col-md-4">
                <button type="button" class="btn btn-default btn-xs" data-toggle="tooltip" data-placement="right"
                        title="აქ ვწერთ ღონისძიების დასახელებას">
                    <span class="glyphicon glyphicon-question-sign"></span>
                </button>
            </div>
            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">წერილის ნომერი</label>
                <div class="col-sm-9">
                    <input type="text" id="letterNumber" ng-model="event.letterNumber" class="form-control input-sm">
                </div>
            </div>
            <div ng-show="event.applicationTypeId == 2">
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">ღონისძიების ტიპი</label>
                    <div class="col-sm-9">
                        <select class="form-control input-sm" ng-model="event.eventTypeId">
                            <option ng-repeat="is in types" value="{{is.id}}">{{is.name}}</option>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">ბიუჯეტი</label>
                    <div class="col-sm-9">
                        <input type="text" id="budge" ng-model="event.budget" class="form-control input-sm">
                    </div>
                </div>
            </div>
            <div ng-show="event.applicationTypeId == 1">
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">ღონისძიების აღწერა</label>
                    <div class="col-sm-9">
                        <textarea class="form-control input-sm" ng-model="event.eventDescription" rows="2"></textarea>
                    </div>
                </div>
                <div class="col-md-4">
                    <button type="button" class="btn btn-default btn-xs" data-toggle="tooltip" data-placement="right"
                            title="აქ ვწერთ ღონისძიების აღწერას">
                        <span class="glyphicon glyphicon-question-sign"></span>
                    </button>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">მიზნები/ამოცანები</label>
                    <div class="col-sm-9">
                        <textarea class="form-control input-sm" ng-model="event.purpose" rows="2"></textarea>
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">მოსალოდნელი შედეგი</label>
                    <div class="col-sm-9">
                        <textarea class="form-control input-sm" ng-model="event.expectedResult" rows="2"></textarea>
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">ღონისძიების ტიპი</label>
                    <div class="col-sm-9">
                        <select class="form-control input-sm" ng-model="event.eventTypeId">
                            <option ng-repeat="is in types" value="{{is.id}}">{{is.name}}</option>
                        </select>
                    </div>
                </div>
                <div class="form-group"><br/></div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">დაწყების თარიღი</label>
                    <div class="col-sm-9">
                        <input type="text" id="startDate" ng-model="event.startDate" class="form-control input-sm">
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">დასრულების თარიღი</label>
                    <div class="col-sm-9">
                        <input type="text" name="endDate" id="endDate" ng-model="event.endDate"
                               class="form-control input-sm" onkeyup="changeDeliveryDate()">
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">ანგარიშის ჩაბარების თარიღი</label>
                    <div class="col-sm-9">
                        <input type="text" id="deliveryDate" ng-model="event.reportDeliveryDate"
                               class="form-control input-sm" disabled>
                    </div>
                </div>
                <div class="form-group"><br/></div>

                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">ბიუჯეტი</label>
                    <div class="col-sm-9">
                        <input type="text" id="budget" ng-model="event.budget" class="form-control input-sm">
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">სპორტულ ღონისძიებაზე პასუხისმგებელი პირი</label>
                    <div class="col-sm-9">
                        <input type="text" id="responsiblePerson" ng-model="event.responsiblePerson"
                               class="form-control input-sm"
                               placeholder="სახელი,გვარი">
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">თანამდებობა</label>
                    <div class="col-sm-9">
                        <input type="text" id="responsiblePersonPosition" ng-model="event.responsiblePersonPosition"
                               class="form-control input-sm" placeholder="პასუხისმგებელი პირის თანამდებობა">
                    </div>
                </div>
            </div>
            <div class="form-group col-sm-8">
                <div class="col-sm-12 text-right">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addEvent()">დამატება</button>
                </div>
            </div>
            <div class="form-group"><br/><br/></div>
        </form>
    </div>

    <div ng-show="type == 'persons'">
        <br/>
        <form class="form-horizontal">
            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">მონაწილე *</label>
                <div class="col-sm-9">
                    <select class="form-control input-sm" ng-model="person.type">
                        <option ng-repeat="t in personTypes" value="{{t.id}}">{{t.name}}</option>
                    </select>
                </div>
            </div>
            <div class="form-group col-sm-8">
                <label class="control-label  col-sm-3">პირადი N *</label>
                <div class="col-sm-6">
                    <input type="text" ng-model="person.personalNumber" class="form-control input-sm">
                </div>
                <div class="col-sm-3">
                    <input id="searchPerson" type="button" class="btn btn-primary btn-xs" value="ძებნა"
                           ng-click="searchPerson()">
                </div>
            </div>
            <div class="form-group col-sm-8 ">
                <label class="control-label  col-sm-3">სახელი *</label>
                <div class="col-sm-9">
                    <input type="text" ng-model="person.firstName" class="form-control input-sm">
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
                    <input type="file" id="personDocumentId" name="file" class="form-control input-sm upload-file">
                </div>
            </div>
            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">დაბადების თარიღი *</label>
                <div class="col-sm-9">
                    <input type="text" id="birtDate" ng-model="person.birthDate" class="form-control input-sm">
                </div>
            </div>
            <div class="form-group col-sm-8">
                <label class="control-label  col-sm-3">სახეობა</label>
                <div class="col-sm-9">
                    <input type="text" id="category" ng-model="person.category" class="form-control input-sm">
                </div>
            </div>
            <div class="form-group col-sm-8 ">
                <label class="control-label col-sm-3">წონა/კატეგორია</label>
                <div class="col-sm-9">
                    <input type="text" id="" ng-model="person.weightCategory" class="form-control input-sm">
                </div>
            </div>
            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">ქალაქი/რაიონი</label>
                <div class="col-xs-9">
                    <input type="text" id="" ng-model="person.city" class="form-control input-sm">
                </div>
            </div>
            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">კლუბი</label>
                <div class="col-sm-9">
                    <input type="text" id="" ng-model="person.club" class="form-control input-sm">
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
            </div>
            <div class="form-group col-sm-8 text-right">
                <div class="col-sm-12">
                    <input id="addPersonItemBtn" type="button" class="btn btn-primary btn-xs" value="დამატება"
                           ng-click="addPersonItem()">
                </div>
            </div>
        </form>
        <div class="col-md-11">
            <table class="table table-striped table-hover">
                <tr>
                    <th>მონაწილე</th>
                    <th>პირ. N</th>
                    <th>დ/წ</th>
                    <th>კლუბი</th>
                    <th>პოზიცია</th>
                    <th>სახეობა</th>
                    <th>ქალ/რაიონი</th>
                    <th>პირ/მწვრთ</th>
                    <th>წ/კ</th>
                    <th></th>
                </tr>
                <tr ng-repeat="x in persons">
                    <td>
                        <a class="btn btn-xs" ng-click="open(x.imageUrl);">
                            <img src="file/draw/{{x.optimizedImageUrl}}/" class="img-thumbnail"
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
                        <button type="button" class="btn btn-xs" ng-click="editPersonItem(x.id, $index);">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </button>
                        <button type="button" class="btn btn-xs" ng-click="deletePersonItem(x.id, $index);">
                            <span class="glyphicon glyphicon-remove"></span>
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
                <label class="control-label col-sm-3">დოკუმენტის ტიპი</label>
                <div class="col-sm-9">
                    <select class="form-control input-sm" ng-model="document.typeId">
                        <option ng-repeat="dt in documentTypes | filter: tpFilter" value="{{dt.id}}">{{dt.name}}
                        </option>
                    </select>
                </div>
            </div>
            <div class="form-group col-sm-8">
                <label class="control-label col-sm-3">დოკუმენტი</label>
                <div class="col-sm-9">
                    <input type="file" id="documentId" name="file"
                           class="form-control input-sm upload-file">
                    <input type="hidden" name="eventId" value="{{document.eventId}}">
                    <input type="hidden" name="typeId" value="{{document.typeId}}">
                </div>
            </div>
            <div class="form-group col-sm-8 text-right">
                <div class="col-sm-12">
                    <!--<button type="submit" class="btn btn-primary btn-xs" >დამატება</button>-->
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addDocument()">დამატება</button>
                </div>
            </div>

        </form>
        <div class="col-sm-8">
            <table class="table table-striped table-hover">
                <tr>
                    <th>ID</th>
                    <th>ტიპი</th>
                    <th>ფაილი</th>
                    <th></th>
                </tr>
                <tr ng-repeat="d in documents | filter: typeFilter">
                    <td>{{$index + 1}}</td>
                    <td>{{ d.type.name}}</td>
                    <td><a class="btn btn-xs" ng-click="open(d.name);">{{d.name}}</a></td>
                    <td>
                        <button type="button" class="btn btn-xs" ng-click="deleteEventDocument(d.id, $index);">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>
            </table>
            <div ng-show="isReport" class="form-group text-right">
                <div class="col-sm-12">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="reportDocument()">ანგარიშის
                        გაგზავნა
                    </button>
                </div>
            </div>
            <div class="form-group"><br/><br/></div>

        </div>
    </div>

</div>

<%@include file="footer.jsp" %>