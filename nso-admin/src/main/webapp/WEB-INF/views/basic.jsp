<!doctype html>
<html  lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <meta name="description" content="Responsive Bootstrap 4 and web Application ui kit.">

    <link rel="stylesheet" href="resources/css/style.css"/>



    <script type="text/javascript" src="resources/js/jquery-1.9.1.js"></script>
     <script src="resources/js/jquery-ui.js"></script>
    <script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/angular.min.js"></script>

   <%-- <link rel="stylesheet" href="resources/assets/plugins/bootstrap/css/bootstrap.min.css">--%>

    <link rel="stylesheet" href="resources/css/jquery-ui.css"/>


    <script type="text/javascript" src="resources/js/global_error_handler.js"></script>
    <script type="text/javascript" src="resources/js/global_util.js"></script>
    <script type="text/javascript" src="resources/js/misc.js"></script>




    <link rel="stylesheet" href="resources/css/autocomplete.css" />
    <script src="resources/js/autocomplete.js"></script>



   <%-- <link rel="stylesheet" href="resources/css/style.css" />
    <link rel="stylesheet" href="resources/css/autocomplete.css" />
    <link rel="stylesheet" href="resources/css/jquery-ui.css">

    <script src="resources/js/jquery-1.9.1.js"></script>
    <script src="resources/js/jquery-ui.js"></script>

    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/angular.min.js"></script>
    <script src="resources/js/global_util.js"></script>
    <script src="resources/js/dom_util.js"></script>
    <script src="resources/js/global_error_handler.js"></script>

    <script src="resources/js/autocomplete.js"></script>--%>



</head>

<script>
    var app = angular.module("app", ['AxelSoft']);
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
            if (isEmptyValue($scope.person.personId)) {
                Modal.info('აირჩიეთ მონაწილე');
                return;
            }
            ajaxCall($http, "event/add-event-person", angular.toJson($scope.person), reload);
        };

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
            var selected = $filter('filter')($scope.personTypes, {id: id}, true)[0];
            if (selected != undefined) {
                return selected.name;
            }
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




        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };

        //=============END DOCUMENT ACTIONS==========================

        $scope.filterPerson = function (searchTerm) {
            if (searchTerm) {
                return function (s) {
                    return (s.firstName.indexOf(searchTerm) > -1 || s.lastName.indexOf(searchTerm) > -1);
                }
            }
        };

    });

</script>
<body class="theme-purple" ng-app="app">
<!-- Page Loader -->
<div class="col-sm-8" ng-controller="eventCtrl">

    <div class="form-group">
    <label class="control-label col-sm-3">აირჩიეთ *</label>

    <%--<select class="form-control input-sm" ng-model="person.personId">
        <option ng-repeat="t in personList" value="{{t.id}}">{{t.firstName}}
            {{t.lastName}} ({{t.personalNumber}})
        </option>
    </select>--%>
    <div class="clearfix"></div>
    <div style="width: 100%!important;"
         custom-select="s.id as s.firstName+' '+s.lastName+''+s.personalNumber for s in personList | filter:filterPerson($searchTerm)   track by s.id"
         ng-model="person.personId"></div>
    </div>

</div>



</body>
<%--
<script src="resources/assets/bundles/libscripts.bundle.js"></script> <!-- Lib Scripts Plugin Js -->
<script src="resources/assets/bundles/vendorscripts.bundle.js"></script> <!-- Lib Scripts Plugin Js -->

<script src="resources/assets/plugins/momentjs/moment.js"></script> <!-- Moment Plugin Js -->
<!-- Bootstrap Material Datetime Picker Plugin Js -->
<script src="resources/assets/plugins/bootstrap-material-datetimepicker/js/bootstrap-material-datetimepicker.js"></script>

<script src="resources/assets/bundles/mainscripts.bundle.js"></script><!-- Custom Js -->
<script src="resources/assets/js/pages/forms/basic-form-elements.js"></script>
--%>
</html>

