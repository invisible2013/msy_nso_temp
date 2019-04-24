<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>

<script>
    /* $(document).ready(function () {
     $('#birthDate').datepicker({
     dateFormat: 'dd/mm/yy',
     changeMonth: true,
     changeYear: true,
     yearRange: '1950:' + new Date()
     });
     });
     */
    var app = angular.module("app", []);
    app.controller("userCtrl", function ($scope, $http, $filter) {
        $scope.persons = [];
        $scope.genders = [];
        $scope.person = {};
        $scope.selectedTypeId = 1;
        $scope.fullText = "";
        $scope.selectedFederationId = 0;
        $scope.start = 0;
        $scope.limit = 40;
        $scope.size = 0;
        function getUsers(res) {
            $scope.persons = $scope.persons.concat(res.data);
            $scope.size = res.data.length;
            console.log(res.data);
        }

        ajaxCall($http, "event/get-persons-by-type", {
            typeId: 1,
            start: $scope.start,
            limit: $scope.limit
        }, getUsers);

        function getUsersByGroup(res) {
            $scope.federations = res.data;
        }

        ajaxCall($http, "users/get-users-by-group", {groupId: 4}, getUsersByGroup);

        function getChampionships(res) {
            $scope.championships = res.data;
        }

        ajaxCall($http, "championship/get-championships?start=0&limit=0", null, getChampionships);


        function getSuccessAwards(res) {
            $scope.awards = res.data;
        }

        ajaxCall($http, "championship/get-awards", null, getSuccessAwards);

        $scope.searchChange = function () {
            $scope.start = 0;
            $scope.persons = [];
            if ($scope.selectedFederationId != 0) {
                ajaxCall($http, "event/get-persons-by-type", {
                    typeId: $scope.selectedTypeId,
                    federationId: $scope.selectedFederationId,
                    start: $scope.start,
                    limit: $scope.limit,
                    fullText: $scope.fullText
                }, getUsers);
            } else {
                ajaxCall($http, "event/get-persons-by-type", {
                    typeId: $scope.selectedTypeId,
                    start: $scope.start,
                    limit: $scope.limit,
                    fullText: $scope.fullText
                }, getUsers);
            }
        };

        $scope.searchChangeNext = function () {
            if ($scope.selectedFederationId != 0) {
                ajaxCall($http, "event/get-persons-by-type", {
                    typeId: $scope.selectedTypeId,
                    federationId: $scope.selectedFederationId,
                    start: $scope.start,
                    limit: $scope.limit,
                    fullText: $scope.fullText
                }, getUsers);
            } else {
                ajaxCall($http, "event/get-persons-by-type", {
                    typeId: $scope.selectedTypeId,
                    start: $scope.start,
                    limit: $scope.limit,
                    fullText: $scope.fullText
                }, getUsers);
            }
        };

        $scope.loadMore = function () {
            $scope.start = $scope.start + $scope.limit;
            $scope.searchChangeNext();
        };

        $scope.loadAll = function () {
            $scope.start = $scope.start + $scope.limit;
            $scope.limit = 1000000;
            $scope.searchChangeNext();
        };

        function getTypes(res) {
            $scope.types = res.data;
        }

        ajaxCall($http, "misc/get-person-types", null, getTypes);

        function getGenders(res) {
            $scope.genders = res.data;
        }

        ajaxCall($http, "misc/get-genders", null, getGenders);


        $scope.addUser = function () {
            ajaxCall($http, "event/add-person", angular.toJson($scope.person), reload);
        };
        $scope.editPerson = function (itemId) {
            if (itemId != undefined) {
                var selected = $filter('filter')($scope.persons, {id: itemId}, true);
                $scope.person = selected[0];
                $("#birthDate").val($scope.person.birthDate);
            }
        };

        $scope.addResult = function (itemId) {
            if (itemId != undefined) {
                $scope.result = {sportsmanId: itemId};
            }

            function getResults(res) {
                $scope.results = res.data;
            }

            ajaxCall($http, "result/get-results", {}, getResults);

        };

        $scope.selectPerson = function () {
            $scope.person = {typeId: $scope.selectedTypeId};
        };
        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };

        $scope.addPersonItem = function () {
            $scope.person.birthDate = $("#birthDate").val();
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
                Modal.info('Enter Date of Birth');
                return;
            }
            var file = $('#personDocumentId')[0].files[0];

            function addPersonSuccess(res) {
                console.log(res.data);
                var personId = res.data.id;
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
                        },
                        error: function (data, status, headers, config) {
                            location.reload();
                        }
                    });
                } else {
                    location.reload();
                }
            }

            ajaxCall($http, "event/add-person-item", angular.toJson($scope.person), addPersonSuccess);
        };
        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };

        $scope.removePerson = function (personId) {
            if (confirm("You need to confirm this operation?")) {
                ajaxCall($http, "event/delete-person-item", {personId: personId}, reload());
            }
        };

        $scope.removeResult = function (resultId) {
            if (confirm("You need to confirm this operation?")) {
                ajaxCall($http, "result/delete-result", {itemId: resultId}, reload());
            }
        };


        $scope.saveResult = function () {
            $scope.result.team = $('input[name=teamRadio]:checked').val() == 1 ? true : false;
            ajaxCall($http, "result/add-result", angular.toJson($scope.result), reload);
        };

    });
</script>

<div ng-controller="userCtrl">
    <div class="modal fade" id="addPersonModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="addIdNumberLabel">Detail Information</h4>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <form class="row" id="form_validation" method="POST">
                            <div class="form-group col-md-6">
                                <label>Person Type</label>
                                <select class="form-control input-sm" ng-model="person.typeId">
                                    <option ng-repeat="t in types" value="{{t.id}}">{{t.name}}</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label>Gender</label>
                                <select class="form-control input-sm" ng-model="person.genderId">
                                    <option ng-repeat="g in genders" value="{{g.id}}">{{g.name}}</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label>FirstName *</label>
                                <input type="text" ng-model="person.firstName" class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>LastName *</label>
                                <input type="text" ng-model="person.lastName" class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Personal Number *</label>
                                <input type="text" ng-model="person.personalNumber" class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Date of birth *</label>
                                <input type="text" id="birthDate" ng-model="person.birthDate"
                                       class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-12">
                                <label>Picture</label>
                                <input type="file" id="personDocumentId" name="file"
                                       class="form-control input-sm upload-file">
                            </div>

                            <div class="form-group col-md-6">
                                <label>Sports</label>
                                <input type="text" id="category" ng-model="person.category"
                                       class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Weight/Category</label>
                                <input type="text" ng-model="person.weightCategory"
                                       class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>City/District</label>
                                <input type="text" ng-model="person.city" class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Club</label>
                                <input type="text" ng-model="person.club" class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Pesition</label>
                                <input type="text" id="position" ng-model="person.position"
                                       class="form-control input-sm">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Personal Coach</label>
                                <input type="text" id="trainer" ng-model="person.trainer"
                                       class="form-control input-sm">
                            </div>
                        </form>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-raised btn-primary btn-xs" ng-click="addPersonItem()">Save
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addResultModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="addl">Information about result</h4>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <form name="sportsmanForm" class="row form-horizontal col-md-12" id="sportsmanPanel">

                            <div class="form-group col-md-12">
                                <label>Championship</label>
                                <select class="form-control input-sm" ng-model="result.championshipId">
                                    <option ng-repeat="c in championships" value="{{c.id}}">{{c.name}}</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label>Sportsman</label>
                                <select class="form-control input-sm" ng-model="result.sportsmanId">
                                    <option ng-repeat="s in persons" value="{{s.id}}">{{s.lastName}}
                                        {{s.firstName}}
                                    </option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label>Award</label>
                                <select class="form-control input-sm" ng-model="result.awardId">
                                    <option ng-repeat="a in awards" value="{{a.id}}">{{a.name}}</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label>Discipline</label>
                                <input type="text" ng-model="result.discipline" class="form-control input-sm"
                                       placeholder="დისციპლინა">
                            </div>
                            <div class="form-group col-md-4">
                                <label>Weight Category</label>
                                <input type="text" ng-model="result.category" class="form-control input-sm"
                                       placeholder="წონა">
                            </div>
                            <div class="form-group col-md-4">
                                <label>Result</label>
                                <input type="text" ng-model="result.score" class="form-control input-sm"
                                       placeholder="შედეგი">
                            </div>
                            <div class="form-group col-md-4">
                                <label>Note</label>
                                <input type="text" ng-model="result.note" class="form-control input-sm"
                                       placeholder="შენიშვნა">
                            </div>
                            <div class="form-group col-md-4">
                                <label>Is Team Member</label>
                                <div class="mt-radio-inline">
                                    <label class="mt-radio">
                                        <input type="radio" ng-model="result.team" name="teamRadio"
                                               id="optionsRadios4"
                                               value="1">Yes
                                        <span></span>
                                    </label>
                                    <label class="mt-radio">
                                        <input type="radio" ng-model="result.team" name="teamRadio"
                                               id="optionsRadios5"
                                               value="0" checked=""> No
                                        <span></span>
                                    </label>
                                </div>
                            </div>

                        </form>
                        <button type="button" class="btn btn-primary btn-xs" ng-click="saveResult()">Save</button>
                    </div>
                    <div class="col-md-12">
                        <table class="table table-striped table-hover" id="resultList">
                            <tr>
                                <th>ID</th>
                                <th>Championship</th>
                                <th>Award</th>
                                <th>Discipline</th>
                                <th>Category</th>
                                <th>Result</th>
                                <th>Note</th>
                                <th></th>
                            </tr>
                            <tr ng-repeat="i in results">
                                <td>{{$index + 1}}</td>
                                <td>{{i.championshipName}}</td>
                                <td>{{i.awardName}}</td>
                                <td>{{i.discipline}}</td>
                                <td><span class="badge badge-warning">{{i.category}}</span></td>
                                <td>{{i.score}}</td>
                                <td>{{i.note}}</td>
                                <td width="100">

                                    <button type="button" class="btn btn-sm btn-icon btn-neutral"
                                            ng-click="removeResult(i.id)">
                                        <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                    </button>

                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">

                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Registry
                        <small>Staff</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                    <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10 "
                            data-toggle="modal" data-target="#addPersonModal" ng-click="selectPerson()" type="button">
                        <i class="zmdi zmdi-plus"></i>
                    </button>
                    <%}%>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Registry</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <span class="body">

                            <div class="row col-md-12">
                                <%if (hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())) {%>
                                <div class="form-group col-sm-2">
                                    <select class="form-control input-sm" ng-model="selectedFederationId"
                                            ng-change="searchChange()">
                                        <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
                                    </select>
                                </div>
                                <%}%>

                                <div class="form-group col-md-2">
                                    <select class="form-control input-sm" ng-model="selectedTypeId"
                                            ng-change="searchChange()">
                                        <option ng-repeat="t in types" value="{{t.id}}">{{t.name}}</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <div class="form-group" style="margin-top:8px;">
                                        <input type="text" class="form-control"
                                               ng-model="fullText">
                                    </div>
                                </div>
                                <div class="form-group col-md-2">
                                    <div class="form-group">
                                        <button class="btn btn-raised btn-primary btn-round waves-effect m-l-20"
                                                ng-click="searchChange()">Search
                                        </button>
                                    </div>
                                </div>

                                <%-- <div class="form-group col-sm-2 text-right" style="float:right;">
                                     <label class="control-label"></label>
                                     <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                                     <button type="button" style="margin-top: 20px;" class="btn btn-primary btn-xs"
                                             data-toggle="modal" data-target="#addPersonModal" ng-click="selectPerson()">
                                         დამატება
                                     </button>
                                     <%}%>
                                 </div>--%>
                            </div>
                            <table class="table table-striped table-hover" id="userList">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th></th>
                                    <th>Personal Number</th>
                                    <th>Date of borth</th>
                                    <th>Sport</th>
                                    <th>Weight category</th>
                                    <th>Club</th>
                                    <th>Position</th>
                                    <th>Coach</th>
                                    <th>City</th>
                                    <th></th>
                                </tr>
                                <tr ng-repeat="i in persons">
                                    <td>{{$index + 1}}</td>
                                    <td>
                                        <a ng-click="open(i.imageUrl);">
                                            <img src="file/draw/{{i.optimizedImageUrl}}/" class="rounded-circle avatar"
                                                 width="40">
                                        </a>
                                    </td>
                                    <td><b lass="text-purple">{{i.firstName}} {{i.lastName}}</b><br>
                                        <span class="text-warning">{{i.genderId==1?'Female':i.genderId==2?'Male':''}}</span><br>
                                        <span class="text-info">{{i.createDate}}</span>
                                           </td>
                                    <td>{{i.personalNumber}}</td>
                                    <td>{{i.birthDate}}</td>
                                    <td><span class="badge badge-warning">{{i.category}}</span></td>
                                    <td>{{i.weightCategory}}</td>
                                    <td>{{i.club}}</td>
                                    <td>{{i.position}}</td>
                                    <td>{{i.trainer}}</td>
                                    <td>{{i.city}}</td>
                                    <td width="140">
                                        <button type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                data-toggle="modal"
                                                data-target="#addResultModal" ng-click="addResult(i.id)">
                                            <i class="zmdi zmdi-refresh-sync zmdi-hc-fw"></i>
                                        </button>
                                        <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                                        <button type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                data-toggle="modal"
                                                data-target="#addPersonModal" ng-click="editPerson(i.id)">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                        </button>

                                        <button type="button" class="btn btn-sm btn-icon btn-neutral"
                                                ng-click="removePerson(i.id)">
                                            <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                        </button>
                                        <%}%>

                                    </td>
                                </tr>
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
<script src="resources/assets/plugins/jquery-validation/jquery.validate.js"></script>
<!-- Jquery Validation Plugin Css -->
<script src="resources/assets/plugins/jquery-steps/jquery.steps.js"></script>
<!-- JQuery Steps Plugin Js -->
<script src="resources/assets/js/pages/forms/form-validation.js"></script>

<script type="text/javascript" src="resources/js/bootstrap-datepicker.min.js"></script>
<script>
    $(document).ready(function () {

        $('#birthDate').datepicker({
            format: 'dd/mm/yyyy'
        });
    });
</script>
